extends GutTest

var _subject: GAwaiter

func before_each() -> void:
    _subject = GAwaiter.new(get_tree())

func test_wait_for_returns_true_if_timer_completes() -> void:
    assert_true(await _subject.wait_for(0.25))

func test_awaiter_returns_true_if_timer_is_not_cancelled() -> void:
    var thread = Thread.new()
    set_meta("val", false)
    thread.start(func() -> void:
        set_meta("val", await _subject.wait_for(0.25))
    )
    await thread.wait_to_finish()
    assert_true(get_meta("val"))

func test_awaiter_not_calling_code_after_wait_if_cancelled() -> void:
    var thread = Thread.new()
    set_meta("val", true)
    thread.start(func() -> void:
        await _subject.wait_for(10)
        set_meta("val", false)
    )
    await wait_seconds(0.2)
    _subject.cancel()
    await  wait_seconds(0.2)
    assert_false(thread.is_alive())
    thread.wait_to_finish()
    assert_true(get_meta("val"))
