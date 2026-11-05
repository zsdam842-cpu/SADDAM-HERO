extends Node
class_name HealthComponent

@export var max_health: float = 100.0
var current_health: float

func _ready() -> void:
    current_health = max_health

func apply_damage(amount: float) -> bool:
    current_health = maxf(0.0, current_health - maxf(0.0, amount))
    return current_health <= 0.0
