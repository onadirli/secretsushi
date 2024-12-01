extends Label

signal score_changed(old_score: int, new_score: int)

var score = 0

func _on_fish_cut():
	var old_score = score
	score += 100
	
	score_changed.emit(old_score, score)
	text = "Score: %s" % score
