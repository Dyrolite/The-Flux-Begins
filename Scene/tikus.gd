extends CharacterBody2D

class_name Player

@onready var anim = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shape_1: MeshInstance2D = $shape1
@onready var shape_2: MeshInstance2D = $shape2
@onready var shape_3: MeshInstance2D = $shape3
@onready var shape_4: MeshInstance2D = $shape4

#variabel
var movement_direction = Vector2.ZERO

#ekspor variabel kecepatan
var next_movement_direction = Vector2.ZERO
var shape_query = PhysicsShapeQueryParameters2D.new()

@export var speed:float = 300

var is_moving:bool = false
var dir:String = "none"

#variabel siap
@onready var diretion_pointer = $CollisionShape2D/AnimatedS/prite2D/direction

func _ready():
	pass

func _process(delta):
	pass

func _physics_process(delta):
	get_input()
	
	if movement_direction == Vector2.ZERO:
		movement_direction = next_movement_direction


func get_input():
	
	if Input.is_action_pressed("Left"):
		velocity = Vector2.LEFT * speed
		is_moving = true
		dir = "left"
		move_and_slide()
	elif Input.is_action_pressed("Right"):
		velocity = Vector2.RIGHT * speed
		is_moving = true
		dir = "right"
		move_and_slide()
	elif Input.is_action_pressed("Down"):
		velocity = Vector2.DOWN * speed
		is_moving = true
		dir = "down"
		move_and_slide()
	elif Input.is_action_pressed("Up"):
		velocity = Vector2.UP * speed
		is_moving = true
		dir = "Up"
		move_and_slide()
		
	if is_moving == true:
		if dir == "left":
			anim.play("rat1")
		
		elif dir == "right":
			anim.play("rat1")
		
		elif dir == "down":
			anim.play("rat1")
		
		elif dir == "Up":
			anim.play("rat1")
		
	elif is_moving == false:
		
		if dir == "left":
			anim.play("rat1")
		
		elif dir == "right":
			anim.play("rat1")
			
		elif dir == "down":
			anim.play("rat1")
			
		elif dir == "Up":
			anim.play("rat1")

func show_ko_sprite():
	sprite_2d.show()
	shape_1.show()
	shape_2.show()
	shape_3.show()
	shape_4.show()

func die():
	print("die")
	anim.hide()
	show_ko_sprite()
	set_physics_process(false)
	pass
