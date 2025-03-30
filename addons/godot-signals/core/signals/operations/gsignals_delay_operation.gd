## Signal operation that introduces a time delay in the signal processing chain
##
## This operation pauses the signal processing pipeline for a specified
## duration before allowing it to continue to the next operation. The signal
## arguments are preserved through the delay.
class_name GSignalsDelayOperation
extends GSignalsOperation

#------------------------------------------
# Constants
#------------------------------------------

#------------------------------------------
# Signals
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

#------------------------------------------
# Public variables
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

## The delay duration in seconds
var delay_s: float

#------------------------------------------
# Godot override functions
#------------------------------------------

## Creates a new delay operation
##
## [param d] The delay time in seconds
func _init(d: float) -> void:
    delay_s = d

#------------------------------------------
# Public functions
#------------------------------------------

## Applies the delay operation to the signal chain
##
## This creates an awaiter to pause processing for the specified duration.
## The signal arguments are unchanged by this operation.
##
## [param args] The signal arguments
## [return] A null value, always
func apply(args: Array) -> Variant:
    var awaiter: GAwaiter = GSignalsUtils.create_awaiter()
    await awaiter.wait_for(delay_s)
    return null

#------------------------------------------
# Private functions
#------------------------------------------
