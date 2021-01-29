METHOD generate_order_by_clause.

  FIELD-SYMBOLS:
    <ls_spi_sort_order> TYPE /plmb/s_spi_sortorder.

  CLEAR:
    et_message,
    ev_failed,
    ev_order_by_clause.

  IF it_sort_order IS NOT INITIAL.
    LOOP AT it_sort_order ASSIGNING <ls_spi_sort_order>.
      IF ev_order_by_clause IS NOT INITIAL.
        ev_order_by_clause = ev_order_by_clause && ` `.
      ENDIF.

      ev_order_by_clause = ev_order_by_clause && get_mapped_view_component( <ls_spi_sort_order>-fieldname ) && ` `.

      IF <ls_spi_sort_order>-descending = abap_true.
        ev_order_by_clause = ev_order_by_clause && `DESCENDING`.
      ELSE.
        ev_order_by_clause = ev_order_by_clause && `ASCENDING`.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDMETHOD.