extends RigidBody2D


var letter : String
var label : Label
var polygon : Polygon2D
var collision_shape : CollisionShape2D
var correct : bool = false
var particles : CPUParticles2D
var clickable : bool = true

var cannon
var sound_player
var laser_player


signal letter_deleted
signal wrong_letter_pressed
signal correct_letter_pressed


func _ready():
	label = get_node("Polygon2D/Label")
	polygon = get_node("Polygon2D")
	collision_shape = get_node("CollisionShape2D")
	particles = get_node("CPUParticles2D")
	cannon = get_node("../../Cannon")
	sound_player = get_node("../../Sounds")
	laser_player = get_node("../../Laser")
	
	connect("correct_letter_pressed", self, "_on_correct_letter_pressed")
	connect("wrong_letter_pressed", self, "_on_wrong_letter_pressed")
	connect("body_entered", self, "_on_body_entered")

func my_init(letter : String, correct : bool):
	self.letter = letter
	self.correct = correct
	_init_polygon()
	_init_label(letter)
	

func _on_body_entered(body):
	if(body.get_class() == "StaticBody2D"):
		self.queue_free()
		emit_signal("letter_deleted")

func _input_event(viewport, event, shape_idx):
	if(clickable):
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				print("pressed: ", letter)
				if(correct):
					emit_signal("correct_letter_pressed")
				else:
					emit_signal("wrong_letter_pressed")

func _init_label(letter : String):
	label.set_text(letter)

func _on_wrong_letter_pressed():
	print("pressed wrong letter!")
	var tween : Tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(get_node("Polygon2D"), "scale", Vector2(1, 1), Vector2(0.001, 0.001), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

	sound_player.play_specific(1)
	laser_player.play_specific(0)
	clickable = false


func _on_correct_letter_pressed():
	print("pressed correct letter!")
	particles.emitting = 1
	var tween : Tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(get_node("Polygon2D"), "scale", Vector2(1, 1), Vector2(0.001, 0.001), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	sound_player.play_specific(0)
	laser_player.play_specific(0)
	clickable = false




func _init_polygon():
	var width : int = 50
	var height : int = 50
	var offset : int = -20
	var A : Vector2 = Vector2(offset, offset)
	var B : Vector2 = Vector2(width, offset)
	var C : Vector2 = Vector2(width, height)
	var D : Vector2 = Vector2(offset, height)
	var corners : PoolVector2Array = PoolVector2Array([A, B, C, D])
	polygon.set_polygon(corners)
	# polygon.set_color(Color(0.2, 0.2, 0.17, 1.0))
	# polygon.set_texture_offset(Vector2(15, 15))
	_init_collisionShape(corners)

func _init_collisionShape(corners : PoolVector2Array):
	var shape : ConvexPolygonShape2D = ConvexPolygonShape2D.new()
	shape.set_points(corners)
	collision_shape.shape = shape
	self.linear_velocity.y = randi() % 50 + 50

