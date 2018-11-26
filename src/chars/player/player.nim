##[filename: player.gd
A player-controlled extension of the core Character class
]##

import godot
import chars.character
import arms.arm

gdobj Player of Character:

  ##[
  === CORE
  ]##

  method ready*() =
    GM.set_player(self)

  method input*(ev: InputEvent) =
    if ev of InputEventMouseButton:
      # NOTE get_global_mouse_position() gets the cursor's world-coords,
      # but is only available from CanvasItems
      # this is in favour of ev.get_position() or ev.get_global_position(), which
      # are relative to the viewport (always positive)
      # lookat_mouse()
      discard

  proc get_h_dir(): int =
    ##
    var left: bool = Input.is_action_pressed("ui_left")
    var right: bool = Input.is_action_pressed("ui_right")
    result = int(right) - int(left)


  ##[
  === HELPERS
  ]##

  proc get_arm(side: string): Arm =
    let first_letter: char = side.to_upper()[0]
    case first_letter:
    of 'L':
      result = get_node("ArmLeft")
    of 'R':
      result = get_node("ArmRight")
    else: result = nil
