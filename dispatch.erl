-module(dispatch).
-export([launch_receiver/0, msg_receiver/0, make/2, turn/2, move/1, rest/1]).

launch_receiver() -> 
	spawn(?MODULE, msg_receiver, []).

msg_receiver() ->
	receive
		{Pid, "i moved!"} -> 
			io:format("~p moved ~n",[Pid]),
			msg_receiver();
		{Pid, "i turned left!"} -> 
			io:format("~p turned left ~n",[Pid]),
			msg_receiver();
		{Pid, "i turned right!"} ->  
			io:format("~p turned right ~n",[Pid]),
			msg_receiver();
		{Pid, "going to rest!"} ->  
			io:format("~p resting ~n",[Pid]),
			msg_receiver();
		_ ->
			msg_receiver()
	end.

make(State, MsgReceiver) -> 
	spawn(robot, loop, [State, MsgReceiver]).

turn(RobotName, Direction) ->
	RobotName ! {turn, Direction}.

move(RobotName) ->
	RobotName ! step.

rest(RobotName) ->
	RobotName ! rest.