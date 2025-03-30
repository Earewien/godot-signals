## Handles the connection to signals and dispatches them to subscribers.
##
## This class connects to objects' signals and routes them to registered callbacks based on
## pattern matching. It supports signals with up to 9 arguments and intelligently passes
## those arguments to callbacks with variable parameter counts.
class_name GBrokerSignalHandler
extends RefCounted

#------------------------------------------
# Constants
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

static var _instance: GBrokerSignalHandler

var _subscription_manager: GBrokerSubscriptionManager = GBrokerSubscriptionManager.get_instance()
var _cached_array: Array[Variant] = []
var _cached_callback_to_remove: Array[Callable] = []

#------------------------------------------
# Public functions
#------------------------------------------

## Gets the singleton instance of the signal handler.
## @return The GBrokerSignalHandler singleton instance.
static func get_instance() -> GBrokerSignalHandler:
    if _instance == null:
        _instance = GBrokerSignalHandler.new()
    return _instance

## Connects to all specified signals on the object.
## @param object The object to connect to.
## @param aliases Identifiers for the object.
## @param signals Array of signals, either dictionaries with name and args or Signal objects.
func connect_to_signals(object: Object, aliases: Array[String], signals: Array) -> void:
    var object_weak_ref: WeakRef = weakref(object)

    for sig in signals:
        var signal_name:String
        var signal_args_count:int
        var object_signal: Signal
        var signal_unique_id: String

        if sig is Dictionary:
            signal_name = sig.name
            signal_args_count = sig.args.size()
            object_signal = object.get(signal_name)
            signal_unique_id = _compute_signal_unique_id(signal_name, sig.args)
        elif sig is Signal:
            signal_name = sig.get_name()
            var sig_descriptor:Dictionary = ClassDB.class_get_signal(object.get_class(), signal_name)
            if sig_descriptor.is_empty() and object.get_script() != null:
                var object_signals:Array[Dictionary] = object.get_signal_list()
                for os in object_signals:
                    if os.name == signal_name:
                        sig_descriptor = os
                        break
                if sig_descriptor.is_empty():
                    push_error("Unable to find signal %s data" % signal_name)
                    continue

            signal_args_count = sig_descriptor.args.size()
            object_signal = sig
            signal_unique_id = _compute_signal_unique_id(signal_name, sig_descriptor.args)
        else:
            push_error("Invalid signal: %s" % sig)
            continue

        # Connect to signal, with a unique id for each signal and sending all known aliases for the object
        object_signal.connect(Callable(self, "_on_signal_%s_received" % signal_args_count).bind(object_weak_ref, aliases, signal_name))

## Clears cached data.
func reset() -> void:
    _cached_array.clear()
    _cached_callback_to_remove.clear()

#------------------------------------------
# Private functions
#------------------------------------------

## Computes a unique ID for a signal based on its name and arguments.
## @param signal_name The name of the signal.
## @param signal_args The arguments of the signal.
## @return A unique string identifier for the signal.
func _compute_signal_unique_id(signal_name: String, signal_args: Array[Dictionary]) -> String:
    return "%s:%s" % [signal_name, signal_args.hash()] # Very low probability of hash collision

# Signal handlers for different argument counts
func _on_signal_0_received(object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([], object_weak_ref, aliases, signal_name)

func _on_signal_1_received(arg1: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1], object_weak_ref, aliases, signal_name)

func _on_signal_2_received(arg1: Variant, arg2: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1, arg2], object_weak_ref, aliases, signal_name)

func _on_signal_3_received(arg1: Variant, arg2: Variant, arg3: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1, arg2, arg3], object_weak_ref, aliases, signal_name)

func _on_signal_4_received(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1, arg2, arg3, arg4], object_weak_ref, aliases, signal_name)

func _on_signal_5_received(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1, arg2, arg3, arg4, arg5], object_weak_ref, aliases, signal_name)

func _on_signal_6_received(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1, arg2, arg3, arg4, arg5, arg6], object_weak_ref, aliases, signal_name)

func _on_signal_7_received(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1, arg2, arg3, arg4, arg5, arg6, arg7], object_weak_ref, aliases, signal_name)

func _on_signal_8_received(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant, arg8: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8], object_weak_ref, aliases, signal_name)

func _on_signal_9_received(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant, arg8: Variant, arg9: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9], object_weak_ref, aliases, signal_name)

