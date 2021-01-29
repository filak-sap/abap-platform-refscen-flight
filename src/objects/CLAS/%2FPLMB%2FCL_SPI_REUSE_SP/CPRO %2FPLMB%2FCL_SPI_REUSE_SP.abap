protected section.

  aliases MS_SPI_OPTIONS
    for /PLMB/IF_SPI_APPL_ACCESS_INIT~MS_SPI_OPTIONS .

  methods CHECK_BEFORE_SAVE
  abstract
    exporting
      !ET_MESSAGE type /PLMB/T_SPI_MSG .
  methods CLEAN_UP
  abstract
    importing
      !IV_REASON type /PLMB/SPI_CLEAN_UP_REASON optional
    exporting
      !ET_MESSAGE type /PLMB/T_SPI_MSG .
  methods SAVE
  abstract
    exporting
      !ET_MESSAGE type /PLMB/T_SPI_MSG .
  methods DEFINE_NODE_CLASS_ASSIGNMENT
  abstract
    exporting
      !ET_ASSIGNMENT type /PLMB/T_SPI_NODE_CLASS_ASG .