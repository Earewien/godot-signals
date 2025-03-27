## Base class for signal connections in the GSignals system.
##
## This class manages the connection between a signal and a callback, with support
## for applying operations to the signal arguments before they reach the callback.
## It handles connection lifecycle and cleanup.
##
## Example:
## [codeblock]
## # Create a connection with a filter operation
## var connection = GSignalsConnection.new(signal, [filter_op], callback, CONNECT_ONE_SHOT)
## connection.start()
## [/codeblock]
class_name GSignalsConnection
extends RefCounted

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

## The object that emits the signal.
var _signal_emitter: Object
## The original signal to connect to.
var _original_signal: Signal
## The number of arguments the signal takes.
var _arg_count: int
## The connection flags to use when connecting.
var _connect_flags: Object.ConnectFlags
## The user's callback function.
var _user_callback: Callable

## The operations to apply to the signal arguments.
var _operations: Array[GSignalsOperation]
## The technical callback that handles the operations.
var _technical_callback: Callable

#------------------------------------------
# Godot override functions
#------------------------------------------

## Creates a new signal connection.
##
## @param sig The signal to connect to
## @param operations Array of operations to apply to the signal arguments
## @param callback The user's callback function
## @param connect_flags The connection flags to use
func _init(sig: Signal, operations: Array[GSignalsOperation], callback: Callable, connect_flags: Object.ConnectFlags) -> void:
    _original_signal = sig
    _operations = operations
    _user_callback = callback
    _signal_emitter = sig.get_object()
    _arg_count = _get_signal_arg_count(sig)
    _connect_flags = connect_flags

## Handles cleanup when the connection is deleted.
##
## Removes the connection from the signal emitter's metadata.
func _notification(what: int) -> void:
    if what == NOTIFICATION_PREDELETE:
        # Remove from signal emitter's connections
        if not is_instance_valid(_signal_emitter):
            return

        if _signal_emitter.has_meta("_gsignals_connections"):
            var connections = _signal_emitter.get_meta("_gsignals_connections")
            connections.erase(self)
            if connections.is_empty():
                _signal_emitter.remove_meta("_gsignals_connections")

#------------------------------------------
# Public functions
#------------------------------------------

## Starts the signal connection.
##
## This connects the signal and sets up the technical callback that will
## handle the operations. If the connection is already active, this does nothing.
func start() -> void:
    if is_active():
        return

    _technical_callback = _do_setup_connection()
    _original_signal.connect(_technical_callback, _connect_flags)

## Stops the signal connection.
##
## This disconnects the signal and cleans up. If the connection is not active,
## this does nothing.
func stop() -> void:
    if not is_active():
        return
    _original_signal.disconnect(_technical_callback)

## Returns whether the connection is currently active.
##
## @return true if the connection is active, false otherwise
func is_active() -> bool:
    if not _technical_callback.is_valid():
        return false

    return _original_signal.is_connected(_technical_callback)

#------------------------------------------
# Private functions
#------------------------------------------

## Gets the number of arguments a signal takes.
##
## @param sig The signal to check
## @return The number of arguments the signal takes
func _get_signal_arg_count(sig: Signal) -> int:
    for s in sig.get_object().get_signal_list():
        if s.name == sig.get_name():
            return s.args.size()
    return 0

## Sets up the connection and returns the technical callback.
##
## This method must be implemented by subclasses to provide the actual
## connection logic.
##
## @return The technical callback that will handle the operations
## @abstract
func _do_setup_connection() -> Callable:
    push_error("Not implemented")
    return Callable()
