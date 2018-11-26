"""
filename: charging.gd
"""

extends './arm_state.gd'

signal charge_change(old_charge, new_charge, delta)

# this represents how many seconds a charge can be held before it must be released
export (float) var MAX_CHARGE = 2.0
# how quickly in relation to dt charge increases
export (float) var CHARGE_RATE = 1.0
# what the max threshold is before a strike is executed instead of a fire
export (float) var STRIKE_THRESH = 4.0/60.0  # two physics frames

var current_charge = 0.0

func _on_enter(state_data={}, last_state=null):
  reset_charge()
  # set animation? or is this handled by the arm_sprite, independently?
  return .on_enter(state_data, last_state)

func _on_leave():
  return .on_leave()

func _on_physics_process(delta):
  arm.point_at_mouse()

  if Input.is_action_just_released(arm.ACTION):
    if current_charge <= STRIKE_THRESH:
      return strike()
    else:
      return fire()
  elif current_charge >= MAX_CHARGE:
    print('yo')
    return fire()

  charge_up(delta)

  return ._on_physics_process(delta)

# func _on_animation_finished(ani_name):
#   return ._on_animation_finished(ani_name)

"""
=== CORE
"""

func fire():
  FSM.set_state_data('firing', {'force': force_from_charge()})
  return 'firing'

func strike():
  # FSM.set_state_data('striking', {'force': force_from_charge()})
  return 'striking'

func force_from_charge(charge=current_charge):
  var proportion = clamp(charge / MAX_CHARGE, 0.0, 1.0)
  return arm.proportional_force(proportion)

func reset_charge():
  set_charge(0.0)

func charge_up(delta):
  var new_charge = current_charge + delta * CHARGE_RATE
  set_charge(new_charge)

func set_charge(charge):
  charge = clamp(charge, 0.0, MAX_CHARGE)
  var old_charge = current_charge
  current_charge = charge
  emit_signal('charge_change', old_charge, charge, charge - old_charge)
