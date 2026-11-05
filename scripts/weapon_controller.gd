extends Node3D
class_name WeaponController

@export var magazine_size: int = 30
@export var reserve_ammo: int = 120
@export var damage: float = 34.0
@export var fire_rate: float = 0.12
@export var range_meters: float = 100.0

var ammo_in_magazine: int
var cooldown := 0.0
var reloading := false

func _ready() -> void:
    ammo_in_magazine = magazine_size

func _process(delta: float) -> void:
    cooldown = maxf(0.0, cooldown - delta)
    if Input.is_action_just_pressed("reload"):
        reload_weapon()
    if Input.is_action_pressed("fire"):
        fire()

func fire() -> void:
    if cooldown > 0.0 or reloading:
        return
    if ammo_in_magazine <= 0:
        reload_weapon()
        return
    ammo_in_magazine -= 1
    cooldown = fire_rate
    var camera := get_viewport().get_camera_3d()
    if camera == null:
        return
    var origin := camera.global_position
    var target := origin - camera.global_transform.basis.z * range_meters
    var query := PhysicsRayQueryParameters3D.create(origin, target)
    query.exclude = [get_parent()]
    var hit := get_world_3d().direct_space_state.intersect_ray(query)
    if hit and hit.collider.has_method("take_damage"):
        hit.collider.take_damage(damage)
    elif hit and hit.collider.get_parent() and hit.collider.get_parent().has_method("take_damage"):
        hit.collider.get_parent().take_damage(damage)

func reload_weapon() -> void:
    if reloading or ammo_in_magazine == magazine_size or reserve_ammo <= 0:
        return
    reloading = true
    await get_tree().create_timer(1.5).timeout
    var needed := magazine_size - ammo_in_magazine
    var loaded := mini(needed, reserve_ammo)
    ammo_in_magazine += loaded
    reserve_ammo -= loaded
    reloading = false
