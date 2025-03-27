# @abstract
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

var callable: Callable

#------------------------------------------
# Private variables
#------------------------------------------

var _should_use_call: bool = false

#------------------------------------------
# Godot override functions
#------------------------------------------

func _init(callable: Callable) -> void:
    self.callable = callable
    if callable.is_standard():
        _look_for_call_method()

#------------------------------------------
# Public functions
#------------------------------------------

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

func _look_for_call_method() -> void:
    for method in callable.get_object().get_method_list():
        if method.name == callable.get_method():
            if method.args.size() == 1 and method.args[0].type == TYPE_ARRAY:
                _should_use_call = true
            break
