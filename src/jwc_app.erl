-module(jwc_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
	jwc_web:http_setup(),
	jwc_sup:start_link().

stop(_State) ->
	ok.


