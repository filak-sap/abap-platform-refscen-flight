  METHOD map_bookingsupplemnt_message.
    DATA(lo) = new_message( id       = is_message-msgid
                            number   = is_message-msgno
                            severity = if_abap_behv_message=>severity-error
                            v1       = is_message-msgv1
                            v2       = is_message-msgv2
                            v3       = is_message-msgv3
                            v4       = is_message-msgv4 ).
    rs_report-%cid      = iv_cid.
    rs_report-travelid  = iv_travel_id.
    rs_report-bookingid = iv_booking_id.
    rs_report-bookingSupplementid = iv_bookingsupplement_id.
    rs_report-%msg      = lo.
  ENDMETHOD.