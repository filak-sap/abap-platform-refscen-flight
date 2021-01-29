  METHOD get_travel.
    CLEAR: es_travel, et_booking, et_booking_supplement, et_messages.

    IF iv_travel_id IS INITIAL.
      APPEND NEW /dmo/cx_flight_legacy( textid = /dmo/cx_flight_legacy=>travel_no_key ) TO et_messages.
      RETURN.
    ENDIF.

    lcl_travel_buffer=>get_instance( )->get( EXPORTING it_travel              = VALUE #( ( travel_id = iv_travel_id ) )
                                                       iv_include_buffer      = iv_include_buffer
                                                       iv_include_temp_buffer = iv_include_temp_buffer
                                             IMPORTING et_travel              = DATA(lt_travel) ).
    IF lt_travel IS INITIAL.
      APPEND NEW /dmo/cx_flight_legacy( textid = /dmo/cx_flight_legacy=>travel_unknown  travel_id = iv_travel_id ) TO et_messages.
      RETURN.
    ENDIF.
    ASSERT lines( lt_travel ) = 1.
    es_travel = lt_travel[ 1 ].

    lcl_booking_buffer=>get_instance( )->get( EXPORTING it_booking             = VALUE #( ( travel_id = iv_travel_id ) )
                                                        iv_include_buffer      = iv_include_buffer
                                                        iv_include_temp_buffer = iv_include_temp_buffer
                                              IMPORTING et_booking             = et_booking ).

    lcl_booking_supplement_buffer=>get_instance( )->get( EXPORTING it_booking_supplement  = CORRESPONDING #( et_booking MAPPING travel_id = travel_id  booking_id = booking_id EXCEPT * )
                                                                   iv_include_buffer      = iv_include_buffer
                                                                   iv_include_temp_buffer = iv_include_temp_buffer
                                                         IMPORTING et_booking_supplement  = et_booking_supplement ).
  ENDMETHOD.