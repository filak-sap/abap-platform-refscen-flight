class-pool .
*"* class pool for class /DMO/CL_FLIGHT_LEGACY

*"* local type definitions
include /DMO/CL_FLIGHT_LEGACY=========ccdef.

*"* class /DMO/CL_FLIGHT_LEGACY definition
*"* public declarations
  include /DMO/CL_FLIGHT_LEGACY=========cu.
*"* protected declarations
  include /DMO/CL_FLIGHT_LEGACY=========co.
*"* private declarations
  include /DMO/CL_FLIGHT_LEGACY=========ci.
endclass. "/DMO/CL_FLIGHT_LEGACY definition

*"* macro definitions
include /DMO/CL_FLIGHT_LEGACY=========ccmac.
*"* local class implementation
include /DMO/CL_FLIGHT_LEGACY=========ccimp.

*"* test class
include /DMO/CL_FLIGHT_LEGACY=========ccau.

class /DMO/CL_FLIGHT_LEGACY implementation.
*"* method's implementations
  include methods.
endclass. "/DMO/CL_FLIGHT_LEGACY implementation
