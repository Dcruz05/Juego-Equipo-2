extends CharacterBody2D

const SPEED = 100.0  # Velocidad del enemigo.
const DAMAGE_COOLDOWN = 1.0  # Tiempo de espera antes de que el enemigo pueda hacer daño de nuevo.

var direction: int = 1  # Dirección en la que se mueve el enemigo (1 = derecha, -1 = izquierda).
var is_paused: bool = false  # Indica si el enemigo está en pausa debido al cooldown.
var cooldown_elapsed: float = 0.0  # Tiempo que ha pasado en el cooldown.

func _physics_process(delta: float) -> void:
	_handle_pause(delta)
	if not is_paused:
		_move_enemy()
		_check_collisions()

# Esta función maneja la pausa, incrementando el tiempo de cooldown si está en pausa y reactivando al enemigo después del cooldown.
func _handle_pause(delta: float) -> void:
	if is_paused:
		cooldown_elapsed += delta
		if cooldown_elapsed >= DAMAGE_COOLDOWN:
			is_paused = false

# Mueve al enemigo según su dirección, utilizando su velocidad y aplicando el movimiento en el plano 2D.
func _move_enemy() -> void:
	velocity.x = direction * SPEED
	move_and_slide()

# Verifica las colisiones del enemigo con Papito o con las paredes y maneja las acciones correspondientes.
func _check_collisions() -> void:
	if _is_colliding_with_papito():
		_handle_collision_with_papito()
	elif _is_colliding_with_wall():
		_reverse_direction()

# Detecta si el enemigo está colisionando con un objeto llamado "papito".
func _is_colliding_with_papito() -> bool:
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "papito":
			return true
	return false

# Si el enemigo colisiona con Papito, le hace daño y entra en un periodo de cooldown.
func _handle_collision_with_papito() -> void:
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "papito":
			var papito = collision.get_collider() as CharacterBody2D
			if papito and papito.has_method("take_damage"):
				papito.take_damage(direction)  # Aplica daño a Papito.
				_pause_for_cooldown()  # Pausa al enemigo para el cooldown.
			break

# Activa la pausa del enemigo y resetea el tiempo de cooldown.
func _pause_for_cooldown() -> void:
	is_paused = true
	cooldown_elapsed = 0.0

# Detecta si el enemigo está colisionando con una pared (cualquier objeto en su camino).
func _is_colliding_with_wall() -> bool:
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision:
			return true
	return false

# Si el enemigo colisiona con una pared, invierte su dirección de movimiento.
func _reverse_direction() -> void:
	direction *= -1
