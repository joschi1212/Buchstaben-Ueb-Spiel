extends Node2D


var letter_scene = preload("letter.tscn")
var num_letters : int = 5
var letters : Array = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", 
"L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
var letters_copy = letters.duplicate(true)
var points : int = 0
var lifes : int = 5

var audio_speech : AudioStreamPlayer2D 
var video_player : VideoPlayer
var points_label : Label
var stars : Node2D
var button : Button
var sprite_points : Sprite

signal no_letters
signal correct
signal wrong

func _ready():
	audio_speech = get_node("../Speech")
	video_player = get_node("../UfoVideoPlayer")
	points_label = get_node("../SpritePoints/Label")
	sprite_points = get_node("../SpritePoints")
	video_player.play_specific(0)
	stars = get_node("../Stars")
	button = get_node("../Button")
	button.connect("button_up", self, "_button_pressed")
	


func _spawn_letters():
	var correct_letter_index : int = randi() % letters.size()
	for n in range(num_letters):
		var letter_index : int = randi() % letters.size()
		var correct : bool = false
		
		if(n == 0):
			letter_index = correct_letter_index
			correct = true
		
		var letter : RigidBody2D = letter_scene.instance()
		letter.add_to_group("letters")
		add_child(letter)
		letter.connect("letter_deleted", self, "_on_letter_deleted")
		letter.connect("wrong_letter_pressed", self, "_on_wrong_letter")
		letter.connect("correct_letter_pressed", self, "_on_correct_letter")
		var letter_string : String = letters.pop_at(letter_index)
		letter.my_init(letter_string, correct)
		var offset_x : int = randi() % 400 + 300
		var offset_y : int = randi() % 300 - 330
		letter.global_position = Vector2(offset_x, offset_y)
	letters = letters_copy.duplicate(true)
	audio_speech.play_specific(correct_letter_index)

func _button_pressed():
	if(get_tree().paused):
		get_tree().paused = false
		for star in stars.get_children():
			star.set_visible(true)
		points = 0
		points_label.text = str(points)
		lifes = 5
	_spawn_letters()
	var tween : Tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(sprite_points, "scale", null, Vector2(0.5, 0.5), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(sprite_points, "position", null, Vector2(420, -250), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _on_wrong_letter():
	emit_signal("wrong")
	video_player.play_specific(2)
	# delete star
	if(lifes > 0):
		var star : Sprite = stars.get_children()[lifes-1]
		lifes = lifes - 1
		star.set_visible(false)
	if(lifes == 0):
		print("Lost!")
		var tween : Tween = Tween.new()
		add_child(tween)
		tween.interpolate_property(sprite_points, "scale", Vector2(0.5, 0.5), Vector2(1,1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.interpolate_property(sprite_points, "position", null, Vector2(0, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
		for letter in get_tree().get_nodes_in_group("letters"):
			letter.queue_free()
		yield(get_tree().create_timer(1, false), "timeout")
		get_tree().paused = true

func _on_correct_letter():
	emit_signal("correct")
	points += 10
	points_label.text = str(points)
	video_player.play_specific(1)

func _on_letter_deleted():
	print("Letter deleted from letters")
	if(get_tree().get_nodes_in_group("letters").size() <= 1):
		print("all letters gone")
		emit_signal("no_letters")
