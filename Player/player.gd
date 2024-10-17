extends CharacterBody2D

signal healthChange

@export var inventory : Inventory
@onready var anims = $AnimationPlayer
@onready var sprite = $Player
@onready var effects = $Effects
@onready var hurt_timer = $HurtTimer
@onready var collision_shape_2d = $HitBox/CollisionShape2D




var speed = 70
var lastDir = "D"
var attackDir = ""
var maxHealt = 5
var currentHealt = maxHealt
var knockBackPower = 400
var isHurting = false
var isAttacking = false
var enemyCollisions = []
var isDied = false


func _ready():
	collision_shape_2d.disabled = true
	
func _process(delta):
	die()


func _physics_process(delta):
	if isDied: return
	move(delta)
	attack()
	animCrtl()
	if not isHurting:
		for enemyArea in enemyCollisions:
			hurt(enemyArea)

func move(delta):
	var direction = Input.get_vector("left","right","up","down").normalized()
	velocity = direction * speed
	move_and_collide(velocity * delta)

func animCrtl():
	if isAttacking: return
	if velocity.x > 0:
		sprite.flip_h = false
		anims.play("wlakR")
		lastDir = "R"
		attackDir = "R"
	elif velocity.x < 0:
		anims.play("wlakR")
		sprite.flip_h = true
		lastDir = "R"
		attackDir = "L"
	elif velocity.y < 0:
		anims.play("wlakU")
		lastDir = "U"
		attackDir = "U"
	elif velocity.y > 0:
		anims.play("walkD")
		lastDir = "D"
		attackDir = "D"
	else:
		anims.play("iddle" + lastDir)
		
func attack():
	if Input.is_action_just_pressed("attack"):
		isAttacking = true
		if attackDir == "D":
			anims.play("attackD")
		elif attackDir == "R":
			anims.play("attackR")
		elif attackDir == "U":
			anims.play("attackU")
		elif attackDir == "L":
			anims.play("attackL")
		await anims.animation_finished
		isAttacking = false
			
func hurt(area):
	currentHealt -= 1
	healthChange.emit(currentHealt)
	isHurting = true
	effects.play("hurt")
	hurt_timer.start()
	knockBack(area.get_parent().velocity)
	await hurt_timer.timeout
	effects.play("RESET")
	print(currentHealt)
	isHurting = false
	
func die():
	if currentHealt <= 0:
		isDied = true
		anims.play("die")
		await anims.animation_finished
		queue_free()
		
func knockBack(enemyVelocity: Vector2):
	var knockBackDir = (enemyVelocity).normalized() * knockBackPower
	velocity = knockBackDir
	move_and_slide()


func _on_hurt_box_area_entered(area):
	if area.is_in_group("Slimes"):
		enemyCollisions.append(area)
	if area.has_method("collect"):
		area.collect(inventory)
	
	
func _on_hit_box_area_exited(area):
	enemyCollisions.erase(area)
