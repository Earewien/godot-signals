extends GutTest

var signal_counter: GSignalsSignalCounter

func before_each() -> void:
    signal_counter = GSignalsSignalCounter.new()

func test_can_start_connection() -> void:
    var connection: GSignalsLowFrequencyConnection = GSignalsLowFrequencyConnection.new(signal_counter.signal_0_args, [], signal_counter.callback_0_args, 0)
    connection.start()
    assert_true(connection.is_active())

func test_can_stop_connection() -> void:
    var connection: GSignalsLowFrequencyConnection = GSignalsLowFrequencyConnection.new(signal_counter.signal_0_args, [], signal_counter.callback_0_args, 0)
    connection.start()
    connection.stop()
    assert_false(connection.is_active())

func test_can_restart_connection() -> void:
    var connection: GSignalsLowFrequencyConnection = GSignalsLowFrequencyConnection.new(signal_counter.signal_0_args, [], signal_counter.callback_0_args, 0)
    connection.start()
    signal_counter.signal_0_args.emit()
    assert_eq(signal_counter.callback_0_called_count, 1)
    connection.stop()
    signal_counter.signal_0_args.emit()
    assert_eq(signal_counter.callback_0_called_count, 1)
    connection.start()
    signal_counter.signal_0_args.emit()
    assert_eq(signal_counter.callback_0_called_count, 2)

func test_can_handle_signal_with_0_args() -> void:
    var connection: GSignalsLowFrequencyConnection = GSignalsLowFrequencyConnection.new(signal_counter.signal_0_args, [], signal_counter.callback_0_args, 0)
    connection.start()
    signal_counter.signal_0_args.emit()
    assert_eq(signal_counter.callback_0_called_count, 1)

func test_can_handle_signal_with_1_arg() -> void:
    var connection: GSignalsLowFrequencyConnection = GSignalsLowFrequencyConnection.new(signal_counter.signal_1_arg, [], signal_counter.callback_1_arg, 0)
    connection.start()
    signal_counter.signal_1_arg.emit(1)
    assert_eq(signal_counter.callback_1_called_count, 1)

func test_can_handle_signal_with_2_args() -> void:
    var connection: GSignalsLowFrequencyConnection = GSignalsLowFrequencyConnection.new(signal_counter.signal_2_args, [], signal_counter.callback_2_args, 0)
    connection.start()
    signal_counter.signal_2_args.emit(1, 2)
    assert_eq(signal_counter.callback_2_called_count, 1)

func test_can_handle_signal_with_3_args() -> void:
    var connection: GSignalsLowFrequencyConnection = GSignalsLowFrequencyConnection.new(signal_counter.signal_3_args, [], signal_counter.callback_3_args, 0)
    connection.start()
    signal_counter.signal_3_args.emit(1, 2, 3)
    assert_eq(signal_counter.callback_3_called_count, 1)

func test_can_handle_signal_with_4_args() -> void:
    var connection: GSignalsLowFrequencyConnection = GSignalsLowFrequencyConnection.new(signal_counter.signal_4_args, [], signal_counter.callback_4_args, 0)
    connection.start()
    signal_counter.signal_4_args.emit(1, 2, 3, 4)
    assert_eq(signal_counter.callback_4_called_count, 1)

func test_can_handle_signal_with_5_args() -> void:
    var connection: GSignalsLowFrequencyConnection = GSignalsLowFrequencyConnection.new(signal_counter.signal_5_args, [], signal_counter.callback_5_args, 0)
    connection.start()
    signal_counter.signal_5_args.emit(1, 2, 3, 4, 5)
    assert_eq(signal_counter.callback_5_called_count, 1)

func test_can_handle_signal_with_6_args() -> void:
    var connection: GSignalsLowFrequencyConnection = GSignalsLowFrequencyConnection.new(signal_counter.signal_6_args, [], signal_counter.callback_6_args, 0)
    connection.start()
    signal_counter.signal_6_args.emit(1, 2, 3, 4, 5, 6)
    assert_eq(signal_counter.callback_6_called_count, 1)

func test_can_handle_signal_with_7_args() -> void:
    var connection: GSignalsLowFrequencyConnection = GSignalsLowFrequencyConnection.new(signal_counter.signal_7_args, [], signal_counter.callback_7_args, 0)
    connection.start()
    signal_counter.signal_7_args.emit(1, 2, 3, 4, 5, 6, 7)
    assert_eq(signal_counter.callback_7_called_count, 1)

func test_can_handle_signal_with_8_args() -> void:
    var connection: GSignalsLowFrequencyConnection = GSignalsLowFrequencyConnection.new(signal_counter.signal_8_args, [], signal_counter.callback_8_args, 0)
    connection.start()
    signal_counter.signal_8_args.emit(1, 2, 3, 4, 5, 6, 7, 8)
    assert_eq(signal_counter.callback_8_called_count, 1)

func test_can_handle_signal_with_9_args() -> void:
    var connection: GSignalsLowFrequencyConnection = GSignalsLowFrequencyConnection.new(signal_counter.signal_9_args, [], signal_counter.callback_9_args, 0)
    connection.start()
    signal_counter.signal_9_args.emit(1, 2, 3, 4, 5, 6, 7, 8, 9)
    assert_eq(signal_counter.callback_9_called_count, 1)
