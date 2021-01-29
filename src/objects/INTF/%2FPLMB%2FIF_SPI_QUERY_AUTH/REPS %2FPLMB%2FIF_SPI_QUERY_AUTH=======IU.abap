interface /PLMB/IF_SPI_QUERY_AUTH
  public .


  methods CHECK_AUTHORIZATIONS
    importing
      !IT_OBJECT_ID type INDEX TABLE
    exporting
      !ET_OBJECT_ID_WITHOUT_AUTH type INDEX TABLE
      !ET_OBJECT_ID_WITH_AUTH type INDEX TABLE
      !ET_MESSAGE type /PLMB/T_SPI_MSG
      !EV_FAILED type /PLMB/SPI_FAILED_IND .
endinterface.