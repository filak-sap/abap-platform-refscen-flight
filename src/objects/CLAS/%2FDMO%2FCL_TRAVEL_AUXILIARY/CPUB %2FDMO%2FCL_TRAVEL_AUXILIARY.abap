CLASS /dmo/cl_travel_auxiliary DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.


*   Type definition for import parameters --------------------------
    TYPES tt_travel_create              TYPE TABLE FOR CREATE   /dmo/i_travel_u.
    TYPES tt_travel_update              TYPE TABLE FOR UPDATE   /dmo/i_travel_u.
    TYPES tt_travel_delete              TYPE TABLE FOR DELETE   /dmo/i_travel_u.

    TYPES tt_travel_failed              TYPE TABLE FOR FAILED   /dmo/i_travel_u.
    TYPES tt_travel_mapped              TYPE TABLE FOR MAPPED   /dmo/i_travel_u.
    TYPES tt_travel_reported            TYPE TABLE FOR REPORTED /dmo/i_travel_u.

    TYPES tt_booking_create             TYPE TABLE FOR CREATE    /dmo/i_booking_u.
    TYPES tt_booking_update             TYPE TABLE FOR UPDATE    /dmo/i_booking_u.
    TYPES tt_booking_delete             TYPE TABLE FOR DELETE    /dmo/i_booking_u.

    TYPES tt_booking_failed             TYPE TABLE FOR FAILED    /dmo/i_booking_u.
    TYPES tt_booking_mapped             TYPE TABLE FOR MAPPED    /dmo/i_booking_u.
    TYPES tt_booking_reported           TYPE TABLE FOR REPORTED  /dmo/i_booking_u.

    TYPES tt_bookingsupplement_failed   TYPE TABLE FOR FAILED    /dmo/i_bookingsupplement_u.
    TYPES tt_bookingsupplement_mapped   TYPE TABLE FOR MAPPED    /dmo/i_bookingsupplement_u.
    TYPES tt_bookingsupplement_reported TYPE TABLE FOR REPORTED  /dmo/i_bookingsupplement_u.


    CLASS-METHODS map_travel_cds_to_db
                            IMPORTING   is_i_travel_u       TYPE /dmo/i_travel_u
                            RETURNING VALUE(rs_travel)      TYPE /dmo/if_flight_legacy=>ts_travel_in.


    CLASS-METHODS map_travel_message
                            IMPORTING iv_cid                TYPE string OPTIONAL
                                      iv_travel_id          TYPE /dmo/travel_id OPTIONAL
                                      is_message            TYPE LINE OF /dmo/if_flight_legacy=>tt_message
                            RETURNING VALUE(rs_report)      TYPE LINE OF tt_travel_reported.



    CLASS-METHODS map_booking_cds_to_db
                            IMPORTING is_i_booking          TYPE /dmo/i_booking_u
                            RETURNING VALUE(rs_booking)     TYPE /dmo/if_flight_legacy=>ts_booking_in.



    CLASS-METHODS map_booking_message
                            IMPORTING iv_cid                TYPE string OPTIONAL
                                      iv_travel_id          TYPE /dmo/travel_id OPTIONAL
                                      iv_booking_id         TYPE /dmo/booking_id OPTIONAL
                                      is_message            TYPE LINE OF /dmo/if_flight_legacy=>tt_message
                            RETURNING VALUE(rs_report)      TYPE LINE OF tt_booking_reported.


    CLASS-METHODS map_bookingsupplemnt_cds_to_db
                            IMPORTING is_i_bookingsupplement      TYPE /dmo/i_bookingsupplement_u
                            RETURNING VALUE(rs_bookingsupplement) TYPE /dmo/if_flight_legacy=>ts_booking_supplement_in.



    CLASS-METHODS map_bookingsupplemnt_message
                            IMPORTING iv_cid                  TYPE string OPTIONAL
                                      iv_travel_id            TYPE /dmo/travel_id OPTIONAL
                                      iv_booking_id           TYPE /dmo/booking_id OPTIONAL
                                      iv_bookingsupplement_id TYPE /dmo/booking_supplement_id OPTIONAL
                                      is_message              TYPE LINE OF /dmo/if_flight_legacy=>tt_message
                            RETURNING VALUE(rs_report)        TYPE LINE OF tt_bookingsupplement_reported.
