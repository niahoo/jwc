-module(jwc).
-export([start/0]).
-export([next/0]).

start() -> application:start(jwc).
next() -> ets:lookup(jwc_dat,jwc_ring:next()).
