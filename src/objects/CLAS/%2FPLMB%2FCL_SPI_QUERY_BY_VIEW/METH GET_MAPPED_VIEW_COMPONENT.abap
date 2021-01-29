METHOD get_mapped_view_component.

  FIELD-SYMBOLS:
    <ls_comp_name_mapping> TYPE gty_s_comp_name_mapping.

  CLEAR:
    rv_comp_name_view.

  READ TABLE mt_comp_name_mapping WITH TABLE KEY comp_name_node = iv_comp_name_node ASSIGNING <ls_comp_name_mapping>.
  IF sy-subrc = 0.
    rv_comp_name_view = <ls_comp_name_mapping>-comp_name_view.
  ELSE.
    " If no mapping exists, we assume that component name in view = component name for node
    rv_comp_name_view = iv_comp_name_node.
  ENDIF.

ENDMETHOD.