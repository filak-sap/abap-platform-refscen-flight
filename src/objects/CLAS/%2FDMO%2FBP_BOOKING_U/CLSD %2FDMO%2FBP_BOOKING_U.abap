class-pool .
*"* class pool for class /DMO/BP_BOOKING_U

*"* local type definitions
include /DMO/BP_BOOKING_U=============ccdef.

*"* class /DMO/BP_BOOKING_U definition
*"* public declarations
  include /DMO/BP_BOOKING_U=============cu.
*"* protected declarations
  include /DMO/BP_BOOKING_U=============co.
*"* private declarations
  include /DMO/BP_BOOKING_U=============ci.
endclass. "/DMO/BP_BOOKING_U definition

*"* macro definitions
include /DMO/BP_BOOKING_U=============ccmac.
*"* local class implementation
include /DMO/BP_BOOKING_U=============ccimp.

class /DMO/BP_BOOKING_U implementation.
*"* method's implementations
  include methods.
endclass. "/DMO/BP_BOOKING_U implementation
