"""
filename: charging.gd
"""

extends './arm_state.gd'

signal charge_change(old_charge, new_charge, delta)

# this represents how many seconds a charge can be held before it must be released
export (float) var MAX_CHARGE = 10.0
# how quickly in relation to dt charge increases
export (float) var CHARGE_RATE = 1.0
# what the max threshold is before a strike is executed instead of a fire
export (float) var STRIKE_THRESH = 2.0/60.0  # two physics frames

var current_charge = 0.0

func _on_enter(state_data={}, last_state=null):
  # set animation? or is this handled by the arm_sprite, independently?
  return ._on_enter(state_data, last_state)

func _on_leave():
  reset_charge()
  return ._on_leave()

func _physics_update(delta):
  if Input.is_action_just_released(arm.ACTION):
    if current_charge <= STRIKE_THRESH:
      return 'striking'
    else:
      FSM.set_state_data('firing', {'charge_time': current_charge})
      return 'firing'

  charge_up(delta)
  arm.point_at_mouse()

  return ._physics_update(delta)

# func _on_animation_finished(ani_name):
#   return ._on_animation_finished(ani_name)


func reset_charge():
  set_charge(0.0)

func charge_up(delta):
  new_charge = current_charge + delta * CHARGE_RATE
  set_charge(new_charge)

func set_charge(charge):
  charge = clamp(charge, 0.0, MAX_CHARGE)
  _charge = current_charge
  current_charge = charge
  emit_signal('charge_change', _charge, charge, charge - _charge)
