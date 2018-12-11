"""
filename: maths.gd
"""

extends Node

func points_of_arc(center_dir, arclen, dist=1.0, resolution=10):
  """
  calculates the clockwise points of an arc
  of length $arclen,
  centered in the direction $center_dir,
  with radius $dist,
  consisting of $resolution points
  """
  var points = PoolVector2Array()

  # calculate the starting angle in degrees:
  #   angle of cone direction + half the desired arc
  var ang_start = rad2deg(center_dir.angle()) + arclen / 2.0

  # add a point for each of the R "slices"
  #   R := resolution
  for r in range(resolution + 1):
    # what is the angle (in radians) of this slice?
    #   Rth slice angle-length := r * arclen / resolution
    #   starting angle + <Rth slice angle-length> - desired arclen
    var angle = deg2rad(ang_start + r * arclen / resolution - arclen)
    # what is the vector location of this slice?
    var point = dist * Vector2(cos(angle), sin(angle))
    points.push_back(point)

  return points
