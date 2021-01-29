  METHOD lock_travel ##NEEDED.
*   IF iv_lock = abap_true.
*     CALL FUNCTION 'ENQUEUE_/DMO/ETRAVEL'
*       EXCEPTIONS
*         foreign_lock   = 1
*         system_failure = 2
*         OTHERS         = 3.
*     IF sy-subrc <> 0.
*       RAISE EXCEPTION TYPE /dmo/cx_flight_legacy
*         EXPORTING
*           textid = /dmo/cx_flight_legacy=>travel_lock.
*     ENDIF.
*   ELSE.
*     CALL FUNCTION 'DEQUEUE_/DMO/ETRAVEL'.
*   ENDIF.
  ENDMETHOD.