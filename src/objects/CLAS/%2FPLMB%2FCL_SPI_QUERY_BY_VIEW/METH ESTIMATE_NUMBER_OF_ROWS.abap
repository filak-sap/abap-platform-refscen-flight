METHOD estimate_number_of_rows.

  CLEAR:
    rv_estimated_number_of_rows.

  CASE iv_attempt.

    WHEN 1.
      " 1st attempt -> assume everything works
      rv_estimated_number_of_rows = iv_requested_number_of_rows.

    WHEN 2.
      " 2nd attempt -> use same logic as F4 help
      IF iv_requested_number_of_rows > 500.
        rv_estimated_number_of_rows = iv_requested_number_of_rows * 2.
      ELSE.
        rv_estimated_number_of_rows = iv_requested_number_of_rows + 500.
      ENDIF.

    WHEN OTHERS.
      " 3rd attempt -> select everything
      rv_estimated_number_of_rows = 0.

  ENDCASE.

ENDMETHOD.