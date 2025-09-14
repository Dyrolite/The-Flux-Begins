extends CharacterBody2D

class_name Player

signal player_died

@export var start_position = Node2D
@export var sound_death : AudioStreamPlayer2D

@onready var death_timer: Timer = $deathTimer
@onready var anim = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D

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
	reset_player()

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



# Ganti fungsi die() Anda dengan ini
func die():
	print("Player mati!")
	emit_signal("player_died")
	
	# 1. Hentikan gerakan pemain
	set_physics_process(false)
	
	# 2. Ganti sprite dan putar suara SEKARANG
	anim.hide()
	sprite_2d.show()
	if sound_death:
		sound_death.play()
	
	# 3. MULAI timer 1 detik. Skrip tidak akan berhenti di sini.
	death_timer.start()


# Tambahkan fungsi baru ini di bawah fungsi die()
func reset_player():
	print("Player di-reset.")
	
	# 1. Kembalikan pemain ke posisi awal
	# Pastikan Anda sudah mengisi variabel 'start_position' di Inspector
	if start_position:
		global_position = start_position.global_position
	
	# 2. Kembalikan sprite ke animasi normal
	anim.show()
	sprite_2d.hide()
	#get_tree().call_group("mahasiswa", "reset")
	# 3. Aktifkan kembali gerakan pemain
	set_physics_process(true)


func _on_death_timer_timeout() -> void:
	reset_player()
