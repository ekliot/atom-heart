"""
filename: hud.gd
"""

extends CanvasLayer

onready var GUI = $GUI

func _ready():
  if DBG.DEBUG:
    get_foot().add_child(DBG.ARM_INSPECT.instance())

func get_health_bar():
  return get_head("/HealthBar")

func get_head(child_path=""):
  return GUI.get_node("Head%s" % child_path)

func get_foot(child_path=""):
  return GUI.get_node("Foot")
