extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.frame = randi_range(0, 4)
	self.rotation = randf_range(0, 2 * PI)

func highlight(state: bool):
	if state == true:
		self.modulate = Color.WHITE
	else:
		self.modulate = Color.DARK_GRAY
