extends Node2D


var letters : Node2D
var line : Line2D

func _ready():
	letters = get_node("../letters")
	line = get_node("Line2D")
	pass 


func shoot(end : Vector2):
	line.set_point_position(0, Vector2(792, 422))
	line.set_point_position(1, end)
	var tween : Tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(line, "default_color", Color(0.55, 0.01, 0.01, 1), Color(0.55, 0.01, 0.01, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(get_tree().create_timer(2, false), "timeout")
	print("bam")

