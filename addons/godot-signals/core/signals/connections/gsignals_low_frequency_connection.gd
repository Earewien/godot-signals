class_name GSignalsLowFrequencyConnection
extends GSignalsConnection

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

func _init(sig: Signal, operations: Array[GSignalsOperation], callback: Callable, flags: int) -> void:
    super._init(sig, operations, callback, flags)

#------------------------------------------
# Public functions
#------------------------------------------

#------------------------------------------
# Private functions
#------------------------------------------

func _do_setup_connection() -> Callable:
    match _arg_count:
        0:
            return _handle_signal_0_args
        1:
            return _handle_signal_1_arg
        2:
            return _handle_signal_2_args
        3:
            return _handle_signal_3_args
        4:
            return _handle_signal_4_args
        5:
            return _handle_signal_5_args
        6:
            return _handle_signal_6_args
        7:
            return _handle_signal_7_args
        8:
            return _handle_signal_8_args
        9:
            return _handle_signal_9_args
        _:
            push_error("Unsupported number of arguments: %d" % _arg_count)
            return Callable()

func _handle_signal_0_args() -> void:
    _handle_signal([])

func _handle_signal_1_arg(arg: Variant) -> void:
    _handle_signal([arg])

func _handle_signal_2_args(arg1: Variant, arg2: Variant) -> void:
    _handle_signal([arg1, arg2])

func _handle_signal_3_args(arg1: Variant, arg2: Variant, arg3: Variant) -> void:
    _handle_signal([arg1, arg2, arg3])

func _handle_signal_4_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant) -> void:
    _handle_signal([arg1, arg2, arg3, arg4])

func _handle_signal_5_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant) -> void:
    _handle_signal([arg1, arg2, arg3, arg4, arg5])

func _handle_signal_6_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant) -> void:
    _handle_signal([arg1, arg2, arg3, arg4, arg5, arg6])

func _handle_signal_7_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant) -> void:
    _handle_signal([arg1, arg2, arg3, arg4, arg5, arg6, arg7])

func _handle_signal_8_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant, arg8: Variant) -> void:
    _handle_signal([arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8])

func _handle_signal_9_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant, arg8: Variant, arg9: Variant) -> void:
    _handle_signal([arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9])

func _handle_signal_10_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant, arg8: Variant, arg9: Variant, arg10: Variant) -> void:
    _handle_signal([arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10])

func _handle_signal(args: Array[Variant]) -> void:
    var current_args: Array = args

    for operation in _operations:
        if operation is GSignalsFilterOperation:
            if not operation.callable.callv(current_args):
                return
        elif operation is GSignalsMapOperation:
            current_args = [operation.callable.callv(current_args)]
        else:
            push_error("Unknown operation type: %s" % operation.type)

    _user_callback.callv(current_args)
