METHOD /plmb/if_spi_appl_access~retrieve.

  DATA:
    lv_node_name             TYPE           /plmb/spi_node_name,
    lv_parent_node_name      TYPE           /plmb/spi_node_name,

    lt_message               TYPE           /plmb/t_spi_msg,
    lt_message_lock          TYPE           /plmb/t_spi_msg,
    lt_message_combined      TYPE           /plmb/t_spi_msg,

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
  CALL METHOD lo_node->retrieve(
    EXPORTING
      iv_lock             = iv_lock
      it_node_id          = it_node_id
      iv_parent_node_name = lv_parent_node_name
      it_requested_field  = it_requested_field
    IMPORTING
      et_message          = lt_message
      et_message_lock     = lt_message_lock
      et_node_data        = et_node_data
      et_node_id_rel      = et_node_id_rel ).

  "Return failed flag and index failed table
  CALL METHOD /plmb/cl_spi_appl_access_utils=>evaluate_messages_retrieve(
    EXPORTING
      it_message_lock     = lt_message_lock
      it_message_retrieve = lt_message
    IMPORTING
      et_message_combined = lt_message_combined
      ev_failed           = ev_failed
      et_index_failed     = et_index_failed ).

  "Forward messages to Collector
  CALL METHOD ms_spi_options-collector->add_message_enh(
    EXPORTING
      it_msg            = lt_message_combined
      iv_node_name      = iv_node_name
      ig_reference_data = it_node_id
      iv_reference_type = /plmb/if_spi_c=>gs_c_msg_ref_type-data_record ).

ENDMETHOD.