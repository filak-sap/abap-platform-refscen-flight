METHOD query.

  DATA:
    lv_failed                 TYPE /plmb/spi_failed_ind,
    lt_message                TYPE /plmb/t_spi_msg,
    lv_message                TYPE string,
    lv_key_fields             TYPE string,
    lv_where_clause           TYPE string,
    lv_order_by_clause        TYPE string,
    lv_max_rows               TYPE syindex,
    lv_number_select_attempts TYPE syindex,
    lv_objects_filtered       TYPE boole_d,
    lv_objects_filtered_auth  TYPE boole_d,
    lv_objects_filtered_filt  TYPE boole_d.

  CLEAR:
    et_node_id,
    et_message,
    ev_severity.

  " Validate query parameters and check for parameter combinations which do not make sense
  validate_query_parameters(
    EXPORTING is_options        = is_options
              it_sel_param      = it_sel_param
    IMPORTING et_message        = lt_message
              ev_failed         = lv_failed ).

  APPEND LINES OF lt_message TO et_message.
  IF lv_failed = abap_true.
    /plmb/cl_spi_appl_access_utils=>get_severity(
      EXPORTING it_message      = et_message
      IMPORTING ev_msg_severity = ev_severity ).
    RETURN.
  ENDIF.

  " Generate the key fields for the SQL SELECT statement
  generate_key_fields(
    EXPORTING it_node_id    = et_node_id
    IMPORTING ev_key_fields = lv_key_fields
              et_message    = lt_message
              ev_failed     = lv_failed ).

  APPEND LINES OF lt_message TO et_message.
  IF lv_failed = abap_true.
    /plmb/cl_spi_appl_access_utils=>get_severity(
      EXPORTING it_message      = et_message
      IMPORTING ev_msg_severity = ev_severity ).
    RETURN.
  ENDIF.

  " Generate the WHERE clause for the SQL SELECT statement
  generate_where_clause(
    EXPORTING it_sel_param    = it_sel_param
    IMPORTING ev_where_clause = lv_where_clause
              et_message      = lt_message
              ev_failed       = lv_failed ).

  APPEND LINES OF lt_message TO et_message.
  IF lv_failed = abap_true.
    /plmb/cl_spi_appl_access_utils=>get_severity(
      EXPORTING it_message      = et_message
      IMPORTING ev_msg_severity = ev_severity ).
    RETURN.
  ENDIF.

  " Generate the ORDER BY clause for the SQL SELECT statement
  generate_order_by_clause(
    EXPORTING it_sort_order      = is_options-sortorder
    IMPORTING ev_order_by_clause = lv_order_by_clause
              et_message         = lt_message
              ev_failed          = lv_failed ).

  APPEND LINES OF lt_message TO et_message.
  IF lv_failed = abap_true.
    /plmb/cl_spi_appl_access_utils=>get_severity(
      EXPORTING it_message      = et_message
      IMPORTING ev_msg_severity = ev_severity ).
    RETURN.
  ENDIF.

  " Execute the SQL query:
  " In view of a subsequent authority check and potential filtering of node IDs, the SELECT runs several times requesting more and more
  " records to make sure that the query returns the correct number of results.
  lv_number_select_attempts = 1.
  DO.
    " Estimate the number of records to request from the database
    lv_max_rows = estimate_number_of_rows(
                    iv_requested_number_of_rows = is_options-number_of_rows
                    iv_attempt                  = sy-index ).

    " Execute the SQL SELECT statement
    TRY.
        SELECT (lv_key_fields)
          FROM (mv_view_name)
          UP TO lv_max_rows ROWS
          INTO CORRESPONDING FIELDS OF TABLE et_node_id
          WHERE (lv_where_clause)
          ORDER BY (lv_order_by_clause).
      CATCH cx_sy_dynamic_osql_syntax.
        MESSAGE e021(/plmb/spi_services) INTO lv_message.   " -> Error building the SQL select statement.

        /plmb/cl_spi_appl_access_utils=>add_syst_message(
          CHANGING ct_message = et_message ).

        /plmb/cl_spi_appl_access_utils=>get_severity(
          EXPORTING it_message      = et_message
          IMPORTING ev_msg_severity = ev_severity ).
        RETURN.
    ENDTRY.

    " Apply the filter from the query parameter
    filter_results(
      EXPORTING it_filter_node_id   = it_filter_node_id
      IMPORTING ev_objects_filtered = lv_objects_filtered_filt
                et_message          = lt_message
                ev_failed           = lv_failed
      CHANGING  ct_node_id          = et_node_id ).

    APPEND LINES OF lt_message TO et_message.
    IF lv_failed = abap_true.
      /plmb/cl_spi_appl_access_utils=>get_severity(
        EXPORTING it_message      = et_message
        IMPORTING ev_msg_severity = ev_severity ).
      RETURN.
    ENDIF.

    " Filter out single objects for which the user does not have sufficient authorizations
    check_authorization(
      IMPORTING ev_objects_filtered = lv_objects_filtered_auth
                et_message          = lt_message
                ev_failed           = lv_failed
      CHANGING  ct_node_id          = et_node_id ).

    APPEND LINES OF lt_message TO et_message.
    IF lv_failed = abap_true.
      /plmb/cl_spi_appl_access_utils=>get_severity(
        EXPORTING it_message      = et_message
        IMPORTING ev_msg_severity = ev_severity ).
      RETURN.
    ENDIF.

    " Check if any objects have been filtered out
    lv_objects_filtered = boolc( lv_objects_filtered_auth = abap_true OR lv_objects_filtered_filt = abap_true ).

    lv_number_select_attempts = lv_number_select_attempts + 1.

    IF lv_objects_filtered = abap_false                     " Exit if no objects have been filtered out
      OR lines( et_node_id ) >= is_options-number_of_rows   " or if the requested number of objects has been returned
      OR lv_number_select_attempts = 3.                     " but at the latest after the third loop execution
      EXIT.
    ENDIF.
  ENDDO.

  " If too many objects have been selected, trim the result table
  adjust_number_of_results(
    EXPORTING iv_requ_number_of_results = is_options-number_of_rows
    CHANGING  ct_node_id                = et_node_id ).

  " Evaluate messages
  /plmb/cl_spi_appl_access_utils=>get_severity(
    EXPORTING it_message      = et_message
    IMPORTING ev_msg_severity = ev_severity ).

ENDMETHOD.