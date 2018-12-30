extends SceneTree

const Blast = preload("./blast.gd")

var cone = null

func _init():
  var b_or = Vector2()
  var b_dr = Vector2(0, -1.0)
  var b_ds = 10.0
  var b_ar = 60.0
  print(current_scene)
  cone = Blast.BlastCone.new(b_or, b_dr, b_ds, b_ar)
  current_scene = Blast.new()
  current_scene.add_child(cone)

  for p in cone.cone_path:
    print(p, rad2deg(p.angle()))


func _input(ev):
  if ev is InputEventMouseButton:
    if ev.pressed:
      _move_to_mouse()

func _move_to_mouse():
  var pos = get_global_mouse_position()
  cone.origin = pos
