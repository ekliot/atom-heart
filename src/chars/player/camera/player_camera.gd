"""
filename: player_camera.gd
"""

extends Camera2D

const MAX_DIST_RATIO := 0.25
onready var max_dist := _max_dist()

var player_pos := Vector2()
var mouse_pos := Vector2()

func _ready() -> void:
  get_viewport().connect('size_changed', self, '_on_view_resize')

func _on_view_resize() -> void:
  max_dist = _max_dist()

func _max_dist() -> Vector2:
  return get_viewport_rect().size * MAX_DIST_RATIO

func set_player_pos(pos:Vector2) -> void:
  player_pos = pos
  mouse_pos = pos

func _input(ev:InputEvent) -> void:
  if ev is InputEventMouseMotion:
    # NOTE get_global_mouse_position() gets the cursor's world-coords,
    # but is only available from CanvasItems
    # this is in favour of ev.get_position() or ev.get_global_position(), which
    # are relative to the viewport (always positive)
    update_lookat()
    update_offset()

func _on_player_move(old_pos:Vector2, new_pos:Vector2) -> void:
  player_pos = new_pos
  update_lookat()
  update_offset()

func update_lookat() -> void:
  mouse_pos = get_global_mouse_position()

func update_offset() -> void:
  var off := (mouse_pos - player_pos) / 2.0
  var off_len := off.length_squared()
  var max_len := max_dist.length_squared()
  if off_len > max_len:
    off = off.normalized() * max_dist.length()
  set_offset(off)
