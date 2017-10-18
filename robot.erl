-module(robot).
-export([loop/1]).


loop({X, Y, Direction, Energy}) ->
	receive
		{From, step} -> 
			From ! {self(), "i moved!"},
			case Direction of
				north -> loop({X, Y - 1, Direction, Energy - 1});
				west ->  loop({X - 1, Y, Direction, Energy - 1});
				east -> loop({X + 1, Y, Direction, Energy - 1});
				south -> loop({X, Y + 1, Direction, Energy - 1})
			end;
		{From, turn, right} -> 
			From ! {self(), "i turned right!"},
			case Direction of
				north -> loop({X, Y, east, Energy});
				west ->  loop({X, Y, north, Energy});
				east -> loop({X, Y, south, Energy});
				south -> loop({X, Y, west, Energy})
			end;
		{From, turn, left} ->
			From ! {self(), "i turned left!"}, 
			case Direction of
				north -> loop({X, Y, west, Energy});
				west ->  loop({X, Y, south, Energy});
				east -> loop({X, Y, north, Energy});
				south -> loop({X, Y, east, Energy})
			end;
		{From, rest} -> 
			From ! {self(), "going to rest!"}
	end.
		
		

