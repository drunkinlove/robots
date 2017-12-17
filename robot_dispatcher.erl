-module(robot_dispatcher).
-behavior(gen_server).
-export([make/2, turn/2, move/1, rest/1]).
-export([init/1, start_link/0, handle_call/3, handle_cast/2]).


%%% Callback functions


init(_Args) -> {ok, _Args}.


handle_call({make, RobotName, {X, Y}}, _From, StateMap) ->
	case cell_free(X, Y, StateMap) of
		true ->
			supervisor:start_child(
							robot_gsup,
							#{id => robot, 
							start => {robot, start_link, [{RobotName, X, Y, south, 10}, self()]}}
					      ),
			{
			 	reply, 
			 	{created, {RobotName, X, Y}}, 
			 	StateMap#{RobotName => {X, Y, south, 10}}
			};
		false ->
			{reply, cell_taken, StateMap}
	end;
handle_call({turn, RobotName, Direction}, _From, StateMap) ->
	RobotName ! {turn, Direction},
	{reply, {turned, RobotName}, update(StateMap)};
handle_call({move, RobotName}, _From, StateMap) ->
	RobotName ! move,
	{reply, {moved, RobotName}, update(StateMap)};
handle_call({rest, RobotName}, _From, StateMap) ->
	RobotName ! rest,
	{reply, {destroyed, RobotName}, update(StateMap)}.


handle_cast(_, StateMap) ->
	{noreply, StateMap}.


%%% Pass commands to server


start_link() -> 
	gen_server:start_link({global, robot_dispatcher}, 
						   ?MODULE, 
						   [#{}], 
						   []).


make(RobotName, {X, Y}) ->
	gen_server:call(robot_dispatcher, {make, RobotName, {X, Y}}).


turn(RobotName, Direction) ->
	gen_server:call(robot_dispatcher, {turn, RobotName, Direction}).


move(RobotName) ->
	gen_server:call(robot_dispatcher, {move, RobotName}).


rest(RobotName) ->
	gen_server:call(robot_dispatcher, {rest, RobotName}).


%%% Internal


update(StateMap) ->
	receive
		{Name, X, Y, Direction, Energy} ->
			StateMap#{Name := {X, Y, Direction, Energy}};
		{Name, _} ->
			StateMap#{Name := resting};
		_ ->
			error
	end.


cell_free(X, Y, StateMap) ->
	case [bot || {_, A, B, _, _} <- maps:values(StateMap), A =:= X, B =:= Y] of
		[] -> true;
		_ -> false
	end.

check_collision(StateMap) ->
	CoordList = [{X, Y} || {_, X, Y, _, _} <- maps:values(StateMap)],
	length(CoordList) =/= sets:size(sets:from_list(CoordList)).

%check_energy(StateMap) ->
%	[{((7 - X) + (7 - Y)) = Energy, Name} || {Name, X, Y, _, Energy} <- maps:values(StateMap)].




