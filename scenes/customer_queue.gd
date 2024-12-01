extends Node2D

enum State {CustomerWalkingIn, CustomerOrdering, CookingMinigame, CookingResult, CustomerReaction, CustomerWalkingOut}
const CUSTOMER_CENTER_PROGRESS = 1160
const CUSTOMER_END_PROGRESS = 3823
var minigames = [
	preload("res://scenes/rice_game/rice_game.tscn"),
	preload("res://scenes/aquarium/aquarium.tscn"),
	preload("res://scenes/chop/chop.tscn"),
	preload("res://scenes/chopper/board.tscn")
]

var customers: Array[CustomerSprites] = [
	preload("res://custom_resources/devon.tres"),
	preload("res://custom_resources/princess_puddles.tres"),
	preload("res://custom_resources/rahul.tres"),
	preload("res://custom_resources/skelex.tres"),
	preload("res://custom_resources/thief.tres"),
]

const aquarium = preload("res://scenes/aquarium/aquarium.tscn")
const animated_label = preload("res://scenes/animated_label.tscn")
var curr_customer = 0

var game_state: State = State.CustomerWalkingIn
var minigame = null

var day = 0
var curr_minigame = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.minigame_over.connect(minigame_over)
	minigame = $RiceGame
	make_new_customer()

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
	
	$Customer.position = $CustomerPath/Follower.position
	#if $Customer_target_progress == CUSTOMER_CENTER_PROGRESS:


func camera_down():
	var t = create_tween()
	t.tween_property($Camera2D, "position", $CameraCounterPosition.position, 0.5)
	
func camera_up():
	var t = create_tween()
	t.tween_property($Camera2D, "position", $CameraStartingPosition.position, 0.5)

	
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
				customers.shuffle()

			
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
			pass
		State.CustomerReaction:
			progress_game_state()
			pass
		State.CustomerWalkingOut:
			pass
		
		
		
func new_day():
	var l = animated_label.instantiate()
	l.text = "Day %d" % (day+1)
	l.position = %MessagePosition.position
	$Camera2D.add_child(l)
	
func make_new_customer():
	curr_customer += 1
	$Customer.texture = customers[curr_customer].walk
	$Camera2D/OppPortrait.texture = customers[curr_customer].portrait

func make_new_minigame():
	var scene = minigames[curr_minigame]
	var s = scene.instantiate()
	s.set_difficulty(day)
	
	if scene == aquarium:
		s.position = $FullMinigamePosition.position
	else:
		s.position = $SmallMinigamePosition.position
	s.enable_input(false)
	add_child(s)
	minigame = s

func delete_minigame():
	if minigame != null:
		minigame.queue_free()

func minigame_over(score: int):
	if game_state != State.CookingMinigame:
		return
		
	if score == 0:
		$Camera2D/ResultBackground.texture = preload("res://assets/img/red_background.png")
		$Camera2D/ResultText.texture = preload("res://assets/img/failure.png")
	elif score == 1:
		$Camera2D/ResultBackground.texture = preload("res://assets/img/purple_background.png")
		$Camera2D/ResultText.texture = preload("res://assets/img/success.png")
	elif score == 2:
		$Camera2D/ResultBackground.texture = preload("res://assets/img/green_background.png")
		$Camera2D/ResultText.texture = preload("res://assets/img/perfect.png")
	
	$AnimationPlayer.play("AnimateResult")
	progress_game_state()
	
	if score == 0:
		await get_tree().create_timer(4.0).timeout
		
		var loss = load("res://scenes/loss.tscn")
		get_tree().change_scene_to_packed(loss)
	elif day == 2 && curr_minigame == 3:
		await get_tree().create_timer(4.0).timeout
		
		var victory = load("res://scenes/victory.tscn")
		get_tree().change_scene_to_packed(victory)

	
	
