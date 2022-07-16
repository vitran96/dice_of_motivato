class_name Player
extends KinematicBody2D

var speed := Vector2(120.0, 360.0)
var velocity := Vector2.ZERO
var falling_slow := false
var falling_fast := false
var no_move_horizontal_time := 0.0

onready var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
    velocity.y += gravity * delta
    if no_move_horizontal_time > 0.0:
        # After doing a hard fall, don't move for a short time.
        velocity.x = 0.0
        no_move_horizontal_time -= delta
    else:
        velocity.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * speed.x
        if Input.is_action_pressed("walk"):
            velocity.x *= 0.2

    #warning-ignore:return_value_discarded
    velocity = move_and_slide(velocity, Vector2.UP)

    # Calculate flipping and falling speed for animation purposes.
    if velocity.y > 500:
        falling_fast = true
        falling_slow = false
    elif velocity.y > 300:
        falling_slow = true

    # Check if on floor and do mostly animation stuff based on it.
    if is_on_floor():
        if falling_fast:
            no_move_horizontal_time = 0.4
            falling_fast = false
        elif falling_slow:
            falling_slow = false
        if Input.is_action_just_pressed("jump"):
            velocity.y = -speed.y
