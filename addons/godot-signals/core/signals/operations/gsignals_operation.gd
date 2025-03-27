## Base class for all signal operations in the GSignals system.
##
## This abstract class defines the interface for signal operations that can be applied
## to signal connections. Operations can transform or filter signal arguments before
## they reach the final callback.
##
## @abstract
class_name GSignalsOperation
extends RefCounted

#------------------------------------------
# Constants
#------------------------------------------

## Defines the types of operations that can be performed on signals.
enum GSignalsMapOperationType {
    ## Operation that filters signal arguments based on a predicate.
    FILTERING,
    ## Operation that transforms signal arguments into a new value.
    VALUE_TRANSFORMATION,
}

#------------------------------------------
# Signals
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

#------------------------------------------
# Public variables
#------------------------------------------

## The type of operation this instance represents.
var type: GSignalsMapOperationType

#------------------------------------------
# Private variables
#------------------------------------------

#------------------------------------------
# Godot override functions
#------------------------------------------

#------------------------------------------
# Public functions
#------------------------------------------

## Applies the operation to the given arguments.
##
## @param args The array of arguments to process
## @return The result of applying the operation to the arguments
## @abstract
func apply(args: Array) -> Variant:
    push_error("Not implemented")
    return null

#------------------------------------------
# Private functions
#------------------------------------------
