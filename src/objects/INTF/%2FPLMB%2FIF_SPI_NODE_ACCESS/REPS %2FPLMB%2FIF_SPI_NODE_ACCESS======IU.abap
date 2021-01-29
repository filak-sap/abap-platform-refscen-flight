*"* components of interface /PLMB/IF_SPI_NODE_ACCESS
interface /PLMB/IF_SPI_NODE_ACCESS
  public .


  methods QUERY
    importing
      !IV_QUERY_NAME type /PLMB/SPI_QUERY_NAME
      !IT_SEL_PARAM type /PLMB/T_SPI_SELECTION_PARAM optional
      !IS_OPTIONS type /PLMB/S_SPI_QUERY_OPTIONS optional
      !IV_KEYS_ONLY type /PLMB/SPI_KEYS_ONLY_IND optional
      !IT_FILTER_NODE_ID type INDEX TABLE optional
      !IT_REQUESTED_FIELD type /PLMB/T_SPI_REQUESTED_FIELD optional
    exporting
      !ET_NODE_ID type INDEX TABLE
      !ET_NODE_DATA type INDEX TABLE
      !ET_NODE_ID_REL type /PLMB/T_SPI_NODE_REL
      !ET_MESSAGE type /PLMB/T_SPI_MSG .
  methods RETRIEVE
    importing
      !IV_PARENT_NODE_NAME type /PLMB/SPI_NODE_NAME optional
      !IT_NODE_ID type INDEX TABLE
      !IT_REQUESTED_FIELD type /PLMB/T_SPI_REQUESTED_FIELD optional
      !IV_LOCK type /PLMB/SPI_LOCK_IND optional
    exporting
      !ET_NODE_DATA type INDEX TABLE
      !ET_NODE_ID_REL type /PLMB/T_SPI_NODE_REL
      !ET_MESSAGE type /PLMB/T_SPI_MSG
      !ET_MESSAGE_LOCK type /PLMB/T_SPI_MSG .
  methods INSERT
    importing
      !IV_PARENT_NODE_NAME type /PLMB/SPI_NODE_NAME optional
      !IS_PARENT_NODE_ID type ANY optional
      !IT_NODE_DATA type INDEX TABLE
      !IS_PARAM type ANY optional
    exporting
      !ET_NODE_DATA type INDEX TABLE
      !ET_NODE_ID_REL type /PLMB/T_SPI_NODE_REL
      !ET_MESSAGE type /PLMB/T_SPI_MSG .
  methods UPDATE
    importing
      !IT_NODE_DATA type INDEX TABLE
      !IT_CHANGED_FIELD type /PLMB/T_SPI_CHANGED_FIELD optional
    exporting
      !ET_NODE_DATA type INDEX TABLE
      !ET_NODE_ID_REL type /PLMB/T_SPI_NODE_REL
      !ET_MESSAGE type /PLMB/T_SPI_MSG .
  methods DELETE
    importing
      !IT_NODE_ID type INDEX TABLE
    exporting
      !ET_MESSAGE type /PLMB/T_SPI_MSG .
  methods ACTION
    importing
      !IV_ACTION_NAME type /PLMB/SPI_ACTION_NAME
      !IT_NODE_ID type INDEX TABLE optional
      !IS_PARAM type ANY optional
    exporting
      !ET_NODE_DATA type INDEX TABLE
      !EG_PARAM type ANY
      !ET_MESSAGE type /PLMB/T_SPI_MSG .
  methods INITIALIZE
    importing
      !IS_OPTIONS type /PLMB/S_SPI_NODE_OPTIONS .
  methods GET_PROPERTIES
    importing
      !IV_PARENT_NODE_NAME type /PLMB/SPI_NODE_NAME optional
      !IV_REFERENCE_TYPE type /PLMB/SPI_PRPTY_REF_TYPE
      !IG_REFERENCE_DATA type ANY optional
    exporting
      !ET_PROPERTIES_SINGLE_IDX type /PLMB/T_SPI_INDEXED_PROPERTY
      !ET_PROPERTIES_MULTI_IDX type /PLMB/T_SPI_INDEXED_PRP_MULTI
      !ET_PROPERTIES type /PLMB/T_SPI_PROPERTIES
      !ET_MESSAGE type /PLMB/T_SPI_MSG .
  methods GET_OPERATION_PROPERTIES
    importing
      !IV_PARENT_NODE_NAME type /PLMB/SPI_NODE_NAME optional
      !IV_REFERENCE_TYPE type /PLMB/SPI_OPR_PRPTY_REF_TYPE
      !IG_REFERENCE_DATA type ANY optional
    exporting
      !ET_OPR_PRPTY_SINGLE_IDX type /PLMB/T_SPI_INDEXED_OPR_PRPTY
      !ET_OPR_PRPTY_MULTI_IDX type /PLMB/T_SPI_NDX_OPR_PRPTY_MULT
      !ET_OPERATION_PROPERTIES type /PLMB/T_SPI_OPERATION_PRPTY
      !ET_MESSAGE type /PLMB/T_SPI_MSG .
endinterface.