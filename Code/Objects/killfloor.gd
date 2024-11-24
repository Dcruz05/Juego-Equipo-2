extends Area2D

# Función que se ejecuta cuando el nodo está listo.
func _ready() -> void:
	pass

# Función que se ejecuta cuando un cuerpo entra en el área y verifica si es "papito".
func _on_body_entered(body: Node) -> void:
	if body.name == "papito":  # Verifica si el cuerpo es "papito".
		restart_scene()  # Reinicia la escena si es "papito".

# Función que recarga la escena actual, reiniciándola.
func restart_scene() -> void:
	get_tree().reload_current_scene()
