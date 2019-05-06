-module(simple_cache).

-export([insert/2, lookup/1, delete/1]).

insert(Key, Value) ->
    case simple_cache_store:lookup(Key) of
        {ok, Pid} -> 
            simple_cache_element:replace(Pid, Value);
        {error, _} -> 
            {ok, Pid} = simple_cache_element:create(Value),
            simple_cache_store:insert(Key, Pid)
    end.

lookup(Key) ->
    try
        {ok, Pid} = simple_cache_store:lookup(Key),
        {ok, Value} = simple_cache_element:fetch(Pid),
        {ok, Value}
    catch
        _Class:_Exception ->
            {error, not_found}
    end.

delete(Key) ->
    case simple_cache_store:lookup(Key) of
        {ok, Pid} -> simple_cache_element:delete(Pid);
        {error, _Reason} -> ok
    end.
