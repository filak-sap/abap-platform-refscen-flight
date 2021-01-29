  METHOD map_travel_cds_to_db.
    rs_travel = CORRESPONDING #( is_i_travel_u MAPPING  travel_id     = travelid
                                                        agency_id     = agencyid
                                                        customer_id   = customerid
                                                        begin_date    = begindate
                                                        end_date      = enddate
                                                        booking_fee   = bookingfee
                                                        total_price   = totalprice
                                                        currency_code = currencycode
                                                        description   = memo
                                                        status        = status ).
  ENDMETHOD.