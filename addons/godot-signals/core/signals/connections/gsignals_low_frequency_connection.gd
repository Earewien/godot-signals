## Connection class optimized for low-frequency signals.
##
## This connection class uses a simple approach to handle signal operations
## by creating a callback for each possible argument count. It is designed
## for signals that are emitted infrequently, where setup time and memory
## usage are more important than per-emission performance.
##
## The implementation is simpler than the high-frequency connection but
## may be less efficient for frequently emitted signals due to array
## allocations and function calls.
##
## Example:
## [codeblock]
## # Create a low-frequency connection with a filter
## var connection = GSignalsLowFrequencyConnection.new(signal, [filter_op], callback, 0)
## connection.start()
## [/codeblock]
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

## Creates a new low-frequency connection.
##
## @param sig The signal to connect to
## @param operations Array of operations to apply to the signal arguments
## @param callback The user's callback function
## @param flags The connection flags to use
func _init(sig: Signal, operations: Array[GSignalsOperation], callback: Callable, flags: int) -> void:
    super._init(sig, operations, callback, flags)

#------------------------------------------
# Public functions
#------------------------------------------

#------------------------------------------
# Private functions
#------------------------------------------

## Sets up the connection and returns the technical callback.
##
## This method returns a callback that matches the signal's argument count
## and applies the operations in sequence.
##
## @return The technical callback that will handle the operations
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

## Handles a signal with no arguments.
func _handle_signal_0_args() -> void:
    _handle_signal([])

## Handles a signal with one argument.
##
## @param arg The signal argument
func _handle_signal_1_arg(arg: Variant) -> void:
    _handle_signal([arg])

## Handles a signal with two arguments.
##
## @param arg1 The first signal argument
## @param arg2 The second signal argument
func _handle_signal_2_args(arg1: Variant, arg2: Variant) -> void:
    _handle_signal([arg1, arg2])

## Handles a signal with three arguments.
##
## @param arg1 The first signal argument
## @param arg2 The second signal argument
## @param arg3 The third signal argument
func _handle_signal_3_args(arg1: Variant, arg2: Variant, arg3: Variant) -> void:
    _handle_signal([arg1, arg2, arg3])

## Handles a signal with four arguments.
##
## @param arg1 The first signal argument
## @param arg2 The second signal argument
## @param arg3 The third signal argument
## @param arg4 The fourth signal argument
func _handle_signal_4_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant) -> void:
    _handle_signal([arg1, arg2, arg3, arg4])

## Handles a signal with five arguments.
##
## @param arg1 The first signal argument
## @param arg2 The second signal argument
## @param arg3 The third signal argument
## @param arg4 The fourth signal argument
## @param arg5 The fifth signal argument
func _handle_signal_5_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant) -> void:
    _handle_signal([arg1, arg2, arg3, arg4, arg5])

## Handles a signal with six arguments.
##
## @param arg1 The first signal argument
## @param arg2 The second signal argument
## @param arg3 The third signal argument
## @param arg4 The fourth signal argument
## @param arg5 The fifth signal argument
## @param arg6 The sixth signal argument
func _handle_signal_6_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant) -> void:
    _handle_signal([arg1, arg2, arg3, arg4, arg5, arg6])

## Handles a signal with seven arguments.
##
## @param arg1 The first signal argument
## @param arg2 The second signal argument
## @param arg3 The third signal argument
## @param arg4 The fourth signal argument
## @param arg5 The fifth signal argument
## @param arg6 The sixth signal argument
## @param arg7 The seventh signal argument
func _handle_signal_7_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant) -> void:
    _handle_signal([arg1, arg2, arg3, arg4, arg5, arg6, arg7])

## Handles a signal with eight arguments.
##
## @param arg1 The first signal argument
## @param arg2 The second signal argument
## @param arg3 The third signal argument
## @param arg4 The fourth signal argument
## @param arg5 The fifth signal argument
## @param arg6 The sixth signal argument
## @param arg7 The seventh signal argument
## @param arg8 The eighth signal argument
func _handle_signal_8_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant, arg8: Variant) -> void:
    _handle_signal([arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8])

## Handles a signal with nine arguments.
##
## @param arg1 The first signal argument
## @param arg2 The second signal argument
## @param arg3 The third signal argument
## @param arg4 The fourth signal argument
## @param arg5 The fifth signal argument
## @param arg6 The sixth signal argument
## @param arg7 The seventh signal argument
## @param arg8 The eighth signal argument
## @param arg9 The ninth signal argument
func _handle_signal_9_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant, arg8: Variant, arg9: Variant) -> void:
    _handle_signal([arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9])

## Handles a signal with ten arguments.
##
## @param arg1 The first signal argument
## @param arg2 The second signal argument
## @param arg3 The third signal argument
## @param arg4 The fourth signal argument
## @param arg5 The fifth signal argument
## @param arg6 The sixth signal argument
## @param arg7 The seventh signal argument
## @param arg8 The eighth signal argument
## @param arg9 The ninth signal argument
## @param arg10 The tenth signal argument
func _handle_signal_10_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant, arg8: Variant, arg9: Variant, arg10: Variant) -> void:
    _handle_signal([arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10])

## Applies the operations to the signal arguments and calls the callback.
##
## This method processes the signal arguments by applying each operation
## in sequence. If any filter operation returns false, the callback is not
## called. If there are map operations, their results are passed to the
## callback.
##
## @param args The array of signal arguments
func _handle_signal(args: Array[Variant]) -> void:
    var current_args: Array = args

    for operation in _operations:
        if operation is GSignalsFilterOperation:
            if not operation.apply(current_args):
                return
        elif operation is GSignalsMapOperation:
            current_args = [operation.apply(current_args)]
        elif operation is GSignalsDelayOperation:
            await operation.apply(current_args)
        else:
            push_error("Unknown operation type: %s" % operation.type)

    _user_callback.callv(current_args)
