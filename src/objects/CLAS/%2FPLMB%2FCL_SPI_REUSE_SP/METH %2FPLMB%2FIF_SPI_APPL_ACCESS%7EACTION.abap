METHOD /plmb/if_spi_appl_access~action.

  DATA:
    lt_message               TYPE           /plmb/t_spi_msg,

    lo_node                  TYPE REF TO    /plmb/if_spi_node_access.

  CLEAR:
    ev_failed,
    et_index_failed,
    et_node_data,
    eg_param.

  "Get node instance
  lo_node = get_node( iv_node_name = iv_node_name ).

  "Delegate call to the specific node
  CALL METHOD lo_node->action(
    EXPORTING
      iv_action_name = iv_action_name
      is_param       = is_param
      it_node_id     = it_node_id
    IMPORTING
      et_message     = lt_message
      et_node_data   = et_node_data
      eg_param       = eg_param ).

  "Return failed flag and index failed table
  CALL METHOD /plmb/cl_spi_appl_access_utils=>evaluate_messages(
    EXPORTING
      it_message      = lt_message
    IMPORTING
      ev_failed       = ev_failed
      et_index_failed = et_index_failed ).

  "Forward messages to Collector
  CALL METHOD ms_spi_options-collector->add_message_enh(
    EXPORTING
      it_msg            = lt_message
      iv_node_name      = iv_node_name
      ig_reference_data = it_node_id
      iv_reference_type = /plmb/if_spi_c=>gs_c_msg_ref_type-data_record ).

ENDMETHOD.