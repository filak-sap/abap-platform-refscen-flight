  METHOD cuerd_travel.
    DATA ls_travel_in  TYPE /dmo/if_flight_legacy=>ts_travel_in.
    DATA ls_travel_inx TYPE /dmo/if_flight_legacy=>ts_travel_inx.
    DATA ls_travel     TYPE /dmo/travel.
    DATA lt_messages   TYPE /dmo/if_flight_legacy=>tt_message.

    " Create Travel and Commit
    ls_travel_in-agency_id   = gv_agency_id_1.
    ls_travel_in-customer_id = gv_customer_id_1.
    ls_travel_in-begin_date  = '20180101'.
    ls_travel_in-end_date    = '20180201'.
    ls_travel_in-description = 'My Test'.
    CALL FUNCTION '/DMO/FLIGHT_TRAVEL_CREATE'
      EXPORTING
        is_travel   = ls_travel_in
      IMPORTING
        es_travel   = ls_travel
        et_messages = lt_messages.
    cl_abap_unit_assert=>assert_initial( lt_messages ).
    DATA(lv_travel_id) = ls_travel-travel_id.
    cl_abap_unit_assert=>assert_not_initial( lv_travel_id ).
    CALL FUNCTION '/DMO/FLIGHT_TRAVEL_SAVE'.

    " DB Check
    SELECT SINGLE agency_id, customer_id, description FROM /dmo/travel WHERE travel_id = @lv_travel_id INTO ( @DATA(lv_agency_id), @DATA(lv_customer_id), @DATA(lv_description) ).
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( act = lv_agency_id    exp = gv_agency_id_1 ).
    cl_abap_unit_assert=>assert_equals( act = lv_customer_id  exp = gv_customer_id_1 ).
    cl_abap_unit_assert=>assert_equals( act = lv_description  exp = 'My Test' ).

    " Update
    CLEAR ls_travel_in.
    ls_travel_in-travel_id   = lv_travel_id.
    ls_travel_in-agency_id   = gv_agency_id_2.
    ls_travel_in-customer_id = gv_customer_id_2.
    ls_travel_in-description = 'My New Test'.
    ls_travel_inx-travel_id   = lv_travel_id.
    ls_travel_inx-agency_id   = abap_true.
    ls_travel_inx-customer_id = abap_true.
    ls_travel_inx-description = abap_true.
    CALL FUNCTION '/DMO/FLIGHT_TRAVEL_UPDATE'
      EXPORTING
        is_travel   = ls_travel_in
        is_travelx  = ls_travel_inx
      IMPORTING
        et_messages = lt_messages.
    cl_abap_unit_assert=>assert_initial( lt_messages ).

    " Action
    CALL FUNCTION '/DMO/FLIGHT_TRAVEL_SET_BOOKING'
      EXPORTING
        iv_travel_id = lv_travel_id
      IMPORTING
        et_messages  = lt_messages.
    cl_abap_unit_assert=>assert_initial( lt_messages ).

    " Faulty Update - All or Nothing -> Nothing
    CLEAR ls_travel_in.
    ls_travel_in-travel_id   = lv_travel_id.
    ls_travel_in-agency_id   = gv_agency_id_unknown.
    ls_travel_in-customer_id = gv_customer_id_1.
    ls_travel_inx-travel_id   = lv_travel_id.
    ls_travel_inx-agency_id   = abap_true.
    ls_travel_inx-customer_id = abap_true.
    CALL FUNCTION '/DMO/FLIGHT_TRAVEL_UPDATE'
      EXPORTING
        is_travel   = ls_travel_in
        is_travelx  = ls_travel_inx
      IMPORTING
        et_messages = lt_messages.
    cl_abap_unit_assert=>assert_not_initial( lt_messages ).

    " Faulty Update - All or Nothing -> Nothing
    CLEAR lt_messages.
    CLEAR ls_travel_in.
    ls_travel_in-travel_id   = lv_travel_id.
    ls_travel_in-agency_id   = gv_agency_id_1.
    ls_travel_in-customer_id = gv_customer_id_unknown.
    ls_travel_inx-travel_id   = lv_travel_id.
    ls_travel_inx-agency_id   = abap_true.
    ls_travel_inx-customer_id = abap_true.
    CALL FUNCTION '/DMO/FLIGHT_TRAVEL_UPDATE'
      EXPORTING
        is_travel   = ls_travel_in
        is_travelx  = ls_travel_inx
      IMPORTING
        et_messages = lt_messages.
    cl_abap_unit_assert=>assert_not_initial( lt_messages ).

    " Read DB only
    CLEAR ls_travel.
    CALL FUNCTION '/DMO/FLIGHT_TRAVEL_READ'
      EXPORTING
        iv_travel_id      = lv_travel_id
        iv_include_buffer = abap_false
      IMPORTING
        es_travel         = ls_travel
        et_messages       = lt_messages.
    cl_abap_unit_assert=>assert_initial( lt_messages ).
    cl_abap_unit_assert=>assert_equals( act = ls_travel-travel_id    exp = lv_travel_id ).
    cl_abap_unit_assert=>assert_equals( act = ls_travel-agency_id    exp = gv_agency_id_1 ).
    cl_abap_unit_assert=>assert_equals( act = ls_travel-customer_id  exp = gv_customer_id_1 ).
    cl_abap_unit_assert=>assert_equals( act = ls_travel-status       exp = CONV /dmo/travel_status( /dmo/if_flight_legacy=>travel_status-new ) ).
    cl_abap_unit_assert=>assert_equals( act = ls_travel-description  exp = 'My Test' ).

    " Read with buffer
    CLEAR ls_travel.
    CALL FUNCTION '/DMO/FLIGHT_TRAVEL_READ'
      EXPORTING
        iv_travel_id      = lv_travel_id
        iv_include_buffer = abap_true
      IMPORTING
        es_travel         = ls_travel
        et_messages       = lt_messages.
    cl_abap_unit_assert=>assert_initial( lt_messages ).
    cl_abap_unit_assert=>assert_equals( act = ls_travel-travel_id  exp = lv_travel_id ).
    cl_abap_unit_assert=>assert_equals( act = ls_travel-agency_id    exp = gv_agency_id_2 ).
    cl_abap_unit_assert=>assert_equals( act = ls_travel-customer_id  exp = gv_customer_id_2 ).
    cl_abap_unit_assert=>assert_equals( act = ls_travel-status       exp = CONV /dmo/travel_status( /dmo/if_flight_legacy=>travel_status-booked ) ).
    cl_abap_unit_assert=>assert_equals( act = ls_travel-description  exp = 'My New Test' ).

    " Delete
    CALL FUNCTION '/DMO/FLIGHT_TRAVEL_DELETE'
      EXPORTING
        iv_travel_id = lv_travel_id
      IMPORTING
        et_messages  = lt_messages.
    cl_abap_unit_assert=>assert_initial( lt_messages ).

    " Delete again -> Error
    CALL FUNCTION '/DMO/FLIGHT_TRAVEL_DELETE'
      EXPORTING
        iv_travel_id = lv_travel_id
      IMPORTING
        et_messages  = lt_messages.
    cl_abap_unit_assert=>assert_not_initial( lt_messages ).

    CALL FUNCTION '/DMO/FLIGHT_TRAVEL_SAVE'.
  ENDMETHOD.