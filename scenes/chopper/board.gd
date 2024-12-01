extends Node2D

const GAME_FAIL = 0
const GAME_OK = 1
const GAME_PERFECT = 2

var difficulty = 1;
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_difficulty(difficulty):
	difficulty = difficulty
	$BottomSpawn.set_difficulty(difficulty)

func _on_score_changed(old_score, new_score):
	score = new_score


func _on_game_over(fish_missed):
	if difficulty == 3:
		if fish_missed < 1:
			Signals.minigame_over.emit(GAME_PERFECT)
		elif fish_missed < 2:
			Signals.minigame_over.emit(GAME_OK)
		else:
			Signals.minigame_over.emit(GAME_FAIL)
			
	elif difficulty == 2:
		if fish_missed < 2:
			Signals.minigame_over.emit(GAME_PERFECT)
		elif fish_missed < 4:
			Signals.minigame_over.emit(GAME_OK)
		else:
			Signals.minigame_over.emit(GAME_FAIL)
	
	else:
		if fish_missed < 3:
			Signals.minigame_over.emit(GAME_PERFECT)
		elif fish_missed < 5:
			Signals.minigame_over.emit(GAME_OK)
		else:
			Signals.minigame_over.emit(GAME_FAIL)
