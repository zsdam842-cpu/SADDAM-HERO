extends Node3D
class_name GameManager

var eliminations := 0
var mission_name := "OPERATION: FIRST LIGHT"

func _ready() -> void:
	var sky_material := ProceduralSkyMaterial.new()
	sky_material.sky_top_color = Color(0.18, 0.32, 0.55)
	sky_material.sky_horizon_color = Color(0.64, 0.72, 0.79)
	sky_material.ground_horizon_color = Color(0.48, 0.5, 0.44)
	sky_material.ground_bottom_color = Color(0.12, 0.14, 0.12)

	var sky := Sky.new()
	sky.sky_material = sky_material

	var env := Environment.new()
	env.background_mode = Environment.BG_SKY
	env.sky = sky
	env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	env.ambient_light_energy = 0.9
	env.fog_enabled = true
	env.fog_light_color = Color(0.62, 0.67, 0.72)
	env.fog_density = 0.01

	var world_env := get_node_or_null("WorldEnvironment") as WorldEnvironment
	if world_env:
		world_env.environment = env

func on_enemy_eliminated() -> void:
	eliminations += 1
