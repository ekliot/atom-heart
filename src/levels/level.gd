"""
filename: level.gd
"""

extends Node

func _ready():
  GM.LEVEL = self

func _exit_tree():
  # TODO cleanup
  GM.clear_level()
