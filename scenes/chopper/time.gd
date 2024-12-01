extends Label

func set_time(time):
	print(time)
	time = max(time, 0)
	print(time)
	text = "Time Remaining: %d" % time
