extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -100.0

const INVUL_COOLDOWN = 10.0 #seconds
const INVUL_LENGTH = 1.0 #seconds
var invul_usable:bool = true
var is_invul:bool = false
var lives:int = 5
var fake_lives:int = 5
var is_area_overlapping_saw:bool = false

@export var default_position: Vector2 = Vector2(0, 0)
@export var UI: Node2D

func _init():
	
	assert( UI == null, "character body no ui thing export var check there")


func _ready():
	$"Invulnerability Cooldown".one_shot = true
	$"Invulnerability Cooldown".wait_time = INVUL_COOLDOWN
	$"Invulnerability Timer".one_shot = true
	$"Invulnerability Timer".wait_time = INVUL_LENGTH
	self.global_position = default_position
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("invulnerability") and invul_usable:
		invul_usable = false
		is_invul = true
		$"Invulnerability Timer".start()
		$"Invulnerability Cooldown".start()
		print("invulnerability has begun")
		
	
	if is_area_overlapping_saw:
		UI.get_node("CanvasLayer/Lives").text = str(fake_lives)
		fake_lives -= 1
		if fake_lives < -100: fake_lives = lives

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

func _on_invulnerability_cooldown_timeout():
	invul_usable = true
	print("invulnerability cooldown is over")


func _on_invulnerability_timer_timeout():
	is_invul = false
	print("invulnerability is over")


func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		if not is_invul:
			take_damage()
		is_area_overlapping_saw=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		is_area_overlapping_saw=false
		fake_lives = lives
		UI.get_node("CanvasLayer/Lives").text = "HEALTH:"+ str(lives)
