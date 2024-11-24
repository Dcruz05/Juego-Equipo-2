extends Area2D

var is_activated: bool = false  # Indica si la palanca está activada o no.
@onready var animated_sprite = $AnimatedSprite2D  # Referencia al nodo AnimatedSprite2D de la palanca.
@onready var end_node = $"../End"  # Referencia al nodo "End", que se activará cuando la palanca se active.

# Función que se ejecuta cuando un cuerpo entra en el área de la palanca.
func _on_body_entered(body: Node) -> void:
	if _can_activate_lever(body):  # Verifica si el cuerpo puede activar la palanca.
		_activate_lever()  # Activa la palanca.

# Función que verifica si el cuerpo es "papito" y si la palanca no está activada.
func _can_activate_lever(body: Node) -> bool:
	return !is_activated and body.name == "papito"

# Función que activa la palanca, reproduce la animación de activación y actualiza el nodo de finalización.
func _activate_lever() -> void:
	if animated_sprite:
		animated_sprite.play("activated")  # Reproduce la animación de activación.
	is_activated = true  # Marca la palanca como activada.
	_update_end_node_collision()  # Actualiza las colisiones del nodo de finalización.

# Función que actualiza las colisiones del nodo "End" para habilitar su interacción.
func _update_end_node_collision() -> void:
	if end_node is CollisionObject2D:  # Verifica que el nodo de finalización sea un objeto de colisión.
		end_node.collision_layer = 1  # Asigna una capa de colisión.
		end_node.collision_mask = 1  # Asigna una máscara de colisión.
		print("Collision layer y mask cambiados para el nodo 'end'.")
