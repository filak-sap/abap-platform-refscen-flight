  METHOD calculate_flight_price.
    DATA: lv_percentage_of_max_price TYPE i.
    lv_percentage_of_max_price = ( 3 * iv_seats_occupied_percent ** 2 DIV 400 ) + 25 ##OPERATOR[**].
    rv_price = lv_percentage_of_max_price * iv_flight_distance DIV 100.
  ENDMETHOD.