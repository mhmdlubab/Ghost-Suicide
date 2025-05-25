extends CharacterBody2D

@export var speed = 80

const JUMP_VELOCITY = -400.0

@onready var player: CharacterBody2D = $"../Player"
var HP 
signal enemy_killed
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var is_alive = true
@onready var enemy_explosion_sound: AudioStreamPlayer2D = $enemy_explosion
@onready var enemy_death_sound: AudioStreamPlayer2D = $enemy_death_sound
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var timer: Timer = $Timer
var attack_range = 1
var has_attacked = false
var is_attacking = false
signal player_damage
var attack_cooldown = 2.0  
var attack_timer: float = 0.0

func _ready() -> void:
	HP = randi_range(50, 100)
	health_bar.max_value = HP
	# player.enemy_collide_attack_animation.connect(self._on_attack_body_entered)
func _physics_process(delta: float) -> void:
	if is_alive == false:
		return	
	if HP <= 0:
		Dead()
	health_bar.value = HP
	var distance_to_player = position.distance_to(player.position)
	
	if attack_timer > 0:
		attack_timer -= delta
		
	if distance_to_player > attack_range and not is_attacking:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		move_and_slide()
	elif attack_timer <= 0:
		velocity = Vector2.ZERO
		_on_attack_body_entered(player)
	
func Dead():
	is_alive = false
	var collision_shape_main: CollisionShape2D = $CollisionShape2D
	if collision_shape_main:
		collision_shape_main.queue_free()
	var collision_shape_attack: CollisionShape2D = $attack/CollisionShape2D
	if collision_shape_attack:
		collision_shape_attack.queue_free()
	animated_sprite_2d.play("enemy_death")
	enemy_death_sound.play()
	await get_tree().create_timer(0.8).timeout
	queue_free()
	emit_signal("enemy_killed")

func _on_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and timer.is_stopped():
		emit_signal("player_damage")
		is_attacking = true
		attack_timer = attack_cooldown
		if not enemy_explosion_sound.playing:
			enemy_explosion_sound.play()
		var collision_shape_main: CollisionShape2D = $CollisionShape2D
		if collision_shape_main:
			collision_shape_main.queue_free()
		var collision_shape_attack: CollisionShape2D = $attack/CollisionShape2D
		if collision_shape_attack:
			collision_shape_attack.queue_free()
		animated_sprite_2d.play("enemy_attack")
		await animated_sprite_2d.animation_finished
		queue_free()
		
