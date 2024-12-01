extends Node2D

enum State {CustomerWalkingIn, CustomerOrdering, CookingMinigame, CookingResult, CustomerReaction, CustomerWalkingOut}
const CUSTOMER_CENTER_PROGRESS = 1160
const CUSTOMER_END_PROGRESS = 3823
var minigames = [
	preload("res://scenes/rice_game/rice_game.tscn"),
	preload("res://scenes/aquarium/aquarium.tscn"),
	preload("res://scenes/aquarium/aquarium.tscn"),
	preload("res://scenes/rice_game/rice_game.tscn"),
]
var curr_customer = null

var game_state: State = State.CustomerWalkingIn
var minigame = null

var day = 0
var curr_minigame = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curr_customer = $Customer
	Signals.minigame_over.connect(minigame_over)
	minigame = $RiceGame

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if game_state == State.CustomerWalkingIn:
		var p = $CustomerPath/Follower.progress
		p = min(CUSTOMER_CENTER_PROGRESS, p + delta * 400)
		$CustomerPath/Follower.progress = p
		if p == CUSTOMER_CENTER_PROGRESS:
			progress_game_state()

	elif game_state == State.CustomerWalkingOut:
		var p = $CustomerPath/Follower.progress
		p = min(CUSTOMER_END_PROGRESS, p + delta * 400)
		$CustomerPath/Follower.progress = p
		if p == CUSTOMER_END_PROGRESS:
			progress_game_state()
	
	curr_customer.position = $CustomerPath/Follower.position
	#if curr_customer_target_progress == CUSTOMER_CENTER_PROGRESS:


func camera_down():
	var t = create_tween()
	t.tween_property($Camera2D, "position", $CameraCounterPosition.position, 0.5)
	
func camera_up():
	var t = create_tween()
	t.tween_property($Camera2D, "position", $CameraStartingPosition.position, 0.5)
	t.tween_callback(progress_game_state)

	
func progress_game_state():
	if game_state == State.CustomerWalkingOut:
		game_state = State.CustomerWalkingIn
	else:
		game_state += 1
		
	match game_state:
		State.CustomerWalkingIn:
			curr_minigame += 1
			if curr_minigame + 1 > minigames.size():
				day += 1
				curr_minigame = 0
				new_day()
				minigames.shuffle()

			
			$CustomerPath/Follower.progress = 0
			make_new_customer()
			pass
		State.CustomerOrdering:
			$AnimationPlayer.play("AnimateVS")
			pass
		State.CookingMinigame:
			minigame.enable_input(true)
		State.CookingResult:
			minigame.enable_input(false)
			progress_game_state()
			pass
		State.CustomerReaction:
			progress_game_state()
			pass
		State.CustomerWalkingOut:
			pass
		
		
		
func new_day():
	#TODO
	pass
	
func make_new_customer():
	#TODO
	pass

func make_new_minigame():
	if minigame != null:
		minigame.queue_free()
	var s = minigames[curr_minigame].instantiate()
	s.set_difficulty(day)
	s.position = $SmallMinigamePosition.position
	s.enable_input(false)
	add_child(s)
	minigame = s
	

func minigame_over(score: int):
	camera_up()
	
