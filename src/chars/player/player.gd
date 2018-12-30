"""
filename: player.gd
"""

extends "res://src/chars/character.gd"

const Heart = preload("heart.gd")

var hearts = []
onready var hp_bar = $HUD.get_health_bar()


"""
==== CORE
"""

func _ready():
  GM.PLAYER = self

  # TODO formalize a default state
  # var player_state = GM.get_player_state()
  # for _hp in player_state['hearts']:
  #   add_heart(_hp)

  var DEFAULT_HEARTS = 3
  for i in range(DEFAULT_HEARTS):
    add_heart()

  $PlayerCamera.set_player_pos(get_position())
  # connect('update_position', self, '_on_move')
  connect('update_position', $PlayerCamera, '_on_player_move')

func _input(ev):
  if ev is InputEventMouseMotion:
    # NOTE get_global_mouse_position() gets the cursor's world-coords,
    # but is only available from CanvasItems
    # this is in favour of ev.get_position() or ev.get_global_position(), which
    # are relative to the viewport (always positive)
    # lookat_mouse()
    pass

func add_heart(hp=Heart.MAX_VAL):
  var heart = Heart.new(hp)
  if heart.get_instance_id() == 0:
    return

  hearts.push_back(heart)
  hp_bar.new_heart(heart)

func pop_heart():
  var popping = hearts.pop_back()
  popping.pop()
  popping.free()

func get_h_dir():
  var l = Input.is_action_pressed("ui_left") || Input.is_action_pressed("move_left")
  var r = Input.is_action_pressed("ui_right") || Input.is_action_pressed("move_right")
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

func export_player_state():
  return {}
