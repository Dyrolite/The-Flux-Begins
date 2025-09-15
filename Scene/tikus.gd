extends CharacterBody2D

class_name Player

signal player_died(life: int)

@export var start_position = Node2D
@export var sound_death : AudioStreamPlayer2D
@export var life: int = 3
@export var ui: UI

@onready var anim = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D

#variabel
var movement_direction = Vector2.ZERO

#ekspor variabel kecepatan
var next_movement_direction = Vector2.ZERO
var shape_query = PhysicsShapeQueryParameters2D.new()

@export var speed:float = 300

var game_is_won:bool = false
var is_moving:bool = false
var dir:String = "none"
var is_dead:bool = false
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

func win():
	print("Player Telah Menang!")
	game_is_won = true
	# Hentikan gerakan player agar tidak bisa jalan-jalan setelah menang
	set_physics_process(false)

# Ganti fungsi die() Anda yang lama dengan ini
func die():
	if is_dead or game_is_won:
		return
	is_dead = true # Aktifkan penjaga
	# Kurangi nyawa
	life -= 1
	ui.set_lifes(life)
	print("Nyawa tersisa: ", life)
	sound_death.play()
	print("Player mati!")
	emit_signal("player_died") 
	# 1. Hentikan gerakan pemain
	set_physics_process(false)
	# 2. Ganti sprite normal dengan sprite mati
	anim.hide()
	sprite_2d.show() # Tampilkan gambar mati
	# 3. Tunggu selama 2 detik
	if life <= 0:
		game_over()
	else:
		# Jika masih punya nyawa, tunggu 1 detik lalu reset
		await get_tree().create_timer(1.0).timeout
		reset_player()

func game_over():
	set_collision_layer_value(4, true)

# Tambahkan fungsi baru ini di bawah fungsi die()
func reset_player():
	print("Player di-reset.")
	game_is_won = false
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
	is_dead = false
