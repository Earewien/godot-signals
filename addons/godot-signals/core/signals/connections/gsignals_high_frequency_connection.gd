class_name GSignalsHighFrequencyConnection
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

var _generated_script: GDScript
var _generated_script_instance: Object

#------------------------------------------
# Godot override functions
#------------------------------------------

func _init(sig: Signal, operations: Array[GSignalsOperation], callback: Callable, flags: int) -> void:
    super._init(sig, operations, callback, flags)

#------------------------------------------
# Public functions
#------------------------------------------

#------------------------------------------
# Private functions
#------------------------------------------

func _do_setup_connection() -> Callable:
    if _generated_script == null:
        _generate_script()
        _generated_script_instance = _generated_script.new()
        _generated_script_instance._callback = _user_callback

        # Set up the callbacks
        var filter_count = 0
        var map_count = 0
        var debounce_count = 0
        var throttle_count = 0
        var buffer_count = 0

        for operation in _operations:
            if operation is GSignalsFilterOperation:
                _generated_script_instance.set("_filter_%d" % filter_count, operation.predicate)
                filter_count += 1
            elif operation is GSignalsMapOperation:
                _generated_script_instance.set("_map_%d" % map_count, operation.mapper)
                map_count += 1
            else:
                push_error("Unknown operation type: %s" % operation.type)

    return _generated_script_instance._handle_signal

func _generate_script() -> void:
    var script_text = """
extends RefCounted

var _callback: Callable
# var _last_time: float = 0.0
# var _buffer: Array = []
# var _pending_args = null
# var _timer: float = 0.0

%s

func _handle_signal(%s) -> void:
    var result
%s
"""
    # Generate argument list
    var arg_list = ""
    for i in range(_arg_count):
        if i > 0:
            arg_list += ", "
        arg_list += "arg%d" % (i + 1)

    # Generate private variables and operation calls
    var private_vars = ""
    var operation_calls = ""
    var filter_count = 0
    var map_count = 0
    var debounce_count = 0
    var throttle_count = 0
    var buffer_count = 0
    var current_args = ""
    var has_mapper = false

    # Initialize current_args with the signal arguments
    for i in range(_arg_count):
        if i > 0:
            current_args += ", "
        current_args += "arg%d" % (i + 1)

    for operation in _operations:
        if operation is GSignalsFilterOperation:
            private_vars += "var _filter_%d: Callable\n" % filter_count
            operation_calls += "    if not _filter_%d.call(%s):\n        return\n" % [filter_count, current_args]
            filter_count += 1
        elif operation is GSignalsMapOperation:
            private_vars += "var _map_%d: Callable\n" % map_count
            operation_calls += "    result = _map_%d.call(%s)\n" % [map_count, current_args]
            current_args = "result"
            has_mapper = true
            map_count += 1
        else:
            push_error("Unknown operation type: %s" % operation.type)


        # "debounce":
        #     private_vars += "var _debounce_%d: float\n" % debounce_count
        #     operation_calls += "    _pending_args = %s\n    _timer = _debounce_%d\n    return\n" % [current_args, debounce_count]
        #     debounce_count += 1
        # "throttle":
        #     private_vars += "var _throttle_%d: float\n" % throttle_count
        #     operation_calls += "    var current_time = Time.get_ticks_msec()\n    if current_time - _last_time < _throttle_%d:\n        return\n    _last_time = current_time\n" % throttle_count
        #     throttle_count += 1
        # "buffer":
        #     private_vars += "var _buffer_%d: int\n" % buffer_count
        #     operation_calls += "    _buffer.append(%s)\n    if _buffer.size() < _buffer_%d:\n        return\n    result = _buffer.duplicate()\n    _buffer.clear()\n" % [current_args, buffer_count]
        #     current_args = "result"
        #     buffer_count += 1

    # Add callback call based on whether we have a mapper or not
    if has_mapper:
        operation_calls += "    _callback.call(result)\n"
    else:
        operation_calls += "    _callback.call(%s)\n" % current_args

    # Create the script
    script_text = script_text % [private_vars, arg_list, operation_calls]
    _generated_script = GDScript.new()
    _generated_script.source_code = script_text
    _generated_script.reload()
