extends VideoPlayer

export(Array, VideoStream) var video_files1: Array

var loop : bool = false

func _ready():
	set_process(true)
	pass 

func play_specific(i) ->void:
	stop()
	if(i == 0):
		loop = true
	stream = video_files1[i]
	play()

func _process(delta):
	if(loop):
		if(!is_playing()):
			play_specific(0)
