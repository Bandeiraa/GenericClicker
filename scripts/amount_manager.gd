extends TextureRect

onready var amount_label: Label = get_node("HContainer/VContainer/ItemAmount")

func update_amount(value: int, multiplier_factor: float) -> void:
	if value % 10 == 0:
		Globals.click_value += (Globals.vaccines_per_second * multiplier_factor)
		
	amount_label.text = str(value)
