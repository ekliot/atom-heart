"""
filename: heart_container.gd
"""

extends TextureRect

var heart = null

func connect_to_heart(_heart):
  self.heart = _heart
  set_health(heart.current)
  self.heart.connect('health_updated', self, 'set_health')
  self.heart.connect('popped', self, '_on_pop')

func _on_pop():
  # TODO animate?
  self.queue_free()

func set_health(hp):
  if not _valid_hp(hp):
    LOGGER.warn(self, "cannot set heart hp to %d" % hp)
    return

  update_sprite()

func update_sprite():
  # TODO animate?
  for c in get_children():
    c.visible = int(c.name) <= self.heart.current

func _valid_hp(hp):
  if not self.heart:
    return false
  return hp <= self.heart.MAX_VAL or hp >= self.heart.MIN_VAL
