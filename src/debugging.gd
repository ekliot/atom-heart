"""
filename: debugging.gd
defines various debugging constants
"""

extends Node

const DEBUG = true

const VEL_POINT = preload("res://src/ui/debug/VelocityPointer.tscn")
const ARM_INSPECT = preload("res://src/ui/debug/ArmInspector.tscn")

func _ready():
  if DEBUG:
    var status = "ENABLED"
    LOGGER.logging_lvl = LOGGER.DEBUG
  else:
    var status = "DISABLED"

  LOGGER.info(self, "DEBUGGING %s" % status)
