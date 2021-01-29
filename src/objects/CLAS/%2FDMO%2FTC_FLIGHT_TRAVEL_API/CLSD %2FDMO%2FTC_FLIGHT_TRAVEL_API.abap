class-pool .
*"* class pool for class /DMO/TC_FLIGHT_TRAVEL_API

*"* local type definitions
include /DMO/TC_FLIGHT_TRAVEL_API=====ccdef.

*"* class /DMO/TC_FLIGHT_TRAVEL_API definition
*"* public declarations
  include /DMO/TC_FLIGHT_TRAVEL_API=====cu.
*"* protected declarations
  include /DMO/TC_FLIGHT_TRAVEL_API=====co.
*"* private declarations
  include /DMO/TC_FLIGHT_TRAVEL_API=====ci.
endclass. "/DMO/TC_FLIGHT_TRAVEL_API definition

*"* macro definitions
include /DMO/TC_FLIGHT_TRAVEL_API=====ccmac.
*"* local class implementation
include /DMO/TC_FLIGHT_TRAVEL_API=====ccimp.

*"* test class
include /DMO/TC_FLIGHT_TRAVEL_API=====ccau.

class /DMO/TC_FLIGHT_TRAVEL_API implementation.
*"* method's implementations
  include methods.
endclass. "/DMO/TC_FLIGHT_TRAVEL_API implementation