## Core handler that processes signal events and dispatches them to matching subscribers.
## Intelligently maps signal arguments to callback parameters based on their argument count.
## @param args Array of signal arguments.
## @param object_weak_ref Weak reference to the signal emitter.
## @param aliases Array of identifiers for the object.
## @param signal_name The name of the emitted signal.
func _handle_signal_received(args: Array, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    var object: Object = object_weak_ref.get_ref()
    if not is_instance_valid(object):
        return

    var matching_patterns_for_signal: Array[String] = _subscription_manager.get_matching_patterns_for_signal(aliases, signal_name)

    for pattern in matching_patterns_for_signal:
        _cached_callback_to_remove.clear()
        var callbacks: Array[Callable] = _subscription_manager.get_callbacks_for_pattern(pattern)

        if callbacks == null or callbacks.is_empty():
            push_warning("Pattern '%s' found in cache/matching but has no callbacks." % pattern)
            continue

        for callback in callbacks:
            # Ensure that the callback is still valid (object is not freed, ...)
            if not callback.is_valid():
                _cached_callback_to_remove.append(callback)
                continue

            var arg_count: int = callback.get_argument_count()

            if arg_count == 0:
                callback.call()
                continue

            # Check for valid number of arguments for Callable.callv
            if arg_count > 11:
                push_error("Too many arguments for callback: %s (max 11)" % callback)
                continue

            # --- Optimized Argument Building ---
            _cached_array.resize(arg_count) # Pre-allocate/resize the array to the exact size needed

            var signal_args_to_copy = min(args.size(), arg_count)
            var object_needed = (arg_count > signal_args_to_copy)
            var signal_name_needed = (arg_count > signal_args_to_copy + (1 if object_needed else 0))

            var write_idx = 0
            # Place object if needed
            if object_needed:
                _cached_array[write_idx] = object
                write_idx += 1
            # Place signal_name if needed
            if signal_name_needed:
                _cached_array[write_idx] = signal_name
                write_idx += 1

            # Copy actual signal arguments
            var read_idx = 0
            while write_idx < arg_count and read_idx < args.size():
                _cached_array[write_idx] = args[read_idx]
                write_idx += 1
                read_idx += 1

            # Fill remaining slots with null if necessary
            while write_idx < arg_count:
                _cached_array[write_idx] = null
                write_idx += 1
            # --- End of Optimized Argument Building ---

            # Call with the calculated arguments
            match arg_count:
                1:
                    callback.call(_cached_array[0])
                2:
                    callback.call(_cached_array[0], _cached_array[1])
                3:
                    callback.call(_cached_array[0], _cached_array[1], _cached_array[2])
                4:
                    callback.call(_cached_array[0], _cached_array[1], _cached_array[2], _cached_array[3])
                5:
                    callback.call(_cached_array[0], _cached_array[1], _cached_array[2], _cached_array[3], _cached_array[4])
                6:
                    callback.call(_cached_array[0], _cached_array[1], _cached_array[2], _cached_array[3], _cached_array[4], _cached_array[5])
                7:
                    callback.call(_cached_array[0], _cached_array[1], _cached_array[2], _cached_array[3], _cached_array[4], _cached_array[5], _cached_array[6])
                8:
                    callback.call(_cached_array[0], _cached_array[1], _cached_array[2], _cached_array[3], _cached_array[4], _cached_array[5], _cached_array[6], _cached_array[7])
                9:
                    callback.call(_cached_array[0], _cached_array[1], _cached_array[2], _cached_array[3], _cached_array[4], _cached_array[5], _cached_array[6], _cached_array[7], _cached_array[8])
                10:
                    callback.call(_cached_array[0], _cached_array[1], _cached_array[2], _cached_array[3], _cached_array[4], _cached_array[5], _cached_array[6], _cached_array[7], _cached_array[8], _cached_array[9])
                11:
                    callback.call(_cached_array[0], _cached_array[1], _cached_array[2], _cached_array[3], _cached_array[4], _cached_array[5], _cached_array[6], _cached_array[7], _cached_array[8], _cached_array[9], _cached_array[10])
                _:
                    # This shouldn't be reached due to the check above
                    push_error("Invalid callback argument count: %d" % arg_count)

        if not _cached_callback_to_remove.is_empty():
            _subscription_manager.remove_invalid_callbacks(pattern, _cached_callback_to_remove)
            _cached_callback_to_remove.clear()
