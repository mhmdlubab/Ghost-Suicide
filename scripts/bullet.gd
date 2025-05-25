extends CharacterBody2D

var mouse_position : Vector2
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	
	var collision_info = move_and_collide(velocity.normalized() * delta * 500)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_bullet_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Object"):
		body.HP -= 25
		queue_free()
