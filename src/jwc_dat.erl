-module(jwc_dat).
-behaviour(gen_server).

%% @todo don't loose the table

-define(dbg(F, A),	io:format("[debug] " ++ F ++ "\n", A)).

-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).


start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
	GamesDir = filename:join(code:priv_dir(jwc),"games"),
	?dbg("Reading games dir ~p",[GamesDir]),
	{ok,Files} = file:list_dir(GamesDir),
	GamesData = [load_file(filename:join(GamesDir,F)) || F <- Files],
	?dbg("Ring initialized with Data :\n~p",[GamesData]),
	T = ets:new(?MODULE,[named_table]),
	true = ets:insert_new(T,GamesData),
	{ok,T}.

handle_call(_Request, _From, State) ->
    {reply, ignored, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% Internal functions

load_file(Filename) ->
	?dbg("Loading file ~p",[Filename]),
	{ok,Bin} = file:read_file(Filename),
	Data = jsx:decode(Bin),
	ID = list_to_atom(binary_to_list(lkup(<<"id">>,Data))),
	?dbg("Decoded JSON for game ID=~p :\n ~p",[ID,Data]),
	{ID,Data}.

lkup(K,L) ->
	{K,V} = lists:keyfind(K,1,L),
	V.
lkup(K,L,Def) ->
	try lkup(K,L)
	catch _:_ -> Def
	end.
