class_name GSignals
extends RefCounted

#------------------------------------------
# Constants
#------------------------------------------

const _METADATA_KEY: String = "_gsignals_connections"

enum GSignalsBindFlags {
    LOW_FREQUENCY_HINT = 0,
    HIGH_FREQUENCY_HINT = 1,
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

#------------------------------------------
# Private variables
#------------------------------------------

var _original_signal: Signal
var _operations: Array[GSignalsOperation]
var _signal_emitter: Object
var _flags: GSignalsBindFlags

#------------------------------------------
# Godot override functions
#------------------------------------------

func _init(sig: Signal, flags: GSignalsBindFlags) -> void:
    _original_signal = sig
    _signal_emitter = sig.get_object()
    _flags = flags

#------------------------------------------
# Public functions
#------------------------------------------

static func from(sig: Signal, flags: GSignalsBindFlags = GSignalsBindFlags.LOW_FREQUENCY_HINT) -> GSignals:
    return GSignals.new(sig, flags)

static func from_signal_name(object: Object, signal_name: String, flags: GSignalsBindFlags = GSignalsBindFlags.LOW_FREQUENCY_HINT) -> GSignals:
    var sig = object.get(signal_name)
    if not sig is Signal:
        push_error("Signal not found")
        return null
    return GSignals.new(sig, flags)

func bind(callback: Callable, connect_flags: Object.ConnectFlags=0) -> GSignalsConnection:
    # Duplicate the operations to create a snapshot of the current state
    # Since it is possible to modify the operations after the connection is created
    # and we dont want to impact already created connections
    var connection: GSignalsConnection
    if _flags == GSignalsBindFlags.LOW_FREQUENCY_HINT:
        connection = GSignalsLowFrequencyConnection.new(_original_signal, _operations.duplicate(), callback, connect_flags)
    else:
        connection = GSignalsHighFrequencyConnection.new(_original_signal, _operations.duplicate(), callback, connect_flags)
    connection.start()

    # Store this connection in the signal emitter to prevent garbage collection
    if not _signal_emitter.has_meta(_METADATA_KEY):
        _signal_emitter.set_meta(_METADATA_KEY, [])
    _signal_emitter.get_meta(_METADATA_KEY).append(connection)

    return connection

func map(mapper: Callable) -> GSignals:
    _operations.append(GSignalsMapOperation.new(mapper))
    return self

func filter(predicate: Callable) -> GSignals:
    _operations.append(GSignalsFilterOperation.new(predicate))
    return self


#------------------------------------------
# Private functions
#------------------------------------------
