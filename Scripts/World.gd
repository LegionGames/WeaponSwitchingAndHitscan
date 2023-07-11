extends Node3D

@onready var hit_rect = $UI/HitRect
@onready var spawns = $Map/Spawns
@onready var navigation_region = $Map/NavigationRegion3D

@onready var crosshair = $UI/Crosshair
@onready var crosshair_hit = $UI/CrosshairHit

var zombie = load("res://Scenes/Zombie.tscn")
var instance


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	crosshair.position.x = get_viewport().size.x / 2 - 32
	crosshair.position.y = get_viewport().size.y / 2 - 32
	crosshair_hit.position.x = get_viewport().size.x / 2 - 32
	crosshair_hit.position.y = get_viewport().size.y / 2 - 32


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_player_player_hit():
	hit_rect.visible = true
	await get_tree().create_timer(0.2).timeout
	hit_rect.visible = false


func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)

func _on_zombie_spawn_timer_timeout():
	var spawn_point = _get_random_child(spawns).global_position
	instance = zombie.instantiate()
	instance.position = spawn_point
	instance.visible = false
	instance.zombie_hit.connect(_on_enemy_hit)
	navigation_region.add_child(instance)


func _on_enemy_hit():
	crosshair_hit.visible = true
	await get_tree().create_timer(0.05).timeout
	crosshair_hit.visible = false
