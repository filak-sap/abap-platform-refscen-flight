class-pool .
*"* class pool for class /DMO/CL_TRAVEL_AUXILIARY

*"* local type definitions
include /DMO/CL_TRAVEL_AUXILIARY======ccdef.

*"* class /DMO/CL_TRAVEL_AUXILIARY definition
*"* public declarations
  include /DMO/CL_TRAVEL_AUXILIARY======cu.
*"* protected declarations
  include /DMO/CL_TRAVEL_AUXILIARY======co.
*"* private declarations
  include /DMO/CL_TRAVEL_AUXILIARY======ci.
endclass. "/DMO/CL_TRAVEL_AUXILIARY definition

*"* macro definitions
include /DMO/CL_TRAVEL_AUXILIARY======ccmac.
*"* local class implementation
include /DMO/CL_TRAVEL_AUXILIARY======ccimp.

class /DMO/CL_TRAVEL_AUXILIARY implementation.
*"* method's implementations
  include methods.
endclass. "/DMO/CL_TRAVEL_AUXILIARY implementation
