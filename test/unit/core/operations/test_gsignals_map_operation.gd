extends GutTest

func test_map_operation() -> void:
    var operation: GSignalsMapOperation = GSignalsMapOperation.new(func(a: int) -> int: return a * 2)
    assert_eq(operation.apply([1]), 2)

func test_map_operation_with_no_param() -> void:
    var operation: GSignalsMapOperation = GSignalsMapOperation.new(func() -> int: return 1)
    assert_eq(operation.apply([]), 1)

func test_map_operation_with_one_param() -> void:
    var operation: GSignalsMapOperation = GSignalsMapOperation.new(func(a: int) -> int: return a * 2)
    assert_eq(operation.apply([1]), 2)

func test_map_operation_with_multiple_params() -> void:
    var operation: GSignalsMapOperation = GSignalsMapOperation.new(func(a: int, b: int) -> int: return a * b)
    assert_eq(operation.apply([1, 2]), 2)

func test_map_operation_with_array_param() -> void:
    var operation: GSignalsMapOperation = GSignalsMapOperation.new(lambda_with_array)
    assert_eq(operation.apply([1, 2, 3]), [1, 2, 3])

func lambda_with_array(arr: Array) -> Array:
    return arr
