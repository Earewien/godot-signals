[![Discord Banner](https://discordapp.com/api/guilds/1067685170397855754/widget.png?style=banner2)](https://discord.gg/SWg6vgcw3F)

# Godot Signals

A powerful signal system for Godot Engine that provides efficient signal handling with support for filtering, mapping, and high-performance signal processing.

## 📖 Overview

Godot Signals is an addon that enhances Godot's built-in signal system with powerful features for signal processing and event management. It provides a clean, high-level API for working with signals while handling all the complexity of efficient signal processing under the hood.

The addon is built on two main components:

- **Signal Processing**: Efficient signal handling with support for transform operations such as filtering and mapping
- **Event Bus** (Coming Soon): A global event system for centralized event management

## 🚀 Quick Start

Here's a quick guide to get started with Godot Signals:

### Basic Signal Connection

```gdscript
# Connect to a signal
GSignals.from(signal)
    .bind(func(val): print("Only 11 and more!"))
```

### Filtering Signals

```gdscript
# Only process signals where the first argument is at least 10
GSignals.from(signal)
    .filter(func(val: int) -> bool: return val >= 10)
    .bind(func(val: int): print("10 and more!"))
```

### Transforming Signals

```gdscript
# Transform a position signal into a distance from origin
GSignals.from(signal)
    .map(func(pos: Vector2) -> float: return pos.distance_to(position))
    .bind(func(distance: float): print("Distance to target: %s" % distance))
```

### Chaining Operations

```gdscript
# Filter and then transform signal arguments
GSignals.from(signal)
    .filter(func(x: int) -> bool: return x > 0)
    .map(func(x: int) -> int: return x * 2)
    .bind(func(x: int): print(x))
```

## 🎯 Features

### 🔑 Signal Processing

- **Filter Operations**: Filter signal arguments based on predicates
- **Map Operations**: Transform signal arguments into new values
- **Combined Operations**: Chain multiple operations together
- **Optimization**: Choose the best connection type based on signal frequency (frequent versus unfrequent emissions)

### 🔑 Event Bus (Coming Soon)

### 🔑 Performance Optimizations

- **Smart Connection Types**: Automatically choose between high-frequency and low-frequency connections
- **Minimal Allocations**: Efficient memory usage
- **Optimized Callbacks**: Reduced overhead for signal processing

## 📚 Usage Guide

### 🔧 Basic Setup

1. Add the addon to your project
2. Enable the addon in Project Settings
3. The `GSignals` class will be available in your code

### 🎯 Creating Operations

```gdscript
# Create a GSignals instance
var sig_1: GSignals = GSignals.from(my_signal)
# Is equivalent to
var sig_2: GSignals = GSignals.from(self, "my_signal")
```

It is also possible to explicitly set the signal emission frequency for optimal performance:

```gdscript
# Tells the signal is emitting frequently and should be optimized for performance
var sig: GSignals = GSignals.from(my_signal, GSignals.GSignalsBindFlags.HIGH_FREQUENCY_HINT)
```

### 🔍 Managing Connections

```gdscript
# Connect to a signal
var connection = GSignals.from(my_signal).bind(callback)
# Also possible to connect to an existing GSignals instance
var sig: GSignals = ...
var connection = sig.bind(callback)
```

When binding to a `GSignals` instance, the connection is automatically started, hence the underlying signal is connected.

```gdscript
# Check if connection is active
if connection.is_active():
    # Do something
```

```gdscript
# Disconnect from a signal
connection.stop()
```

Connections can be re-established by invoking the `start` method.

### 🔍 Operations

#### Filter

```gdscript
# Filter signal parameters; if the filter returns false, the signal is not handled
GSignals.from(on_damage)
    .filter(func(val: int) -> bool: return val > 0)
    .bind(...)
```

#### Map

```gdscript
# Transform parameters into another value
GSignals.from(on_damage)
    .map(func(val: int) -> int: return val * critical_damage_ratio)
    .bind(...)
```

### 🎮 Performance Considerations

- Chain operations carefully as each operation adds overhead
- Use the Event Bus (coming soon) for global event management

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.
