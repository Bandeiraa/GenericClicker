extends Control

onready var tween: Tween = get_node("Tween")

onready var v_container: VBoxContainer = get_node("VContainer")
onready var current_v: Label = v_container.get_node("TFContainer/VaccineFarm")
onready var coin_bg: TextureRect = v_container.get_node("CoinBackground")
onready var vps_label: Label = v_container.get_node("FPSContainer/VaccineFarm")

export(Vector2) var travel = Vector2(0, -80)
export(float) var spread = PI/2
export(float) var duration = 2.0

func _ready() -> void:
	connect_signals()
	
	
func connect_signals() -> void:
	var _entered = coin_bg.connect("mouse_entered", self, "on_mouse_entered")
	var _exited = coin_bg.connect("mouse_exited", self, "on_mouse_exited")
	
	
func on_mouse_entered() -> void:
	coin_bg.modulate = Color(1.0, 1.0, 1.0, 0.5)
	
	
func on_mouse_exited() -> void:
	coin_bg.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	
func on_button_pressed() -> void:
	Globals.total_vaccine_amount += Globals.click_value
	value_popup()
	update_cv_label()
	
	
func value_popup() -> void:
	font_configuration()
	
	
func font_configuration() -> void:
	var dynamic_font: DynamicFont = DynamicFont.new()
	dynamic_font.font_data = load("res://assets/fonts/Kenney Future.ttf")
	dynamic_font.size = 16
	var label: Label = Label.new()
	label.add_font_override("font", dynamic_font)
	instance_label(label)
	
	
func instance_label(label: Label) -> void:
	label.text = verify_amount(Globals.click_value)
	label.rect_position = get_global_mouse_position()
	get_tree().root.call_deferred("add_child", label)
	var movement: Vector2 = travel.rotated(rand_range(-spread/2, spread/2))
	var _interpolate_to: bool = tween.interpolate_property(label, "rect_position", label.rect_position, label.rect_position + movement, duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	var _interpolate_from: bool = tween.interpolate_property(label, "modulate:a", 1.0, 0.0, duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	var _start_tween: bool = tween.start()
	
	
func update_cv_label() -> void:
	current_v.text = verify_amount(Globals.total_vaccine_amount)
	
	
func update_vps_label() -> void:
	vps_label.text = verify_amount(Globals.vaccines_per_second)
	
	
func verify_amount(target: float) -> String:
	if target >= 0 and target < 1000: 
		return str(stepify(target, 0.1)) + " G"
	elif target >= 1000 and target < 1000000:
		return str(stepify(target/1000, 0.1)) + " K"
	elif target >= 1000000 and target < 1000000000:
		return str(stepify(target/1000000, 0.1)) + " MK"
	else:
		return str(stepify(target/1000000000, 0.1)) + " BK"
		
		
func on_tween_completed(object, _key) -> void:
	object.queue_free()
