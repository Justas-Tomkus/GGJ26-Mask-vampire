extends Panel

@onready var hint_button : Button = $InteractionHint

var interact_target :Node2D
var press_progress :bool = false

func _ready() -> void:
	Hub.interaction_area_in.connect(on_interact_in)
	Hub.interaction_area_out.connect(on_interact_out)
	hint_button.connect("pressed", on_button_pressed)
	visible = false

func on_interact_in(type :DataTypes.MaskTypes, target :Node2D) -> void:
	# TODO(Justas): can interact
	interact_target = target
	visible = true

func on_interact_out(type :DataTypes.MaskTypes) -> void:
	interact_target = null
	print("interaction hint out on: ", self)
	visible = false

func on_button_pressed() -> void:
	print("button mouse press")
	if interact_target == null:
		push_error("pressing interact, but no target")
		return
	interact_target.doit()

func _process(delta: float) -> void:
	if Input.is_action_pressed("Interact"):
		if interact_target != null and not press_progress:
			print("simulate press")
			hint_button.toggle_mode = true
			hint_button.set_pressed_no_signal(true)
			hint_button.pressed.emit()
			press_progress = true
			await get_tree().create_timer(0.2).timeout
			hint_button.toggle_mode = false
			hint_button.set_pressed_no_signal(false)
			press_progress = false
