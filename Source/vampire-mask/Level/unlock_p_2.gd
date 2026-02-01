extends Area2D

@export var to_disable_collision : NodePath
var to_disable : CollisionShape2D
@export var add_to_camera_bounds : NodePath
var add_to_cam : Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not to_disable_collision.is_empty():
		to_disable = get_node(to_disable_collision) as CollisionShape2D
	if not add_to_camera_bounds.is_empty():
		add_to_cam = get_node(add_to_camera_bounds) as Sprite2D
	connect("body_entered", on_body_in)

func on_body_in(body :Node2D) -> void:
	if to_disable != null:
		to_disable.disabled = true
	if add_to_cam != null:
		Hub.unlock_area.emit(add_to_cam)
