extends Node

var rng = RandomNumberGenerator.new()
var playerSpawnDistanceSafety = 200

var support = Preloads.enemy_support
var lancer = Preloads.enemy_lancer
var interceptor = Preloads.enemy_interceptor
var bulwark = Preloads.enemy_bulwark
var boss = Preloads.enemy_boss
#Add new enemy to preloads first

signal enemySpawned(enemy)

func _ready() -> void:
	$"../EnemySpawnTimer".wait_time = 3.0
	$"../EnemySpawnTimer".start()

func enemyPicker():
	var enemies = [support, lancer, interceptor, bulwark, boss]
	var weights = PackedFloat32Array([0.75, 0.5, 2, 1, 0.1])
	#TODO set weights based on current enemies in scene
	spawnEnemy(enemies[rng.rand_weighted(weights)])

func pickLocation():
	var r = rng.randi_range(1,4)
	#Scene is 1280*720 regardless of window resolution
	
	if r == 1:
		return Vector2(0-50,rng.randi_range(0-50,720+50))
	elif r == 2:
		return Vector2(1280+50,rng.randi_range(0-50,720+50))
	elif r == 3:
		return Vector2(rng.randi_range(0-50,1280+50),0-50)
	elif r == 4:
		return Vector2(rng.randi_range(0-50,1280+50),720+50)

func spawnEnemy(enemy: Variant):
	var x = enemy.instantiate()
	
	var doWhile = true
	while doWhile:
		x.global_position = pickLocation()
		if x.global_position.distance_to($"../Player".global_position) > playerSpawnDistanceSafety:
			doWhile = false
	
	emit_signal("enemySpawned", x)


func _on_enemy_spawn_timer_timeout() -> void:
	var times = [1, 1.5, 2, 2.5, 3]
	var weights = PackedFloat32Array([0.5, 1, 1, 1, 1.5])
	#TODO set weights based on Time since start
	$"../EnemySpawnTimer".wait_time = rng.randf_range(0,times[rng.rand_weighted(weights)])
	$"../EnemySpawnTimer".start()
	enemyPicker()
