extends Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position = get_viewport().get_mouse_position() + Vector2(70,230)
	pass
