  METHOD _determine.
    ASSERT cs_travel-travel_id IS NOT INITIAL.
    LOOP AT ct_booking TRANSPORTING NO FIELDS WHERE travel_id <> cs_travel-travel_id.
      EXIT.
    ENDLOOP.
    ASSERT sy-subrc = 4.
    LOOP AT ct_booking_supplement TRANSPORTING NO FIELDS WHERE travel_id <> cs_travel-travel_id.
      EXIT.
    ENDLOOP.
    ASSERT sy-subrc = 4.
    CLEAR et_messages.
    _determine_travel_total_price( CHANGING cs_travel             = cs_travel
                                            ct_booking            = ct_booking
                                            ct_booking_supplement = ct_booking_supplement
                                            ct_messages           = et_messages ).
  ENDMETHOD.