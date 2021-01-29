*"* components of interface /PLMB/IF_SPI_SERVICES_C
INTERFACE /plmb/if_spi_services_c
  PUBLIC .


  CONSTANTS:
    BEGIN OF gs_c_query_name,
 	    query_by_gos_internal_key   TYPE /plmb/spi_query_name VALUE 'QUERY_BY_GOS_INTERNAL_KEY',
      query_by_readable_key       TYPE /plmb/spi_query_name VALUE 'QUERY_BY_READABLE_KEY',
    END   OF gs_c_query_name.

ENDINTERFACE.                    "/PLMB/IF_SPI_SERVICES_C