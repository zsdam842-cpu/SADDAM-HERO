extends CanvasLayer

@onready var status: Label = $Status

func _process(_delta: float) -> void:
    var player := get_tree().get_first_node_in_group("player")
    var manager := get_tree().current_scene
    if player and manager:
        var weapon := player.get_node_or_null("Weapon")
        if weapon:
            status.text = "SADDAM HERO   |   HP %d   ARM %d   |   AMMO %d / %d   |   KILLS %d" % [
                int(player.health), int(player.armor), weapon.ammo_in_magazine,
                weapon.reserve_ammo, manager.eliminations
            ]
