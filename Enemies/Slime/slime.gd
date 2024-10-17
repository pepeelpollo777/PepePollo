extends CharacterBody2D

@export var endPoint: Marker2D
@onready var sprite = $Slime
@onready var anims = $AnimationPlayer
@onready var collision_shape_2d = $HitBox/CollisionShape2D
@onready var effects = $Effects
@onready var collision_shape_2d_hurt = $HurtBox/CollisionShape2D


var speed = 50
var startPosition
var endPosition
var limit = 0.5
var lastDir = "D"
var slimeLife = 2
var isDied = false

func _ready():
	startPosition = position
	endPosition = endPoint.global_position
	
func _physics_process(delta):
	if isDied:
		collision_shape_2d.disabled = true
		collision_shape_2d_hurt.disabled = true
		return
		
	move(delta)
	animCrtl()

func _process(delta):
	die()
	
func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd
	
func move(delta):
	var moveDirection = (endPosition - position)
	if moveDirection.length() < limit:
		changeDirection()
	
	
	velocity = moveDirection.normalized() * speed
	move_and_collide(velocity * delta)

func animCrtl():
	if velocity.x > 0:
		sprite.flip_h = false
		anims.play("walkR")
		lastDir = "R"
	elif velocity.x < 0:
		anims.play("walkR")
		sprite.flip_h = true
		lastDir = "R"
	elif velocity.y < 0:
		anims.play("walkU")
		lastDir = "U"
	elif velocity.y > 0:
		anims.play("walkD")
		lastDir = "D"
	else:
		anims.play("iddle" + lastDir)
		
func hurt():
	slimeLife -=1
	effects.play("hurt")
	await effects.animation_finished
	effects.play("RESET")
	
func die():
	if slimeLife <= 0:
		isDied = true
		anims.play("die")
		await anims.animation_finished
		queue_free()

func _on_hurt_box_area_entered(area):
	if area.is_in_group("Player"):
		hurt()
