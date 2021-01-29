METHOD /plmb/if_spi_appl_access~check_before_save.

  DATA:
    lv_severity              TYPE           /plmb/spi_msg_severity,

    lt_message               TYPE           /plmb/t_spi_msg.

  CLEAR ev_failed.

  "Delegate call to application
  CALL METHOD check_before_save(
    IMPORTING
      et_message = lt_message ).

  "Set failed flag if any error occured
  CALL METHOD /plmb/cl_spi_appl_access_utils=>get_severity(
    EXPORTING
      it_message      = lt_message
    IMPORTING
      ev_msg_severity = lv_severity ).
  IF lv_severity CA /plmb/if_spi_c=>gs_c_severity_category-error_or_worse.
    ev_failed = abap_true.
  ENDIF.

  "Forward messages to Collector
  CALL METHOD ms_spi_options-collector->add_message_enh(
    EXPORTING
      it_msg            = lt_message
      iv_reference_type = /plmb/if_spi_c=>gs_c_msg_ref_type-abb ).

ENDMETHOD.