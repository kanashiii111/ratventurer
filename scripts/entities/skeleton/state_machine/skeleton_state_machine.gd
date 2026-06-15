class_name SkeletonStateMachine extends Node2D

var states : Array[SkeletonState]
var curr_state : SkeletonState :
	get : return states.front()
var prev_state : SkeletonState :
	get : return states[1]
var skeleton : Skeleton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func _process( _delta: float ) -> void:
	#curr_state.direction = Vector2(
		#sign ( Input.get_axis( "MoveLeft", "MoveRight" ) ),
		#sign ( Input.get_axis( "MoveDown", "MoveUp" ) )
	#) ПЕРЕПИСАТь
	var new_state = curr_state.process( _delta )
	change_state( new_state )

func _physics_process( _delta: float ) -> void:
	var new_state = curr_state.physics_process( _delta )
	change_state( new_state )

func _unhandled_input( _event: InputEvent ) -> void:
	var new_state = curr_state.handle_input( _event )
	change_state( new_state )

func change_state( new_state : SkeletonState ) -> void:
	if new_state == null: return
	if new_state == curr_state:
		curr_state.exit()
		curr_state.enter()
		return
	curr_state.exit()
	states.push_back( curr_state )
	states.push_front( new_state )
	new_state.enter()
	states.resize( 2 )

func init( _skeleton : Skeleton ) -> void:
	skeleton = _skeleton
	states = []
	for node in get_children():
		if node is SkeletonState:
			states.append(node)
	
	if states.size() == 0:
		return
	
	for state in states:
		state.skeleton = skeleton
		state.state_machine = self
		state.init()
	
	change_state( curr_state )
	process_mode = Node.PROCESS_MODE_INHERIT

func is_state(state: Node) -> bool:
	return curr_state == state
