extends CharacterBody2D

class_name Player

@export var speed = 300

var movement_direction = Vector2.ZERO

func _physics_process(delta):
	get_input()
	velocity = movement_direction * speed
	move_and_slide()

func get_input():
	if Input.is_action_pressed("Right"):
		movement_direction = Vector2.RIGHT
		scale.x = 1 
		
	elif Input.is_action_pressed("Left"):
		movement_direction = Vector2.LEFT
		scale.x = -1 
		
	elif Input.is_action_pressed("Down"):
		movement_direction = Vector2.DOWN
		
	elif Input.is_action_pressed("Up"):
		movement_direction = Vector2.UP
