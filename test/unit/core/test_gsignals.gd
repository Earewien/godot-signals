extends GutTest

var signal_counter: GSignalsSignalCounter

func before_each() -> void:
    signal_counter = GSignalsSignalCounter.new()

func test_from_creates_gsignals_instance() -> void:
    var gsignals = GSignals.from(signal_counter.signal_0_args)
    assert_not_null(gsignals)

func test_from_signal_name_creates_gsignals_instance() -> void:
    var gsignals = GSignals.from_signal_name(signal_counter, "signal_0_args")
    assert_not_null(gsignals)

func test_from_signal_name_returns_null_for_invalid_signal() -> void:
    var gsignals = GSignals.from_signal_name(signal_counter, "invalid_signal")
    assert_null(gsignals)

func test_bind_creates_connection() -> void:
    var gsignals = GSignals.from(signal_counter.signal_0_args)
    var connection = gsignals.bind(signal_counter.callback_0_args)
    assert_not_null(connection)

func test_bind_with_low_frequency_hint_creates_low_frequency_connection() -> void:
    var gsignals = GSignals.from(signal_counter.signal_0_args, GSignals.GSignalsBindFlags.LOW_FREQUENCY_HINT)
    var connection = gsignals.bind(signal_counter.callback_0_args)
    assert_true(connection is GSignalsLowFrequencyConnection)

func test_bind_with_high_frequency_hint_creates_high_frequency_connection() -> void:
    var gsignals = GSignals.from(signal_counter.signal_0_args, GSignals.GSignalsBindFlags.HIGH_FREQUENCY_HINT)
    var connection = gsignals.bind(signal_counter.callback_0_args)
    assert_true(connection is GSignalsHighFrequencyConnection)

func test_map_operation_transforms_signal_args() -> void:
    GSignals \
        .from(signal_counter.signal_1_arg) \
        .map(func(a: int) -> int: return a * 2) \
        .bind(signal_counter.callback_1_arg)
    
    signal_counter.signal_1_arg.emit(5)
    assert_eq(signal_counter.callback_1_called_count, 1)
    assert_eq(signal_counter.last_callback_1_args, [10])

func test_filter_operation_filters_signal_args() -> void:
    GSignals \
        .from(signal_counter.signal_1_arg) \
        .filter(func(a: int) -> bool: return a > 0) \
        .bind(signal_counter.callback_1_arg)
    
    signal_counter.signal_1_arg.emit(5)
    assert_eq(signal_counter.callback_1_called_count, 1)
    signal_counter.signal_1_arg.emit(-1)
    assert_eq(signal_counter.callback_1_called_count, 1)

func test_chained_operations() -> void:
    GSignals \
        .from(signal_counter.signal_1_arg) \
        .filter(func(a: int) -> bool: return a > 0) \
        .map(func(a: int) -> int: return a * 2) \
        .bind(signal_counter.callback_1_arg)
    
    signal_counter.signal_1_arg.emit(5)
    assert_eq(signal_counter.callback_1_called_count, 1)
    assert_eq(signal_counter.last_callback_1_args, [10])

func test_connection_is_stored_in_signal_emitter() -> void:
    var gsignals = GSignals.from(signal_counter.signal_0_args)
    var connection = gsignals.bind(signal_counter.callback_0_args)
    assert_true(signal_counter.has_meta("_gsignals_connections"))
    var connections = signal_counter.get_meta("_gsignals_connections")
    assert_true(connections.has(connection))
