"""
filename: level.gd
"""

class_name Level
extends Node

func _ready() -> void:
  GM.LEVEL = self

func _exit_tree() -> void:
  # TODO cleanup
  GM.clear_level()
