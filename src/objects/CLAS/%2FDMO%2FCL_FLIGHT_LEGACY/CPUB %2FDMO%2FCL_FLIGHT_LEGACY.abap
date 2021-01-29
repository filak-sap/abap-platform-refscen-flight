CLASS /dmo/cl_flight_legacy DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS /dmo/cl_flight_data_generator.

  PUBLIC SECTION.
    INTERFACES /dmo/if_flight_legacy.

    TYPES: BEGIN OF ENUM ty_change_mode STRUCTURE change_mode," Key checks are done separately
             create,
             update," Only fields that have been changed need to be checked
           END OF ENUM ty_change_mode STRUCTURE change_mode.

    CLASS-METHODS: get_instance RETURNING VALUE(ro_instance) TYPE REF TO /dmo/cl_flight_legacy.

    "   With respect to the same method call of create/update/delete_travel() we have All or Nothing.
    "   I.e. when one of the levels contains an error, the complete call is refused.
    "   However, the buffer is not cleared in case of an error.
    "   I.e. when the caller wants to start over, he needs to call Initialize() explicitly.

    METHODS set_status_to_booked IMPORTING iv_travel_id TYPE /dmo/travel_id
                                 EXPORTING et_messages  TYPE /dmo/if_flight_legacy=>tt_if_t100_message.

    METHODS create_travel IMPORTING is_travel             TYPE /dmo/if_flight_legacy=>ts_travel_in
                                    it_booking            TYPE /dmo/if_flight_legacy=>tt_booking_in OPTIONAL
                                    it_booking_supplement TYPE /dmo/if_flight_legacy=>tt_booking_supplement_in OPTIONAL
                          EXPORTING es_travel             TYPE /dmo/travel
                                    et_booking            TYPE /dmo/if_flight_legacy=>tt_booking
                                    et_booking_supplement TYPE /dmo/if_flight_legacy=>tt_booking_supplement
                                    et_messages           TYPE /dmo/if_flight_legacy=>tt_if_t100_message.
    METHODS update_travel IMPORTING is_travel              TYPE /dmo/if_flight_legacy=>ts_travel_in
                                    is_travelx             TYPE /dmo/if_flight_legacy=>ts_travel_inx
                                    it_booking             TYPE /dmo/if_flight_legacy=>tt_booking_in OPTIONAL
                                    it_bookingx            TYPE /dmo/if_flight_legacy=>tt_booking_inx OPTIONAL
                                    it_booking_supplement  TYPE /dmo/if_flight_legacy=>tt_booking_supplement_in OPTIONAL
                                    it_booking_supplementx TYPE /dmo/if_flight_legacy=>tt_booking_supplement_inx OPTIONAL
                          EXPORTING es_travel              TYPE /dmo/travel
                                    et_booking             TYPE /dmo/if_flight_legacy=>tt_booking
                                    et_booking_supplement  TYPE /dmo/if_flight_legacy=>tt_booking_supplement
                                    et_messages            TYPE /dmo/if_flight_legacy=>tt_if_t100_message.
    METHODS delete_travel IMPORTING iv_travel_id TYPE /dmo/travel_id
                          EXPORTING et_messages  TYPE /dmo/if_flight_legacy=>tt_if_t100_message.
    METHODS get_travel IMPORTING iv_travel_id           TYPE /dmo/travel_id
                                 iv_include_buffer      TYPE abap_boolean
                                 iv_include_temp_buffer TYPE abap_boolean OPTIONAL
                       EXPORTING es_travel              TYPE /dmo/travel
                                 et_booking             TYPE /dmo/if_flight_legacy=>tt_booking
                                 et_booking_supplement  TYPE /dmo/if_flight_legacy=>tt_booking_supplement
                                 et_messages            TYPE /dmo/if_flight_legacy=>tt_if_t100_message.
    METHODS save.
    METHODS initialize.
    METHODS convert_messages IMPORTING it_messages TYPE /dmo/if_flight_legacy=>tt_if_t100_message
                             EXPORTING et_messages TYPE /dmo/if_flight_legacy=>tt_message.