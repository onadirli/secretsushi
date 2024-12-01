extends Node2D

const GAME_FAIL = 0
const GAME_OK = 1
const GAME_PERFECT = 2

const blood_splatter_scene = preload("res://scenes/chop/bloodsplatter.tscn")
const animated_label_scene = preload("res://scenes/animated_label.tscn")

var are_controls_enabled = true

var misses: int = 0
var hits: int = 0

var max_misses: int = 5
var min_score_okay = 15
var min_score_perfect = 20

var score: int = 0

@onready var knife: Area2D = get_node('Knife')
@onready var fish: Sprite2D = get_node('Fish')

@onready var paw: Node2D = get_node('Paw')
@onready var paw_initial_position = paw.position


func _input(event):
	if not are_controls_enabled:
		return
		
	if event is InputEventKey:
		if event.pressed and event.is_action('chop'):
			_handle_chop()

func _handle_chop():
	enable_input(false)
	
	# Chop!
	knife.chop()
	
	# Create tween
	var t = create_tween()
	t.tween_property(paw, 'position', knife.position, 0.3)
	t.tween_callback(_add_blood)
	t.tween_property(paw, 'position', paw_initial_position, 0.3)
	t.tween_callback(enable_input)
	
	$ChopSound.play()

func _ready():
	var tries_remaining = max_misses - misses
	$TriesLabel.text = 'Tries: %s' % tries_remaining

func set_difficulty(difficulty: int = 2):
	if difficulty < 1 or difficulty > 3:
		print('Invalid difficulty setting')
		difficulty = 2
	
	knife.speed = difficulty
	max_misses -= difficulty
	
func _add_blood():
	var blood_splatter = blood_splatter_scene.instantiate()
	blood_splatter.position = fish.get_transform().inverse() * knife.position
	
	fish.add_child(blood_splatter)
	
func enable_input(is_enabled: bool = true):
	knife.toggle_controls(is_enabled)

func _on_score_changed(old_score, new_score):
	score = new_score
	$ScoreLabel.text = str(score)


func _on_show_action_label(text):
	var action_label = animated_label_scene.instantiate()
	action_label.text = text
	action_label.position = $ActionMarker.position
	
	add_child(action_label)

func _on_finish():
	enable_input(false)
	
	if score > min_score_perfect:
		Signals.minigame_over.emit(GAME_PERFECT)
	elif score > min_score_okay:
		Signals.minigame_over.emit(GAME_OK)
	else:
		Signals.minigame_over.emit(GAME_FAIL)

func _on_knife_miss():
	misses += 1
	
	var tries_remaining = max(max_misses - misses, 0)
	$TriesLabel.text = 'Tries: %s' % tries_remaining
	
	if misses >= max_misses:
		_on_finish()


func _on_knife_hit():
	hits += 1
	
	if hits == 5:
		_on_finish()
