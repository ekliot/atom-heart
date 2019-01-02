"""
filename: charging.gd
"""

extends "arm_state.gd"

signal charge_change(old_charge, new_charge, delta)

# what the max threshold is before a strike is executed instead of a fire
const STRIKE_THRESH = 5.0/60.0  # five physics frames

var current_charge = 0.0

func _on_enter(state_data={}, last_state=null):
  reset_charge()
  # set animation? or is this handled by the arm_sprite, independently?
  return ._on_enter(state_data, last_state)

func _on_leave():
  return ._on_leave()

func _on_physics_process(delta):
  arm.point_at_mouse()

  if Input.is_action_just_released(arm.ACTION):
    if current_charge <= STRIKE_THRESH:
      return strike()
    else:
      return fire()
  elif current_charge >= arm.MAX_CHARGE:
    return fire()

  charge_up(delta)

  return ._on_physics_process(delta)

# func _on_animation_finished(ani_name):
#   return ._on_animation_finished(ani_name)

"""
=== CORE
"""

func fire():
  FSM.set_state_data('firing', {'charge': charge_power()})
  return 'firing'

func strike():
  return 'striking'

func charge_power(charge=current_charge):
  var proportion = clamp(charge / arm.MAX_CHARGE, 0.0, 1.0)
  return arm.proportional_force(proportion)

func reset_charge():
  set_charge(0.0)

func charge_up(delta):
  var new_charge = current_charge + delta * arm.CHARGE_RATE
  set_charge(new_charge)

func set_charge(charge):
  charge = clamp(charge, 0.0, arm.MAX_CHARGE)
  var old_charge = current_charge
  current_charge = charge
  emit_signal('charge_change', old_charge, charge, charge - old_charge)
