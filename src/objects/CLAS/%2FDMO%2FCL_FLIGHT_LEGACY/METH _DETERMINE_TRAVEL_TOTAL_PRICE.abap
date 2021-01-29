  METHOD _determine_travel_total_price.
    DATA lv_add TYPE /dmo/total_price.
    DATA(lv_currency_code_target) = cs_travel-currency_code.

    " If we do not have a Travel Currency Code yet,
    " we may derive it when all the subnodes have the same non-initial Currency Code
    IF lv_currency_code_target IS INITIAL.
      DATA lv_ok TYPE abap_bool.
      lv_ok = abap_true.
      LOOP AT ct_booking ASSIGNING FIELD-SYMBOL(<s_booking>).
        IF sy-tabix = 1.
          lv_currency_code_target = <s_booking>-currency_code.
        ENDIF.
        IF <s_booking>-currency_code IS INITIAL.
          lv_ok = abap_false.
          EXIT.
        ENDIF.
        IF lv_currency_code_target <> <s_booking>-currency_code.
          lv_ok = abap_false.
          EXIT.
        ENDIF.
      ENDLOOP.
      IF lv_ok = abap_true.
        LOOP AT ct_booking_supplement ASSIGNING FIELD-SYMBOL(<s_booking_supplement>).
          IF <s_booking_supplement>-currency_code IS INITIAL.
            lv_ok = abap_false.
            EXIT.
          ENDIF.
          IF lv_currency_code_target <> <s_booking_supplement>-currency_code.
            lv_ok = abap_false.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF lv_currency_code_target IS NOT INITIAL.
      " Total Price = Booking Fee + Booking Flight Prices + Booking Supplement Prices
      cs_travel-total_price   = cs_travel-booking_fee.
      cs_travel-currency_code = lv_currency_code_target.
      LOOP AT ct_booking ASSIGNING <s_booking>
          GROUP BY <s_booking>-currency_code INTO DATA(booking_currency_code).

        lv_add = REDUCE #( INIT sum = 0
                           FOR b IN GROUP booking_currency_code
                           NEXT  sum = sum + b-flight_price  ).

        IF booking_currency_code <> lv_currency_code_target.
          lv_add = _convert_currency( iv_currency_code_source = booking_currency_code
                                      iv_currency_code_target = lv_currency_code_target
                                      iv_amount               = lv_add ).
        ENDIF.
        cs_travel-total_price = cs_travel-total_price + lv_add.
      ENDLOOP.
      LOOP AT ct_booking_supplement ASSIGNING <s_booking_supplement>
          GROUP BY <s_booking_supplement>-currency_code INTO DATA(supplement_currency_code).

        lv_add = REDUCE #( INIT sum = 0
                           FOR s IN GROUP supplement_currency_code
                           NEXT  sum = sum + s-price  ).

        IF supplement_currency_code <> lv_currency_code_target.
          lv_add = _convert_currency( iv_currency_code_source = supplement_currency_code
                                      iv_currency_code_target = lv_currency_code_target
                                      iv_amount               = lv_add ).
        ENDIF.
        cs_travel-total_price = cs_travel-total_price + lv_add.
      ENDLOOP.
      lcl_travel_buffer=>get_instance( )->cud_prep( EXPORTING it_travel   = VALUE #( ( travel_id = cs_travel-travel_id  total_price = cs_travel-total_price  currency_code = cs_travel-currency_code ) )
                                                              it_travelx  = VALUE #( ( action_code = /dmo/if_flight_legacy=>action_code-update  travel_id = cs_travel-travel_id  total_price = abap_true  currency_code = abap_true ) )
                                                    IMPORTING et_messages = DATA(lt_messages) ).
      ASSERT lt_messages IS INITIAL.
    ENDIF.
  ENDMETHOD.