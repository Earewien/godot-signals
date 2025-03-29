extends GutTest

var _pattern_matcher: GBrokerPatternMatcher

func before_each() -> void:
    _pattern_matcher = GBrokerPatternMatcher.new()


func test_exact_match() -> void:
    assert_true(_pattern_matcher.matches("player", "player_signal", "player:player_signal"))
    assert_true(_pattern_matcher.matches("enemy", "enemy_signal", "enemy:enemy_signal"))
    assert_false(_pattern_matcher.matches("player", "enemy_signal", "player:player_signal"))
    assert_false(_pattern_matcher.matches("enemy", "player_signal", "player:player_signal"))

func test_wildcard_in_alias() -> void:
    assert_true(_pattern_matcher.matches("player_1", "player_signal", "player*:player_signal"))
    assert_true(_pattern_matcher.matches("player_2", "player_signal", "player*:player_signal"))
    assert_true(_pattern_matcher.matches("player", "player_signal", "*:player_signal"))
    assert_false(_pattern_matcher.matches("enemy", "player_signal", "player*:player_signal"))

func test_wildcard_in_signal() -> void:
    assert_true(_pattern_matcher.matches("player", "player_signal_1", "player:player_signal*"))
    assert_true(_pattern_matcher.matches("player", "player_signal_2", "player:player_signal*"))
    assert_true(_pattern_matcher.matches("player", "player_signal", "player:*"))
    assert_false(_pattern_matcher.matches("player", "enemy_signal", "player:player_signal*"))

func test_wildcard_in_both() -> void:
    assert_true(_pattern_matcher.matches("player_1", "player_signal_1", "player*:player_signal*"))
    assert_true(_pattern_matcher.matches("player_2", "player_signal_2", "player*:player_signal*"))
    assert_true(_pattern_matcher.matches("enemy_1", "enemy_signal_1", "*:enemy_signal*"))
    assert_false(_pattern_matcher.matches("enemy", "player_signal", "player*:player_signal*"))

func test_invalid_patterns() -> void:
    assert_false(_pattern_matcher.matches("player", "player_signal", ""))
    assert_false(_pattern_matcher.matches("player", "player_signal", "player"))
    assert_false(_pattern_matcher.matches("player", "player_signal", "player:signal:extra"))
    assert_false(_pattern_matcher.matches("player", "player_signal", ":player_signal"))
    assert_false(_pattern_matcher.matches("player", "player_signal", "player:"))
    assert_false(_pattern_matcher.matches("player", "player_signal", "::"))
