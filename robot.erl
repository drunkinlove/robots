-module(robot).
-compile(export_all).

%State = {X, Y, Direction, Energy}

loop({X, Y, Direction, Energy}) ->
	receive
		step -> 
			case Direction of
				north -> loop({X, Y - 1, Direction, Energy - 1}),
				west ->  loop({X - 1, Y, Direction, Energy - 1}),
				east -> loop({X + 1, Y, Direction, Energy - 1}),
				south -> loop({X, Y + 1, Direction, Energy - 1})
			end,
		{rotate, right} -> 
			case Direction of
				north -> loop({X, Y, east, Energy}),
				west ->  loop({X, Y, north, Energy}),
				east -> loop({X, Y, south, Energy}),
				south -> loop({X, Y, west, Energy})
			end.
		{rotate, left} -> 
			case Direction of
				north -> loop({X, Y, west, Energy}),
				west ->  loop({X, Y, south, Energy}),
				east -> loop({X, Y, north, Energy}),
				south -> loop({X, Y, east, Energy})
			end.

