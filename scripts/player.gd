extends CharacterBody2D

@onready var world: Node2D = $".."
const BULLET = preload("res://scenes/bullet.tscn")
@onready var hp: Label = $"../Health/VBoxContainer/HP"
@export var speed = 20
@export var max_speed = 300
var HP = 100
var mouse_position
@onready var shooting_sound: AudioStreamPlayer2D = $shooting_sound

func _ready() -> void:
	hp.text = "Health: " + str(HP)
	add_to_group("Player")
	

func _physics_process(delta: float) -> void:
	# to not let player get out of the screen
	var margin = 50
	if position.x < margin:
		position.x = margin
	elif position.x > get_viewport_rect().size.x - margin:
		position.x = get_viewport_rect().size.x - margin
	if position.y < margin:
		position.y = margin
	elif position.y > get_viewport_rect().size.y - margin:
		position.y = get_viewport_rect().size.y - margin
	
	var directionx: float = Input.get_axis("left","right")
	var directiony:float = Input.get_axis("up","down")
	if directionx:
		velocity.x += directionx * speed
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.x = move_toward(velocity.x, 0, 2)
	if directiony:
		velocity.y += directiony * speed
		velocity.y = clamp(velocity.y, -max_speed, max_speed)
	velocity.y = move_toward(velocity.y, 0, 2)
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if HP <= 0:
		world.Dead()

	mouse_position = get_viewport().get_mouse_position()
	look_at(mouse_position)
	move_and_slide()
	

func shoot():
	var bullet = BULLET.instantiate()
	get_parent().add_child(bullet)
	bullet.position = $Position2D.global_position
	bullet.global_rotation = $Position2D.global_rotation
	bullet.velocity =  mouse_position - bullet.position
	shooting_sound.play()

# not necessary anymore
#func _on_hurt_body_entered(body: Node2D) -> void:
#	if body.is_in_group("Object"):
#		HP -= 20
#		hp.text = "Health: " + str(HP)
		
func _on_hurt_body_attacked():
	HP -= 20
	hp.text = "Health: " + str(HP)
