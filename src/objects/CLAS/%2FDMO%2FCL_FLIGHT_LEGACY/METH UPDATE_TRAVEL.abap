  METHOD update_travel.
    CLEAR es_travel.
    CLEAR et_booking.
    CLEAR et_booking_supplement.
    CLEAR et_messages.

    " Travel
    IF is_travel-travel_id IS INITIAL.
      APPEND NEW /dmo/cx_flight_legacy( textid = /dmo/cx_flight_legacy=>travel_no_key ) TO et_messages.
      RETURN.
    ENDIF.
    DATA ls_travelx TYPE /dmo/if_flight_legacy=>ts_travelx.
    ls_travelx = CORRESPONDING #( is_travelx ).
    ls_travelx-action_code = /dmo/if_flight_legacy=>action_code-update.
    lcl_travel_buffer=>get_instance( )->cud_prep( EXPORTING it_travel   = VALUE #( ( CORRESPONDING #( is_travel ) ) )
                                                            it_travelx  = VALUE #( ( ls_travelx ) )
                                                  IMPORTING et_travel   = DATA(lt_travel)
                                                            et_messages = et_messages ).

    " We may need to delete Booking Supplements of deleted Bookings
    " Read all Booking Supplements before any Bookings are deleted
    get_travel( EXPORTING iv_travel_id           = is_travel-travel_id
                          iv_include_buffer      = abap_true
                          iv_include_temp_buffer = abap_true
                IMPORTING et_booking_supplement  = DATA(lt_booking_supplement_del) ).

    " Bookings
    IF et_messages IS INITIAL.
      " Ignore provided Travel ID of subnode tables
      DATA lt_booking  TYPE /dmo/if_flight_legacy=>tt_booking.
      DATA lt_bookingx TYPE /dmo/if_flight_legacy=>tt_bookingx.
      LOOP AT it_booking INTO DATA(ls_booking_in).
        DATA ls_booking TYPE /dmo/booking.
        ls_booking = CORRESPONDING #( ls_booking_in ).
        ls_booking-travel_id = is_travel-travel_id.
        INSERT ls_booking INTO TABLE lt_booking.
      ENDLOOP.
      LOOP AT it_bookingx INTO DATA(ls_booking_inx).
        DATA ls_bookingx TYPE /dmo/if_flight_legacy=>ts_bookingx.
        ls_bookingx = CORRESPONDING #( ls_booking_inx ).
        ls_bookingx-travel_id = is_travel-travel_id.
        INSERT ls_bookingx INTO TABLE lt_bookingx.
      ENDLOOP.
      lcl_booking_buffer=>get_instance( )->cud_prep( EXPORTING it_booking  = lt_booking
                                                               it_bookingx = lt_bookingx
                                                     IMPORTING et_booking  = et_booking
                                                               et_messages = DATA(lt_messages) ).
      APPEND LINES OF lt_messages TO et_messages.
    ENDIF.

    " Booking Supplements
    IF et_messages IS INITIAL.
      " Ignore provided Travel ID of subnode tables
      DATA lt_booking_supplement  TYPE /dmo/if_flight_legacy=>tt_booking_supplement.
      DATA lt_booking_supplementx TYPE /dmo/if_flight_legacy=>tt_booking_supplementx.
      LOOP AT it_booking_supplement INTO DATA(ls_booking_supplement_in).
        DATA ls_booking_supplement TYPE /dmo/book_suppl.
        ls_booking_supplement = CORRESPONDING #( ls_booking_supplement_in ).
        ls_booking_supplement-travel_id = is_travel-travel_id.
        IF lcl_booking_buffer=>get_instance( )->check_booking_id( EXPORTING iv_travel_id  = ls_booking_supplement-travel_id
                                                                            iv_booking_id = ls_booking_supplement-booking_id
                                                                  CHANGING  ct_messages   = et_messages ) = abap_false.
          EXIT.
        ENDIF.
        INSERT ls_booking_supplement INTO TABLE lt_booking_supplement.
      ENDLOOP.
      IF et_messages IS INITIAL.
        LOOP AT it_booking_supplementx INTO DATA(ls_booking_supplement_inx).
          DATA ls_booking_supplementx TYPE /dmo/if_flight_legacy=>ts_booking_supplementx.
          ls_booking_supplementx = CORRESPONDING #( ls_booking_supplement_inx ).
          ls_booking_supplementx-travel_id = is_travel-travel_id.
          INSERT ls_booking_supplementx INTO TABLE lt_booking_supplementx.
        ENDLOOP.
        lcl_booking_supplement_buffer=>get_instance( )->cud_prep( EXPORTING it_booking_supplement  = lt_booking_supplement
                                                                            it_booking_supplementx = lt_booking_supplementx
                                                                  IMPORTING et_booking_supplement  = et_booking_supplement
                                                                            et_messages            = lt_messages ).
        APPEND LINES OF lt_messages TO et_messages.
      ENDIF.
    ENDIF.

    " For Bookings to be deleted we also need to delete the Booking Supplements
    IF    et_messages IS INITIAL
      AND lt_booking_supplement_del IS NOT INITIAL
      AND line_exists( lt_bookingx[ action_code = CONV /dmo/action_code( /dmo/if_flight_legacy=>action_code-delete ) ] ).
      " Remove any Bookings from internal table that must not be deleted
      LOOP AT lt_booking_supplement_del ASSIGNING FIELD-SYMBOL(<s_booking_supplement_del>).
        READ TABLE lt_bookingx TRANSPORTING NO FIELDS WITH KEY action_code = CONV /dmo/action_code( /dmo/if_flight_legacy=>action_code-delete )
                                                               travel_id   = <s_booking_supplement_del>-travel_id
                                                               booking_id  = <s_booking_supplement_del>-booking_id.
        IF sy-subrc <> 0.
          DELETE lt_booking_supplement_del.
        ENDIF.
      ENDLOOP.
      lcl_booking_supplement_buffer=>get_instance( )->cud_prep( EXPORTING it_booking_supplement  = CORRESPONDING #( lt_booking_supplement_del MAPPING travel_id             = travel_id
                                                                                                                                                      booking_id            = booking_id
                                                                                                                                                      booking_supplement_id = booking_supplement_id EXCEPT * )
                                                                          it_booking_supplementx = VALUE #( FOR ls_bs IN lt_booking_supplement_del ( action_code           = /dmo/if_flight_legacy=>action_code-delete
                                                                                                                                                     travel_id             = ls_bs-travel_id
                                                                                                                                                     booking_id            = ls_bs-booking_id
                                                                                                                                                     booking_supplement_id = ls_bs-booking_supplement_id ) )
                                                                          iv_no_delete_check     = abap_true " No existence check required
                                                                IMPORTING et_messages            = et_messages ).
    ENDIF.

    IF et_messages IS INITIAL.
      ASSERT lines( lt_travel ) = 1.
      " Now do any derivations that require the whole business object (not only a single node), but which may in principle result in an error
      " The derivation may need the complete Business Object, i.e. including unchanged subnodes
      get_travel( EXPORTING iv_travel_id           = lt_travel[ 1 ]-travel_id
                            iv_include_buffer      = abap_true
                            iv_include_temp_buffer = abap_true
                  IMPORTING es_travel              = es_travel
                            et_booking             = et_booking
                            et_booking_supplement  = et_booking_supplement
                            et_messages            = et_messages ).
      ASSERT et_messages IS INITIAL.
      _determine( IMPORTING et_messages           = et_messages
                  CHANGING  cs_travel             = es_travel
                            ct_booking            = et_booking
                            ct_booking_supplement = et_booking_supplement ).
      IF et_messages IS INITIAL.
        " We do not want to return all subnodes, but only those that have been created or changed.
        " So currently it is not implemented that a determination of a booking changes another booking as the other booking cannot be properly returned.
        LOOP AT et_booking ASSIGNING FIELD-SYMBOL(<s_booking>).
          LOOP AT it_bookingx TRANSPORTING NO FIELDS WHERE booking_id = <s_booking>-booking_id
            AND ( action_code = CONV /dmo/action_code( /dmo/if_flight_legacy=>action_code-create ) OR action_code = CONV /dmo/action_code( /dmo/if_flight_legacy=>action_code-update ) ).
            EXIT.
          ENDLOOP.
          IF sy-subrc <> 0.
            DELETE et_booking.
          ENDIF.
        ENDLOOP.
        LOOP AT et_booking_supplement ASSIGNING FIELD-SYMBOL(<s_booking_supplement>).
          LOOP AT it_booking_supplementx TRANSPORTING NO FIELDS WHERE booking_id = <s_booking_supplement>-booking_id AND booking_supplement_id = <s_booking_supplement>-booking_supplement_id
            AND ( action_code = CONV /dmo/action_code( /dmo/if_flight_legacy=>action_code-create ) OR action_code = CONV /dmo/action_code( /dmo/if_flight_legacy=>action_code-update ) ).
            EXIT.
          ENDLOOP.
          IF sy-subrc <> 0.
            DELETE et_booking_supplement.
          ENDIF.
        ENDLOOP.
      ENDIF.
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