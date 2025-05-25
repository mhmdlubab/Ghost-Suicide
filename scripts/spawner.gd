extends Node2D
var mouse_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_position = get_viewport().get_mouse_position()
	 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(mouse_position)
	transform.	
