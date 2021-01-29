PRIVATE SECTION.

    CLASS-METHODS new_message
                            IMPORTING id                    TYPE symsgid
                                      number                TYPE symsgno
                                      severity              TYPE if_abap_behv_message=>t_severity
                                      v1                    TYPE simple OPTIONAL
                                      v2                    TYPE simple OPTIONAL
                                      v3                    TYPE simple OPTIONAL
                                      v4                    TYPE simple OPTIONAL
                              RETURNING VALUE(obj)          TYPE REF TO if_abap_behv_message .


