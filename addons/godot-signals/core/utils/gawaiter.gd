## A utility class for creating and managing timers for asynchronous operations
##
## GAwaiter provides a simple interface for waiting a specified duration
## without blocking the main thread. It's primarily used by delay operations
## in signal processing chains.
class_name GAwaiter
extends RefCounted

#------------------------------------------
# Constants
#------------------------------------------

class GAwaiterWaitForResult extends RefCounted:
    var wait_completed_successfully: bool

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

## Reference to the SceneTree for creating timers
var _scene_tree: SceneTree
## The Timer node used for waiting
var _current_timer: Timer
## Whether the wait completed successfully, i.e. the timer did not stop prematurely
var _wait_completed_successfully: GAwaiterWaitForResult
# Self is null when the object is beeing garbage collected, so to call _destroy_timer,
# I keep a reference to self in _this
var _this: GAwaiter

#------------------------------------------
# Godot override functions
#------------------------------------------

## Creates a new awaiter
##
## [param st] The SceneTree instance used to create timers
func _init(st: SceneTree) -> void:
    _scene_tree = st
    _this = self

## Handles cleanup when the object is destroyed
func _notification(what: int) -> void:
    if what == NOTIFICATION_PREDELETE:
        _this._destroy_timer()
        _this = null

#------------------------------------------
# Public functions
#------------------------------------------

## Pauses execution for the specified duration
##
## This method creates a timer that will trigger after the specified
## duration, allowing for non-blocking delays in signal processing.
##
## [param time_s] The time to wait in seconds
func wait_for(time_s: float) -> bool:
    if _current_timer == null or not _current_timer.is_node_ready():
        await _create_timer()
    _stop_timer()
    return await _wait_for_timer(time_s)

## Stops the timer if it's running
func cancel() -> void:
    _stop_timer()

#------------------------------------------
# Private functions
#------------------------------------------

## Creates the internal timer node
func _create_timer() -> void:
    if _current_timer != null:
        if not _current_timer.is_node_ready():
            await _current_timer.ready
        _stop_timer()
        return

    _current_timer = Timer.new()
    _current_timer.name = "%s-%s" % ["GAwaiter", get_instance_id()]
    _scene_tree.root.call_deferred("add_child", _current_timer)
    if _current_timer.is_node_ready():
        return
    else:
        await _current_timer.ready

## Cleans up the timer node
func _destroy_timer() -> void:
    if _current_timer != null:
        _current_timer.stop()
        _current_timer.queue_free()
        _current_timer = null

## Sets up and waits for the timer
##
## [param time_s] The time to wait in seconds
func _wait_for_timer(time_s: float) -> bool:
    var result = GAwaiterWaitForResult.new()
    result.wait_completed_successfully = true
    # Save the reference so a cancel operation can flag this result as not completed
    _wait_completed_successfully = result

    _current_timer.start(time_s)
    await _current_timer.timeout
    # Use the local reference, not the global one, since if a wait_for has been relaunched, the global
    # reference will be different and will be set to true
    return result.wait_completed_successfully

## Stops the timer if it's running
func _stop_timer() -> void:
    if _current_timer != null:
        _current_timer.stop()
        if _wait_completed_successfully != null:
            _wait_completed_successfully.wait_completed_successfully = false
