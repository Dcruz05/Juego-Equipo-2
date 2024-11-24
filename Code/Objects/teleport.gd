extends Area2D

# Función que se ejecuta cuando el nodo está listo.
func _ready():
	pass

# Función que se ejecuta cuando un cuerpo entra en el área de teletransporte.
# Si el cuerpo es "papito", cambia la escena a "inside.tscn".
func _on_body_entered(body):
	if body.name == "papito":  # Verifica si el cuerpo es "papito".
		get_tree().change_scene_to_file("res://Scenes/Levels/inside.tscn")  # Cambia la escena.
