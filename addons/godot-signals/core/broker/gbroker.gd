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

#------------------------------------------
# Private variables
#------------------------------------------

static var _signal_handler: GBrokerSignalHandler = GBrokerSignalHandler.get_instance()
static var _subscription_manager: GBrokerSubscriptionManager = GBrokerSubscriptionManager.get_instance()
static var _signal_detector: GBrokerSignalDetector = GBrokerSignalDetector.new()

#------------------------------------------
# Public functions
#------------------------------------------

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

static func subscribe(pattern: String, callback: Callable) -> void:
    _subscription_manager.subscribe(pattern, callback)

static func reset() -> void:
    _subscription_manager.reset()
    _signal_handler.reset()

#------------------------------------------
# Private functions
#------------------------------------------

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
