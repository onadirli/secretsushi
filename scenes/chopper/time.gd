extends Label

func set_time(time):
	text = "Time Remaining: %s" % str(max(time, 0)).split('.')[0]
