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
	GetAllKeys = ets:fun2ms(fun({K,_}) -> K end),
	AllKeys = ets:select(jwc_ring_dat,GetAllKeys),
	?dbg("Gmes keys : ~p",[AllKeys]),
	case AllKeys
		of [] ->
				{error,no_data}
		 ; _ ->
				gen_server:start_link({local,?MODULE},?MODULE,[AllKeys],[])
	end.

next() ->
	Key = gen_server:call(?MODULE,next),
	[{Key,Dat}] = ets:lookup(jwc_ring_dat,Key),
	Dat.

%% -- Callbacks -----------------------------------------------------

init([AllKeys]) when is_list(AllKeys) ->
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


