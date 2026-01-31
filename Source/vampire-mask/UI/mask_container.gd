extends PanelContainer

@export var layout_container: HBoxContainer
@export var mask_ui_template: PackedScene

func _ready() -> void:
	Hub.mask_pickup.connect(on_mask_picked_up)
	Hub.checkpoint_reset.connect(on_reinit_masks)
	on_reinit_masks()
	# Setup initial "face/mask"
	# TODO(Justas): move to more appropriate place when checkpoints are working
	Hub.mask_pickup.emit(DataTypes.MaskTypes.None)
	Hub.mask_equip.emit(DataTypes.MaskTypes.None)
	
func on_reinit_masks() -> void:
	var children = layout_container.get_children()
	for child in children:
		child.queue_free()
	var current_masks = Storage.get_current_masks()
	for mask_type in current_masks:
		add_mask(mask_type)

func on_mask_picked_up(mask_type :DataTypes.MaskTypes) -> void:
	add_mask(mask_type)

func add_mask(mask_type :DataTypes.MaskTypes) -> void:
	var mask_node = mask_ui_template.instantiate()
	print("adding mask node: ", mask_node)
	mask_node.setup(mask_type)
	layout_container.add_child(mask_node)
