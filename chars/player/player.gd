"""
filename: player.gd
"""

extends "res://chars/character.gd"

"""
==== CORE
"""

func _input( ev ):
  if ev is InputEventMouseMotion:
    # NOTE get_global_mouse_position() gets the cursor's world-coords,
    # but is only available from CanvasItems
    # this is in favour of ev.get_position() or ev.get_global_position(), which
    # are relative to the viewport (always positive)
    # lookat_mouse()
    pass

func get_h_dir():
  var l = Input.is_action_pressed("ui_left")
  var r = Input.is_action_pressed("ui_right")
  return int(r) - int(l)
