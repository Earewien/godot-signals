class_name GBrokerSubscriptionManager
extends RefCounted

#------------------------------------------
# Constants
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

static var _instance: GBrokerSubscriptionManager

var _pattern_matcher: GBrokerPatternMatcher = GBrokerPatternMatcher.new()
var _subscriptions: Dictionary = {}
var _pattern_match_cache: Dictionary = {}

#------------------------------------------
# Public functions
#------------------------------------------

static func get_instance() -> GBrokerSubscriptionManager:
    if _instance == null:
        _instance = GBrokerSubscriptionManager.new()
    return _instance

func subscribe(pattern: String, callback: Callable) -> void:
    var callbacks: Array[Callable] = _subscriptions.get_or_add(pattern, Array([], TYPE_CALLABLE, '', null))
    callbacks.append(callback)
    _pattern_match_cache.clear()

func reset() -> void:
    _subscriptions.clear()
    _pattern_match_cache.clear()

func get_matching_patterns_for_signal(aliases: Array[String], signal_name: String) -> Dictionary:
    var matching_patterns_for_signal: Dictionary = {}

    for alias in aliases:
        var cache_key := "%s::%s" % [alias, signal_name]

        if _pattern_match_cache.has(cache_key):
            var cached_patterns: Array[String] = _pattern_match_cache[cache_key]
            for p in cached_patterns:
                matching_patterns_for_signal[p] = true
        else:
            var newly_matched_patterns: Array[String] = []
            for pattern in _subscriptions.keys():
                if _pattern_matcher.matches(alias, signal_name, pattern):
                    newly_matched_patterns.append(pattern)
                    matching_patterns_for_signal[pattern] = true
            _pattern_match_cache[cache_key] = newly_matched_patterns

    return matching_patterns_for_signal

func get_callbacks_for_pattern(pattern: String) -> Array[Callable]:
    return _subscriptions.get(pattern, [])

func remove_invalid_callbacks(pattern: String, invalid_callbacks: Array[Callable]) -> void:
    var callbacks: Array[Callable] = _subscriptions.get(pattern, [])
    for callback in invalid_callbacks:
        callbacks.erase(callback)