extends Node

signal player_set(player)

var PLAYER: Player = null setget set_player, get_player

const Level = preload("res://src/levels/level.gd")
var LEVEL: Level = null setget set_level, get_level

func set_player(player:Player) -> void:
  if player and not PLAYER:
    PLAYER = player
    emit_signal('player_set', PLAYER)

func get_player() -> Player:
  return PLAYER

func clear_level() -> void:
  LEVEL = null

func set_level(level) -> void:
  if not LEVEL:
    # TODO scene switching
    pass
  LEVEL = level

func get_level() -> Level:
  return LEVEL
