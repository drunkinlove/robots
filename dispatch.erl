-module(dispatch).
-export([launchdisp/0, make/1, turn/2, move/1, rest/1]).

launchdisp() -> 
	spawn(dispatch, msgreceiver, []).

msgreceiver() ->
	receive
		{Pid, step} -> 
			io:format("~p moved ~n",[Pid]),
			msgreceiver();
		{Pid, "i turned left!"} -> 
			io:format("~p turned left ~n",[Pid]),
			msgreceiver();
		{Pid, "i turned right!"} ->  
			io:format("~p turned right ~n",[Pid]),
			msgreceiver();
		{Pid, "going to rest!"} ->  
			io:format("~p resting ~n",[Pid]),
			msgreceiver()
	end.

make(State) -> 
	spawn(robot, loop, [State]).

turn(RobotName, Direction) ->
	RobotName ! {self(), turn, Direction}.

move(RobotName) ->
	RobotName ! {self(), step}.

rest(RobotName) ->
	RobotName ! {self(), rest}.