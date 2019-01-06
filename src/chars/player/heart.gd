"""
filename: heart.gd
"""

extends Object

signal popped()
signal health_updated(new_hp)

const MAX_VAL := 3
const MIN_VAL := 0

var current := MIN_VAL

func _init(hp:=MAX_VAL):
  if not _valid_hp(hp):
    LOGGER.warn(self, "cannot set heart value to %d" % hp)
    self.free()

  current = hp

func pop() -> void:
  emit_signal('popped')

func health_down() -> void:
  set_health(current - 1)

func health_up() -> void:
  set_health(current + 1)

func set_health(hp:int) -> void:
  if not _valid_hp(hp):
    LOGGER.warn(self, "cannot set heart value to %d" % hp)
    return

  current = hp
  emit_signal('health_updated', current)

func _valid_hp(hp:int) -> bool:
  return hp <= MAX_VAL or hp >= MIN_VAL
