"""
filename: blast.gd
"""

"""
DOC DUMP

What I want to do:
  when a player fires a blast, the blast size is variable (longer charge=bigger blast)
  that means that a blast cone/area needs to be created dynamically
  ADDITONALLY
  a blast can be blocked by, say, a floor
  in this case, the blast cone needs to extend only until the floor
  excess area is dispersed to the sides as blowback
    these are also particles, and push physics bodies back
  this is (relatively) straight-forward, and possible solutions include some combinations of:
    RayCast2D
    Area2D
    Light2D/LightOccluder2D
      This technically has the most built-in high-level functionality that we need, but feels like a hack of its intention.
      It _is_ documented to be used as a clipping mask, however our use case is ever slightly more difficult -- especially because we want to extract the resulting shape of the light and execute logic (deal damage, determine max-real size for blowback proportion, etc.)
    Shape.collide_and_get_contacts()
      I think this is our best bet, but I need to investigate how Shapes interact with Area, Polygon, and Collision objects
      That is to say, how do we get, subtract, apply, and generally use Shape objects
  COMPLICATIONS
  what happens if a blocker is not flat?
  what happens if there are two blockers with a gap in between? eg:
    x is blast source, f is floor, / and \ are blast outline, space is gap between floors
      xx
      /\
     //\\
    ff  ff

What I think should work:
  Use Light2D to create a shape for the blast
  Subtract that shape from the maximum possible shape to determine difference (BlastDiff)
  Create an Area2D using the light shape to represent the damage zone
  Combo of shaders/textures/Light2D to represent the blast sprite
  Convert the size of BlastDiff to use as a magnitude for blowback Area2D and particles

  this process assumes a lot of things about how Shapes and Light2D works. Investigate!

DUMB IDEA AHEAD:
  Put a Light2D in the center of a 3-sided box. This is our blast source. It has a circular texture
  When firing, turn on the light, which has a texture. Adjust the H/W of the box to adjust the arc

  THIS ONLY SOLVES THE VISUAL ELEMENT. HOW DO WE KNOW WHAT IS COVERED BY THE LIGHT?
"""

""" NAIVE, HALF-BAKED INITIAL IMPLEMENTATION BELOW SAVED FOR POSTERITY
class BlastCone
  extends Area2D

  var origin = Vector2()
  var dir = 0.0
  var dist = 0.0
  var arc = 0.0

  var area = null
  var rays = []

  func _init(_orig, _dir, _dist, _arc, _resolution=10):
    self.origin = _orig
    self.dir = _dir
    self.dist = _dist
    self.arc = _arc

    self.rays = _build_rays(_resolution)

  func _build_rays(resolution):
    rays.clear()

    var start_ang = rad2deg(dir.angle()) + arc / 2.0

    for r in range(resolution + 1):
      var angle = deg2rad(start_ang + r * arc / resolution - arc)
      var ray_dest = origin + dist * Vector2(cos(angle), sin(angle))

      var ray = RayCast2D.new()
      ray.set_position(origin)
      ray.set_cast_to(ray_dest)
      rays.push_back(ray)
"""
