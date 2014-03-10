-module(jwc_web).

-export([http_setup/0,out/1]).
-define(dbg(F, A),	io:format("[debug] " ++ F ++ "\n", A)).

http_setup() ->
	PrivDir =
		fun(Mod) ->
			Ebin = filename:dirname(code:which(Mod)),
			filename:join(filename:dirname(Ebin), "priv")
		end,
	SL =
		[ {servername, "localhost"},
		  {listen, {0,0,0,0}},
		  {appmods, [{"/", ?MODULE}]}
		],
	GL =
		[ {cache_refresh_secs,1},
		  {logdir, "log"}
		],
	ok = application:start(gproc),
	yaws:start_embedded(".",SL,GL).

out(Arg) ->
	Req = yaws_api:arg_req(Arg),
	{abs_path,AbsPath} = yaws_api:http_request_path(Req),
	DecPath = yaws_api:url_decode(AbsPath),
	{PrePath,_} = yaws:split_at(DecPath, $?),
	Path = string:tokens(PrePath,"/"),
	Method = yaws_api:http_request_method(Req),
	out(Arg,Method,Path).

out(Arg, 'GET', []) ->
	[{redirect_local,"/banner/next"}];

out(Arg, 'GET', ["banner","next"]) ->
	out(Arg, 'GET', ["banner","next","728x90"]);

out(Arg, 'GET', ["banner","next",LSize]) ->
	Infos = try
		Size = list_to_binary(LSize),
		App = jwc_ring:next(),
		[{status,ok},{url,lkup(Size,lkup(<<"banners">>,App))}]
	catch
		_:{badmatch,false} ->
			[{status,error},{message,<<"Bad banner size">>}]
	end,
	JSON = jsx:encode(Infos),
	[{content,"application/json",JSON}|force_reload_headers()];

out(Arg, 'GET', _Path) ->
	[{status,404}].

force_reload_headers() ->
	[ {header,"Expires: Sat, 26 Jul 1997 05:00:00 GMT"}
	, {header, {last_modified,yaws:local_time_as_gmt_string(erlang:localtime())}}
	, {header, "Cache-control: post-check=0, pre-check=0"}
	, {header, "Cache-control: no-store, no-cache, must-revalidate"}
	, {header, "Pragma: no-cache"}
	].

lkup(K,L) ->
	{K,V} = lists:keyfind(K,1,L),
	V.
