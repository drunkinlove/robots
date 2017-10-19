-module(robot).
-export([loop/2]).


loop({X, Y, Direction, Energy}, MsgReceiver) ->
	receive
		step -> 
			MsgReceiver ! {self(), "i moved!"},
			case Direction of
				north -> loop({X, Y - 1, Direction, Energy - 1}, MsgReceiver);
				west ->  loop({X - 1, Y, Direction, Energy - 1}, MsgReceiver);
				east -> loop({X + 1, Y, Direction, Energy - 1}, MsgReceiver);
				south -> loop({X, Y + 1, Direction, Energy - 1}, MsgReceiver)
			end;
		{turn, right} -> 
			MsgReceiver ! {self(), "i turned right!"},
			case Direction of
				north -> loop({X, Y, east, Energy}, MsgReceiver);
				west ->  loop({X, Y, north, Energy}, MsgReceiver);
				east -> loop({X, Y, south, Energy}, MsgReceiver);
				south -> loop({X, Y, west, Energy}, MsgReceiver)
			end;
		{turn, left} ->
			MsgReceiver ! {self(), "i turned left!"}, 
			case Direction of
				north -> loop({X, Y, west, Energy}, MsgReceiver);
				west ->  loop({X, Y, south, Energy}, MsgReceiver);
				east -> loop({X, Y, north, Energy}, MsgReceiver);
				south -> loop({X, Y, east, Energy}, MsgReceiver)
			end;
		rest -> 
			MsgReceiver ! {self(), "going to rest!"};
		_ ->
			loop({X, Y, Direction, Energy}, MsgReceiver)
	end.
		
		

