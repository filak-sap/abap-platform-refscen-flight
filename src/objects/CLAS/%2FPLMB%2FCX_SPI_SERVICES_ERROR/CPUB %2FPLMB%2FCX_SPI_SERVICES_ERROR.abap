class /PLMB/CX_SPI_SERVICES_ERROR definition
  public
  inheriting from CX_NO_CHECK
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional .