extends Node

@export var mob_scene: PackedScene
@export var coin_scene: PackedScene
@export var dan_scene: PackedScene
var score
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func game_over():
	$ScoreTimer.stop()
	$Music.stop()
	$DeathSound.play()
	$MobTimer.stop()
	$CoinTimer.stop()
	$DanTimer.stop()
	$DanielMusic.stop()
	$HUD.show_game_over()

func new_game():
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("coins", "queue_free")
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()
	$Player.start($StartPosition.position)
	$StartTimer.start()

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_coin_timer_timeout():
	# Create a new instance of the Mob scene.
	var coin = coin_scene.instantiate()

	# Choose a random location on Path2D.
	var coin_spawn_location = $MobPath/MobSpawnLocation
	coin_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = coin_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	coin.position = coin_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	coin.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	coin.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(coin)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func scoreCoin():
	score += 10
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$DanTimer.start()
	$CoinTimer.start()
	$ScoreTimer.start()

func _on_dan_timer_timeout():
	# Create a new instance of the Mob scene.
	var dan = dan_scene.instantiate()

	# Choose a random location on Path2D.
	var dan_spawn_location = $MobPath/MobSpawnLocation
	dan_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = dan_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	dan.position = dan_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	dan.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	dan.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(dan)

func _on_player_dan():
	$Music.stop()
	$DanielSound.play();
	$DanielMusic.play();
