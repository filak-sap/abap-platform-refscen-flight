METHOD adjust_number_of_results.

  IF iv_requ_number_of_results > 0.
    IF lines( ct_node_id ) > iv_requ_number_of_results.
      DELETE ct_node_id FROM iv_requ_number_of_results + 1.
    ENDIF.
  ENDIF.

ENDMETHOD.