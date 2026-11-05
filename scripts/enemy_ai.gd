extends CharacterBody3D
class_name TacticalEnemy

@export var move_speed: float = 2.8
@export var detection_range: float = 24.0
@export var attack_range: float = 12.0
@export var attack_damage: float = 8.0
@export var attack_interval: float = 1.2

var attack_timer := 0.0
var health := 100.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var player: Node3D

func _ready() -> void:
    player = get_tree().get_first_node_in_group("player") as Node3D

func _physics_process(delta: float) -> void:
    attack_timer = maxf(0.0, attack_timer - delta)
    if not is_on_floor():
        velocity.y -= gravity * delta
    if not is_instance_valid(player):
        player = get_tree().get_first_node_in_group("player") as Node3D
        move_and_slide()
        return
    var to_player := player.global_position - global_position
    var distance := to_player.length()
    if distance <= detection_range:
        var flat := Vector3(to_player.x, 0, to_player.z).normalized()
        if distance > attack_range:
            velocity.x = flat.x * move_speed
            velocity.z = flat.z * move_speed
            look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
        else:
            velocity.x = move_toward(velocity.x, 0.0, move_speed)
            velocity.z = move_toward(velocity.z, 0.0, move_speed)
            if attack_timer <= 0.0 and player.has_method("take_damage"):
                player.take_damage(attack_damage)
                attack_timer = attack_interval
    else:
        velocity.x = move_toward(velocity.x, 0.0, move_speed)
        velocity.z = move_toward(velocity.z, 0.0, move_speed)
    move_and_slide()

func take_damage(amount: float) -> void:
    health -= amount
    if health <= 0.0:
        queue_free()
        var manager := get_tree().current_scene
        if manager and manager.has_method("on_enemy_eliminated"):
            manager.on_enemy_eliminated()
