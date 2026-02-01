extends PanelContainer

@onready var label = $VBoxContainer/Label
@onready var start_button = $VBoxContainer/RetryButton
@onready var quit_button = $VBoxContainer/QuitButton

func _ready() -> void:
	Hub.take_damage.connect(on_damage_taken)
	start_button.connect("pressed", on_retry)
	quit_button.connect("pressed", on_quit)
	visible = false

func on_damage_taken(dtype :DataTypes.MaskTypes) -> void:
	var hintText :String = ""
	if dtype == DataTypes.MaskTypes.Sun:
		hintText = "You dead because of sunburns, try not to stay in sun for too long without a proper mask"
	elif dtype == DataTypes.MaskTypes.Human:
		hintText = "You got recognized by a human, try not stay in sight without a proper disguise"
	else:
		hintText = "You mananged to be dead-dead, congrats!"
	label.text = hintText
	visible = true
	Hub.mark_dead.emit()
	Hub.checkpoint_hit.emit()

func on_retry() -> void:
	get_tree().reload_current_scene()
	Hub.try_retry.emit()

func on_quit() -> void:
	get_tree().quit()
