extends CharacterBody3D
class_name HeroPlayer
@export var walk_speed := 4.5
@export var sprint_speed := 7.0
@export var jump_velocity := 4.8
@export var mouse_sensitivity := 0.0025
@export var crouch_speed := 2.5
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_crouching := false
var health := 100.0
var armor := 50.0
@onready var pivot: Node3D = $CameraPivot
func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        rotate_y(-event.relative.x * mouse_sensitivity)
        pivot.rotate_x(-event.relative.y * mouse_sensitivity)
        pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-55), deg_to_rad(65))
    if event.is_action_pressed("ui_cancel"):
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    if event is InputEventMouseButton and event.pressed and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= gravity * delta
    is_crouching = Input.is_action_pressed("crouch")
    if Input.is_action_just_pressed("jump") and is_on_floor() and not is_crouching:
        velocity.y = jump_velocity
    var v := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    var dir := (transform.basis * Vector3(v.x, 0, v.y)).normalized()
    var speed := crouch_speed if is_crouching else (sprint_speed if Input.is_action_pressed("sprint") else walk_speed)
    if dir:
        velocity.x = dir.x * speed
        velocity.z = dir.z * speed
    else:
        velocity.x = move_toward(velocity.x, 0.0, speed)
        velocity.z = move_toward(velocity.z, 0.0, speed)
    move_and_slide()
func take_damage(amount: float) -> void:
    var absorbed := minf(armor, amount * 0.6)
    armor -= absorbed
    health = maxf(0.0, health - (amount - absorbed))
    if health <= 0.0:
        get_tree().reload_current_scene()
