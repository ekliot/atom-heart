"""
filename: health_bar.gd
"""

extends HBoxContainer

const HeartContainer = preload("res://src/ui/hud/HeartContainer.tscn")

var player = null

func _ready():
  if not GM.PLAYER:
    GM.connect('player_set', self, '_set_player')
  else:
    _set_player(GM.PLAYER)

func _set_player(_player):
  player = _player

func _update_health(amt, new_hp):
  # animate based on amt (inc or dec)
  set_health(new_hp)

func new_heart(heart):
  var container = HeartContainer.instance()
  container.name = "%s" % get_child_count()
  container.connect_to_heart(heart)
  add_child(container)

func set_health(val):
  pass
