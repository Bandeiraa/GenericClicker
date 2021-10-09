extends Control

onready var left_container: Control = get_node("LeftContainer")

func on_vps_timeout() -> void:
	Globals.total_vaccine_amount += Globals.vaccines_per_second
	left_container.update_cv_label()
