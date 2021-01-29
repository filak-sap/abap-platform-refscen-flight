METHOD check_authorization.

  DATA:
    lt_message                    TYPE        /plmb/t_spi_msg,
    lv_failed                     TYPE        /plmb/spi_failed_ind,
    lo_exception                  TYPE REF TO cx_root,
    lr_node_id_struc_with_auth    TYPE REF TO data,
    lr_node_id_struc_without_auth TYPE REF TO data.

  FIELD-SYMBOLS:
    <lt_node_id_with_auth>    TYPE INDEX TABLE,
    <lt_node_id_without_auth> TYPE INDEX TABLE.

  CLEAR:
    et_message,
    ev_failed,
    ev_objects_filtered.

  IF mo_authorization_check IS NOT BOUND.
    " The optional mo_authorization_check has not been provided -> nothing to do
    RETURN.
  ENDIF.

  " Create two tables of the same type as ct_node_id
  TRY.
      CREATE DATA lr_node_id_struc_with_auth    LIKE ct_node_id.
      CREATE DATA lr_node_id_struc_without_auth LIKE ct_node_id.

    CATCH cx_sy_create_data_error INTO lo_exception.

      /plmb/cl_spi_appl_access_utils=>convert_exception_to_msg(
        EXPORTING io_exception = lo_exception
        IMPORTING et_messages  = et_message ).

      ev_failed = abap_true.
      RETURN.
  ENDTRY.

  ASSIGN lr_node_id_struc_without_auth->* TO <lt_node_id_without_auth>.
  ASSIGN lr_node_id_struc_with_auth->*    TO <lt_node_id_with_auth>.

  " Perform the authorization check
  mo_authorization_check->check_authorizations(
    EXPORTING it_object_id              = ct_node_id
    IMPORTING et_object_id_with_auth    = <lt_node_id_with_auth>
              et_object_id_without_auth = <lt_node_id_without_auth>
              et_message                = lt_message
              ev_failed                 = lv_failed ).

  APPEND LINES OF lt_message TO et_message.
  IF lv_failed = abap_true.
    ev_failed = abap_true.
    RETURN.
  ENDIF.

  ASSERT lines( <lt_node_id_with_auth> ) + lines( <lt_node_id_without_auth> ) = lines( ct_node_id ).

  ev_objects_filtered = boolc( <lt_node_id_without_auth> IS NOT INITIAL ).
  ct_node_id          = <lt_node_id_with_auth>.

ENDMETHOD.