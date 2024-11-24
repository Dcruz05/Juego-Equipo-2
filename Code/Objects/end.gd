extends Area2D

var is_open: bool = false  # Indica si el área está abierta o no.

# Función que se ejecuta cuando el nodo está listo.
func _ready() -> void:
	pass

# Función que se ejecuta cuando un cuerpo entra en el área, y verifica si es "papito".
func _on_body_entered(body: Node2D) -> void:
	if _is_papito(body):  # Verifica si el cuerpo es "papito".
		_finish_level()  # Finaliza el nivel.

# Función que verifica si el cuerpo es "papito".
func _is_papito(body: Node2D) -> bool:
	return body.name == "papito"

# Función que termina el nivel. **MEJORAR PARA FINALIZAR VISUALMENTE**
func _finish_level() -> void:
	print("Nivel terminado!")
