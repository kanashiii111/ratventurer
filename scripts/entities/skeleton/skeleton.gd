class_name Skeleton extends CharacterBody2D

@onready var skeleton_state_machine : SkeletonStateMachine = $StateMachine
@onready var skeleton_collider : CollisionShape2D = $CollisionShape
@onready var player_detection_area : Area2D = $PlayerDetectionArea
@onready var player_attack_area : Area2D = $PlayerAttackArea

@onready var chase_state: SkeletonState = $StateMachine/Chase
@onready var idle_state: SkeletonState = $StateMachine/Idle
@onready var attack_state: SkeletonState = $StateMachine/Attack
@onready var walk_state: SkeletonState = $StateMachine/Walk

@onready var player : CharacterBody2D = get_parent().get_node("Player")

@onready var sprite : Sprite2D = $Sprite

func _ready() -> void:
	skeleton_state_machine.init( self )
	skeleton_state_machine.change_state(walk_state)
	#player_detection_area.body_entered.connect(_on_player_detection_area_body_entered)
	#player_detection_area.body_exited.connect(_on_player_detection_area_body_exited)
	#player_attack_area.body_entered.connect(_on_player_attack_area_body_entered)
	#player_attack_area.body_exited.connect(_on_player_attack_area_body_exited)

func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if body == player:
		skeleton_state_machine.change_state(chase_state)

func _on_player_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		skeleton_state_machine.change_state(walk_state)

func _on_player_attack_area_body_entered(body: Node2D) -> void:
	if body == player:
		skeleton_state_machine.change_state(attack_state)

func _on_player_attack_area_body_exited(body: Node2D) -> void:
	if body == player:
		skeleton_state_machine.change_state(chase_state)

func _physics_process( _delta: float ) -> void:
	gravity(_delta)
	move_and_slide()
	$VerticalVelocityLabel.text = str(skeleton_state_machine.skeleton.velocity.y)
	$HorizontalVelocityLabel.text = str(skeleton_state_machine.skeleton.velocity.x)
	$PrevStateLabel.text = "prev: " + skeleton_state_machine.prev_state.name
	$CurrStateLabel.text = "curr: " + skeleton_state_machine.curr_state.name

func gravity( _delta: float ):
	if not is_on_floor():
		velocity.y += get_gravity().y * _delta

func update_velocity( _to_velocity: float, _acceleration: float) -> void:
	velocity.x = move_toward(velocity.x, _to_velocity, _acceleration)

func update_animation_direction():
	if self.velocity.x > 0:
		sprite.flip_h = true
	if self.velocity.x < 0:
		sprite.flip_h = false
