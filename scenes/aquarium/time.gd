extends Label

func set_time(time):
	text = "Time Remaining: %d" % max(time, 0)
