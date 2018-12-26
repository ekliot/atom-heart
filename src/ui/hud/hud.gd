"""
filename: hud.gd
"""

extends CanvasLayer

func _ready():
  if DBG.DEBUG:
    add_child(DBG.ARM_INSPECT.instance())
