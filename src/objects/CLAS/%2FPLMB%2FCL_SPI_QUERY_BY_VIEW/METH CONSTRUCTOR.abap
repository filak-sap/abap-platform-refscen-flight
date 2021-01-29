METHOD constructor.

  ASSERT:
    iv_view_name IS NOT INITIAL.

  " Save passed parameters
  mv_view_name = iv_view_name.

  IF it_comp_name_mapping IS SUPPLIED.
    mt_comp_name_mapping = it_comp_name_mapping.
  ENDIF.

  IF io_authorization_check IS SUPPLIED.
    mo_authorization_check = io_authorization_check.
  ENDIF.

ENDMETHOD.