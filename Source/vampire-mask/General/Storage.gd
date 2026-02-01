extends Node

# progress
var progress: Dictionary
# progress on checkpoint
var checkpoint: Dictionary

const keys_mask : String = "masks"
const keys_active : String = "active_m"
const keys_shadows : String = "shadows"

func _ready() -> void:
	print("reload")
	progress[keys_mask] = []
	progress[keys_shadows] = []
	checkpoint = progress.duplicate()

	Hub.checkpoint_hit.connect(on_checkpoint_hit)
	Hub.checkpoint_reset.connect(on_checkpoint_reset)
	Hub.mask_equip.connect(on_mask_equip)
	Hub.mask_pickup.connect(on_got_mask)
	Hub.mark_dead.connect(on_marked_dead)
	Hub.try_retry.connect(on_try_retry)
	
	Hub.in_shadow.connect(on_shadow_entered)
	Hub.out_shadow.connect(on_shadow_exited)
	
	# setup
	Hub.mask_pickup.emit(DataTypes.MaskTypes.None)
	
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
	

func on_shadow_entered(body :Node2D) -> void:
	progress[keys_shadows].append(body)

func on_shadow_exited(body :Node2D) -> void:
	if not progress[keys_shadows].has(body):
		push_error("why are we clearing body, which is not tracked ", body)
	progress[keys_shadows].erase(body)

var track_shadows = true
func on_marked_dead() -> void:
	track_shadows = false
	print("no tracking")
func on_try_retry() -> void:
	# Note(Justas): we delay one frame, just in case
	# Note(Justas): ok, so we need more than one frame...
	# Lovely.. TODO(Justas): fix this stupidity
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	track_shadows = true
	print("set tracking")

func _process(delta: float) -> void:
	if track_shadows and progress[keys_shadows].is_empty():
		if get_active_mask() != DataTypes.MaskTypes.Sun:
			Hub.take_damage.emit(DataTypes.MaskTypes.Sun)
