[![Discord Banner](https://discordapp.com/api/guilds/1067685170397855754/widget.png?style=banner2)](https://discord.gg/SWg6vgcw3F)

# Godot Signals

A powerful signal system for Godot Engine, making signal handling and event management effortless and flexible.

## 📖 Overview

Godot Signals is an addon that extends Godot's built-in signal system with powerful features for event handling and signal management. It provides a global event bus, signal instrumentation, and advanced signal utilities that make working with signals more intuitive and powerful.

While Godot's native signal system is powerful, it has some limitations when dealing with complex scenarios like:

- Connecting to multiple signals simultaneously
- Handling conditional signal connections
- Managing dynamic signal connections
- Debugging signal flows
- Pattern-based signal matching

This addon addresses these limitations by providing a comprehensive solution that makes signal handling more flexible and maintainable.

## 🎯 Features

### 🔑 Global Event Bus

- Centralized event management
- Pattern-based signal subscription
- Automatic signal forwarding from instrumented objects

### 🔑 Signal Instrumentation

- Easy integration with existing nodes
- Automatic signal forwarding to global bus
- Support for dynamic node creation

### 🔑 Advanced Signal Utilities

- Signal combination operators (`any`, `all`, `with_latest_from`)
- Signal filtering and mapping
- Pattern matching for signal names
- Debugging tools for signal flow

## 🚀 Quick Start

Here's a simple example showing how to use the addon:

```gdscript
# player.gd
extends CharacterBody2D

signal died(location: Vector2)
signal health_changed(new_health: int)

func _ready() -> void:
    # Instrument this node to forward its signals to the global bus
    GSignalsCore.instrument(self)

func die() -> void:
    died.emit(position)

func take_damage(amount: int) -> void:
    health -= amount
    health_changed.emit(health)

# main.gd
extends Node2D

func _ready() -> void:
    # Connect to any player death signal
    GSignals.any_player_died.connect(_on_player_died)

    # Connect using pattern matching
    GSignals.connect("player:*", _on_player_signal)

    # Connect to multiple signals
    GSignals.any(
        player.died,
        player.health_changed
    ).connect(_on_player_event)

    # Connect with filtering
    GSignals.any_player_died.filter(
        func(pos): pos != respawn_position
    ).connect(_on_player_died_away_from_spawn)
```

## 📚 Usage Guide

### 🔧 Basic Setup

1. Add the addon to your project
2. Enable the addon in Project Settings
3. The `GSignals` autoload will be automatically added

### 🎯 Signal Instrumentation

To forward a node's signals to the global bus:

```gdscript
# In _ready() or when creating nodes dynamically
GSignalsCore.instrument(node)
```

### 🔍 Pattern Matching

Connect to signals using patterns:

```gdscript
# Connect to all player signals
GSignals.connect("player:*", _on_player_signal)

# Connect to specific signal patterns
GSignals.connect("player:health_*", _on_player_health_signal)
```

### 🎮 Signal Operators

Combine and transform signals:

```gdscript
# Connect to either signal
GSignals.any(player.died, player.health_changed).connect(_on_event)

# Connect to both signals
GSignals.all(player.died, player.health_changed).connect(_on_both)

# Connect with latest value from another signal
GSignals.with_latest_from(
    player.died,
    player.position_changed
).connect(_on_died_with_position)
```

### 🔄 Signal Transformation

Filter and map signals:

```gdscript
# Filter signals
GSignals.any_player_died.filter(
    func(pos): return pos.x > 100
).connect(_on_player_died_right)

# Map signal data
GSignals.any_player_health_changed.map(
    func(health): return health / max_health
).connect(_on_health_percentage_changed)
```

## 🛠️ Advanced Features

### 🔍 Debug Mode

Enable debug mode to track signal flow:

```gdscript
GSignalsCore.set_debug(true)
```

### 🎯 Dynamic Connections

Connect to signals from dynamically created nodes:

```gdscript
# The connection will be established when the node is created
GSignals.connect_dynamic("player:*", _on_player_signal)
```

### 🔄 Signal Batching

Batch multiple signal emissions:

```gdscript
GSignalsCore.batch_begin()
# Multiple signal emissions
player.died.emit(position)
player.health_changed.emit(0)
GSignalsCore.batch_end()
```

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.
