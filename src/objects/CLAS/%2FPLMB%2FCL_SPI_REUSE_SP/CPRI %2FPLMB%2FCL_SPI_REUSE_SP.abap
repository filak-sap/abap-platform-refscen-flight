private section.

  types:
    BEGIN OF lty_s_node_instance,
      service_provider  TYPE REF TO  /plmb/if_spi_appl_access,
      node_name         TYPE         /plmb/spi_node_name,
      node              TYPE REF TO  /plmb/if_spi_node_access,
    END OF lty_s_node_instance .
  types:
    lty_t_node_instance  TYPE SORTED TABLE OF lty_s_node_instance WITH UNIQUE KEY service_provider node_name .

  data MT_NODE_CLASS_ASG type /PLMB/T_SPI_NODE_CLASS_ASG .
  class-data GT_NODE_INSTANCE type LTY_T_NODE_INSTANCE .

  methods GET_NODE
    importing
      !IV_NODE_NAME type /PLMB/SPI_NODE_NAME
    returning
      value(RO_NODE) type ref to /PLMB/IF_SPI_NODE_ACCESS .