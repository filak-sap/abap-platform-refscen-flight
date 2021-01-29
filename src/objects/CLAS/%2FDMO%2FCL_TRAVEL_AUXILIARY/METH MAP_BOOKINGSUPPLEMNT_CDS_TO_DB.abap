  METHOD map_bookingsupplemnt_cds_to_db.
    rs_bookingsupplement = CORRESPONDING #( is_i_bookingsupplement MAPPING  booking_id             = bookingid
                                                                            booking_supplement_id  = bookingsupplementid
                                                                            supplement_id          = supplementid
                                                                            price                  = price
                                                                            currency_code          = currencycode  ).
  ENDMETHOD.