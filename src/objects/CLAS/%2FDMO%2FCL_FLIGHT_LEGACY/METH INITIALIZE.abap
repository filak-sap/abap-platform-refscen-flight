  METHOD initialize.
    lcl_travel_buffer=>get_instance( )->initialize( ).
    lcl_booking_buffer=>get_instance( )->initialize( ).
    lcl_booking_supplement_buffer=>get_instance( )->initialize( ).
  ENDMETHOD.