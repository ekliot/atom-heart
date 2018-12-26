"""
filename: velocity_pointer.gd
"""

extends Line2D

const MAX_LENGTH = 100.0
const VEL_SCALE = 0.2
const MIN_THRESH = 0.01

var subject = null

func _ready():
  if get_parent() is KinematicBody2D:
    self.subject = get_parent()
    add_point(Vector2())

func _physics_process(dt):
  if not subject:
    return

  if get_point_count() > 1:
    remove_point(1)

  if subject.velocity.length() <= MIN_THRESH:
    self.visible = false
    $Label.visible = false
    return
  else:
    self.visible = true
    $Label.visible = true

  var end_pt = subject.velocity * VEL_SCALE
  add_point(end_pt.clamped(MAX_LENGTH))

  $Label.text = "%s" % floor(subject.velocity.length())
  $Label.rect_position = get_point_position(1)
