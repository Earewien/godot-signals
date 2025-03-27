extends GutTest

func test_predicate_is_applyed() -> void:
    var operation: GSignalsFilterOperation = GSignalsFilterOperation.new(func(a, _b, _c) -> bool: return a == 1)
    assert_true(operation.apply([1, 2, 3]))
    assert_false(operation.apply([2, 3, 4]))

func test_predicate_0_arg() -> void:
    var operation: GSignalsFilterOperation = GSignalsFilterOperation.new(func() -> bool: return true)
    assert_true(operation.apply([]))

func test_predicate_1_arg() -> void:
    var operation: GSignalsFilterOperation = GSignalsFilterOperation.new(func(a:int) -> bool: return a == 1)
    assert_true(operation.apply([1]))

func test_predicate_can_apply_to_array_param_if_using_func_reference() -> void:
    var operation: GSignalsFilterOperation = GSignalsFilterOperation.new(lambda_with_array)
    assert_false(operation.apply([1, 2, 3]))
    assert_true(operation.apply([]))

func lambda_with_array(arr:Array) -> bool:
    return arr.is_empty()
