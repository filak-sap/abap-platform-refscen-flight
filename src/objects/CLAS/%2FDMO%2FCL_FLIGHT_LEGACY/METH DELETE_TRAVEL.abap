  METHOD delete_travel.
    CLEAR et_messages.

    get_travel( EXPORTING iv_travel_id           = iv_travel_id
                          iv_include_buffer      = abap_true
                          iv_include_temp_buffer = abap_true
                IMPORTING et_booking             = DATA(lt_booking)
                          et_booking_supplement  = DATA(lt_booking_supplement)
                          et_messages            = et_messages ).

    IF et_messages IS INITIAL.
      lcl_booking_supplement_buffer=>get_instance( )->cud_prep( EXPORTING it_booking_supplement  = CORRESPONDING #( lt_booking_supplement MAPPING travel_id             = travel_id
                                                                                                                                                  booking_id            = booking_id
                                                                                                                                                  booking_supplement_id = booking_supplement_id EXCEPT * )
                                                                          it_booking_supplementx = VALUE #( FOR ls_bs IN lt_booking_supplement ( action_code           = /dmo/if_flight_legacy=>action_code-delete
                                                                                                                                                 travel_id             = ls_bs-travel_id
                                                                                                                                                 booking_id            = ls_bs-booking_id
                                                                                                                                                 booking_supplement_id = ls_bs-booking_supplement_id ) )
                                                                          iv_no_delete_check     = abap_true " No existence check required
                                                                IMPORTING et_messages            = DATA(lt_messages) ).
      APPEND LINES OF lt_messages TO et_messages.
    ENDIF.

    IF et_messages IS INITIAL.
      lcl_booking_buffer=>get_instance( )->cud_prep( EXPORTING it_booking         = CORRESPONDING #( lt_booking MAPPING travel_id = travel_id  booking_id = booking_id EXCEPT * )
                                                               it_bookingx        = VALUE #( FOR ls_b IN lt_booking ( action_code = /dmo/if_flight_legacy=>action_code-delete  travel_id = ls_b-travel_id  booking_id = ls_b-booking_id ) )
                                                               iv_no_delete_check = abap_true " No existence check required
                                                     IMPORTING et_messages        = lt_messages ).
      APPEND LINES OF lt_messages TO et_messages.
    ENDIF.

    IF et_messages IS INITIAL.
      lcl_travel_buffer=>get_instance( )->cud_prep( EXPORTING it_travel          = VALUE #( ( travel_id = iv_travel_id ) )
                                                              it_travelx         = VALUE #( ( travel_id = iv_travel_id  action_code = /dmo/if_flight_legacy=>action_code-delete ) )
                                                              iv_no_delete_check = abap_true " No existence check required
                                                    IMPORTING et_messages        = lt_messages ).
      APPEND LINES OF lt_messages TO et_messages.
    ENDIF.

    IF et_messages IS INITIAL.
      lcl_travel_buffer=>get_instance( )->cud_copy( ).
      lcl_booking_buffer=>get_instance( )->cud_copy( ).
      lcl_booking_supplement_buffer=>get_instance( )->cud_copy( ).
    ELSE.
      lcl_travel_buffer=>get_instance( )->cud_disc( ).
      lcl_booking_buffer=>get_instance( )->cud_disc( ).
      lcl_booking_supplement_buffer=>get_instance( )->cud_disc( ).
    ENDIF.
  ENDMETHOD.