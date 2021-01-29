METHOD /plmb/if_spi_appl_access~update.

  DATA:
    lo_node                  TYPE REF TO    /plmb/if_spi_node_access,

    lt_message               TYPE           /plmb/t_spi_msg.

  CLEAR:
    ev_failed,
    et_index_failed,
    et_node_data,
    et_node_id_rel.

  "Get node instance
  lo_node = get_node( iv_node_name = iv_node_name ).

  "Delegate call to the specific node
  CALL METHOD lo_node->update(
    EXPORTING
      it_node_data     = it_node_data
      it_changed_field = it_changed_field
    IMPORTING
      et_message       = lt_message
      et_node_data     = et_node_data
      et_node_id_rel   = et_node_id_rel ).

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
      ig_reference_data = it_node_data
      iv_reference_type = /plmb/if_spi_c=>gs_c_msg_ref_type-data_record ).

ENDMETHOD.