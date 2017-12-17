-module(robot).
-export([start_link/1, loop/2, move/2, turn/3]).


start_link(Args) -> 
	spawn_link(?MODULE, loop, Args).


loop(State, From) ->
	From ! State,
	receive
		move -> 
			move(State, From);
		{turn, Where} -> 
			turn(Where, State, From);
		rest -> 
			{Name, _, _, _} = State,
			From ! {Name, goodbye};
		_ ->
			loop(State, From)
	end.
		

move({Name, X, Y, Direction, Energy}, From) ->
	case Direction of
		north -> loop({Name, X, Y - 1, Direction, Energy - 1}, From);
		west ->  loop({Name, X - 1, Y, Direction, Energy - 1}, From);
		east -> loop({Name, X + 1, Y, Direction, Energy - 1}, From);
		south -> loop({Name, X, Y + 1, Direction, Energy - 1}, From)
	end.


turn(Where, {Name, X, Y, Direction, Energy}, From) ->
	case Where of
		left -> 
			case Direction of
				north -> loop({Name, X, Y, east, Energy}, From);
				west ->  loop({Name, X, Y, north, Energy}, From);
				east -> loop({Name, X, Y, south, Energy}, From);
				south -> loop({Name, X, Y, west, Energy}, From)
			end;
		right -> 
			case Direction of
				north -> loop({Name, X, Y, west, Energy}, From);
				west ->  loop({Name, X, Y, south, Energy}, From);
				east -> loop({Name, X, Y, north, Energy}, From);
				south -> loop({Name, X, Y, east, Energy}, From)
			end
	end.
