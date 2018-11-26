"""
filename: move.gd
"""

extends '../player_state.gd'


"""
=== STATE OVERRIDES
"""

func _on_enter(state_data, last_state):
  # play movement animation
  # player.animate(ID + move_dir_as_str())
  return ._on_enter(state_data, last_state)

func _process(delta):
  # var interruptor = check_interrupts()
  # if interruptor:
  #   return interruptor

  return ._process(delta)

func _on_physics_process(delta):
  if Input.is_action_just_pressed("ui_up"):
    return "jumping"

  # if player.is_on_wall():
  #   return 'on_wall'

  if not player.is_on_floor():
    return 'airborne'

  var h_dir = player.get_h_dir()

  if not h_dir:
    return FSM.START_STATE

  move_step()

  # if we've stopped moving (such as hitting a wall), return to our last state (idle)
  if not player.velocity.x:
    return FSM.START_STATE

  return ._on_physics_process(delta)


"""
=== CORE METHODS
"""

func move_step():
  var _vel = update_velocity()
  _vel = PHYSICS.cap_velocity(_vel, player.MAX_VEL)
  # TODO friction?
  player.apply_velocity(_vel)
