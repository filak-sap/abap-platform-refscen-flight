METHOD /plmb/if_spi_appl_access~clean_up.

  DATA:
    lt_message               TYPE           /plmb/t_spi_msg.

  "Delegate call to application
  CALL METHOD clean_up(
    EXPORTING
      iv_reason  = iv_reason
    IMPORTING
      et_message = lt_message ).

  "Forward messages to Collector
  CALL METHOD ms_spi_options-collector->add_message_enh(
    EXPORTING
      it_msg            = lt_message
      iv_reference_type = /plmb/if_spi_c=>gs_c_msg_ref_type-abb ).

ENDMETHOD.