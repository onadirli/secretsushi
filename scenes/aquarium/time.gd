extends Label

func set_time(time):
	text = "Time Remaining: %s" % str(time).split('.')[0]
