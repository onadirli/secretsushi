extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.pressed.connect(back_to_menu)


func back_to_menu():
	var menu = load("res://scenes/menus/main_menu.tscn") as PackedScene
	get_tree().change_scene_to_packed(menu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
