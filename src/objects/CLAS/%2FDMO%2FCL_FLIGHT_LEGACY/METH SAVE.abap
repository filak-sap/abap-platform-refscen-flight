  METHOD save.
    lcl_travel_buffer=>get_instance( )->save( ).
    lcl_booking_buffer=>get_instance( )->save( ).
    lcl_booking_supplement_buffer=>get_instance( )->save( ).
    initialize( ).
  ENDMETHOD.