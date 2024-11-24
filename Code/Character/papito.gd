extends CharacterBody2D

const SPEED = 300.0  # Velocidad de movimiento del personaje.
const JUMP_VELOCITY = -400.0  # Velocidad de salto.

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")  # Obtiene la gravedad predeterminada del proyecto.

@onready var sprite = $AnimatedSprite2D  # Referencia al nodo AnimatedSprite2D del personaje.

var health = 3  # Salud del personaje.
var is_attacking = false  # Indica si el personaje está atacando.
var is_jumping = false  # Indica si el personaje está saltando.
var is_taking_damage = false  # Indica si el personaje está tomando daño.

func _ready():
	up_direction = Vector2.UP

func _physics_process(delta):
	_apply_gravity(delta)
	_handle_movement()
	_handle_jump()
	_handle_attack()
	_update_animation()
	move_and_slide()

# Aplica la gravedad al personaje, ajustando su velocidad vertical según el estado de colisión con el suelo.
func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		is_jumping = false

# Maneja el movimiento del personaje en función de las teclas presionadas (izquierda o derecha).
func _handle_movement():
	var direction = _get_direction()
	velocity.x = direction * SPEED
	if direction != 0:
		sprite.flip_h = direction < 0

# Obtiene la dirección de movimiento según las teclas presionadas.
func _get_direction() -> int:
	var direction = 0
	if Input.is_action_pressed("Right"):
		direction += 1
	if Input.is_action_pressed("Left"):
		direction -= 1
	return direction

# Maneja el salto, activando la acción de salto solo si el personaje está en el suelo.
func _handle_jump():
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		if sprite and not is_attacking:
			sprite.play("Jump")

# Maneja la acción de ataque, asegurándose de que no se pueda realizar otro ataque hasta que el anterior termine.
func _handle_attack():
	if Input.is_action_just_pressed("Attack") and not is_attacking:
		is_attacking = true
		if sprite:
			sprite.play("Attack")
		await sprite.animation_finished
		is_attacking = false

# Actualiza la animación del personaje según su estado (saltando, caminando, en reposo).
func _update_animation():
	if is_attacking:
		return
	if not is_on_floor():
		if sprite.animation != "Jump" and is_jumping:
			sprite.play("Jump")
	elif velocity.x != 0:
		if sprite.animation != "Walk":
			sprite.play("Walk")
	else:
		if sprite.animation != "Idle":
			sprite.play("Idle")

# Maneja el daño recibido por el personaje, reduciendo su salud y aplicando una animación de daño.
func take_damage(from_direction: int) -> void:
	if is_taking_damage:
		return
	is_taking_damage = true
	health -= 1
	_apply_damage_effect()
	if health <= 0:
		get_tree().reload_current_scene()
	else:
		_reset_damage_state_after_delay()

# Aplica un efecto visual de parpadeo al personaje cuando recibe daño.
func _apply_damage_effect() -> void:
	for i in range(6):
		await get_tree().create_timer(0.1).timeout
		sprite.visible = not sprite.visible
	sprite.visible = true

# Resetea el estado de daño después de un pequeño retraso.
func _reset_damage_state_after_delay() -> void:
	await get_tree().create_timer(0.3).timeout
	is_taking_damage = false
