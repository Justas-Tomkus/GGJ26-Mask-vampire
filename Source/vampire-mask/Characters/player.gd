extends CharacterBody2D

@export var cam_node: NodePath
@export var rtrans: NodePath
@export var anim: NodePath
@onready var anim_: AnimatedSprite2D = get_node(anim) as AnimatedSprite2D

@export var max_speed: float = 100.0
@export var acceleration: float = 300.0
@export var friction: float = 400.0
@export var dash_imp: float = 1000.0
@export var dash_fric: float = 0.6
@export var dash_cd: float = 1.0


var motion = Vector2.ZERO
var active_mtype :DataTypes.MaskTypes

func _ready() -> void:
	Hub.mask_equip.connect(on_mask_changed)
	
	# Note(Justas): dynamic set doesn't seem to work, using manually expanded children
	#var cam_follow : RemoteTransform2D = get_node(rtrans)
	#cam_follow.remote_path = cam_node

func _physics_process(delta: float) -> void:
	
	var move_vecn :Vector2 = Input.get_vector("MoveLeft", "MoveRight", "MoveDown", "MoveUp").normalized()
		
	apply_movement_friction(move_vecn, delta)
	move_and_slide()
	motion = get_real_velocity()
	apply_animation()

func apply_movement_friction(in_vec: Vector2, delta: float) -> void:
	if in_vec != Vector2.ZERO:
		motion = motion.move_toward(in_vec * max_speed, acceleration * delta)
	else:
		motion = motion.move_toward(Vector2.ZERO, friction * delta)
	velocity = motion
	

func apply_animation() -> void:
	if motion == Vector2.ZERO:
		# if walking sfx -> stop
		if anim_.is_playing():
			anim_.stop()
			anim_.frame = 0
	else:
		pass
		if motion.x < 0:
			anim_.flip_h = true
		elif motion.x > 0:
			anim_.flip_h = false
		# if !walk sfx -> play
		if !anim_.is_playing():
			anim_.play()

func on_mask_changed(mtype) -> void:
	active_mtype = mtype
	var playing_initially = anim_.is_playing()
	print("Setting mask anim: ", mtype)
	if mtype == DataTypes.MaskTypes.None:
		anim_.animation = "move_side"
	elif mtype == DataTypes.MaskTypes.Sun:
		anim_.animation = "move_side_sun"
	elif mtype == DataTypes.MaskTypes.Human:
		anim_.animation = "move_side_human"
	elif mtype == DataTypes.MaskTypes.Garlic:
		anim_.animation = "move_side_garlic"
	else:
		push_error("Undefined move animation for mask type: ", mtype)
