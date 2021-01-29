private section.

  data MV_VIEW_NAME type TABNAME .
  data MT_COMP_NAME_MAPPING type GTY_T_COMP_NAME_MAPPING .
  data MO_AUTHORIZATION_CHECK type ref to /PLMB/IF_SPI_QUERY_AUTH .

  methods VALIDATE_QUERY_PARAMETERS
    importing
      !IS_OPTIONS type /PLMB/S_SPI_QUERY_OPTIONS
      !IT_SEL_PARAM type /PLMB/T_SPI_SELECTION_PARAM
    exporting
      !ET_MESSAGE type /PLMB/T_SPI_MSG
      !EV_FAILED type /PLMB/SPI_FAILED_IND .
  methods GENERATE_KEY_FIELDS
    importing
      !IT_NODE_ID type INDEX TABLE
    exporting
      !EV_KEY_FIELDS type STRING
      !ET_MESSAGE type /PLMB/T_SPI_MSG
      !EV_FAILED type /PLMB/SPI_FAILED_IND .
  methods GENERATE_WHERE_CLAUSE
    importing
      !IT_SEL_PARAM type /PLMB/T_SPI_SELECTION_PARAM
    exporting
      !EV_WHERE_CLAUSE type STRING
      !ET_MESSAGE type /PLMB/T_SPI_MSG
      !EV_FAILED type /PLMB/SPI_FAILED_IND .
  methods GENERATE_ORDER_BY_CLAUSE
    importing
      !IT_SORT_ORDER type /PLMB/T_SPI_SORTORDER
    exporting
      !EV_ORDER_BY_CLAUSE type STRING
      !ET_MESSAGE type /PLMB/T_SPI_MSG
      !EV_FAILED type /PLMB/SPI_FAILED_IND .
  methods ESTIMATE_NUMBER_OF_ROWS
    importing
      !IV_REQUESTED_NUMBER_OF_ROWS type /PLMB/SPI_NUMBER_OF_ROWS
      !IV_ATTEMPT type SYINDEX
    returning
      value(RV_ESTIMATED_NUMBER_OF_ROWS) type /PLMB/SPI_NUMBER_OF_ROWS .
  methods CHECK_AUTHORIZATION
    exporting
      !ET_MESSAGE type /PLMB/T_SPI_MSG
      !EV_FAILED type /PLMB/SPI_FAILED_IND
      !EV_OBJECTS_FILTERED type BOOLE_D
    changing
      !CT_NODE_ID type INDEX TABLE .
  methods FILTER_RESULTS
    importing
      !IT_FILTER_NODE_ID type INDEX TABLE
    exporting
      !ET_MESSAGE type /PLMB/T_SPI_MSG
      !EV_FAILED type /PLMB/SPI_FAILED_IND
      !EV_OBJECTS_FILTERED type BOOLE_D
    changing
      !CT_NODE_ID type INDEX TABLE .
  methods ADJUST_NUMBER_OF_RESULTS
    importing
      !IV_REQU_NUMBER_OF_RESULTS type /PLMB/SPI_NUMBER_OF_ROWS
    changing
      !CT_NODE_ID type INDEX TABLE .
  methods GET_MAPPED_VIEW_COMPONENT
    importing
      !IV_COMP_NAME_NODE type FIELDNAME
    returning
      value(RV_COMP_NAME_VIEW) type STRING .