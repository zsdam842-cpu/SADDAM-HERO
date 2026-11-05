extends Node3D
class_name GameManager
var eliminations := 0
var mission_name := "OPERATION: FIRST LIGHT"
func _ready() -> void:
    var env := Environment.new()
    env.background_mode = Environment.BG_SKY
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color(0.38, 0.42, 0.46)
    env.ambient_light_energy = 0.7
    var world_env := get_node_or_null("WorldEnvironment") as WorldEnvironment
    if world_env:
        world_env.environment = env
func on_enemy_eliminated() -> void:
    eliminations += 1
