METHOD /plmb/if_spi_properties_access~get_operation_properties.

  DATA:
    lv_node_name             TYPE           /plmb/spi_node_name,
    lv_parent_node_name      TYPE           /plmb/spi_node_name,

    lt_message               TYPE           /plmb/t_spi_msg,
    lv_msg_reference_type	   TYPE           /plmb/spi_msg_ref_type,

    lo_node                  TYPE REF TO    /plmb/if_spi_node_access.

  CLEAR:
    et_opr_prpty_single_idx,
    et_opr_prpty_multi_idx,
    et_operation_properties.

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
  CALL METHOD lo_node->get_operation_properties(
    EXPORTING
      iv_parent_node_name     = lv_parent_node_name
      iv_reference_type       = iv_reference_type
      ig_reference_data       = ig_reference_data
    IMPORTING
      et_opr_prpty_single_idx = et_opr_prpty_single_idx
      et_opr_prpty_multi_idx  = et_opr_prpty_multi_idx
      et_operation_properties = et_operation_properties
      et_message              = lt_message ).

  CALL METHOD /plmb/cl_spi_appl_access_utils=>map_opr_property_ref_type
    EXPORTING
      iv_opr_property_reference_type = iv_reference_type
      iv_node_name                   = iv_node_name
      iv_target_node_name            = iv_target_node_name
    IMPORTING
      ev_message_reference_type      = lv_msg_reference_type
      ev_node_name                   = lv_node_name.

  "Forward messages to Collector
  CALL METHOD ms_spi_options-collector->add_message_enh
    EXPORTING
      it_msg            = lt_message
      iv_node_name      = lv_node_name
      ig_reference_data = ig_reference_data
      iv_reference_type = lv_msg_reference_type.

ENDMETHOD.