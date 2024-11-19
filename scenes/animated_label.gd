extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	self.rotation_degrees = randf_range(-10, 10)
	$AnimationPlayer.play('pop')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func move_up():
	var t = create_tween()
	t.tween_property(self, "position", position + Vector2.UP * 100, 1)
