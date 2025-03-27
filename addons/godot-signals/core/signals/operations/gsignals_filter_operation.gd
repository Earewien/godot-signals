## Operation that filters signal arguments based on a predicate.
##
## This operation takes a predicate Callable and only allows signal arguments
## to pass through if the predicate returns true. If the predicate returns
## false, the signal is filtered out and the callback is not called.
##
## Example:
## [codeblock]
## # Only process signals where the first argument is positive
## var filter_op = GSignalsFilterOperation.new(func(x): return x > 0)
## [/codeblock]
class_name GSignalsFilterOperation
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

## Creates a new filter operation.
##
## @param predicate The Callable that determines whether to allow the signal through
func _init(predicate: Callable) -> void:
    super (predicate)
    type = GSignalsMapOperationType.FILTERING

#------------------------------------------
# Public functions
#------------------------------------------

#------------------------------------------
# Private functions
#------------------------------------------
