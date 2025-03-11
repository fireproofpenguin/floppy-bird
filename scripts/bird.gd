class_name Bird extends RigidBody2D

signal on_death

@export var death_cutoff = 552

@export var jump_force: float = 300.0

var has_died = false

func _physics_process(delta):
	if global_position.y > death_cutoff and not has_died:
		_died()
		
	if global_position.y < 0 and not has_died:
		_died()
		
	var rotation_target = 0
	rotation_target = linear_velocity.y / 10
	rotation_target = clampf(rotation_target, -90, 90)
		
	rotation_degrees = rotation_target

	if Input.is_action_just_pressed("jump") and not has_died:
		var force = (Vector2.UP * jump_force)
		if linear_velocity.y > 0:
			force -= linear_velocity
		apply_central_impulse(force)

func _died():
	print("Dead")
	freeze = true
	has_died = true
	on_death.emit()
