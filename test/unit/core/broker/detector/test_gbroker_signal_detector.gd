extends GutTest

var _detector: GBrokerSignalDetector

class NodeTest extends Node:
    signal test_signal

class CharacterBody2DTest extends CharacterBody2D:
    signal test_signal

func before_each() -> void:
    _detector = GBrokerSignalDetector.new()

func test_get_signals_from_object_script() -> void:
    var object: NodeTest = NodeTest.new()

    var signals: Array[Dictionary] = _detector.get_signals_from_object_script(object)
    assert_eq(signals.size(), 1)
    assert_eq(signals[0].name, "test_signal")
    assert_eq(signals[0].args.size(), 0)

func test_get_signals_from_object_except_native() -> void:
    var object: CharacterBody2D = CharacterBody2D.new()

    var signals: Array[Dictionary] = _detector.get_signals_from_object_except_native(object)
    print(signals)
    assert_true(signals.any(func(sig: Dictionary) -> bool: return sig.name == "input_event"))
    assert_true(signals.any(func(sig: Dictionary) -> bool: return sig.name == "mouse_shape_entered"))
    assert_true(signals.any(func(sig: Dictionary) -> bool: return sig.name == "mouse_shape_exited"))
    assert_false(signals.any(func(sig: Dictionary) -> bool: return sig.name == "mouse_entered"))
    assert_false(signals.any(func(sig: Dictionary) -> bool: return sig.name == "mouse_exited"))

func test_get_signals_from_object_except_native_with_user_defined_signals() -> void:
    var object: CharacterBody2DTest = CharacterBody2DTest.new()
    object.add_user_signal("user_signal", [])

    var signals: Array[Dictionary] = _detector.get_signals_from_object_except_native(object)
    assert_true(signals.any(func(sig: Dictionary) -> bool: return sig.name == "user_signal"))

func test_get_signals_from_object_all() -> void:
    var object: CharacterBody2DTest = CharacterBody2DTest.new()

    var signals: Array[Dictionary] = _detector.get_signals_from_object_all(object)
    assert_true(signals.any(func(sig: Dictionary) -> bool: return sig.name == "input_event"))
    assert_true(signals.any(func(sig: Dictionary) -> bool: return sig.name == "ready"))
    assert_true(signals.any(func(sig: Dictionary) -> bool: return sig.name == "tree_entered"))
