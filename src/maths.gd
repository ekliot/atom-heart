"""
filename: maths.gd
"""

extends Node

const EPS_FLT := 0.00001

"""
=== GEOMETRY
"""

static func reduce_vecs(vecs:PoolVector2Array) -> PoolVector2Array:
  if len(vecs) == 1:
    return vecs

  var uniq = PoolVector2Array()
  var a:Vector2
  var b:Vector2
  var next:int

  for idx in range(len(vecs)):
    a = vecs[idx]
    if a in uniq:
      continue

    next = (idx + 1) % len(vecs)
    # next is 0 when idx + 1 == len(vecs)
    if not next:
      break

    for jdx in range(next, len(vecs)):
      b = vecs[jdx]
      if CompareVec.approx_equal_vec(a, b, EPS_FLT * 10):
        vecs[jdx] = a

    uniq.push_back(a)

  print(len(vecs) - len(uniq))

  return uniq

static func point_inside_poly(point:Vector2, poly:PoolVector2Array) -> bool:
  var tris := Geometry.triangulate_polygon(poly)
  if not tris:
    return false

  var try = [
    point,
    point + Vector2(     0.0,  EPS_FLT),
    point + Vector2(     0.0, -EPS_FLT),
    point + Vector2( EPS_FLT,      0.0),
    point + Vector2( EPS_FLT,  EPS_FLT),
    point + Vector2( EPS_FLT, -EPS_FLT),
    point + Vector2(-EPS_FLT,      0.0),
    point + Vector2(-EPS_FLT,  EPS_FLT),
    point + Vector2(-EPS_FLT, -EPS_FLT),
  ]
  var a:Vector2
  var b:Vector2
  var c:Vector2
  for idx in range(0, len(tris), 3):
    a = poly[tris[idx]]
    b = poly[tris[idx+1]]
    c = poly[tris[idx+2]]

    for pt in try:
      if Geometry.point_is_inside_triangle(pt, a, b, c):
        return true

  return false

static func points_of_arc(angle:float, arclen:float, dist:float, resolution:=10) -> PoolVector2Array:
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

static func blast_points_parametric_left(dir:float, w:float, l:float, resolution:=10) -> PoolVector2Array:
  """
  $w := width
  $l := length
  $dir := direction of blast in radians
  $resolution := how many points
  """
  return blast_points_parametric(dir, w, l, resolution, PI, PI*2)

static func blast_points_parametric_right(dir:float, w:float, l:float, resolution:=10) -> PoolVector2Array:
  """
  $w := width
  $l := length
  $dir := direction of blast in radians
  $resolution := how many points
  """
  return blast_points_parametric(dir, w, l, resolution, 0, PI)

static func blast_points_parametric(rot:float, w:float, l:float, resolution:int, start:float, end:float) -> PoolVector2Array:
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
    if pt.round().abs(): # if not (0, 0)
      points.push_back(pt.round())

  return points


class CompareVec:
  # partial implementation of https://github.com/fahall/godot_2d_visibility/blob/master/FOV.gd
  var origin:Vector2
  func _init(_orig:=Vector2()):
    self.origin = _orig

  static func approx_equal_flt(a:float, b:float, eps:=EPS_FLT) -> bool:
    return abs(a-b) <= eps

  static func approx_equal_vec(a:Vector2, b:Vector2, eps:=EPS_FLT) -> bool:
    return approx_equal_flt(a.x, b.x, eps) and approx_equal_flt(a.y, b.y, eps)

  func compare_angle(a:Vector2, b:Vector2) -> bool:
    return is_counter_clockwise(a, b, origin)

  static func is_counter_clockwise(a:Vector2, b:Vector2, origin:Vector2) -> bool:
    if approx_equal_flt(a.x, origin.x) and approx_equal_flt(b.x, origin.x):
      if not a.y < origin.y or not b.y < origin.y:
        return b.y < a.y
      return a.y < b.y
    var oa := a - origin
    var ob := b - origin
    var det = oa.cross(ob)
    if approx_equal_flt(det, 0.0):
      return oa.length_squared() < ob.length_squared()
    return det < 0
