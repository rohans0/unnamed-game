extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -100.0

const INVUL_COOLDOWN = 10.0 #seconds
const INVUL_TIME = 1.0 #seconds
var invul_usable:bool = true
var is_invul:bool = false
var lives:int = 5

@export var default_position: Vector2 = Vector2(0, 0)


func _ready():
	
	$"Invulnerability Cooldown".one_shot = true
	$"Invulnerability Cooldown".wait_time = INVUL_COOLDOWN
	$"Invulnerability Timer".one_shot = true
	$"Invulnerability Timer".wait_time = INVUL_TIME
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("invulnerability") and invul_usable:
		invul_usable = false
		is_invul = true
		$"Invulnerability Timer".start()
		$"Invulnerability Cooldown".start()
		print("invulnerability has begun")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("up"):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func take_damage():
	print("took damage")
	lives -= 1
	#if lives <= 0:
		#print("game over!") #add real game over here
	self.global_position = default_position

func _on_invulnerability_cooldown_timeout():
	invul_usable = true
	print("invulnerability cooldown is over")


func _on_invulnerability_timer_timeout():
	is_invul = false
	print("invulnerability is over")


func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy") and not is_invul:
		take_damage()
