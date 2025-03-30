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
func wait_for(time_s: float) -> void:
    if _current_timer == null:
        _create_timer()
    _stop_timer()
    await _wait_for_timer(time_s)

#------------------------------------------
# Private functions
#------------------------------------------

## Creates the internal timer node
func _create_timer() -> void:
    if _current_timer != null:
        _destroy_timer()

    _current_timer = Timer.new()
    _current_timer.name = "%s-%s" % ["GAwaiter", get_instance_id()]
    _scene_tree.root.add_child(_current_timer)

## Cleans up the timer node
func _destroy_timer() -> void:
    if _current_timer != null:
        _current_timer.stop()
        _current_timer.queue_free()
        _current_timer = null

## Sets up and waits for the timer
##
## [param time_s] The time to wait in seconds
func _wait_for_timer(time_s: float) -> void:
    _current_timer.start(time_s)
    await _current_timer.timeout

## Stops the timer if it's running
func _stop_timer() -> void:
    if _current_timer != null:
        _current_timer.stop()
