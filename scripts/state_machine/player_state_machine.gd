class_name StateMachine extends Node2D

var states : Array[PlayerState]
var curr_state : PlayerState :
	get : return states.front()
var prev_state : PlayerState :
	get : return states[1]
var player : Player

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func _process( _delta: float ) -> void:
	curr_state.direction = Vector2(
		sign ( Input.get_axis( "MoveLeft", "MoveRight" ) ),
		sign ( Input.get_axis( "MoveDown", "MoveUp" ) )
	)
	var new_state = curr_state.process( _delta )
	change_state( new_state )

func _physics_process( _delta: float ) -> void:
	var new_state = curr_state.physics_process( _delta )
	change_state( new_state )

func _unhandled_input( _event: InputEvent ) -> void:
	var new_state = curr_state.handle_input( _event )
	change_state( new_state )
	
func change_state( new_state : PlayerState ) -> void:
	if new_state == null || new_state == curr_state: return
	curr_state.exit()
	states.push_back( curr_state )
	states.push_front( new_state )
	new_state.enter()
	states.resize( 2 )

func init( _player : Player) -> void:
	player = _player
	states = []
	for node in get_children():
		if node is PlayerState:
			states.append(node)
	
	if states.size() == 0:
		return
	
	curr_state.player = player
	curr_state.state_machine = self
	
	for state in states:
		state.init()
	
	change_state( curr_state )
	process_mode = Node.PROCESS_MODE_INHERIT

func is_state(state: Node) -> bool:
	return curr_state == state
