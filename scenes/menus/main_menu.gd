extends Control

@onready var customer_queue = preload("res://scenes/customer_queue.tscn") as PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%PlayButton.pressed.connect(_play_pressed)
	%QuitButton.pressed.connect(_quit_pressed)


func _play_pressed() -> void:
	get_tree().change_scene_to_packed(customer_queue)
	
func _quit_pressed() -> void:
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
