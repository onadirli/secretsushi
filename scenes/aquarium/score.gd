extends Label

var score = 0

func _on_fish_consumed():
	score += 100
	text = "Score: %s" % score
	
func _on_lobster_touched():
	score -= 20
	text = "Score: %s" % score
