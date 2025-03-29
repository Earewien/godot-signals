class_name GBrokerSignalDetector
extends RefCounted

#------------------------------------------
# Constants
#------------------------------------------

# Use a Dictionay to compare values in O(1)
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
# Public functions
#------------------------------------------

func get_signals_from_object_script(object: Object) -> Array[Dictionary]:
    var signals: Array[Dictionary] = []
    var script: GDScript = object.get_script()
    if not script:
        return signals
    for sig in script.get_script_signal_list():
        signals.append(sig)
    return signals

func get_signals_from_object_except_native(object: Object) -> Array[Dictionary]:
    var signals: Array[Dictionary] = []
    for sig in object.get_signal_list():
        if _BANNED_SIGNALS.has(sig.name):
            continue
        signals.append(sig)
    return signals

func get_signals_from_object_all(object: Object) -> Array[Dictionary]:
    return object.get_signal_list()
