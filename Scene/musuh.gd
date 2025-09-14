extends Node

@onready var player: Player = $"../Player" as Player

func _ready() -> void:
	player.player_died.connect(reset_mahasiswa)

func reset_mahasiswa():
	var all_mahasiswa = get_children() as Array[Mahasiswa]
	for mhs in all_mahasiswa:
		# Panggil fungsi reset() yang sudah Anda buat di mahasiswa.gd
		mhs.reset()
