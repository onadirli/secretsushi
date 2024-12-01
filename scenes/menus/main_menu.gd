extends Control

@onready var imgs = [
	preload("res://assets/img/intro/catman_begins.png"),
	preload("res://assets/img/intro/cat_glass_discovery.png"),
	preload("res://assets/img/intro/catman_begins.png"),
]
@onready var customer_queue = preload("res://scenes/customer_queue.tscn") as PackedScene

var timer: Timer
var img_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%PlayButton.pressed.connect(_play_pressed)
	%QuitButton.pressed.connect(_quit_pressed)

func _cycle_images():
	img_count += 1
	
	if img_count >= 3:
		_load_game()
		return
	
	var texture = StyleBoxTexture.new()
	var img = imgs[img_count]
	texture.texture =  imgs[img_count]
	$PanelContainer.remove_theme_stylebox_override("panel")
	$PanelContainer.add_theme_stylebox_override("panel", texture)
	

func _play_pressed() -> void:
	# Make menu invisible
	%Menu.visible = false
	
	timer = Timer.new()
	timer.wait_time = 5.0
	timer.timeout.connect(_cycle_images)
	
	add_child(timer)
	
	timer.start()
	
	var texture = StyleBoxTexture.new()
	texture.texture =  imgs[img_count]
	
	# Set image to panel container
	$PanelContainer.add_theme_stylebox_override("panel", texture)
	
	# Show each image for 5 seconds
	
func _load_game():
	get_tree().change_scene_to_packed(customer_queue)
	
func _quit_pressed() -> void:
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
