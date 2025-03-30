## A global signal broker for managing signal communication between objects.
##
## GBroker provides a centralized signal management system that allows objects to broadcast
## their signals and other objects to subscribe to these signals using pattern matching.
## This facilitates an event-driven architecture and loose coupling between components.
class_name GBroker
extends RefCounted

#------------------------------------------
# Constants
#------------------------------------------

## Controls which signals get registered with the broker.
enum GBrokerBroadcastFlags {
    ## Only broadcasts signals defined in the object's script.
    SCRIPT_ONLY = 0,
    ## Broadcasts all signals except common native Godot signals.
    EXCEPT_NATIVE_SIGNALS = 1,
    ## Broadcasts all signals, including native ones.
    ALL = 2,
}

#------------------------------------------
# Private variables
#------------------------------------------

static var _signal_handler: GBrokerSignalHandler = GBrokerSignalHandler.get_instance()
static var _subscription_manager: GBrokerSubscriptionManager = GBrokerSubscriptionManager.get_instance()
static var _signal_detector: GBrokerSignalDetector = GBrokerSignalDetector.new()

#------------------------------------------
# Public functions
#------------------------------------------

## Registers an object's signals with the broker.
## @param object The object whose signals will be broadcasted.
## @param alias Optional identifier(s) for the object. Can be a String, PackedStringArray, or Array[String].
##              If not provided, the system will use node groups or the object's name.
## @param flags Controls which signals to broadcast.
static func broadcast_signals_of(object: Object, alias: Variant = '', flags: GBrokerBroadcastFlags = GBrokerBroadcastFlags.SCRIPT_ONLY) -> void:
    var aliases: Array[String] = _get_aliases(object, alias)
    match flags:
        GBrokerBroadcastFlags.SCRIPT_ONLY:
            _signal_handler.connect_to_signals(object, aliases, _signal_detector.get_signals_from_object_script(object))
        GBrokerBroadcastFlags.EXCEPT_NATIVE_SIGNALS:
            _signal_handler.connect_to_signals(object, aliases, _signal_detector.get_signals_from_object_except_native(object))
        GBrokerBroadcastFlags.ALL:
            _signal_handler.connect_to_signals(object, aliases, _signal_detector.get_signals_from_object_all(object))
        _:
            push_error("Invalid broadcast flags: %s" % flags)

## Broadcasts signals from an array of Signal dictionaries.
## @param signals Array of Signal dictionaries with name and args.
static func broadcast_signals(signals: Array[Signal]) -> void:
    # Signals can comes from multiple objects, so we need to pack them by object first
    var signals_by_object: Dictionary = {}
    for sig in signals:
        var object: Object = sig.get_object()
        if not signals_by_object.has(object):
            signals_by_object[object] = []
        signals_by_object[object].append(sig)

    for object in signals_by_object:
        var aliases: Array[String] = _get_aliases(object, '')
        _signal_handler.connect_to_signals(object, aliases, signals_by_object[object])

## Registers a callback to be called when signals matching the pattern are emitted.
## @param pattern Format is "alias:signal" where * can be used as a wildcard. For example,
##               "player:*" matches all signals from objects with the "player" alias.
## @param callback The function to call when a matching signal is emitted.
static func subscribe(pattern: String, callback: Callable) -> void:
    _subscription_manager.subscribe(pattern, callback)

## Clears all subscriptions and signal handlers.
## Call this when you want to reset the entire signal broker system.
static func reset() -> void:
    _subscription_manager.reset()
    _signal_handler.reset()

#------------------------------------------
# Private functions
#------------------------------------------

## Determines the aliases for an object based on the provided alias parameter.
## If no alias is provided, uses node groups or object name as fallback.
## @param object The object to determine aliases for.
## @param alias Optional identifier(s) for the object.
## @return An array of string aliases for the object.
static func _get_aliases(object: Object, alias: Variant) -> Array[String]:
    if (alias is String && alias != '') or alias is PackedStringArray or alias is Array[String]:
        if alias is String:
            return [alias]
        elif alias is PackedStringArray:
            var aliases: Array[String] = []
            for a in alias:
                aliases.append(alias)
            return aliases
        elif alias is Array[String]:
            return alias

    # Use Dictionary to avoid duplicated values easily
    var aliases: Dictionary[String, bool] = {}
    if object is Node:
        if not object.get_groups().is_empty():
            for group in object.get_groups():
                # Filter "internal groups": see get_groups documentation
                if not str(group).begins_with("_"):
                    aliases[group] = true

    aliases[object.get_name()] = true
    aliases[object.get_name().to_lower().to_snake_case()] = true

    return aliases.keys()
