  METHOD create_travel.
    CLEAR: es_travel, et_booking, et_booking_supplement, et_messages.

    " Travel
    lcl_travel_buffer=>get_instance( )->cud_prep( EXPORTING it_travel   = VALUE #( ( CORRESPONDING #( is_travel ) ) )
                                                            it_travelx  = VALUE #( ( travel_id = is_travel-travel_id  action_code = /dmo/if_flight_legacy=>action_code-create ) )
                                                  IMPORTING et_travel   = DATA(lt_travel)
                                                            et_messages = et_messages ).
    IF et_messages IS INITIAL.
      ASSERT lines( lt_travel ) = 1.
      es_travel = lt_travel[ 1 ].
    ENDIF.

    " Bookings
    IF et_messages IS INITIAL.
      DATA lt_booking  TYPE /dmo/if_flight_legacy=>tt_booking.
      DATA lt_bookingx TYPE /dmo/if_flight_legacy=>tt_bookingx.
      LOOP AT it_booking INTO DATA(ls_booking_in).
        DATA ls_booking TYPE /dmo/booking.
        ls_booking = CORRESPONDING #( ls_booking_in ).
        ls_booking-travel_id = es_travel-travel_id.
        INSERT ls_booking INTO TABLE lt_booking.
        INSERT VALUE #( travel_id = ls_booking-travel_id  booking_id = ls_booking-booking_id  action_code = /dmo/if_flight_legacy=>action_code-create ) INTO TABLE lt_bookingx.
      ENDLOOP.
      lcl_booking_buffer=>get_instance( )->cud_prep( EXPORTING it_booking  = lt_booking
                                                               it_bookingx = lt_bookingx
                                                     IMPORTING et_booking  = et_booking
                                                               et_messages = DATA(lt_messages) ).
      APPEND LINES OF lt_messages TO et_messages.
    ENDIF.

    " Booking Supplements
    IF et_messages IS INITIAL.
      DATA lt_booking_supplement  TYPE /dmo/if_flight_legacy=>tt_booking_supplement.
      DATA lt_booking_supplementx TYPE /dmo/if_flight_legacy=>tt_booking_supplementx.
      LOOP AT it_booking_supplement INTO DATA(ls_booking_supplement_in).
        DATA ls_booking_supplement TYPE /dmo/book_suppl.
        ls_booking_supplement = CORRESPONDING #( ls_booking_supplement_in ).
        ls_booking_supplement-travel_id = es_travel-travel_id.
        IF lcl_booking_buffer=>get_instance( )->check_booking_id( EXPORTING iv_travel_id = ls_booking_supplement-travel_id  iv_booking_id = ls_booking_supplement-booking_id CHANGING ct_messages = et_messages ) = abap_false.
          EXIT.
        ENDIF.
        INSERT ls_booking_supplement INTO TABLE lt_booking_supplement.
        INSERT VALUE #( travel_id             = ls_booking_supplement-travel_id
                        booking_id            = ls_booking_supplement-booking_id
                        booking_supplement_id = ls_booking_supplement-booking_supplement_id
                        action_code           = /dmo/if_flight_legacy=>action_code-create ) INTO TABLE lt_booking_supplementx.
      ENDLOOP.
      IF et_messages IS INITIAL.
        lcl_booking_supplement_buffer=>get_instance( )->cud_prep( EXPORTING it_booking_supplement  = lt_booking_supplement
                                                                            it_booking_supplementx = lt_booking_supplementx
                                                                  IMPORTING et_booking_supplement  = et_booking_supplement
                                                                            et_messages            = lt_messages ).
        APPEND LINES OF lt_messages TO et_messages.
      ENDIF.
    ENDIF.

    " Now do any derivations that require the whole business object (not only a single node), but which may in principle result in an error
    IF et_messages IS INITIAL.
      _determine( IMPORTING et_messages           = et_messages
                  CHANGING  cs_travel             = es_travel
                            ct_booking            = et_booking
                            ct_booking_supplement = et_booking_supplement ).
    ENDIF.

    IF et_messages IS INITIAL.
      lcl_travel_buffer=>get_instance( )->cud_copy( ).
      lcl_booking_buffer=>get_instance( )->cud_copy( ).
      lcl_booking_supplement_buffer=>get_instance( )->cud_copy( ).
    ELSE.
      CLEAR: es_travel, et_booking, et_booking_supplement.
      lcl_travel_buffer=>get_instance( )->cud_disc( ).
      lcl_booking_buffer=>get_instance( )->cud_disc( ).
      lcl_booking_supplement_buffer=>get_instance( )->cud_disc( ).
    ENDIF.
  ENDMETHOD.