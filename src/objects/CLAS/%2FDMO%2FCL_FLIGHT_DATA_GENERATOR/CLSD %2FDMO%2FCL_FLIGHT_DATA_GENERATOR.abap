class-pool .
*"* class pool for class /DMO/CL_FLIGHT_DATA_GENERATOR

*"* local type definitions
include /DMO/CL_FLIGHT_DATA_GENERATOR=ccdef.

*"* class /DMO/CL_FLIGHT_DATA_GENERATOR definition
*"* public declarations
  include /DMO/CL_FLIGHT_DATA_GENERATOR=cu.
*"* protected declarations
  include /DMO/CL_FLIGHT_DATA_GENERATOR=co.
*"* private declarations
  include /DMO/CL_FLIGHT_DATA_GENERATOR=ci.
endclass. "/DMO/CL_FLIGHT_DATA_GENERATOR definition

*"* macro definitions
include /DMO/CL_FLIGHT_DATA_GENERATOR=ccmac.
*"* local class implementation
include /DMO/CL_FLIGHT_DATA_GENERATOR=ccimp.

class /DMO/CL_FLIGHT_DATA_GENERATOR implementation.
*"* method's implementations
  include methods.
endclass. "/DMO/CL_FLIGHT_DATA_GENERATOR implementation
