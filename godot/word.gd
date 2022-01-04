extends Node2D



var num_letters : int
var label : Label
var word : String
var polygon : Polygon2D
var collision_shape : CollisionShape2D


func _ready():
	label = get_node("Label")
	polygon = get_node("Polygon2D")
	collision_shape = get_node("CollisionShape2D")


func _my_init(word : String):
	set_word(word)
	_init_polygon()

func set_word(word):
	self.word = word
	label.set_text(word)
	num_letters = word.length()

func _init_polygon():
	var kerning : int = 10
	var height : int = 15
	var A : Vector2 = Vector2(0, 0)
	var B : Vector2 = Vector2(kerning * num_letters, 0)
	var C : Vector2 = Vector2(kerning * num_letters, height)
	var D : Vector2 = Vector2(0, height)
	var corners : PoolVector2Array = PoolVector2Array([A, B, C, D])
	polygon.set_polygon(corners)
	polygon.set_color(Color(1.0, 0.0, 0.0, 1.0))



