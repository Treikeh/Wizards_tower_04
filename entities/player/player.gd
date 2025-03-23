extends CharacterBody3D


var move_input := Vector2.ZERO
var move_dir := Vector3.ZERO
var is_jumping := false

@onready var orientation: Node3D = $Orientation


func _ready() -> void:
	sm.switch(WALKING)


func _unhandled_input(event: InputEvent) -> void:
	move_input = Input.get_vector("move_l", "move_r", "move_f", "move_b")
	if event.is_action_pressed("jump"):
		is_jumping = true


func _physics_process(delta: float) -> void:
	move_dir = orientation.global_basis * Vector3(move_input.x, 0.0, move_input.y).normalized()
	sm.physics(delta)


#region State Machine

enum {WALKING, FALLING, JUMPING}

# Initilize state machine
var sm := SM.new({
	WALKING: {SM.PHYSICS: _walking_physics},
	FALLING: {SM.PHYSICS: _falling_physics},
	JUMPING: {SM.ENTER: _jumping_enter, SM.EXIT: _jumping_exit},
})


func _walking_physics(_delta: float) -> void:
	velocity = move_dir * 10.0
	move_and_slide()
	
	if not is_on_floor():
		sm.switch(FALLING)
	
	if is_jumping:
		sm.switch(JUMPING)


func _falling_physics(delta: float) -> void:
	velocity.x = move_dir.x * 5.0
	velocity.z = move_dir.z * 5.0
	velocity.y -= 10.0 * delta
	move_and_slide()
	
	if is_on_floor():
		sm.switch(WALKING)


func _jumping_enter() -> void:
	velocity.y = 5.0
	sm.switch(FALLING)


func _jumping_exit() -> void:
	is_jumping = false

#endregion
