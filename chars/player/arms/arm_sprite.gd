"""
filename: arm_sprite.gd
"""

extends AnimatedSprite

const ANI_NAME_FMT = "%s_%d"

var angle = 0 setget set_angle,get_angle

func animate(state):
  """
  we want each arm to be able to animate in multiple directions:
    - [0, 45, 90, 135, 180, 225, 270, 315] degrees
    - for each state, except idle (which only has one animation, because it's not being aimed)
    - for both facing directions
    - for both the left and right arm
  """
  """
  TODO facing
  """
  var ani_name = ANI_NAME_FMT % [state, angle]
  play(ani_name)


func set_angle(dir):
  """
  takes a vector, or a float representing radians, and converts it to an angle
  matching animation names
  """
  if typeof(dir) is TYPE_VECTOR2:
    dir = dir.angle()

  var degrees = rad2deg(dir)
  degrees = stepify(degrees, 45.0)

  # convert degrees to angles CCW from x-axis
  if degrees < 0:
    degrees = 360 - abs(degrees)

  angle = degrees # set the degrees to a cardinal direction

func get_angle():
  return angle
