extends Control

@onready var main_game = preload("res://scenes/game.tscn") as PackedScene
@onready var aquarium = preload("res://scenes/aquarium/aquarium.tscn") as PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%PlayButton.pressed.connect(_play_pressed)
	%QuitButton.pressed.connect(_quit_pressed)



func _play_pressed() -> void:
	get_tree().change_scene_to_packed(aquarium)
	
func _quit_pressed() -> void:
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
