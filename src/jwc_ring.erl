-module(jwc_ring).
-behaviour(gen_server).
-include_lib("stdlib/include/ms_transform.hrl").

-define(dbg(F, A),	io:format("[debug] " ++ F ++ "\n", A)).


-export([start_link/0]).
-export([next/0]).

%% gen_server callbacks
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2
					,code_change/3]).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

next() ->
	gen_server:call(?MODULE,next).

%% -- Callbacks -----------------------------------------------------

init([]) ->
	GetAllKeys = ets:fun2ms(fun({K,_}) -> K end),
	?dbg("Get all keys matchspec: ~p",[GetAllKeys]),
	AllKeys = ets:select(jwc_dat,GetAllKeys),
	?dbg("AllKeys = ~p",[AllKeys]),
	{ok,{AllKeys,[]}}.

handle_call(next, _From, {[],Q}) ->
	handle_call(next, _From, {lists:reverse(Q),[]});
handle_call(next, _From, {[G|T],Q}) ->
	{reply, G, {T,[G|Q]}}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(_Info, State) ->
	?dbg("~p unhandled info ~p",[?MODULE,_Info]),
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.


