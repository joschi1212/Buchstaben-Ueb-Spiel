extends AudioStreamPlayer2D

export(Array, AudioStream) var audio_files1: Array
export(Array, AudioStream) var audio_files2: Array
export(Array, AudioStream) var audio_files3: Array

export var interrupting: bool


func _ready():
	randomize()
	pass

func play_specific(i) ->void:
	# stop()
	stream = audio_files1[i]
	play()

func play_random(par) -> void:
	var audio_files: Array
	if(par > 1000):
		audio_files = audio_files2
	else:
		audio_files = audio_files1
	if(audio_files2.size() == 0):
		audio_files = audio_files1
	if(interrupting):
		var random_index: = randi() % audio_files.size()
		stop()
		stream = audio_files[random_index]
		play()
	else:
		if(is_playing()):
			return
		else:
			var random_index: = randi() % audio_files.size()
			stop()
			stream = audio_files[random_index]
			play()
		
		
		

