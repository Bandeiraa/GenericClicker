extends Control

onready var background_texture: TextureRect = get_node("BGTexture")
onready var item_button: TextureButton = get_node("ItemButton")

onready var item_icon: TextureRect = get_node("HContainer/ItemIcon")
onready var item_name_label: Label = get_node("HContainer/VBox/ItemName")
onready var item_price: Label = get_node("HContainer/VBox/ItemPrice")

var amount: int = 0
var current_buff_stack: float
var current_cost_stack: float

export(int) var item_value
export(float) var vaccine_buff
export(float) var multiplier_cost_factor
export(float) var multiplier_buff_factor
export(String) var item_name
export(String) var item_image_path 

func _ready() -> void:
	current_cost_stack = item_value
	initial_configuration()
	connect_signals()
	
	
func initial_configuration() -> void:
	item_icon.texture = load(item_image_path) #Textura do Item
	item_name_label.text = item_name #Nome do Item
	item_price.text = str(item_value) + " G" #Preço Inicial
	
	
func connect_signals() -> void:
	var _pressed = item_button.connect("pressed", self, "on_button_pressed")
	var _mouse_entered = connect("mouse_entered", self, "on_mouse_entered")
	var _mouse_exited = connect("mouse_exited", self, "on_mouse_exited")
	
	
func _process(_delta: float) -> void:
	if item_value >= Globals.total_vaccine_amount:
		item_price.modulate = Color(1.0, 0.0, 0.0, 1.0)
	else:
		item_price.modulate = Color(0.0, 1.0, 0.0, 1.0)
		
		
func on_button_pressed() -> void:
	if item_value <= Globals.total_vaccine_amount:
		change_amount()
		modify_item_value()
		modify_vaccine_production()
		
		
func change_amount() -> void:
	amount += 1
	get_tree().call_group(name, "update_amount", amount, multiplier_buff_factor)
	get_tree().call_group("Left_Container", "update_cv_label")
	Globals.total_vaccine_amount -= item_value
	
	
func modify_item_value() -> void:
	current_cost_stack += (item_value * multiplier_cost_factor)
	item_value = current_cost_stack
	if item_value >= 1 and item_value < 1000: 
		item_price.text = str(stepify(item_value, 0.1)) + " G"
	elif item_value >= 1000 and item_value < 1000000:
		item_price.text = str(stepify(item_value/1000, 0.1)) + " K"
	elif item_value >= 1000000 and item_value < 1000000000:
		item_price.text = str(stepify(item_value/1000000, 0.1)) + " MK"
	elif item_value >= 1000000000 and item_value < 1000000000000:
		item_price.text = str(stepify(item_value/1000000000, 0.1)) + " BK"
		
		
func modify_vaccine_production() -> void:
	current_buff_stack += vaccine_buff * (1 + multiplier_buff_factor)
	Globals.vaccines_per_second += current_buff_stack
	get_tree().call_group("Left_Container", "update_vps_label")
	
	
func on_mouse_entered() -> void:
	background_texture.modulate = Color(1.0, 1.0, 1.0, 0.3)
	
	
func on_mouse_exited() -> void:
	background_texture.modulate = Color(1.0, 1.0, 1.0, 1.0)
