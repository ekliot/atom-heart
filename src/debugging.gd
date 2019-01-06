"""
filename: debugging.gd
defines various debugging constants
"""

extends Node

const DEBUG := true

const VEL_POINT = preload("res://src/ui/debug/VelocityPointer.tscn")
const ARM_INSPECT = preload("res://src/ui/debug/ArmInspector.tscn")

func _ready() -> void:
  var status:String

  if DEBUG:
    status = "ENABLED"
    LOGGER.logging_lvl = LOGGER.LEVELS.DEBUG
  else:
    status = "DISABLED"

  LOGGER.info(self, "DEBUGGING %s" % status)
