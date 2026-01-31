class_name InteractionTarget
extends Node

@export var itype : DataTypes.InterTypes
@export var mask_type : DataTypes.MaskTypes



func doit() -> void:
	print("got interaction call on ", self)
	if itype == DataTypes.InterTypes.AddMask:
		Hub.mask_pickup.emit(mask_type)
	else:
		print("dunno, how to handle itype: ", itype)

func is_it_me(inter_type :DataTypes.InterTypes, mask_type :DataTypes.MaskTypes) -> bool:
	if inter_type == itype and self.mask_type == mask_type:
		return true
	return false
