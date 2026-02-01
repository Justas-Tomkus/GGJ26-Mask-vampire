class_name InteractionTarget
extends Node2D

@export var itype : DataTypes.InterTypes
@export var mask_type : DataTypes.MaskTypes
@export var enter_in : bool
@export var hide_on_enter : NodePath

var hide_node : Node2D = null

func _ready() -> void:
	if not hide_on_enter.is_empty():
		hide_node = get_node(hide_on_enter)

func doit() -> void:
	print("got interaction call on ", self)
	if itype == DataTypes.InterTypes.AddMask:
		Hub.mask_pickup.emit(mask_type)
	elif itype == DataTypes.InterTypes.OpenDoor:
		Hub.enter_request.emit(self.global_position)
		if hide_node != null:
			hide_node.visible = !enter_in
	else:
		print("dunno, how to handle itype: ", itype)

func is_it_me(inter_type :DataTypes.InterTypes, mask_type :DataTypes.MaskTypes) -> bool:
	if inter_type == itype and self.mask_type == mask_type:
		return true
	return false
