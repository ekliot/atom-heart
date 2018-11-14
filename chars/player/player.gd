"""
filename: player.gd
"""

extends "res://chars/character.gd"

"""
==== CORE
"""

func _ready():
  GM.PLAYER = self
  # ._ready()

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


"""
=== HELPERS
"""

func get_arm(side):
  if side.to_upper()[0] == 'L':
    return get_node("ArmLeft")
  elif side.to_upper()[0] == 'R':
    return get_node("ArmRight")
  return null
