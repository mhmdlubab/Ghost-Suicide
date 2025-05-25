extends Node2D

@onready var canvas: Control = $DeathScreen


func _ready() -> void:
	var pause_menu: Control = $CanvasLayer/pauseMenu
	pause_menu.reload_world.connect(self.reloadWorld)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().paused = false
		reloadWorld()


func reloadWorld():
	get_tree().reload_current_scene()

func Dead():
	canvas.show()
	get_tree().paused = true
	
	
	
