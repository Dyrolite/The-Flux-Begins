extends Node

var total_pellets_count
var pellets_eaten = 0

@onready var ui: CanvasLayer = $"../UI" as UI
# Gunakan tipe data 'Mahasiswa' yang spesifik
@export var mahasiswa_array : Array[Mahasiswa]

func _ready():
	var pellets = self.get_children() as Array[Coin]
	print("Jumlah koin yang ditemukan oleh manager: ", pellets.size())
	total_pellets_count = pellets.size()
	
	for pellet in pellets:
		pellet.koin_diambil.connect(on_pellet_eaten)

func on_pellet_eaten(bisa_kalahkan_mahasiswa: bool):
	pellets_eaten += 1
	if bisa_kalahkan_mahasiswa:
		for mahasiswa in mahasiswa_array:
			# Sekarang Godot tahu bahwa 'mahasiswa' memiliki fungsi lari_dari_tikus()
			mahasiswa.lari_dari_tikus()
	print("Koin dimakan: ", pellets_eaten, " / ", total_pellets_count)
	if pellets_eaten == total_pellets_count:
		ui.game_won()
