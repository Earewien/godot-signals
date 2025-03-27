## Base class for operations that use a Callable to process signal arguments.
##
## This abstract class provides common functionality for operations that use a
## Callable to process signal arguments. It handles different argument counts
## and provides smart argument passing based on the Callable's signature.
##
## @abstract
class_name GSignalsCallableOperation
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

## The Callable that will be used to process the signal arguments.
var callable: Callable

#------------------------------------------
# Private variables
#------------------------------------------

## Whether to use call() instead of callv() for single argument callables.
var _should_use_call: bool = false

#------------------------------------------
# Godot override functions
#------------------------------------------

## Creates a new callable operation.
##
## @param callable The Callable to use for processing arguments
func _init(callable: Callable) -> void:
    self.callable = callable
    if callable.is_standard():
        _look_for_call_method()

#------------------------------------------
# Public functions
#------------------------------------------

## Applies the callable operation to the given arguments.
##
## This method handles different argument counts intelligently:
## - For callables with no arguments, calls them directly
## - For callables with one argument, tries to pass the entire array first,
##   falling back to the first argument if that fails
## - For callables with multiple arguments, uses callv()
##
## @param args The array of arguments to process
## @return The result of applying the callable to the arguments
func apply(args: Array) -> Variant:
    if callable.get_argument_count() == 0:
        # For callable with no arguments, just call them
        return callable.call()
    elif callable.get_argument_count() == 1:
        # For callable with one argument, try to pass the entire array first
        # If that fails, fall back to passing the first argument
        if _should_use_call:
            return callable.call(args)
        else:
            # This could be wrong in case of a lambda taking one argument of type Array
            # But it is not possible to determine the type of the argument for a lambda
            # So this is a wild guess. In case this is an issue, create a real func and reference
            # its Callable
            return callable.call(args[0])
    else:
        # For callable with multiple arguments, use callv
        return callable.callv(args)

#------------------------------------------
# Private functions
#------------------------------------------

## Looks for a call method that takes an array argument.
##
## This is used to determine whether to use call() or callv() for single argument
## callables. If the method takes an array argument, we use call() to pass the
## entire array.
func _look_for_call_method() -> void:
    for method in callable.get_object().get_method_list():
        if method.name == callable.get_method():
            if method.args.size() == 1 and method.args[0].type == TYPE_ARRAY:
                _should_use_call = true
            break
