extends AudioStreamPlayer2D

export(Array, AudioStream) var audio_files1: Array
export(Array, AudioStream) var audio_files2: Array
export(Array, AudioStream) var audio_files3: Array

export var interrupting : bool
export var music : bool
export var sound : bool

var music_slider : HSlider
var sound_slider : HSlider

func _ready():
	randomize()
	music_slider = get_parent().find_node("MusicSlider")
	sound_slider = get_parent().find_node("SoundSlider")
	if(music):
		music_slider.connect("value_changed", self, "_on_music_slider_changed")
	if(sound):
		sound_slider.connect("value_changed", self, "_on_sound_slider_changed")

func play_specific(i) ->void:
	# stop()
	stream = audio_files1[i]
	if(volume_db <= -29.99):
		stop()
		return
	play()

func play_random(par) -> void:
	var audio_files: Array
	
	if(volume_db <= -29.99):
		stop()
		return
	
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

func _on_music_slider_changed(value : float):
	volume_db = value
	if(volume_db <= -29.99):
		stop()
		return

func _on_sound_slider_changed(value : float):
	volume_db = value
	if(volume_db <= -29.99):
		stop()
		return
