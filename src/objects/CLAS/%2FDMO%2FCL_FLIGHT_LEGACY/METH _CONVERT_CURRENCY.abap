  METHOD _convert_currency.
    DATA(lv_exchange_rate_date) = cl_abap_context_info=>get_system_date( )." Do not buffer: Current date may change during lifetime of session
    /dmo/cl_flight_amdp=>convert_currency(
      EXPORTING
        iv_amount               = iv_amount
        iv_currency_code_source = iv_currency_code_source
        iv_currency_code_target = iv_currency_code_target
        iv_exchange_rate_date   = lv_exchange_rate_date
      IMPORTING
        ev_amount               = rv_amount
    ).
  ENDMETHOD.