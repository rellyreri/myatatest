extends CharacterBody3D

@export_category("Movement Properties")
@export var SPEED = 10
@export var DECEL = 150
@export var ACCEL = 200
@export_category("Jump Properties")
@export var JUMP_HEIGHT = 100
@export var JUMP_TIME_PEAK = 0.5
@export var JUMP_TIME_DESCEND = 0.4 

@onready var JUMP_VELOCITY : float = (2.0 * JUMP_HEIGHT) / JUMP_TIME_PEAK
@onready var JUMP_GRAVITY : float = (-2.0 * JUMP_HEIGHT) / (JUMP_TIME_PEAK * JUMP_TIME_PEAK)
@onready var FALL_GRAVITY : float = (-2.0 * JUMP_HEIGHT) / (JUMP_TIME_DESCEND * JUMP_TIME_DESCEND)

@onready var neck := $CameraBase
@onready var camera := $CameraBase/Camera3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	EventBus.connect("environment_damage",_environmentDamage)
	
#CAMERA
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			@warning_ignore("unsafe_property_access", "unsafe_method_access")
			neck.rotate_y(-event.relative.x*0.01) #having it as rotate_y makes it rotate left and right
			#camera.rotate_x(-event.relative.y*0.01) #having it as rotate_x makes it rotate up and down
			@warning_ignore("unsafe_property_access")
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(20))

#MOVEMENT
func _physics_process(delta):

	velocity.y += get_gravity() * delta #adds the value from get_gravity to velocity.y, bringing you down
	handle_jump()

	# Get the input direction
	var input_x_axis = Input.get_axis("ui_left", "ui_right")
	var input_z_axis = Input.get_axis("ui_up", "ui_down")
	@warning_ignore("unsafe_property_access", "unsafe_method_access")
	var direction = (neck.transform.basis * Vector3(input_x_axis,0,input_z_axis)).normalized()
	#var direction changes based on the neck's rotation
	#neck.transform.basis * Vector3 multiplies the 3 vectors by that transform basis. which is why 
	#it changes when you rotate

	handle_movement(delta,direction) # Uses input direction
	
	
	
	move_and_slide()

func get_gravity() -> float:
	return JUMP_GRAVITY if velocity.y < 0.0 else FALL_GRAVITY #gets jump gravity, always negative

func handle_jump():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		#sets your y velocity to the jump velocity which makes you Go into the air. then gravity brings you down

func handle_movement(delta,direction):
	if direction:
		velocity.x = move_toward(velocity.x, SPEED * direction.x, ACCEL * delta)
		velocity.z = move_toward(velocity.z, SPEED * direction.z, ACCEL * delta)
		#velocity.x moves A(velocity.x) to B(SPEED * direction.x) at the speed of ACCEL(C)
		#SPEED is multiplied by the axis, so if it's negative you'll go left, and positive you'll go right.
		#also since it's an axis, joystick movements will let you move slower
		#same goes for velocity.z but in z axis
	else:
		velocity.x = move_toward(velocity.x, 0, DECEL * delta)
		#velocity.x moves A(velocity.x) to B(0) at the speed of DECEL(C)
		#velocity.x is your velocity in the x axis
		velocity.z = move_toward(velocity.z, 0, DECEL * delta)
		#same as input_x_axis, but with the z axis

func _environmentDamage(damage):
	print(damage)
	EventBus.playerhealth -= damage
	print("HP = ",EventBus.playerhealth)
#AAAA
