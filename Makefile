all:
	rebar get-deps com

serve:
	erl -pa ..\jwc\ebin -config priv/app.config -s jwc
