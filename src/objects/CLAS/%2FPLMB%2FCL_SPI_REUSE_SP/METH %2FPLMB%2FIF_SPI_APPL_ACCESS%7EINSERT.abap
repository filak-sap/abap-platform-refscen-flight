METHOD /plmb/if_spi_appl_access~insert.

  DATA:
    lv_node_name             TYPE           /plmb/spi_node_name,
    lv_parent_node_name      TYPE           /plmb/spi_node_name,

    lt_message               TYPE           /plmb/t_spi_msg,

    lo_node                  TYPE REF TO    /plmb/if_spi_node_access.

  CLEAR:
    ev_failed,
    et_index_failed,
    et_node_data,
    et_node_id_rel.

  "Set node names
  IF iv_target_node_name IS INITIAL.
    lv_node_name = iv_node_name.
  ELSE.
    lv_node_name        = iv_target_node_name.
    lv_parent_node_name = iv_node_name.
  ENDIF.

  "Get node instance
  lo_node = get_node( iv_node_name = lv_node_name ).

  "Delegate call to the specific node
  CALL METHOD lo_node->insert(
    EXPORTING
      iv_parent_node_name = lv_parent_node_name
      is_parent_node_id   = is_node_id
      is_param            = is_param
      it_node_data        = it_node_data
    IMPORTING
      et_message          = lt_message
      et_node_data        = et_node_data
      et_node_id_rel      = et_node_id_rel ).

  "Return failed flag and index failed table
  CALL METHOD /plmb/cl_spi_appl_access_utils=>evaluate_messages(
    EXPORTING
      it_message      = lt_message
    IMPORTING
      ev_failed       = ev_failed
      et_index_failed = et_index_failed ).

  "Forward messages to Collector
  CALL METHOD /plmb/cl_spi_appl_access_utils=>add_insert_msg_to_collector(
    EXPORTING
      iv_node_name   = lv_node_name
      it_message     = lt_message
      it_import_data = it_node_data
      it_export_data = et_node_data
      it_node_id_rel = et_node_id_rel
      io_collector   = ms_spi_options-collector ).

ENDMETHOD.