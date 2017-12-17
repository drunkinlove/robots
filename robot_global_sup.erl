-module(robot_global_sup).      
-behavior(supervisor).
-export([start_link/0]).
-export([init/1]).


start_link() ->
    supervisor:start_link({global, robot_gsup}, ?MODULE, []).


init(_Args) ->
        SupFlags = #{
                         strategy => one_for_one,
                         intensity => 5,
                         period => 1
                    },
        ChildSpecs = [#{
                            id => robot_dispatcher,
                            start => {robot_dispatcher, start_link, []}
                     }],
        {ok, {SupFlags, ChildSpecs}}.