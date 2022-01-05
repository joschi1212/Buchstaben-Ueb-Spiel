extends Sprite



signal spawn_letters

var cannon : Node2D
var laser_player : AudioStreamPlayer2D
var music_player : AudioStreamPlayer2D

func _ready():
	randomize()
	cannon = get_node("Cannon")
	laser_player = get_node("Laser")
	music_player = get_node("Music")
	music_player.play_specific(0)
	connect("spawn_letters", get_node("letters"), "_spawn_letters")
	get_node("Button").connect("button_up", self, "_button_pressed")
	get_node("letters").connect("no_letters", self, "_on_no_letters")
	emit_signal("spawn_letters")


func _on_no_letters():
	print("no letters")
	emit_signal("spawn_letters")

func _input(event):
	if event is InputEventMouseButton:
		if(event.pressed):
			cannon.shoot(get_global_mouse_position())
			laser_player.play_specific(0)
			print(get_global_mouse_position())




