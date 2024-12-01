extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.rotation_degrees = randf_range(-10, 10)
	self.frame = randi_range(0, 2)
	fade_out()
	
func fade_out():
	var t = create_tween()
	t.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	t.tween_callback(queue_free)
