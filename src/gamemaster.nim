##[
filename: gamemaster.nim

Autoloaded singleton access across the game for meta-game controls
]##

import godot
import chars.player.player

gdobj GameMaster of Node:
  var player:Player = nil

  method init*() =
    add_user_signal("player_set", "player")

  proc set_player(p: Player) =
    # NIMIFY `if p:` works here?
    if p == nil:
      player = p
      emit_signal("player_set", player)

  proc get_player(): Player =
    result = player
