class_name Bird extends RigidBody2D

signal on_death

@export var jump_force: float = 300.0

func _physics_process(delta):
	var rotation_target = 0
	rotation_target = linear_velocity.y / 10
	rotation_target = clampf(rotation_target, -90, 90)
		
	rotation_degrees = rotation_target

	if Input.is_action_just_pressed("jump"):
		var force = (Vector2.UP * jump_force)
		if linear_velocity.y > 0:
			force -= linear_velocity
		apply_central_impulse(force)

func _on_body_entered(body):
	print("Dead")
	on_death.emit();
