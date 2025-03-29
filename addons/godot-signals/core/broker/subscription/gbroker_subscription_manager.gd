## Manages subscriptions to signals in the broker system.
##
## This class handles the registration of signal subscriptions and matches
## incoming signals to the appropriate patterns. It maintains a cache of
## pattern matches to optimize performance for frequently triggered signals.
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

## Gets the singleton instance of the subscription manager.
## @return The GBrokerSubscriptionManager singleton instance.
static func get_instance() -> GBrokerSubscriptionManager:
    if _instance == null:
        _instance = GBrokerSubscriptionManager.new()
    return _instance

## Registers a callback to be called when signals matching the pattern are emitted.
## @param pattern Format is "alias:signal" where * can be used as a wildcard.
## @param callback The function to call when a matching signal is emitted.
func subscribe(pattern: String, callback: Callable) -> void:
    var callbacks: Array[Callable] = _subscriptions.get_or_add(pattern, Array([], TYPE_CALLABLE, '', null))
    callbacks.append(callback)
    _pattern_match_cache.clear()

## Clears all subscriptions and the pattern match cache.
func reset() -> void:
    _subscriptions.clear()
    _pattern_match_cache.clear()

## Gets patterns that match the given aliases and signal name.
## @param aliases Array of identifiers to match against.
## @param signal_name The name of the signal.
## @return A dictionary with matching patterns as keys.
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

## Gets all callbacks registered for a specific pattern.
## @param pattern The pattern to get callbacks for.
## @return Array of callables registered for the pattern.
func get_callbacks_for_pattern(pattern: String) -> Array[Callable]:
    return _subscriptions.get(pattern, [])

## Removes callbacks that are no longer valid.
## @param pattern The pattern to remove callbacks from.
## @param invalid_callbacks Array of callbacks to remove.
func remove_invalid_callbacks(pattern: String, invalid_callbacks: Array[Callable]) -> void:
    var callbacks: Array[Callable] = _subscriptions.get(pattern, [])
    for callback in invalid_callbacks:
        callbacks.erase(callback)