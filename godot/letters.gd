extends Node2D


var letter_scene = preload("letter.tscn")
var num_letters : int = 5
var letters : Array = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", 
"L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
var letters_copy = letters.duplicate(true)
var points : int = 0

var audio_speech : AudioStreamPlayer2D 
var points_label : Label

signal no_letters
signal correct
signal wrong

func _ready():
	audio_speech = get_node("../Speech")
	points_label = get_node("../SpritePoints/Label")


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

func _on_wrong_letter():
	emit_signal("wrong")

func _on_correct_letter():
	emit_signal("correct")
	points += 10
	points_label.text = str(points)

func _on_letter_deleted():
	print("Letter deleted from letters")
	if(self.get_children().size() <= 1):
		print("all letters gone")
		emit_signal("no_letters")
