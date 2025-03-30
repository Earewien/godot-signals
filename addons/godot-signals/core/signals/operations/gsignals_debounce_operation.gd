## Signal operation that debounces a signal, only allowing it to emit after a quiet period
##
## This operation delays processing the signal until a certain period of quiet time has passed
## without the signal being triggered again. This is useful for handling rapid signal emissions
## where you only want to process the last one after the activity settles.
class_name GSignalsDebounceOperation
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

## The debounce wait duration in seconds
var wait_time_s: float
## The awaiter instance currently in use
var _current_awaiter: GAwaiter

#------------------------------------------
# Godot override functions
#------------------------------------------

## Creates a new debounce operation
##
## [param wait_time] The time to wait after the last signal before processing it (in seconds)
func _init(wait_time: float) -> void:
    wait_time_s = wait_time

#------------------------------------------
# Public functions
#------------------------------------------

## Applies the debounce operation to the signal chain
##
## This manages the timer for debouncing and ensures only one signal gets
## processed after the quiet period ends.
##
## [param args] The signal arguments
## [return] The unmodified args if the signal should pass, null if it should be dropped
func apply(args: Array) -> Variant:
    # Cancel any existing timer
    if _current_awaiter != null:
        _current_awaiter.cancel()

    # Create awaiter if needed
    if _current_awaiter == null:
        _current_awaiter = GSignalsUtils.create_awaiter()

    # Start awaiter for subsequent signals
    if not await _current_awaiter.wait_for(wait_time_s):
        return null

    # For leading edge, drop subsequent signals during quiet period
    return args

#------------------------------------------
# Private functions
#------------------------------------------
