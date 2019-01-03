"""
filename: maths.gd
"""

extends Node

func points_of_arc(angle:float, arclen:float, dist:float, resolution:=10) -> PoolVector2Array:
  """
  calculates the counter-clockwise points of an arc
  of length $arclen,
  centered in the direction $center_dir,
  with radius $dist,
  consisting of $resolution points
  """
  var points := PoolVector2Array()

  # calculate the starting angle in degrees:
  #   angle of cone direction + half the desired arc
  var ang_start := rad2deg(angle) + arclen / 2.0

  # add a point for each of the R "slices"
  #   R := resolution
  for r in range(resolution + 1):
    # what is the angle (in radians) of this slice?
    #   Rth slice angle-length := r * arclen / resolution
    #   starting angle + <Rth slice angle-length> - desired arclen
    var ang := deg2rad(ang_start + r * arclen / resolution - arclen)
    # what is the vector location of this slice?
    var pt := dist * Vector2(cos(ang), sin(ang))
    points.push_back(pt.round())

  return points

func blast_points_parametric_left(dir:float, w:float, l:float, resolution:=10) -> PoolVector2Array:
  """
  $w := width
  $l := length
  $dir := direction of blast in radians
  $resolution := how many points
  """
  return blast_points_parametric(dir, w, l, resolution, PI, PI*2)

func blast_points_parametric_right(dir:float, w:float, l:float, resolution:=10) -> PoolVector2Array:
  """
  $w := width
  $l := length
  $dir := direction of blast in radians
  $resolution := how many points
  """
  return blast_points_parametric(dir, w, l, resolution, 0, PI)

func blast_points_parametric(rot:float, w:float, l:float, resolution:int, start:float, end:float) -> PoolVector2Array:
  """
  $start := starting angle of parametric eq in radians
  $end := ending angle of parametric eq in radians
  """
  var points := PoolVector2Array()

  var step := (end - start) / resolution

  for r in range(resolution + 1):
    var ang := start + r * step
    # DEV NOTE the former can be used for optimization, but it will be backwards
    var _x := l - l * sin(ang / 2.0)
    var _y := w * sin(ang) * 50 # MAGICNUM

    var x := _x * cos(rot) - _y * sin(rot)
    var y := _x * sin(rot) + _y * cos(rot)
    var pt := Vector2(x, y)
    if pt.abs() != Vector2():
      points.push_back(pt.round())

  return points
