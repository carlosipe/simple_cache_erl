-module(simple_cache_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    SupFlags = #{strategy => one_for_one, intensity => 4, period => 360},
    ElementSupSpec = #{id => simple_cache_element_sup,
                       start => {simple_cache_element_sup, start_link, []},
                       restart => permanent
                       %% type: supervisor ?
                      },
    EventManagerSpec = #{id=> simple_cache_event,
                         start => {simple_cache_event, start_link, []},
                         restart => permanent
                        },
    ChildrenSpecs = [ElementSupSpec, EventManagerSpec],
    {ok, {SupFlags, ChildrenSpecs}}.
