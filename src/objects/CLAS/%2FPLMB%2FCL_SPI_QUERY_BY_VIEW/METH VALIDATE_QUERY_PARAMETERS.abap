METHOD validate_query_parameters.

  DATA:
    lv_message             TYPE        string,
    lo_typedescr_view      TYPE REF TO cl_abap_typedescr,
    lo_structdescr_view    TYPE REF TO cl_abap_structdescr,
    lt_components_view     TYPE        cl_abap_structdescr=>included_view.

  FIELD-SYMBOLS:
    <ls_sel_param>         TYPE /plmb/s_spi_selection_param,
    <ls_spi_sort_order>    TYPE /plmb/s_spi_sortorder,
    <ls_comp_name_mapping> TYPE gty_s_comp_name_mapping.

  CLEAR:
    et_message,
    ev_failed.

  " Check if parameters are valid and make sense
**  IF it_filter_node_id IS NOT INITIAL AND is_options-number_of_rows IS NOT INITIAL.
*** TODO combination not meaningful
**    ev_failed = abap_true.
**  ENDIF.

  " Page navigation parameter "NAVI" is depracated and not supported
  IF is_options-navi IS NOT INITIAL.
    MESSAGE e011(/plmb/spi_services) INTO lv_message.  " -> The page navigation parameter "NAVI" is not supported.

    /plmb/cl_spi_appl_access_utils=>add_syst_message(
      CHANGING ct_message = et_message ).

    ev_failed = abap_true.
  ENDIF.

  " Get the view components which will be needed in the subsequent checks
  cl_abap_structdescr=>describe_by_name(
    EXPORTING  p_name         = mv_view_name
    RECEIVING  p_descr_ref    = lo_typedescr_view
    EXCEPTIONS type_not_found = 1
               OTHERS         = 2 ).
  IF sy-subrc <> 0.
    CASE sy-subrc.
      WHEN 1.
        MESSAGE e001(/plmb/spi_services) INTO lv_message WITH mv_view_name.   " -> Database view &1 does not exist.
      WHEN OTHERS.
        MESSAGE e002(/plmb/spi_services) INTO lv_message WITH mv_view_name.   " -> There is a technical error with database view &1.
    ENDCASE.

    /plmb/cl_spi_appl_access_utils=>add_syst_message(
      CHANGING ct_message = et_message ).

    ev_failed = abap_true.
    RETURN.
  ENDIF.

  ASSERT lo_typedescr_view IS BOUND.   " Otherwise we should have exited before
  lo_structdescr_view ?= lo_typedescr_view.
  lt_components_view = lo_structdescr_view->get_included_view( ).

  " Check if mapped view components exist in the database view
  IF mt_comp_name_mapping IS NOT INITIAL.
    " Check if each comp_name_view is in the view definition
    LOOP AT mt_comp_name_mapping ASSIGNING <ls_comp_name_mapping>.
      READ TABLE lt_components_view WITH TABLE KEY name = <ls_comp_name_mapping>-comp_name_view TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        MESSAGE e012(/plmb/spi_services) INTO lv_message WITH <ls_comp_name_mapping>-comp_name_view mv_view_name.  " -> There is no component &1 in database view &2.

        /plmb/cl_spi_appl_access_utils=>add_syst_message(
          CHANGING ct_message = et_message ).

        ev_failed = abap_true.
        CONTINUE.   " We collect all error messages before exiting the method
      ENDIF.
    ENDLOOP.
  ENDIF.

  " Check if select options (WHERE clause) exist in the database view
  LOOP AT it_sel_param ASSIGNING <ls_sel_param>.
    READ TABLE lt_components_view WITH TABLE KEY name = get_mapped_view_component( <ls_sel_param>-fieldname ) TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e012(/plmb/spi_services) INTO lv_message WITH get_mapped_view_component( <ls_sel_param>-fieldname ) mv_view_name.  " -> There is no component &1 in database view &2.

      /plmb/cl_spi_appl_access_utils=>add_syst_message(
        CHANGING ct_message = et_message ).

      ev_failed = abap_true.
      CONTINUE.   " We collect all error messages before exiting the method
    ENDIF.
  ENDLOOP.

  " Check if sort order parameters exist in the database view
  LOOP AT is_options-sortorder ASSIGNING <ls_spi_sort_order>.
    READ TABLE lt_components_view WITH TABLE KEY name = get_mapped_view_component( <ls_spi_sort_order>-fieldname ) TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e012(/plmb/spi_services) INTO lv_message WITH get_mapped_view_component( <ls_spi_sort_order>-fieldname ) mv_view_name.  " -> There is no component &1 in database view &2.

      /plmb/cl_spi_appl_access_utils=>add_syst_message(
        CHANGING ct_message = et_message ).

      ev_failed = abap_true.
      CONTINUE.   " We collect all error messages before exiting the method
    ENDIF.
  ENDLOOP.

ENDMETHOD.