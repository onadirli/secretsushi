extends Area2D

const animated_label_scene = preload("res://scenes/animated_label.tscn")
const blood_splatter_scene = preload("res://scenes/bloodsplatter.tscn")

var dx: Vector2 = Vector2.RIGHT
var speed: int = 2;

var zoneStack: Array[Area2D] = []

var score = 0

var are_controls_enabled = true

@onready var right_marker: Marker2D = get_parent().get_node('RightMarker')
@onready var left_marker: Marker2D = get_parent().get_node('LeftMarker')

@onready var action_marker: Marker2D = get_parent().get_node('ActionMarker')
@onready var fish: Sprite2D = get_parent().get_node('Fish')

@onready var paw: Node2D = get_parent().get_node('Paw')
@onready var paw_initial_position = paw.position



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if not are_controls_enabled:
		return
		
	if event is InputEventKey:
		if event.pressed and event.is_action('chop'):
			_toggle_controls(false)
			_on_chop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not are_controls_enabled:
		return
		
	position = position + dx * speed
	
	var is_beyond_right_marker = position >= right_marker.position
	var is_beyond_left_marker = position <= left_marker.position
	
	var should_change_dir = is_beyond_right_marker or is_beyond_left_marker
	
	if should_change_dir:
		dx = -dx
		
func _on_chop():
	var size = zoneStack.size()
	
	var isNormalChop = size == 1
	var isPerfectChop = size == 2
	
	# Figure out perfect chop or okay chop or bad chop
	var label_text = 'This will not do'
	if isPerfectChop:
		label_text = 'Perfect!'
		score += 5
		zoneStack[1].get_parent().queue_free()
		
	elif isNormalChop:
		label_text = 'Not bad'
		score += 1
		zoneStack[0].get_parent().queue_free()

	# Display action label	
	var action_label = animated_label_scene.instantiate()
	action_label.text = label_text
	action_label.position = action_marker.position
	
	get_parent().add_child(action_label)
	
	# Update score
	var score_label = get_parent().get_node('ScoreLabel')
	score_label.text = str(score)
	
	# Create tween
	var t = create_tween()
	t.tween_property(paw, 'position', position, 0.3)
	t.tween_callback(_add_blood)
	t.tween_property(paw, 'position', paw_initial_position, 0.3)
	t.tween_callback(_toggle_controls)
	

func _toggle_controls(enabled: bool = true):
	are_controls_enabled = enabled

func _add_blood():
	var blood_splatter = blood_splatter_scene.instantiate()
	blood_splatter.global_position = global_position
	
	fish.add_child(blood_splatter)
	

func _on_area_entered(area):
	zoneStack.push_back(area)


func _on_area_exited(area):
	zoneStack.pop_back()
