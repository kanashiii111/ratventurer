class_name Player extends CharacterBody2D

@onready var player_state_machine : PlayerStateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer2D
@onready var wall_detector = $WallDetector
@onready var ledge_detector = $LedgeDetector
@onready var player_collider : CollisionShape2D = $CollisionShape
@onready var attack_marker: Marker2D = $AttackSpawn
@onready var ground_slam_timer: Timer = $GroundSlamTimer
@onready var attack_collision_area: Area2D = $AttackCollisionArea

var has_dash: bool = true
var want_to_uncrouch: bool = false

const SLIDE_SHAPE_SIZE_Y: int = 12
const SLIDE_POSITION_Y: float = 5.2

const AFTER_SLIDE_SHAPE_SIZE_Y: int = 19
const AFTER_SLIDE_POSITION_Y: float = 1.75

func _ready() -> void:
	player_state_machine.init( self )

#func _on_attack_collision_area_body_entered(body: Node2D) -> void:
	#if body is Skeleton and player_state_machine.is_state(%Attack):
		#print("yo")
		
func _physics_process( _delta: float ) -> void:
	$Label.text = "curr: " + player_state_machine.curr_state.name
	$Label2.text = str(player_state_machine.player.velocity.x)
	$Label3.text = str(player_state_machine.player.velocity.y)
	$Label4.text = "prev: " + player_state_machine.prev_state.name
	gravity(_delta)
	move_and_slide()

func is_ceiling_above() -> bool:
	# Проверяем, впишется ли ВЫСОКИЙ коллайдер в пространство над нами
	# Смещаем проверку чуть вверх от текущей позиции
	var check_distance = abs(AFTER_SLIDE_POSITION_Y - SLIDE_POSITION_Y) + 2
	return test_move(global_transform, Vector2(0, -check_distance))

func is_at_ledge() -> bool:	
	return wall_detector.is_colliding() and not ledge_detector.is_colliding()

func gravity( _delta: float ):
	if player_state_machine.curr_state.name == "Latch":
		velocity = Vector2.ZERO
		return
	if player_state_machine.curr_state.name == "Dash":
		velocity.y = Vector2.ZERO.y
		return
	
	if not is_on_floor():
		velocity.y += get_gravity().y * _delta

func update_velocity( _to_velocity: float, _acceleration: float) -> void:
	velocity.x = move_toward(velocity.x, _to_velocity, _acceleration)
	
func update_animation_direction():
	if self.velocity.x < 0 or sign(Input.get_axis("MoveLeft", "MoveRight")) == -1:
		attack_collision_area.scale.x = -1
		attack_collision_area.position.x = -3
		player_collider.position.x = -4
		ledge_detector.position.x = -15
		wall_detector.rotation = PI
		sprite.flip_h = true
	elif sign(Input.get_axis("MoveLeft", "MoveRight")) == 1 or self.velocity.x > 0: # or self.velocity.x > 0 or
		attack_collision_area.scale.x = 1
		attack_collision_area.position.x = 3
		player_collider.position.x = 4
		ledge_detector.position.x = 15
		wall_detector.rotation = 0
		sprite.flip_h = false

func update_animation_rotation():
	if is_on_floor():
		var normal = get_floor_normal()
		var angle = normal.angle() + PI / 2
		sprite.rotation = angle * 0.5
	else:
		sprite.rotation = 0

func play_audio( audio : AudioStream ):
	if audio == null:
		return
	audio_player.stream = audio
	audio_player.play()
