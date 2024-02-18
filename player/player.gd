extends Area2D
signal hit
signal scored
signal dan

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var screen_edge
@export var daniel = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	screen_size = get_viewport_rect().size
	screen_edge = Vector2.ZERO
	screen_size.x -= ($CollisionShape2D.shape.get_rect().size.x/2)
	screen_edge.x += ($CollisionShape2D.shape.get_rect().size.x/2)
	screen_size.y -= ($CollisionShape2D.shape.get_rect().size.y/2)
	screen_edge.y += ($CollisionShape2D.shape.get_rect().size.y/2)

func start(pos):
	position = pos
	daniel = 0
	show()
	$CollisionShape2D.disabled = false
# Called every frame. 'delta' is the elapsed time since the previous frame.

func set_daniel(danny):
	daniel = danny
	if(daniel):
		$AnimatedSprite2D.animation = "dan"
	else:
		$AnimatedSprite2D.animation = "walk"

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if velocity.x != 0:
		if daniel:
			$AnimatedSprite2D.animation = "dan"
		else:
			$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		if daniel:
			$AnimatedSprite2D.animation = "dan"
		else:
			$AnimatedSprite2D.animation = "up"
			$AnimatedSprite2D.flip_v = velocity.y > 0
			
	position += velocity * delta
	position = position.clamp(screen_edge, screen_size)

func _on_body_entered(body):
	if(daniel == 0):
		if body.is_in_group("mobs"):
			hide() # Player disappears after being hit.
			hit.emit()
			# Must be deferred as we can't change physics properties on a physics callback.
			$CollisionShape2D.set_deferred("disabled", true)
		elif body.is_in_group("coins"):
			scored.emit()
			body.queue_free()
		else:
			daniel = 1
			$AnimatedSprite2D.animation = "dan"
			body.queue_free()
			dan.emit()
	else:
		if body.is_in_group("coins"):
			hide() # Player disappears after being hit.
			hit.emit()
			# Must be deferred as we can't change physics properties on a physics callback.
			$CollisionShape2D.set_deferred("disabled", true)
		elif body.is_in_group("mobs"):
			scored.emit()
			body.queue_free()
