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

var _signal_emitter: Object
var _original_signal: Signal
var _arg_count: int
var _connect_flags: Object.ConnectFlags
var _user_callback: Callable

var _operations: Array[GSignalsOperation]
var _technical_callback: Callable

#------------------------------------------
# Godot override functions
#------------------------------------------

func _init(sig: Signal, operations: Array[GSignalsOperation], callback: Callable, connect_flags: Object.ConnectFlags) -> void:
    _original_signal = sig
    _operations = operations
    _user_callback = callback
    _signal_emitter = sig.get_object()
    _arg_count = _get_signal_arg_count(sig)
    _connect_flags = connect_flags

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

func start() -> void:
    if is_active():
        return

    _technical_callback = _do_setup_connection()
    _original_signal.connect(_technical_callback, _connect_flags)

func stop() -> void:
    if not is_active():
        return
    _original_signal.disconnect(_technical_callback)

func is_active() -> bool:
    if not _technical_callback.is_valid():
        return false

    return _original_signal.is_connected(_technical_callback)

#------------------------------------------
# Private functions
#------------------------------------------

func _get_signal_arg_count(sig: Signal) -> int:
    for s in sig.get_object().get_signal_list():
        if s.name == sig.get_name():
            return s.args.size()
    return 0

func _do_setup_connection() -> Callable:
    push_error("Not implemented")
    return Callable()
