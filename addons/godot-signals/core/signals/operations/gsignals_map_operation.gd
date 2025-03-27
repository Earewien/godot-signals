## Operation that transforms signal arguments into a new value.
##
## This operation takes a mapper Callable and uses it to transform the signal
## arguments into a new value before passing them to the callback. The mapper
## can combine multiple arguments into a single value or transform them in any way.
##
## Example:
## [codeblock]
## # Transform a position signal into a distance from origin
## var map_op = GSignalsMapOperation.new(func(x, y): return sqrt(x*x + y*y))
## [/codeblock]
class_name GSignalsMapOperation
extends GSignalsCallableOperation

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

#------------------------------------------
# Godot override functions
#------------------------------------------

## Creates a new map operation.
##
## @param mapper The Callable that transforms the signal arguments
func _init(mapper: Callable) -> void:
    super (mapper)
    type = GSignalsMapOperationType.VALUE_TRANSFORMATION

#------------------------------------------
# Public functions
#------------------------------------------

#------------------------------------------
# Private functions
#------------------------------------------
