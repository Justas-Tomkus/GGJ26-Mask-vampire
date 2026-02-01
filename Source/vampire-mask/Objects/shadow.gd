extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", on_body_entered)
	connect("body_exited", on_body_exited)

func on_body_entered(body :Node2D) -> void:
	Hub.in_shadow.emit(body)
	print("shadow in")
	
func on_body_exited(body :Node2D) -> void:
	Hub.out_shadow.emit(body)
	print("shadow out")
