## A powerful signal processing utility that allows for filtering, mapping, and delaying signals
##
## GSignals provides a fluent interface for creating processing chains for Godot signals.
## You can transform signal values, filter out unwanted signals, delay signal processing,
## and more through a simple chaining API.
class_name GSignals
extends RefCounted

#------------------------------------------
# Constants
#------------------------------------------

const _METADATA_KEY: String = "_gsignals_connections"

## Connection flags for optimizing signal handling
enum GSignalsBindFlags {
    ## Default. Optimized for signals that emit infrequently
    LOW_FREQUENCY_HINT = 0,
    ## Optimized for signals that emit many times per frame or very frequently
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

## Creates a new GSignals instance from a signal reference
##
## [param sig] The signal to process
## [param flags] Optimization hints for the connection
## [return] A new GSignals instance
static func from(sig: Signal, flags: GSignalsBindFlags = GSignalsBindFlags.LOW_FREQUENCY_HINT) -> GSignals:
    return GSignals.new(sig, flags)

## Creates a new GSignals instance from an object and signal name
##
## [param object] The object containing the signal
## [param signal_name] The name of the signal
## [param flags] Optimization hints for the connection
## [return] A new GSignals instance
static func from_signal_name(object: Object, signal_name: String, flags: GSignalsBindFlags = GSignalsBindFlags.LOW_FREQUENCY_HINT) -> GSignals:
    var sig = object.get(signal_name)
    if not sig is Signal:
        push_error("Signal not found")
        return null
    return GSignals.new(sig, flags)

## Connects the signal processing chain to a callback function
##
## [param callback] The function to call when the signal triggers
## [param connect_flags] Godot's connection flags
## [return] A connection object that can be used to manage the connection
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

## Transforms signal values using a mapping function
##
## [param mapper] A function that receives signal arguments and returns a new value
## [return] The GSignals instance for method chaining
func map(mapper: Callable) -> GSignals:
    _operations.append(GSignalsMapOperation.new(mapper))
    return self

## Filters signals based on a predicate function
##
## [param predicate] A function that returns true to allow the signal to continue, false to stop
## [return] The GSignals instance for method chaining
func filter(predicate: Callable) -> GSignals:
    _operations.append(GSignalsFilterOperation.new(predicate))
    return self

## Delays signal processing by a specified number of seconds
##
## This operation creates a timer that will delay the signal processing chain
## by the specified duration. The signal arguments are preserved through the delay.
##
## [param delay_s] The delay time in seconds
## [return] The GSignals instance for method chaining
func delay(delay_s: float) -> GSignals:
    _operations.append(GSignalsDelayOperation.new(delay_s))
    return self

## Debounces signal processing to prevent rapid-fire signal handling
##
## This operation waits until the signal stops firing for the specified duration
## before allowing the signal to proceed. This is useful for handling events
## that might fire in rapid succession when you only want to respond once after
## the activity settles.
##
## [param wait_time_s] The time in seconds to wait for inactivity
## [return] The GSignals instance for method chaining
func debounce(wait_time_s: float) -> GSignals:
    _operations.append(GSignalsDebounceOperation.new(wait_time_s))
    return self

#------------------------------------------
# Private functions
#------------------------------------------
