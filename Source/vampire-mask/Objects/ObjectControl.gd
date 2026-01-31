extends StaticBody2D

@export var sprite_frames: SpriteFrames
@onready var anim_sprite :AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_sprite.sprite_frames_changed.connect(sprites_updated)
	anim_sprite.sprite_frames = sprite_frames
	pass # Replace with function body.

func sprites_updated() -> void:
	print("sprites changed to: ", anim_sprite.sprite_frames)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
