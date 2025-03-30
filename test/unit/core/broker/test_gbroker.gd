extends GutTest

class Node2DTest extends Node2D:
    signal test_signal(value: int)
    signal signal_9_args(arg1: int, arg2: int, arg3: int, arg4: int, arg5: int, arg6: int, arg7: int, arg8: int, arg9: int)

class Node2DChildTest extends Node2DTest:
    signal test_child_signal(value: int)

var _test_node

func before_each() -> void:
    _test_node = Node2DTest.new()
    autoqfree(_test_node)

func after_each() -> void:
    GBroker.reset()

func test_broker_broadcast_only_script_signals() -> void:
    GBroker.broadcast_signals_of(_test_node, 'test', GBroker.GBrokerBroadcastFlags.SCRIPT_ONLY)
    GBroker.subscribe("test:test_signal", func(): _test_node.set_meta("test_signal", true))
    GBroker.subscribe("test:ready", func(): _test_node.set_meta("ready", true))
    _test_node.test_signal.emit(1)
    add_child_autoqfree(_test_node)
    wait_frames(1)
    assert_true(_test_node.has_meta("test_signal"))
    assert_false(_test_node.has_meta("ready"))

func test_broker_broadcast_only_except_native_signals() -> void:
    _test_node = Node2DChildTest.new()
    GBroker.broadcast_signals_of(_test_node, 'test', GBroker.GBrokerBroadcastFlags.EXCEPT_NATIVE_SIGNALS)
    GBroker.subscribe("test:test_signal", func(): _test_node.set_meta("test_signal", true))
    GBroker.subscribe("test:test_child_signal", func(): _test_node.set_meta("test_child_signal", true))
    GBroker.subscribe("test:ready", func(): _test_node.set_meta("ready", true))
    _test_node.test_signal.emit(1)
    _test_node.test_child_signal.emit(1)
    add_child_autoqfree(_test_node)
    wait_frames(1)
    assert_true(_test_node.has_meta("test_signal"))
    assert_true(_test_node.has_meta("test_child_signal"))
    assert_false(_test_node.has_meta("ready"))

func test_broker_broadcast_all_signals() -> void:
    _test_node = Node2DChildTest.new()
    GBroker.broadcast_signals_of(_test_node, 'test', GBroker.GBrokerBroadcastFlags.ALL)
    GBroker.subscribe("test:test_signal", func(): _test_node.set_meta("test_signal", true))
    GBroker.subscribe("test:test_child_signal", func(): _test_node.set_meta("test_child_signal", true))
    GBroker.subscribe("test:ready", func(): _test_node.set_meta("ready", true))
    _test_node.test_signal.emit(1)
    _test_node.test_child_signal.emit(1)
    add_child_autoqfree(_test_node)
    wait_frames(1)
    assert_true(_test_node.has_meta("test_signal"))
    assert_true(_test_node.has_meta("test_child_signal"))
    assert_true(_test_node.has_meta("ready"))

func test_broker_subscribe_to_all_instances() -> void:
    var test_node1: Node2DTest = Node2DTest.new()
    var test_node2: Node2DTest = Node2DTest.new()
    autoqfree(test_node1)
    autoqfree(test_node2)
    GBroker.broadcast_signals_of(test_node1, 'test')
    GBroker.broadcast_signals_of(test_node2, 'test')
    GBroker.subscribe("test:test_signal", func(): set_meta("signal_called", get_meta("signal_called", 0) + 1))
    test_node1.test_signal.emit(1)
    test_node2.test_signal.emit(1)
    wait_frames(1)
    assert_eq(get_meta("signal_called"), 2)

func test_broker_can_have_callback_with_no_args() -> void:
    GBroker.subscribe("test:test_signal", func(): set_meta("signal_called", true))
    GBroker.broadcast_signals_of(_test_node, 'test')
    wait_frames(1)
    _test_node.test_signal.emit(1)
    assert_true(get_meta("signal_called"))

func test_broker_can_have_callback_with_right_number_of_args() -> void:
    GBroker.subscribe("test:test_signal", func(_val: int): set_meta("signal_called", true))
    GBroker.broadcast_signals_of(_test_node, 'test')
    wait_frames(1)
    _test_node.test_signal.emit(1)
    assert_true(get_meta("signal_called"))

func test_broker_can_have_callback_with_objet_emitter_as_arg() -> void:
    GBroker.subscribe("test:test_signal", func(_emitter: Node2D, _val: int): set_meta("signal_called", true))
    GBroker.broadcast_signals_of(_test_node, 'test')
    wait_frames(1)
    _test_node.test_signal.emit(1)
    assert_true(get_meta("signal_called"))

func test_broker_can_have_callback_with_objet_emitter_and_signal_name_as_arg() -> void:
    GBroker.subscribe("test:test_signal", func(_emitter: Node2D, _sig: String, _val: int): set_meta("signal_called", true))
    GBroker.broadcast_signals_of(_test_node, 'test')
    wait_frames(1)
    _test_node.test_signal.emit(1)
    assert_true(get_meta("signal_called"))

func test_broker_can_have_callback_with_9_args() -> void:
    GBroker.subscribe("test:signal_9_args", func(arg1: int, arg2: int, arg3: int, arg4: int, arg5: int, arg6: int, arg7: int, arg8: int, arg9: int):
        set_meta("signal_called", arg1 + arg2 + arg3 + arg4 + arg5 + arg6 + arg7 + arg8 + arg9))
    GBroker.broadcast_signals_of(_test_node, 'test')
    wait_frames(1)
    _test_node.signal_9_args.emit(1, 2, 3, 4, 5, 6, 7, 8, 9)
    assert_eq(get_meta("signal_called"), 45)

func test_broker_can_broadcast_direct_signals_from_same_object() -> void:
    _test_node.name = "test"
    set_meta("signal_called", [])
    GBroker.broadcast_signals([_test_node.test_signal, _test_node.ready])
    GBroker.subscribe("test:*", func(_object: Object, sig: String, _val):
        get_meta("signal_called").append(sig))

    add_child_autoqfree(_test_node)
    _test_node.test_signal.emit(1)
    wait_frames(1)

    assert_eq(get_meta("signal_called"), ["ready", "test_signal"])

func test_broker_can_broadcast_direct_signals_from_different_objects() -> void:
    _test_node.name = "test"
    var test_node2: Node2DTest = Node2DTest.new()
    test_node2.name = "test"
    set_meta("signal_called", [])
    GBroker.broadcast_signals([_test_node.test_signal, _test_node.ready, test_node2.test_signal, test_node2.ready])
    GBroker.subscribe("test:*", func(_object: Object, sig: String, _val):
        get_meta("signal_called").append(sig))

    add_child_autoqfree(_test_node)
    add_child_autoqfree(test_node2)
    _test_node.test_signal.emit(1)
    test_node2.test_signal.emit(1)
    wait_frames(1)

    assert_eq(get_meta("signal_called"), ["ready", "ready", "test_signal", "test_signal"])

func test_broker_only_emit_once_even_if_duplicated_aliases() -> void:
    _test_node.name = "test"
    _test_node.add_to_group("test")
    set_meta("signal_called", [])

    GBroker.broadcast_signals_of(_test_node, 'test')
    GBroker.subscribe("test:*", func(_object: Object, sig: String, _val):
        get_meta("signal_called").append(sig))
    _test_node.test_signal.emit(1)
    wait_frames(1)
    assert_eq(get_meta("signal_called"), ["test_signal"])
