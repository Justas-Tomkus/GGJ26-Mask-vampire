extends Node

# progress
var progress: Dictionary
# progress on checkpoint
var checkpoint: Dictionary

func _ready() -> void:
	Hub.checkpoint_hit.connect(on_checkpoint_hit)
	Hub.checkpoint_reset.connect(on_checkpoint_reset)
	
func on_checkpoint_hit() -> void:
	checkpoint = progress.duplicate()

func on_checkpoint_reset() -> void:
	progress = checkpoint.duplicate()

func get_current_masks() -> Array:
	if progress.has("masks"):
		return progress["masks"]
	return []
