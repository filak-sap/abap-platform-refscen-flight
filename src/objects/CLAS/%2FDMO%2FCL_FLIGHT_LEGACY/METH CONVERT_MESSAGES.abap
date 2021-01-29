  METHOD convert_messages.
    CLEAR et_messages.
    DATA ls_message TYPE symsg.
    LOOP AT it_messages INTO DATA(lr_error) ##INTO_OK.
      ls_message-msgty = 'E'.
      ls_message-msgid = lr_error->t100key-msgid.
      ls_message-msgno = lr_error->t100key-msgno.
      IF lr_error IS INSTANCE OF /dmo/cx_flight_legacy.
        DATA(lx) = CAST /dmo/cx_flight_legacy( lr_error ).
        ls_message-msgv1 = _resolve_attribute( iv_attrname = lr_error->t100key-attr1  ix = lx ).
        ls_message-msgv2 = _resolve_attribute( iv_attrname = lr_error->t100key-attr2  ix = lx ).
        ls_message-msgv3 = _resolve_attribute( iv_attrname = lr_error->t100key-attr3  ix = lx ).
        ls_message-msgv4 = _resolve_attribute( iv_attrname = lr_error->t100key-attr4  ix = lx ).
      ENDIF.
      APPEND ls_message TO et_messages.
    ENDLOOP.
  ENDMETHOD.