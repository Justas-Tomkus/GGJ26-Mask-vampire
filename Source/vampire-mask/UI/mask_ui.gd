class_name MaskUI
extends Button

@export var data_map :Dictionary[DataTypes.MaskTypes, Dictionary]
var mask_d

func _ready() -> void:
	connect("pressed", on_clicked)

func setup(mask_type) -> void:
	if mask_type == DataTypes.MaskTypes.Undefined:
		push_error("trying to add mask type for undefiend type")
		return
	if not data_map.has(mask_type):
		push_error("Trying to add mask UI, but missing mask data")
		return
	var mask_data = data_map[mask_type]
	mask_d = mask_data
	icon = mask_data["image"]
	Hub.interaction_area_deactivate.emit(DataTypes.InterTypes.AddMask, mask_type)
	
func on_clicked() -> void:
	if mask_d == null:
		push_error("no data to click on mask")
		return
	Hub.mask_equip.emit(mask_d)
