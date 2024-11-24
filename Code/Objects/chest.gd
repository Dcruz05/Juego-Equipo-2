extends Area2D

var is_open: bool = false  # Indica si el cofre ya está abierto o no.
@onready var animated_sprite = $AnimatedSprite2D  # Referencia al nodo AnimatedSprite2D del cofre.

# Función que se ejecuta cuando un cuerpo entra en el área del cofre. Si se cumplen las condiciones, se abre el cofre.
func _on_body_entered(body: Node) -> void:
	if _can_open_chest(body):
		_open_chest()

# Función que verifica si el cofre puede abrirse. El cofre solo se puede abrir si no está abierto y el cuerpo que entra es "papito".
func _can_open_chest(body: Node) -> bool:
	return !is_open and body.name == "papito"

# Función que abre el cofre, reproduciendo la animación de apertura y marcando el cofre como abierto.
func _open_chest() -> void:
	animated_sprite.play("open")
	is_open = true
