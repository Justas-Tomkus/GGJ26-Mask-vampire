extends Area2D

@export var req_type :DataTypes.MaskTypes
@export var target_path :NodePath
@onready var target :InteractionTarget = get_node(target_path)

func _ready() -> void:
	connect("body_entered", on_body_entered)
	connect("body_exited", on_body_exited)
	Hub.interaction_area_deactivate.connect(on_area_deactivate_request)

func on_body_entered(body :Node2D) -> void:
	# TODO(Justas): check if it's actually player
	print("body entered in", get_node("."))
	Hub.interaction_area_in.emit(req_type, target)

func on_body_exited(body: Node2D) -> void:
	# TODO(Justas): check if it's actually player
	print("body entered out", get_node("."))
	Hub.interaction_area_out.emit(req_type)

func on_area_deactivate_request(inter_type :DataTypes.InterTypes, mask_type :DataTypes.MaskTypes) -> void:
	print("deactivate request on area ", self)
	if target.is_it_me(inter_type, mask_type) and monitoring:
		monitoring = false
