METHOD get_node.

  CONSTANTS:
    lc_node_access           TYPE           seoclsname VALUE '/PLMB/IF_SPI_NODE_ACCESS',
    lc_method_initialize     TYPE           seocpdname VALUE 'INITIALIZE'.

  DATA:
    ls_node_instance         TYPE           lty_s_node_instance,
    lo_potential_node_sp     TYPE REF TO    object,
    ls_options               TYPE           /plmb/s_spi_node_options.

  FIELD-SYMBOLS:
    <ls_node_class_asg>      TYPE           /plmb/s_spi_node_class_asg,
    <ls_node_instance>       TYPE           lty_s_node_instance.

  "Check if corresponding sp_node_class was already instantiated
  READ TABLE gt_node_instance
    WITH TABLE KEY service_provider = me
                   node_name        = iv_node_name
    ASSIGNING <ls_node_instance>.
  IF sy-subrc IS NOT INITIAL.
    "Get class name for node
    READ TABLE mt_node_class_asg ASSIGNING <ls_node_class_asg>
      WITH TABLE KEY node_name = iv_node_name.
    IF sy-subrc IS NOT INITIAL.
      "Entry must exist, for each node defined in the metadata provider
      "a class name must be provided by method DEFINE_NODE_CLASS_ASG
      RAISE EXCEPTION TYPE /plmb/cx_spi_services_error.
    ENDIF.

    "Instantiate new sp node class
    ls_node_instance-service_provider = me.
    ls_node_instance-node_name        = iv_node_name.

    "Create SP instance.
    TRY.
        CREATE OBJECT lo_potential_node_sp
          TYPE
          (<ls_node_class_asg>-class_name).
      CATCH cx_sy_create_object_error.
        RAISE EXCEPTION TYPE /plmb/cx_spi_error
          EXPORTING
            textid     = /plmb/cx_spi_error=>class_not_found
            class_name = <ls_node_class_asg>-class_name.
      CATCH cx_sy_dyn_call_param_missing.
        RAISE EXCEPTION TYPE /plmb/cx_spi_error
          EXPORTING
            textid     = /plmb/cx_spi_error=>constructor_param_wrong
            class_name = <ls_node_class_asg>-class_name.
    ENDTRY.

    "Check if application access interface is implemented.
    TRY .
        ls_node_instance-node ?= lo_potential_node_sp.
      CATCH cx_sy_move_cast_error.
        RAISE EXCEPTION TYPE /plmb/cx_spi_error
          EXPORTING
            textid         = /plmb/cx_spi_error=>interface_not_implemented_sp
            interface_name = lc_node_access
            sp_name        = <ls_node_class_asg>-class_name.
    ENDTRY.

    TRY.
        "Set options.
        ls_options-node_name = iv_node_name.
        ls_options-collector = ms_spi_options-collector.
        ls_options-metadata  = ms_spi_options-metadata.
        "Initialize SP.
        ls_node_instance-node->initialize(
          EXPORTING is_options = ls_options ).
      CATCH cx_sy_dyn_call_illegal_method.
        RAISE EXCEPTION TYPE /plmb/cx_spi_error
          EXPORTING
            textid         = /plmb/cx_spi_error=>method_not_implemented
            class_name     = <ls_node_class_asg>-class_name
            method_name    = lc_method_initialize
            interface_name = lc_node_access.
    ENDTRY.

    "Buffer instance
    INSERT ls_node_instance
      INTO TABLE gt_node_instance
      ASSIGNING <ls_node_instance>.
  ENDIF.

  "Return node instance
  ro_node = <ls_node_instance>-node.

ENDMETHOD.