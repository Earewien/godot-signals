## Matches signal patterns against aliases and signal names.
##
## This class provides pattern matching functionality for the signal broker system.
## It supports wildcard patterns in the format "alias:signal" where * can be used
## as a wildcard to match any sequence of characters.
class_name GBrokerPatternMatcher
extends RefCounted

#------------------------------------------
# Constants
#------------------------------------------

#------------------------------------------
# Signals
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

#------------------------------------------
# Public variables
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

#------------------------------------------
# Godot override functions
#------------------------------------------

#------------------------------------------
# Public functions
#------------------------------------------

## Checks if the given alias and signal name match the pattern.
## @param alias The identifier of the object.
## @param signal_name The name of the signal.
## @param pattern Format is "alias:signal" where * can be used as a wildcard.
## @return True if the alias and signal match the pattern, false otherwise.
func matches(alias: String, signal_name: String, pattern: String) -> bool:
	# Split the pattern into alias and signal parts
	var parts := pattern.split(":")
	if parts.size() != 2:
		return false
	
	var pattern_alias := parts[0]
	var pattern_signal := parts[1]
	
	# If no wildcards, use direct string comparison
	if not "*" in pattern_alias and not "*" in pattern_signal:
		return alias == pattern_alias and signal_name == pattern_signal
	
	# Convert wildcard patterns to regex patterns
	var alias_pattern := "^" + pattern_alias.replace("*", ".*") + "$"
	var signal_pattern := "^" + pattern_signal.replace("*", ".*") + "$"
	
	# Create regex objects
	var alias_regex := RegEx.new()
	var signal_regex := RegEx.new()
	
	# Compile regex patterns
	if alias_regex.compile(alias_pattern) != OK or signal_regex.compile(signal_pattern) != OK:
		return false
	
	# Check if both alias and signal match their respective patterns
	return alias_regex.search(alias) != null and signal_regex.search(signal_name) != null

#------------------------------------------
# Private functions
#------------------------------------------
