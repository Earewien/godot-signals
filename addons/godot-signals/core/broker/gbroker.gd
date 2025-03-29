class_name GBroker
extends RefCounted

#------------------------------------------
# Constants
#------------------------------------------

enum GBrokerBroadcastFlags {
    SCRIPT_ONLY = 0,
    EXCEPT_NATIVE_SIGNALS = 1,
    ALL = 2,
}

const _BANNED_SIGNALS: Dictionary = {
    "property_list_changed": true,
    "script_changed": true,
    "child_order_changed": true,
    "child_entered_tree": true,
    "child_exiting_tree": true,
    "editor_description_changed": true,
    "editor_state_changed": true,
    "ready": true,
    "renamed": true,
    "replacing_by": true,
    "tree_entered": true,
    "tree_exited": true,
    "tree_exiting": true,
    "draw": true,
    "hidden": true,
    "item_rect_changed": true,
    "visibility_changed": true,
    "focus_entered": true,
    "focus_exited": true,
    "gui_input": true,
    "minimum_size_changed": true,
    "mouse_entered": true,
    "mouse_exited": true,
    "resized": true,
    "size_flags_changed": true,
    "theme_changed": true,
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

static var _pattern_matcher: GBrokerPatternMatcher = GBrokerPatternMatcher.new()

static var _subscriptions: Dictionary = {}
static var _cached_array: Array[Variant] = []
static var _cached_callback_to_remove: Array[Callable] = []

#------------------------------------------
# Godot override functions
#------------------------------------------

#------------------------------------------
# Public functions
#------------------------------------------

static func broadcast_signals_of(object: Object, alias: String = '', flags: GBrokerBroadcastFlags = GBrokerBroadcastFlags.SCRIPT_ONLY) -> void:
    match flags:
        GBrokerBroadcastFlags.SCRIPT_ONLY:
            _connect_to_signals(object, alias, _get_signals_from_object_script(object))
        GBrokerBroadcastFlags.EXCEPT_NATIVE_SIGNALS:
            _connect_to_signals(object, alias, _get_signals_from_object_except_native(object))
        GBrokerBroadcastFlags.ALL:
            _connect_to_signals(object, alias, _get_signals_from_object_all(object))
        _:
            push_error("Invalid broadcast flags: %s" % flags)

static func subscribe(pattern: String, callback: Callable) -> void:
    var callbacks: Array[Callable] = _subscriptions.get_or_add(pattern, Array([], TYPE_CALLABLE, '', null))
    callbacks.append(callback)

#------------------------------------------
# Private functions
#------------------------------------------

static func _get_signals_from_object_script(object: Object) -> Array[Dictionary]:
    var signals: Array[Dictionary] = []
    var script: GDScript = object.get_script()
    if not script:
        return signals
    for sig in script.get_script_signal_list():
        signals.append(sig)
    return signals

static func _get_signals_from_object_except_native(object: Object) -> Array[Dictionary]:
    var signals: Array[Dictionary] = []
    for sig in object.get_signal_list():
        if _BANNED_SIGNALS.has(sig.name):
            continue
        signals.append(sig)
    return signals

static func _get_signals_from_object_all(object: Object) -> Array[Dictionary]:
    return object.get_signal_list()

static func _connect_to_signals(object: Object, alias: String, signals: Array[Dictionary]) -> void:
    var object_weak_ref: WeakRef = weakref(object)

    var aliases: Array[String] = _get_aliases(object, alias)
    for sig in signals:
        var signal_unique_id: String = _compute_signal_unique_id(sig.name, sig.args)
        # Connect to signal, with a unique id for each signal and sending all known aliases for the object
        object.get(sig.name).connect(Callable(GBroker, "_on_signal_%s_received" % sig.args.size()).bind(object_weak_ref, aliases, sig.name))

static func _compute_signal_unique_id(signal_name: String, signal_args: Array[Dictionary]) -> String:
    return "%s:%s" % [signal_name, signal_args.hash()] # Very low probability of hash collision

static func _get_aliases(object: Object, alias: String) -> Array[String]:
    if alias != '':
        return [alias]

    var aliases: Array[String] = []
    if object is Node:
        if not object.get_groups().is_empty():
            for group in object.get_groups():
                # Filter "internal groups": see get_groups documentation
                if not str(group).begins_with("_"):
                    aliases.append(group)

    if aliases.is_empty():
        aliases.append(object.get_name())
        aliases.append(object.get_name().to_lower().to_snake_case())

    return aliases

static func _on_signal_0_received(object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([], object_weak_ref, aliases, signal_name)

static func _on_signal_1_received(arg1: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1], object_weak_ref, aliases, signal_name)

static func _on_signal_2_received(arg1: Variant, arg2: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1, arg2], object_weak_ref, aliases, signal_name)

static func _on_signal_3_received(arg1: Variant, arg2: Variant, arg3: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1, arg2, arg3], object_weak_ref, aliases, signal_name)

static func _on_signal_4_received(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1, arg2, arg3, arg4], object_weak_ref, aliases, signal_name)

static func _on_signal_5_received(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1, arg2, arg3, arg4, arg5], object_weak_ref, aliases, signal_name)

static func _on_signal_6_received(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1, arg2, arg3, arg4, arg5, arg6], object_weak_ref, aliases, signal_name)

static func _on_signal_7_received(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1, arg2, arg3, arg4, arg5, arg6, arg7], object_weak_ref, aliases, signal_name)

static func _on_signal_8_received(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant, arg8: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8], object_weak_ref, aliases, signal_name)

static func _on_signal_9_received(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant, arg8: Variant, arg9: Variant, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    _handle_signal_received([arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9], object_weak_ref, aliases, signal_name)

static func _handle_signal_received(args: Array, object_weak_ref: WeakRef, aliases: Array[String], signal_name: String) -> void:
    var object: Object = object_weak_ref.get_ref()
    if not is_instance_valid(object):
        return

    for pattern in _subscriptions.keys():
        for alias in aliases:
            if _pattern_matcher.matches(alias, signal_name, pattern):
                _cached_callback_to_remove.clear()

                var callbacks: Array[Callable] = _subscriptions[pattern]
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
                    for callback_ref in _cached_callback_to_remove:
                        callbacks.erase(callback_ref)
                    _cached_callback_to_remove.clear()
