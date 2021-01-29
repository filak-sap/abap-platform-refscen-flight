  METHOD _resolve_attribute.
    CLEAR rv_symsgv.
    CASE iv_attrname.
      WHEN ''.
        rv_symsgv = ''.
      WHEN 'MV_TRAVEL_ID'.
        rv_symsgv = |{ ix->mv_travel_id ALPHA = OUT }|.
      WHEN 'MV_BOOKING_ID'.
        rv_symsgv = |{ ix->mv_booking_id ALPHA = OUT }|.
      WHEN 'MV_BOOKING_SUPPLEMENT_ID'.
        rv_symsgv = |{ ix->mv_booking_supplement_id ALPHA = OUT }|.
      WHEN 'MV_AGENCY_ID'.
        rv_symsgv = |{ ix->mv_agency_id ALPHA = OUT }|.
      WHEN 'MV_CUSTOMER_ID'.
        rv_symsgv = |{ ix->mv_customer_id ALPHA = OUT }|.
      WHEN 'MV_CARRIER_ID'.
        rv_symsgv = |{ ix->mv_carrier_id ALPHA = OUT }|.
      WHEN 'MV_CONNECTION_ID'.
        rv_symsgv = |{ ix->mv_connection_id ALPHA = OUT }|.
      WHEN 'MV_SUPPLEMENT_ID'.
        rv_symsgv = ix->mv_supplement_id.
      WHEN 'MV_BEGIN_DATE'.
        rv_symsgv = |{ ix->mv_begin_date DATE = USER }|.
      WHEN 'MV_END_DATE'.
        rv_symsgv = |{ ix->mv_end_date DATE = USER }|.
      WHEN 'MV_BOOKING_DATE'.
        rv_symsgv = |{ ix->mv_booking_date DATE = USER }|.
      WHEN 'MV_FLIGHT_DATE'.
        rv_symsgv = |{ ix->mv_flight_date DATE = USER }|.
      WHEN 'MV_STATUS'.
        rv_symsgv = ix->mv_status.
      WHEN 'MV_CURRENCY_CODE'.
        rv_symsgv = ix->mv_currency_code.
      WHEN 'MV_UNAME'.
        rv_symsgv = ix->mv_uname.
      WHEN OTHERS.
        ASSERT 1 = 2.
    ENDCASE.
  ENDMETHOD.