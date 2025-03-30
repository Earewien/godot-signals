extends GutTest

func test_debounce_return_last_signal_args_if_no_new_values() -> void:
    var operation = GSignalsDebounceOperation.new(0.2)
    var result = await operation.apply([1, 2, 3])
    assert_eq(result, [1, 2, 3])

func test_debounce_return_last_signal_args_if_new_values() -> void:
    var operation = GSignalsDebounceOperation.new(0.2)
    operation.apply([1, 2, 3])
    operation.apply([4, 5, 6])
    var result = await operation.apply([7, 8, 9])
    assert_eq(result, [7, 8, 9])
