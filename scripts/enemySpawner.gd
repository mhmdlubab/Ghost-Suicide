extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_cooldown = 2.0
var timer: float = spawn_cooldown
@onready var label: Label = $"../Control/enemy_counter"
var enemies_killed = 0

func _ready() -> void:
	add_to_group("enemies")
	label.text = "Enemies killed: " + str(enemies_killed)

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		var enemies_count = get_tree().get_nodes_in_group("enemies").size()
		if (enemies_count < 10):
			spawn_enemy()
			timer = spawn_cooldown
		
func spawn_enemy():
		var new_enemy = enemy_scene.instantiate()
		var enemy_position = Vector2()
		var side = randi_range(1, 4)
		match side:
			1: #left
				enemy_position = Vector2(0 , randi_range(0, get_viewport().get_size().y))
			2: #right
				enemy_position = Vector2(get_viewport().get_size().x , randi_range(0, get_viewport().get_size().y))
			3: #bottom
				enemy_position = Vector2(randi_range(0, get_viewport().get_size().x) , get_viewport().get_size().y)
			4: #top
				enemy_position = Vector2(randi_range(0, get_viewport().get_size().x)  , 0)
		new_enemy.position = enemy_position
		get_parent().add_child(new_enemy)
		new_enemy.add_to_group(	"enemies")
		new_enemy.enemy_killed.connect(self.enemy_counter_func)
		var player: CharacterBody2D = $"../Player"
		new_enemy.player_damage.connect(player._on_hurt_body_attacked)
	
func enemy_counter_func():
	enemies_killed += 1
	label.text = "Enemies killed: " + str(enemies_killed)

	
	
	
