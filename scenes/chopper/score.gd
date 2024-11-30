extends Label

var score = 0

func _on_fish_cut():
	score += 100
	text = "Score: %s" % score
