extends VideoPlayer

export(Array, VideoStream) var video_files1: Array

var lastplayed = -1

func _ready():
	set_process(true)
	pass 

func play_specific(i) ->void:
	if (lastplayed != i):
		stream = video_files1[i]
		lastplayed = i
	play()

func _process(delta):
	if(!is_playing()):
		play_specific(0)
