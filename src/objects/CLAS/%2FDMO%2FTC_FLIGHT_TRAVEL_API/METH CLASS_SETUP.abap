  METHOD class_setup.
    DATA lt_agency_id TYPE SORTED TABLE OF /dmo/agency_id     WITH UNIQUE KEY table_line.
    SELECT DISTINCT agency_id FROM /dmo/agency     ORDER BY agency_id   DESCENDING INTO TABLE @lt_agency_id .

    DATA lt_customer_id TYPE SORTED TABLE OF /dmo/customer_id WITH UNIQUE KEY table_line.
    SELECT DISTINCT customer_id FROM /dmo/customer ORDER BY customer_id DESCENDING INTO TABLE @lt_customer_id .

    " Select 2 known agency IDs
    IF lines( lt_agency_id ) < 2.
      cl_abap_unit_assert=>abort( msg = 'No agency data!'   ).
    ENDIF.
    gv_agency_id_1 = lt_agency_id[ 1 ].
    gv_agency_id_2 = lt_agency_id[ 2 ].
    cl_abap_unit_assert=>assert_differs( act = gv_agency_id_1  exp = gv_agency_id_2 )." To be totally sure

    " Select 2 known customer IDs
    IF lines( lt_customer_id ) < 2.
      cl_abap_unit_assert=>abort( msg = 'No customer data!' ).
    ENDIF.
    gv_customer_id_1 = lt_customer_id[ 1 ].
    gv_customer_id_2 = lt_customer_id[ 2 ].
    cl_abap_unit_assert=>assert_differs( act = gv_customer_id_1  exp = gv_customer_id_2 )." To be totally sure

    " Determine an unknown agency ID
    gv_agency_id_unknown = lt_agency_id[ 1 ].
    DO.
      gv_agency_id_unknown = gv_agency_id_unknown + 1.
      READ TABLE lt_agency_id   TRANSPORTING NO FIELDS WITH TABLE KEY table_line = gv_agency_id_unknown.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
    ENDDO.

    " Determine an unknown customer ID
    gv_customer_id_unknown = lt_customer_id[ 1 ].
    DO.
      gv_customer_id_unknown = gv_customer_id_unknown + 1.
      READ TABLE lt_customer_id TRANSPORTING NO FIELDS WITH TABLE KEY table_line = gv_customer_id_unknown.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
    ENDDO.
  ENDMETHOD.