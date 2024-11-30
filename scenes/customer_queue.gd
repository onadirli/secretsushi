extends Node2D

enum State {CustomerWalkingIn, CustomerOrdering, CookingMinigame, CookingResult, CustomerReaction, CustomerWalkingOut}
const CUSTOMER_CENTER_PROGRESS = 1160
const CUSTOMER_END_PROGRESS = 3823

var curr_customer = null

var game_state: State = State.CustomerWalkingIn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curr_customer = $Customer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if game_state == State.CustomerWalkingIn:
		var p = $CustomerPath/Follower.progress
		p = min(CUSTOMER_CENTER_PROGRESS, p + delta * 400)
		$CustomerPath/Follower.progress = p
		if p == CUSTOMER_CENTER_PROGRESS:
			game_state += 1
			camera_down()
			print("go go")

	elif game_state == State.CustomerWalkingOut:
		var p = $CustomerPath/Follower.progress
		p = min(CUSTOMER_END_PROGRESS, p + delta * 400)
	
	curr_customer.position = $CustomerPath/Follower.position
	#if curr_customer_target_progress == CUSTOMER_CENTER_PROGRESS:


func camera_down():
	var t = create_tween()
	t.tween_property($Camera2D, "position", $CameraCounterPosition.position, 0.5)
	
func camera_up():
	var t = create_tween()
	t.tween_property($Camera2D, "position", $CameraStartingPosition.position, 0.5)
