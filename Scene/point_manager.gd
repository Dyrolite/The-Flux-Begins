extends Node

class_name PointManager

var point_mengalahkan_mahasiswa = 0
var point = 0

func pause_saat_kalahkan_mahasiswa():
	point += point_mengalahkan_mahasiswa
	get_tree().paused = true
	await  get_tree().create_timer(1.0).timeout
	get_tree().paused = false
