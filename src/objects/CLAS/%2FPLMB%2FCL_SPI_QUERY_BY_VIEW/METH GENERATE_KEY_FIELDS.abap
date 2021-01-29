METHOD generate_key_fields.

  DATA:
    lt_components_node_id  TYPE        cl_abap_structdescr=>included_view,
    lo_tabledescr_node_id  TYPE REF TO cl_abap_tabledescr,
    lo_structdescr_node_id TYPE REF TO cl_abap_structdescr,
    lv_comp_node           TYPE        fieldname,
    lv_comp_view           TYPE        string.

  FIELD-SYMBOLS:
    <ls_component_node_id> TYPE abap_simple_componentdescr.

  CLEAR:
    et_message,
    ev_failed,
    ev_key_fields.

  " Get components of the node id table type
  lo_tabledescr_node_id ?= cl_abap_structdescr=>describe_by_data( it_node_id ).
  lo_structdescr_node_id ?= lo_tabledescr_node_id->get_table_line_type( ).
  lt_components_node_id = lo_structdescr_node_id->get_included_view( ).

  LOOP AT lt_components_node_id ASSIGNING <ls_component_node_id>.
    " Add space after every key component
    IF ev_key_fields IS NOT INITIAL.
      ev_key_fields = ev_key_fields && ` `.
    ENDIF.

    " Add the key component
    lv_comp_node = <ls_component_node_id>-name.
    lv_comp_view = get_mapped_view_component( lv_comp_node ).
    ev_key_fields = ev_key_fields && lv_comp_view.

    " Map view field to node component if necessary
    IF lv_comp_node <> lv_comp_view.
      ev_key_fields = ev_key_fields && ` AS ` && lv_comp_node.
    ENDIF.
  ENDLOOP.

ENDMETHOD.