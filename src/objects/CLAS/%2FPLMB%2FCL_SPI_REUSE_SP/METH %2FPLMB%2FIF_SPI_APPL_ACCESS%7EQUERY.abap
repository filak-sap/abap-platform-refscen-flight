METHOD /plmb/if_spi_appl_access~query.

  DATA:
    lo_node                  TYPE REF TO    /plmb/if_spi_node_access,

    lt_message               TYPE           /plmb/t_spi_msg.

  CLEAR:
    ev_failed,
    et_node_id,
    et_node_data,
    et_node_id_rel.

  "Get node instance
  lo_node = get_node( iv_node_name = iv_node_name ).

  "Delegate call to the specific node
  CALL METHOD lo_node->query(
    EXPORTING
      iv_query_name      = iv_query_name
      it_sel_param       = it_sel_param
      iv_keys_only       = iv_keys_only
      is_options         = is_options
      it_filter_node_id  = it_filter_node_id
      it_requested_field = it_requested_field
    IMPORTING
      et_node_id         = et_node_id
      et_node_data       = et_node_data
      et_node_id_rel     = et_node_id_rel
      et_message         = lt_message ).

  "Return failed flag
  CALL METHOD /plmb/cl_spi_appl_access_utils=>evaluate_messages(
    EXPORTING
      it_message = lt_message
    IMPORTING
      ev_failed  = ev_failed ).

  "Get rid of message index since no reference data will be provided
  CALL METHOD /plmb/cl_spi_appl_access_utils=>set_msg_index(
    EXPORTING
      iv_index   = 0
    CHANGING
      ct_message = lt_message ).

  "Forward messages to Collector
  CALL METHOD ms_spi_options-collector->add_message_enh(
    EXPORTING
      it_msg            = lt_message
      iv_node_name      = iv_node_name
      iv_reference_type = /plmb/if_spi_c=>gs_c_msg_ref_type-node ).

ENDMETHOD.