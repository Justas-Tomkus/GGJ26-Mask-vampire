extends HSlider

@export var dmgps : float = 2
@export var dmg_max :float = 1.2
@export var recovery_rate :float = 0.5

var dmg_taken_this_frame :bool = false
var sent_dead = false

func _ready() -> void:
	Hub.take_damage_reduced.connect(on_damage_taken)
	
	max_value = dmg_max
	visible = false

func on_damage_taken(dtype :DataTypes.MaskTypes) -> void:
	dmg_taken_this_frame = true

func _process(delta: float) -> void:
	if dmg_taken_this_frame:
		value += dmgps * delta
	else:
		value -= recovery_rate * delta
	print("val", value)
	dmg_taken_this_frame = false
	if value <= min_value:
		visible = false
	else:
		visible = true
	if value >= max_value:
		if not sent_dead:
			sent_dead = true
			print("sending dead")
			Hub.mark_dead.emit(DataTypes.MaskTypes.Sun)
