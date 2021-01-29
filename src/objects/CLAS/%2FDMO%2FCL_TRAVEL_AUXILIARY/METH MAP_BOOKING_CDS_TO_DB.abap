  METHOD map_booking_cds_to_db.
    rs_booking = CORRESPONDING #( is_i_booking MAPPING  booking_id    = bookingid
                                                        booking_date  = bookingdate
                                                        customer_id   = customerid
                                                        carrier_id    = airlineid
                                                        connection_id = connectionid
                                                        flight_date   = flightdate
                                                        flight_price  = flightprice
                                                        currency_code = currencycode ).
  ENDMETHOD.