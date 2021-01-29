  METHOD set_status_to_booked.
    lcl_travel_buffer=>get_instance( )->set_status_to_booked( EXPORTING iv_travel_id = iv_travel_id
                                                              IMPORTING et_messages  = et_messages ).
  ENDMETHOD.