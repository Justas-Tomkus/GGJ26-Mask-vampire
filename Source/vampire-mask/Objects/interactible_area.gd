extends Area2D

@export var req_type :DataTypes.MaskTypes
@export var target_path :NodePath
@onready var target :InteractionTarget = get_node(target_path)
@onready var anim :AnimatedSprite2D = $AnimatedSprite2D

var hover :Node2D = null

func _ready() -> void:
	connect("body_entered", on_body_entered)
	connect("body_exited", on_body_exited)
	Hub.interaction_area_deactivate.connect(on_area_deactivate_request)
	Hub.mask_equip.connect(on_mask_equipped)

func on_body_entered(body :Node2D) -> void:
	# TODO(Justas): check if it's actually player
	print("body entered in", get_node("."))
	try_notify_target(Storage.get_active_mask())
	if hover != null:
		push_error("why do we already have body in? ", hover)
	hover = body
	print("pass - condition unmet yet")

func try_notify_target(mtype :DataTypes.MaskTypes) -> void:
	if req_type == DataTypes.MaskTypes.Undefined or req_type  == mtype:
		# Note(Justas): we wait for frame, because of underterministic 
		# event firing order when manually changing position and jumping
		# straing from one area to another one
		await get_tree().process_frame
		Hub.interaction_area_in.emit(req_type, target)

func on_body_exited(body: Node2D) -> void:
	# TODO(Justas): check if it's actually player
	print("body entered out", get_node("."))
	Hub.interaction_area_out.emit(req_type)
	if hover != body:
		push_error("how can we with wrong body? ", hover)
	hover = null

func on_area_deactivate_request(inter_type :DataTypes.InterTypes, mask_type :DataTypes.MaskTypes) -> void:
	print("deactivate request on area ", self)
	if target.is_it_me(inter_type, mask_type) and monitoring:
		monitoring = false
		if anim.sprite_frames != null:
			anim.visible = false

func on_mask_equipped(mtype :DataTypes.MaskTypes, last_type :DataTypes.MaskTypes) -> void:
	print("mask change notify")
	if hover != null:
		if last_type == req_type:
			Hub.interaction_area_out.emit(req_type)
		try_notify_target(mtype)
	
