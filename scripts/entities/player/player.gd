class_name Player extends CharacterBody2D

@onready var player_state_machine : PlayerStateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer2D
@onready var audio_player_2 = $AudioStreamPlayer2D2
@onready var wall_detector = $WallDetector
@onready var ledge_detector = $LedgeDetector
@onready var player_collider : CollisionShape2D = $CollisionShape
@onready var attack_marker: Marker2D = $AttackSpawn
@onready var ground_slam_timer: Timer = $GroundSlamTimer
@onready var ground_slam_hitbox: Area2D = $GroundSlamHitbox

var has_dash: bool = true
var want_to_uncrouch: bool = false

const SLIDE_SHAPE_SIZE_Y: int = 12
const SLIDE_POSITION_Y: float = 5.2

const AFTER_SLIDE_SHAPE_SIZE_Y: int = 19
const AFTER_SLIDE_POSITION_Y: float = 1.75

func _ready() -> void:
	add_to_group("player")
	player_state_machine.init( self )
	
	sprite.rotation = 0
	player_collider.shape.size.y = AFTER_SLIDE_SHAPE_SIZE_Y
	player_collider.position.y = AFTER_SLIDE_POSITION_Y

#func _on_attack_collision_area_body_entered(body: Node2D) -> void:
	#if body is Skeleton and player_state_machine.is_state(%Attack):
		#print("yo")
		
func _physics_process( _delta: float ) -> void:
	$Label2.text = str(player_state_machine.player.velocity.x)
	$Label3.text = str(player_state_machine.player.velocity.y)
	$Label4.text = "prev: " + player_state_machine.prev_state.name
	gravity(_delta)
	move_and_slide()
	if is_on_floor():
		has_dash = true

func is_ceiling_above() -> bool:
	# Проверяем, впишется ли ВЫСОКИЙ коллайдер в пространство над нами
	# Смещаем проверку чуть вверх от текущей позиции
	var check_distance = abs(AFTER_SLIDE_POSITION_Y - SLIDE_POSITION_Y) + 2
	return test_move(global_transform, Vector2(0, -check_distance))

func is_at_ledge() -> bool:	
	return wall_detector.is_colliding() and not ledge_detector.is_colliding()

func gravity( _delta: float ):
	if player_state_machine.curr_state.name == "Death":
		return
	if player_state_machine.curr_state.name == "Latch":
		velocity = Vector2.ZERO
		return
	if player_state_machine.curr_state.name == "Dash":
		velocity.y = Vector2.ZERO.y
		return
	
	if not is_on_floor():
		velocity.y += get_gravity().y * _delta

func update_velocity( _to_velocity: float, _acceleration: float) -> void:
	#velocity.x = move_toward(velocity.x, _to_velocity, _acceleration)
	if sign(_to_velocity) != 0 and sign(velocity.x) != sign(_to_velocity):
		# резкое торможение при развороте (acceleration * 5)
		velocity.x = move_toward(velocity.x, _to_velocity, _acceleration * 5)
	else:
		velocity.x = move_toward(velocity.x, _to_velocity, _acceleration)
	
func update_animation_direction():
	#if self.velocity.x < 0 or sign(Input.get_axis("MoveLeft", "MoveRight")) == -1:
		#player_collider.position.x = -4
		#ledge_detector.position.x = -15
		#wall_detector.rotation = PI
		#sprite.flip_h = true
	#elif sign(Input.get_axis("MoveLeft", "MoveRight")) == 1 or self.velocity.x > 0: # or self.velocity.x > 0 or
		#player_collider.position.x = 4
		#ledge_detector.position.x = 15
		#wall_detector.rotation = 0
		#sprite.flip_h = false
	var input_dir = sign(Input.get_axis("MoveLeft", "MoveRight"))
	
	var face_left: bool
	if input_dir != 0:
		face_left = input_dir < 0
	elif self.velocity.x != 0:
		face_left = self.velocity.x < 0
	else:
		return

	player_collider.position.x = -4 if face_left else 4
	ledge_detector.position.x = -15 if face_left else 15
	wall_detector.rotation = PI if face_left else 0.0
	sprite.flip_h = face_left

func update_animation_rotation():
	if is_on_floor():
		var normal = get_floor_normal()
		var angle = normal.angle() + PI / 2
		sprite.rotation = angle * 0.5
	else:
		sprite.rotation = 0

func die() -> void:
	player_state_machine.change_state(%Death)

func play_audio( audio : AudioStream ):
	if audio == null: return
	audio_player.stream = audio
	audio_player.play()

func play_sfx(audio : AudioStream):
	if audio == null: return
	audio_player_2.stream = audio
	audio_player_2.play()
