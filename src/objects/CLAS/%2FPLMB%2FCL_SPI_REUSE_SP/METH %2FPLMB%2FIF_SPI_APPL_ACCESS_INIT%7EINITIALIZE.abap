METHOD /plmb/if_spi_appl_access_init~initialize.

  "Buffer SPI options (Collector, Metadata Provider)
  ms_spi_options = is_options.

  "Get node class assignment
  define_node_class_assignment(
    IMPORTING et_assignment = mt_node_class_asg ).

ENDMETHOD.