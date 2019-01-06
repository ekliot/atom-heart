"""
filename: arm_sprite.gd
"""

extends AnimatedSprite

enum FACING {LEFT, RIGHT}

const ANI_NAME_FMT := "%s_%d"

var angle := 0.0 setget set_angle, get_angle
var facing:int = FACING.LEFT setget set_facing

func animate(state:String)  -> void: #, args=null):
  """
  we want each arm to be able to animate in multiple directions:
    - [0, 45, 90, 135, 180, 225, 270, 315] degrees
    - for each state, except idle (which only has one animation, because it's not being aimed)
    - for both facing directions
    - for both the left and right arm
    - for player states? e.g. jumping, stunned, etc.
  """
  """
  TODO facing
  """
  var ani_name := ANI_NAME_FMT % [state, angle]
  play(ani_name)


func set_facing(dir) -> void:
  match typeof(dir):
    TYPE_VECTOR2:
      facing = int((sign(dir.x) + 1) / 2)
    TYPE_STRING:
      facing = FACING.LEFT if dir[0].to_upper() == 'L' else FACING.RIGHT
    TYPE_INT:
      if dir == FACING.LEFT or dir == FACING.RIGHT:
        facing = dir


func set_angle(dir:float) -> void:
  """
  takes a float representing radians, and converts it to an angle matching animation names
  """
  var degrees := rad2deg(dir)
  degrees = stepify(degrees, 45.0)

  # convert degrees to angles CCW from x-axis
  if degrees < 0:
    degrees = 360 - abs(degrees)

  angle = degrees # set the degrees to a cardinal direction

func get_angle() -> float:
  return angle
