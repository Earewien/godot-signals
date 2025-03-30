class_name GSignalsSignalCounter
extends RefCounted

#------------------------------------------
# Constants
#------------------------------------------

#------------------------------------------
# Signals
#------------------------------------------

signal signal_0_args
signal signal_1_arg(arg: Variant)
signal signal_2_args(arg1: Variant, arg2: Variant)
signal signal_3_args(arg1: Variant, arg2: Variant, arg3: Variant)
signal signal_4_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant)
signal signal_5_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant)
signal signal_6_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant)
signal signal_7_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant)
signal signal_8_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant, arg8: Variant)
signal signal_9_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant, arg8: Variant, arg9: Variant)


#------------------------------------------
# Exports
#------------------------------------------

#------------------------------------------
# Public variables
#------------------------------------------

var callback_called_count: int = 0
var callback_0_called_count: int = 0
var callback_1_called_count: int = 0
var callback_2_called_count: int = 0
var callback_3_called_count: int = 0
var callback_4_called_count: int = 0
var callback_5_called_count: int = 0
var callback_6_called_count: int = 0
var callback_7_called_count: int = 0
var callback_8_called_count: int = 0
var callback_9_called_count: int = 0

var last_callback_1_args: Array[Variant]
var last_callback_2_args: Array[Variant]
var last_callback_3_args: Array[Variant]
var last_callback_4_args: Array[Variant]
var last_callback_5_args: Array[Variant]
var last_callback_6_args: Array[Variant]
var last_callback_7_args: Array[Variant]
var last_callback_8_args: Array[Variant]
var last_callback_9_args: Array[Variant]

#------------------------------------------
# Private variables
#------------------------------------------

#------------------------------------------
# Godot override functions
#------------------------------------------

#------------------------------------------
# Public functions
#------------------------------------------

func callback_0_args() -> void:
    callback_called_count += 1
    callback_0_called_count += 1

func callback_1_arg(arg: Variant) -> void:
    callback_called_count += 1
    callback_1_called_count += 1
    last_callback_1_args = [arg]

func callback_2_args(arg1: Variant, arg2: Variant) -> void:
    callback_called_count += 1
    callback_2_called_count += 1
    last_callback_2_args = [arg1, arg2]

func callback_3_args(arg1: Variant, arg2: Variant, arg3: Variant) -> void:
    callback_called_count += 1
    callback_3_called_count += 1
    last_callback_3_args = [arg1, arg2, arg3]

func callback_4_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant) -> void:
    callback_called_count += 1
    callback_4_called_count += 1
    last_callback_4_args = [arg1, arg2, arg3, arg4]

func callback_5_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant) -> void:
    callback_called_count += 1
    callback_5_called_count += 1
    last_callback_5_args = [arg1, arg2, arg3, arg4, arg5]
func callback_6_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant) -> void:
    callback_called_count += 1
    callback_6_called_count += 1
    last_callback_6_args = [arg1, arg2, arg3, arg4, arg5, arg6]

func callback_7_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant) -> void:
    callback_called_count += 1
    callback_7_called_count += 1
    last_callback_7_args = [arg1, arg2, arg3, arg4, arg5, arg6, arg7]

func callback_8_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant, arg8: Variant) -> void:
    callback_called_count += 1
    callback_8_called_count += 1
    last_callback_8_args = [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8]

func callback_9_args(arg1: Variant, arg2: Variant, arg3: Variant, arg4: Variant, arg5: Variant, arg6: Variant, arg7: Variant, arg8: Variant, arg9: Variant) -> void:
    callback_called_count += 1
    callback_9_called_count += 1
    last_callback_9_args = [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9]

#------------------------------------------
# Private functions
#------------------------------------------
