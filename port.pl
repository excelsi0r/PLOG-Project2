:- include('config.pl').

:- use_module(library(lists)).
:- use_module(library(clpfd)).

solve:-	

		create_port(Port),
		write(Port).

%======================================================
timing(Port, Total):-	
		
		check_if_empty(Port, Bool),		
		timing_eval(Port, Total, Bool).
		
timing_eval(_, Total, 'true'):-	Total = 0.
timing_eval(Port, Total, 'false'):-	timing_not_empty(Port, Total).
		
		
timing_not_empty(Port, Total):-	

		expedition_port(Port, NewPort, Time),
		update_times(NewPort, NewPort2),
		timing(NewPort2, Time2),
		Total is Time + Time2.
		
%======================================================
create_port(Port):-	
		
		port_lines(Lines),
		port_columns(Columnns),
		create_port_line(Lines, Columnns, Port).
		

create_port_line(0,_,L):- 	L = [].
create_port_line(Lines,Columnns,L):- 
		
		length(L1, Columnns),
		maplist(=([]), L1),
		N is Lines - 1,
		create_port_line(N, Columnns, L2),
		append([L1], L2, L).
		
%======================================================
check_if_empty(Port, Bool):-	

		flatten_port(Port, NewPort),
		length(NewPort, N),
		eval_check_if_empty(N, Bool).
		
eval_check_if_empty(N, Bool):-	N == 0, Bool = 'true'.
eval_check_if_empty(N, Bool):-	N \= 0, Bool = 'false'.

%=======================================================
flatten_port([], NewPort):-	NewPort = [].
flatten_port([Line | Rest], NewPort):-	

		flatten(Line, NewLine),
		flatten_port(Rest, NewRest),
		append(NewLine, NewRest, NewPort).
		
flatten([], NewLine):-	NewLine = [].
flatten([Elem | Rest], NewLine):-	

		flatten(Rest, NewLine2),
		append(Elem, NewLine2, NewLine).

%======================================================
expedition_port(Port, NewPort, Time):-	expedition(Port, NewPort, Time, 1).

expedition([], NewPort, Time, _):-	NewPort = [], Time = 0.
expedition([Line | Rest], NewPort, Time, Y):-	
		
		expedition_by_line(Line, NewLine, TimeLine, Y, 1),
		Y1 is Y + 1,
		expedition(Rest, NewRest, TimeRest, Y1),
		append([NewLine], NewRest, NewPort),
		Time is TimeLine + TimeRest.

expedition_by_line([], NewLine, TimeLine,_,_):-	NewLine = [], TimeLine = 0.
expedition_by_line([Elem | Rest], NewLine, TimeLine,Y,X):-	
	
		expedition_by_elem(Elem, NewElem, TimeElem1),
		calculate_time_crane(TimeElem1, Y,X, TimeElem),
		X1 is X + 1,
		expedition_by_line(Rest, NewRest, TimeRest,Y,X1),
		append([NewElem], NewRest, NewLine),
		TimeLine is TimeElem + TimeRest.
		
expedition_by_elem([], NewElem, TimeElem):-	NewElem = [], TimeElem = 0.
expedition_by_elem([Container | Rest], NewElem, TimeElem):-	
		
		calculate_container(Container, NewContainer, TimeContainer),
		expedition_by_elem(Rest, NewRest, TimeRest),
		calculate_time(NewContainer, TimeContainer, TimeRest, TimeElem),
		append(NewContainer, NewRest, NewElem).
		
calculate_container([Type | [Heigth | [Exp]]], NewContainer, TimeContainer):-	

		TimeContainer is Type * 60 + Heigth,
		eval_container(Type, Heigth, Exp, NewContainer).
		
eval_container(Type, Heigth, Exp, NewContainer):-	

		Exp >= 1,
		append([Type], [Heigth], L1),
		append(L1, [Exp], L2),		
		NewContainer = [L2].

eval_container(_,_,0,NewContainer):-	NewContainer = [].
		
		
calculate_time([], TimeContainer, TimeRest, TimeElem):-	TimeElem is TimeContainer + TimeRest.
calculate_time(_, TimeContainer, TimeRest, TimeElem):-
			
			TimeRest > 0,
			TimeElem is TimeContainer + TimeRest.
			
calculate_time(_, _, TimeRest, TimeElem):-			
	
			TimeRest == 0,
			TimeElem = 0.
			
calculate_time_crane(TimeElem1, Y,X, TimeElem):-	

		TimeElem1 >= 1,
		
		Y1 is Y*Y,
		X1 is X*X,
		
		Diff is X1 + Y1,
		
		TimeTemp is sqrt(Diff),
		
		TimeElem is TimeElem1 + TimeTemp*100.

calculate_time_crane(TimeElem1, _,_, TimeElem):-	

		TimeElem1 == 0,
		
		TimeElem is TimeElem1.
		
%===================================================================
update_times(Port, Port2):-	upate_boat_by_line(Port, Port2).

upate_boat_by_line([], New):-	New = [].	
upate_boat_by_line([Line | Rest], New):-	

		
		update_boat_by_elem(Line, NewLine),
		upate_boat_by_line(Rest, New2),
		
		append([NewLine], New2, New).

update_boat_by_elem([], NewLine):-	NewLine = [].		
update_boat_by_elem([Containers | Rest], NewLine):-	

		update_containers(Containers, NewContainers),
		update_boat_by_elem(Rest, NewContainers2),
		
		append([NewContainers], NewContainers2, NewLine).
		
update_containers([], NewContainers):-	NewContainers = [].
update_containers([[Type | [Heigth | [Exp]]] | Rest], NewContainers):-	

		append([Type], [Heigth], L1),
		NewTime is Exp - 1,
		
		append(L1, [NewTime], NewContainer),	
		
		update_containers(Rest, NewContainers2),		
		append([NewContainer], NewContainers2, NewContainers).	

		
		
		
		
		

		


		