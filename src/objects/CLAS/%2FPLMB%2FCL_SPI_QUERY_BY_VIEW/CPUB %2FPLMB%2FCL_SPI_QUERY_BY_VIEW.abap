class /PLMB/CL_SPI_QUERY_BY_VIEW definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF gty_s_comp_name_mapping,
        comp_name_node TYPE string,
        comp_name_view TYPE string,
      END OF gty_s_comp_name_mapping .
  types:
    gty_t_comp_name_mapping TYPE HASHED TABLE OF gty_s_comp_name_mapping WITH UNIQUE KEY comp_name_node .

  methods CONSTRUCTOR
    importing
      !IV_VIEW_NAME type TABNAME
      !IT_COMP_NAME_MAPPING type GTY_T_COMP_NAME_MAPPING optional
      !IO_AUTHORIZATION_CHECK type ref to /PLMB/IF_SPI_QUERY_AUTH optional .
  methods QUERY
    importing
      !IS_OPTIONS type /PLMB/S_SPI_QUERY_OPTIONS optional
      !IT_SEL_PARAM type /PLMB/T_SPI_SELECTION_PARAM optional
      !IT_FILTER_NODE_ID type INDEX TABLE optional
    exporting
      !ET_NODE_ID type INDEX TABLE
      !ET_MESSAGE type /PLMB/T_SPI_MSG
      !EV_SEVERITY type /PLMB/SPI_MSG_SEVERITY .