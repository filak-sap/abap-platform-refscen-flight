METHOD generate_where_clause.

  DATA:
    lv_message      TYPE string,
    ls_table_range  TYPE rsds_range,
    lt_table_range  TYPE rsds_trange,
    ls_field_range  TYPE rsds_frange,
    lt_field_range  TYPE rsds_frange_t,
    ls_sel_opt      TYPE rsdsselopt,
    lv_conv_high    TYPE string,
    lv_conv_low     TYPE string,
    lt_where_cond   TYPE rsds_twhere.

  FIELD-SYMBOLS:
    <ls_sel_param>         TYPE /plmb/s_spi_selection_param,
    <ls_field_range>       TYPE rsds_frange,
    <ls_where_cond>        TYPE rsds_where,
    <ls_where_cond_single> TYPE rsdswhere.

  CLEAR:
    et_message,
    ev_failed,
    ev_where_clause.

  " Convert SPI select options to select options which can be translated into a WHERE clause
  LOOP AT it_sel_param ASSIGNING <ls_sel_param>.
    MOVE-CORRESPONDING <ls_sel_param> TO ls_sel_opt.
    " High/low values are passed as char255; database selection only allows char45 -> convert
    " Low value
    lv_conv_low = <ls_sel_param>-low.
    SHIFT lv_conv_low LEFT DELETING LEADING space.
    ls_sel_opt-low = lv_conv_low.

    IF strlen( lv_conv_low ) > 45.
      MESSAGE w013(/plmb/spi_services) INTO lv_message WITH lv_conv_low <ls_sel_param>-fieldname.   " -> Low value &1 fieldname &2 of search options is too long and was cropped.
      /plmb/cl_spi_appl_access_utils=>add_syst_message(
        CHANGING ct_message = et_message ).
    ENDIF.

    " High value
    lv_conv_high = <ls_sel_param>-high.
    SHIFT lv_conv_high LEFT DELETING LEADING space.
    ls_sel_opt-high = lv_conv_high.

    IF strlen( lv_conv_high ) > 45.
      MESSAGE w014(/plmb/spi_services) INTO lv_message WITH lv_conv_high <ls_sel_param>-fieldname.   " -> High value &1 fieldname &2 of search options is too long and was cropped.
      /plmb/cl_spi_appl_access_utils=>add_syst_message(
        CHANGING ct_message = et_message ).
    ENDIF.

    READ TABLE lt_field_range WITH TABLE KEY fieldname = <ls_sel_param>-fieldname ASSIGNING <ls_field_range>.
    IF sy-subrc = 0.
      INSERT ls_sel_opt INTO TABLE <ls_field_range>-selopt_t.
    ELSE.
      CLEAR ls_field_range.
      ls_field_range-fieldname = <ls_sel_param>-fieldname.
      INSERT ls_sel_opt INTO TABLE ls_field_range-selopt_t.
      INSERT ls_field_range INTO TABLE lt_field_range.
    ENDIF.
  ENDLOOP.

  " Map component names node -> view
  LOOP AT lt_field_range ASSIGNING <ls_field_range>.
    <ls_field_range>-fieldname = get_mapped_view_component( <ls_field_range>-fieldname ).
  ENDLOOP.

  " Generate WHERE clause
  IF lt_field_range IS NOT INITIAL.
    CLEAR ls_table_range.
    ls_table_range-tablename = mv_view_name.
    ls_table_range-frange_t  = lt_field_range.
    INSERT ls_table_range INTO TABLE lt_table_range.

    CALL FUNCTION 'FREE_SELECTIONS_RANGE_2_WHERE'
      EXPORTING
        field_ranges  = lt_table_range
      IMPORTING
        where_clauses = lt_where_cond.

    ASSERT lines( lt_where_cond ) = 1.
    READ TABLE lt_where_cond ASSIGNING <ls_where_cond> INDEX 1.
    ASSERT sy-subrc = 0.

    LOOP AT <ls_where_cond>-where_tab ASSIGNING <ls_where_cond_single>.
      IF ev_where_clause IS INITIAL.
        ev_where_clause = <ls_where_cond_single>-line.
      ELSE.
        ev_where_clause = ev_where_clause && ` ` && <ls_where_cond_single>-line.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDMETHOD.