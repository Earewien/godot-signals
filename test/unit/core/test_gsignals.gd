extends GutTest

var signal_counter: GSignalsSignalCounter

var bind_flags = [
    GSignals.GSignalsBindFlags.LOW_FREQUENCY_HINT,
    GSignals.GSignalsBindFlags.HIGH_FREQUENCY_HINT,
]

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

func test_map_operation_transforms_signal_args(flags=use_parameters(bind_flags)) -> void:
    GSignals \
        .from(signal_counter.signal_1_arg, flags) \
        .map(func(a: int) -> int: return a * 2) \
        .bind(signal_counter.callback_1_arg)

    signal_counter.signal_1_arg.emit(5)
    assert_eq(signal_counter.callback_1_called_count, 1)
    assert_eq(signal_counter.last_callback_1_args, [10])


func test_filter_operation_filters_signal_args(flags=use_parameters(bind_flags)) -> void:
    GSignals \
        .from(signal_counter.signal_1_arg, flags) \
        .filter(func(a: int) -> bool: return a > 0) \
        .bind(signal_counter.callback_1_arg)

    signal_counter.signal_1_arg.emit(5)
    assert_eq(signal_counter.callback_1_called_count, 1)
    signal_counter.signal_1_arg.emit(-1)
    assert_eq(signal_counter.callback_1_called_count, 1)

func test_delay_operation_is_delaying_signal_emission(flags=use_parameters(bind_flags)) -> void:
    GSignals \
        .from(signal_counter.signal_1_arg, flags) \
        .delay(1.0) \
        .bind(signal_counter.callback_1_arg)

    signal_counter.signal_1_arg.emit(5)
    assert_eq(signal_counter.callback_1_called_count, 0)
    await get_tree().create_timer(1.0).timeout
    assert_eq(signal_counter.callback_1_called_count, 1)

func test_debounce_operation_let_pass_values_if_delay_is_okay(flags=use_parameters(bind_flags)) -> void:
    GSignals \
        .from(signal_counter.signal_1_arg, flags) \
        .debounce(0.1) \
        .bind(signal_counter.callback_1_arg)

    signal_counter.signal_1_arg.emit(1)
    await get_tree().create_timer(0.15).timeout
    assert_eq(signal_counter.callback_1_called_count, 1)
    assert_eq(signal_counter.last_callback_1_args, [1])

    signal_counter.signal_1_arg.emit(2)
    await get_tree().create_timer(0.15).timeout
    assert_eq(signal_counter.callback_1_called_count, 2)
    assert_eq(signal_counter.last_callback_1_args, [2])

func test_debounce_operation_is_debouncing_signal_emission(flags=use_parameters(bind_flags)) -> void:
    GSignals \
        .from(signal_counter.signal_1_arg, flags) \
        .debounce(0.5) \
        .bind(signal_counter.callback_1_arg)

    signal_counter.signal_1_arg.emit(1)
    assert_eq(signal_counter.callback_1_called_count, 0)
    await get_tree().create_timer(0.25).timeout
    signal_counter.signal_1_arg.emit(2)
    assert_eq(signal_counter.callback_1_called_count, 0)
    await get_tree().create_timer(0.5).timeout
    assert_eq(signal_counter.callback_1_called_count, 1)
    assert_eq(signal_counter.last_callback_1_args, [2])

func test_debounce_real_example(flags=use_parameters(bind_flags)) -> void:
    var input: TextEdit = TextEdit.new()
    add_child_autofree(input)
    GSignals \
        .from(input.text_set, flags) \
        .map(func(): return input.text) \
        .debounce(0.5) \
        .bind(signal_counter.callback_1_arg)

    input.text = "a"
    await wait_seconds(0.2)
    input.text = "ab"
    await wait_seconds(0.2)
    input.text = "abc"
    await wait_seconds(0.6)

    assert_eq(signal_counter.callback_1_called_count, 1)
    assert_eq(signal_counter.last_callback_1_args, ["abc"])

func test_chained_operations(flags=use_parameters(bind_flags)) -> void:
    GSignals \
        .from(signal_counter.signal_1_arg, flags) \
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

func test_can_subscribe_and_received_signal_args_without_operations(flags=use_parameters(bind_flags)) -> void:
    GSignals \
        .from(signal_counter.signal_1_arg, flags) \
        .bind(signal_counter.callback_1_arg)

    signal_counter.signal_1_arg.emit(9)
    assert_eq(signal_counter.callback_1_called_count, 1)
    assert_eq(signal_counter.last_callback_1_args, [9])
