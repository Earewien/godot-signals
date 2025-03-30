# Autoload

## Utility node that provides helper functions for the GSignals system
##
## This autoload node contains utility functions for creating objects
## and managing resources needed by the signal processing system.
extends Node

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

## Creates a new awaiter for delaying signal processing
##
## This helper method creates a new GAwaiter instance that can be
## used to introduce delays in signal processing chains. The awaiter
## is automatically provided with the current SceneTree.
##
## [return] A new GAwaiter instance configured with the current SceneTree
func create_awaiter() -> GAwaiter:
    var awaiter: GAwaiter = GAwaiter.new(get_tree())
    return awaiter

#------------------------------------------
# Private functions
#------------------------------------------
