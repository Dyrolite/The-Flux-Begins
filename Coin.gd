extends Area2D


@onready var anim_player = $AnimationSprite2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var anim = $AnimatedSprite2D
@onready var sound_pickup = $AudioStreamPlayer2D
@onready var audio_player = $AudioStreamPlayer2D
@onready var collision_shape = $CollisionShape2D


func _ready():
	if animated_sprite_2d:
		anim.play("putar")
func _on_Coin_body_entered(body):
	# Cek apakah body yang masuk adalah pemain (player)
	# Ini bisa disesuaikan, misalnya dengan mengecek nama node
	# atau grup node. Contoh ini mengasumsikan pemain diberi nama "Player"
		if body.is_in_group("Player"):
			$AnimatedSprite2D.visible = false
			$CollisionShape2D.disabled = true
			emit_signal("koin_diambil")
		get_tree().create_timer(sound_pickup.get_stream().get_length()).timeout.connect(queue_free)
		hide()
		collision_shape.disabled = true
		collision_shape.visible = false
		
		sound_pickup.play()
		
		
		
