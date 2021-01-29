METHOD filter_results.

  DATA:
    lo_exception TYPE REF TO cx_root,
    lr_node_id   TYPE REF TO data.

  FIELD-SYMBOLS:
    <lt_node_id_filtered> TYPE INDEX TABLE,
    <ls_filter_node_id>   TYPE any.

  CLEAR:
    et_message,
    ev_failed,
    ev_objects_filtered.

  IF it_filter_node_id IS INITIAL.
    " The optional IT_FILTER_NODE_ID has not been provided -> nothing to do
    RETURN.
  ENDIF.

  " Create a table of the same type as ct_node_id
  TRY.
      CREATE DATA lr_node_id LIKE ct_node_id.

    CATCH cx_sy_create_data_error INTO lo_exception.

      /plmb/cl_spi_appl_access_utils=>convert_exception_to_msg(
        EXPORTING io_exception = lo_exception
        IMPORTING et_messages  = et_message ).

      ev_failed = abap_true.
      RETURN.
  ENDTRY.

  ASSIGN lr_node_id->* TO <lt_node_id_filtered>.

  " Only return records which are requested in it_filter_node_id
  LOOP AT it_filter_node_id ASSIGNING <ls_filter_node_id>.
    READ TABLE ct_node_id FROM <ls_filter_node_id> TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      INSERT <ls_filter_node_id> INTO TABLE <lt_node_id_filtered>.
    ENDIF.
  ENDLOOP.

  ev_objects_filtered = boolc( lines( ct_node_id ) <> lines( <lt_node_id_filtered> ) ).
  ct_node_id = <lt_node_id_filtered>.

ENDMETHOD.