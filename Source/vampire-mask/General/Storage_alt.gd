extends Node

# progress
var progress: Dictionary
# progress on checkpoint
var checkpoint: Dictionary

const keys_mask : String = "masks"
const keys_active : String = "active_m"

func _ready() -> void:
	progress[keys_mask] = []
	checkpoint = progress.duplicate()
	Hub.checkpoint_hit.connect(on_checkpoint_hit)
	Hub.checkpoint_reset.connect(on_checkpoint_reset)
	Hub.mask_equip.connect(on_mask_equip)
	Hub.mask_pickup.connect(on_got_mask)
	
func on_checkpoint_hit() -> void:
	checkpoint = progress.duplicate()

func on_checkpoint_reset() -> void:
	progress = checkpoint.duplicate()

func on_mask_equip(mtype: DataTypes.MaskTypes, last_type :DataTypes.MaskTypes) -> void:
	if not mtype in progress[keys_mask]:
		push_error("how did we got equipped with ", mtype)
	progress[keys_active] = mtype

func on_got_mask(mtype :DataTypes.MaskTypes):
	if not mtype in progress[keys_mask]:
		(progress[keys_mask] as Array).append(mtype)
	else:
		push_error("we already got this picked up, are we not deleting data enough? ", mtype)

# Info Queries
func get_current_masks() -> Array:
	if progress.has(keys_mask):
		return progress[keys_mask]
	return []

func get_active_mask() -> DataTypes.MaskTypes:
	if not progress.has(keys_active):
		push_error("no active face")
		return DataTypes.MaskTypes.None
	return progress[keys_active]
	
