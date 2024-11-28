extends CharacterBody2D

const SPEED = 200.0  # Velocidad horizontal del personaje
const JUMP_VELOCITY = -400.0  # Velocidad del salto (negativa porque va hacia arriba)
const STAND_TO_IDLE_DELAY = 0.5  # Tiempo antes de pasar de "stand" a "idle"
const DUCK_DURATION = 0.2  # Duración de la animación "duck" al aterrizar después de un salto o caída

@export var damage: int = 50
var max_health = 100  # Vida máxima del jugador
var current_health = max_health  # Vida actual del jugador
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D  # Referencia al sprite animado del personaje
@onready var area_ataque = $areaAtaque/Melee 
@onready var area_ataque2 = $areaAtaque/Melee2
@onready var health_bar: ProgressBar = $ProgressBar 


# Variables de estado
var stand_timer = 0.0  # Temporizador para cambiar de "stand" a "idle"
var duck_timer = 0.0  # Temporizador para controlar la duración de la animación "duck"
var was_in_air = false  # Indica si el personaje estaba en el aire (por salto o caída)
var is_ducking = false  # Indica si el personaje está actualmente agachado
var landed_from_jump = false  # Indica si el personaje acaba de aterrizar de un salto o caída
var attack : bool = false  # Controla si el personaje está en estado de ataque


# Función principal del ciclo de físicas que se ejecuta cada frame
func _physics_process(delta):
	
	handle_gravity(delta)  # Aplicar la gravedad si no está en el suelo
	handle_movement(delta)  # Controlar el movimiento horizontal
	handle_jump()  # Verificar si el personaje salta
	handle_manual_duck()  # Manejar el agachado manual con la tecla abajo
	handle_landing(delta)  # Verificar y manejar el aterrizaje después de un salto o caída
	move_and_slide()  # Mover el personaje y aplicar la física de colisiones

 #Aplica la gravedad cuando el personaje está en el aire
func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

# Controla el movimiento horizontal del personaje, según la dirección y si está agachado o acaba de aterrizar
func handle_movement(delta):
	var direction = Input.get_axis("ui_left", "ui_right")  # Obtener la dirección de entrada (izquierda/derecha)
	
	if direction != 0 and not is_ducking and not landed_from_jump: 
		# Mover el personaje en la dirección ingresada si no está agachado o aterrizando
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0  # Voltear el sprite si se mueve a la izquierda
		if is_on_floor() and not is_ducking and attack == false:
			sprite.play("Walk")  # Reproducir la animación de caminar
		reset_timers()  # Reiniciar los temporizadores cuando se mueve
	else:
		# Detener el movimiento horizontal gradualmente
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and not is_ducking and not landed_from_jump:
			handle_idle_transition(delta)  # Controlar la transición a "idle" si no se mueve

# Verifica si el personaje debe saltar
func handle_jump():
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		# Asignar la velocidad de salto en el eje Y (negativa para moverse hacia arriba)
		velocity.y = JUMP_VELOCITY
		
		
	pass

# Maneja el agachado manual con la tecla hacia abajo
func handle_manual_duck():
	if Input.is_action_pressed("ui_down") and is_on_floor():
		# Si el jugador presiona la tecla abajo y está en el suelo, se agacha
		is_ducking = true
		sprite.play("duck")
	else:
		# Si no está presionando hacia abajo o no está en el suelo, deja de agacharse
		is_ducking = false
	pass

# Controla el aterrizaje después de un salto o caída
func handle_landing(delta):
	if not was_in_air and not is_on_floor():
		# Si el personaje estaba en el suelo y ahora está en el aire (saltando o cayendo)
		was_in_air = true
		
	elif was_in_air and is_on_floor():
		# Si estaba en el aire y aterriza en el suelo
		landed_from_jump = true
		was_in_air = false  # Ahora está en el suelo
		duck_timer = DUCK_DURATION  # Inicia el temporizador de la animación de "duck"
		sprite.play("duck")  # Reproduce la animación de agacharse al aterrizar

	if landed_from_jump:
		# Si aterrizó, decrementa el temporizador de "duck"
		duck_timer -= delta
		if duck_timer <= 0.0:
			# Si se acaba el temporizador, vuelve al estado normal
			landed_from_jump = false
			sprite.play("Idle")  # Cambia a la animación de "idle"
	pass

# Controla la transición de "stand" a "idle" si el personaje está quieto
func handle_idle_transition(delta):
	# Implementar la transición a "idle" aquí
	if is_on_floor() and velocity.x == 0 and not is_ducking:
		# Iniciar o incrementar el temporizador "stand" para la transición a "idle"
		stand_timer += delta
		
		# Si el temporizador supera el retraso, cambiar a la animación "idle"
		if stand_timer >= STAND_TO_IDLE_DELAY and attack == false:
			sprite.play("Idle")
	pass
	

func _process(delta):
	if Input.is_action_just_pressed("Attack"):
		area_ataque.disabled = false
		area_ataque2.disabled = false
		
		
		atacar_ctrl()
	pass
	
func atacar_ctrl():
	attack = true
	sprite.play("Attack")
	await (sprite.animation_finished)
	attack = false
	area_ataque.disabled = true
	area_ataque2.disabled = true
	
	
	pass
# Reinicia todos los temporizadores y estados
func reset_timers():
	stand_timer = 0.0  # Reinicia el temporizador de "stand" a "idle"
	duck_timer = 0.0   # Reinicia el temporizador de agachado
	landed_from_jump = false  # Resetea el estado de aterrizaje
	is_ducking = false  # Resetea el estado de agachado
	
	pass


func _on_area_ataque_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(damage)
	pass # Replace with function body.
	
# Nueva función para recibir daño
# Nueva función para recibir daño
func take_damage(damage_amount):
	if current_health > 0:
		current_health -= damage_amount
		health_bar.value = current_health  # Actualiza la barra de vida

		# Si la vida llega a 0, llamar a la función morir
		if current_health <= 0:
			die()

# Controla la muerte del personaje
func die():
	
	set_process(false)  # Desactiva el _process para evitar más acciones
	set_physics_process(false)  # Desactiva el _physics_process también
	get_tree().change_scene_to_file("res://Scenes/Levels/gameOver.tscn")
pass
	# Aquí puedes agregar lógica adicional como mostrar una pantalla de Game Over o reiniciar el nivel
# Función para curar al jugador
func heal(amount):
	# Aumenta la salud actual en la cantidad especificada, sin superar la salud máxima
	current_health = min(current_health + amount, max_health)
	
	# Actualiza la barra de salud en la interfaz
	health_bar.value = current_health

	# Imprimir el estado actual de la salud (opcional)
	print("Salud del jugador: ", current_health)
