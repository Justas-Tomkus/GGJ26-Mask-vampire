extends PanelContainer

@onready var label = $VBoxContainer/Label
@onready var start_button = $VBoxContainer/RetryButton
@onready var quit_button = $VBoxContainer/QuitButton

func _ready() -> void:
	Hub.take_damage.connect(on_damage_taken)
	Hub.mark_dead.connect(on_marked_dead)
	start_button.connect("pressed", on_retry)
	quit_button.connect("pressed", on_quit)
	visible = false

func on_damage_taken(dtype :DataTypes.MaskTypes) -> void:
	Hub.mark_dead.emit(dtype)
	# sun damage handled by sun bar, not got, but time is short
	
func on_marked_dead(dtype :DataTypes.MaskTypes) -> void:
	var hintText :String = ""
	if dtype == DataTypes.MaskTypes.Sun:
		hintText = "You are dead because of the sunburns, try not to stay in sun for too long without a proper mask"
	elif dtype == DataTypes.MaskTypes.Human:
		hintText = "You got recognized by a human, try not stay in sight without a proper disguise"
	else:
		hintText = "You mananged to be dead-dead, congratulations!"
	label.text = hintText
	visible = true
	Hub.checkpoint_hit.emit()

func on_retry() -> void:
	get_tree().reload_current_scene()
	Hub.try_retry.emit()

func on_quit() -> void:
	get_tree().quit()
