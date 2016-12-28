:- include('config.pl').

:- use_module(library(lists)).
:- use_module(library(clpfd)).
solve:-	
		create_port(Port, Len, Heigth,_, Columnns),
		create_types(Types),	
		create_heigths(Weigths),
		create_expeditions(Expeditions),
		
		boat_length_sum(N, _),
		domain(Port, 1, N),
		
		create_cardinality(Len, N, Card),
		global_cardinality(Port, Card),
	
		create_restrictions(Port, Heigth, Types, Weigths),
		
		%write(Port), nl,
		%timing(Port,Len,Heigth, Columnns, Types, Weigths, Expeditions, Time),
		%write(Time), nl,
		
		timing(Port,Len,Heigth, Columnns, Types, Weigths, Expeditions, Time),
		write(Time), nl,
		
		minimize(labeling([],Port), Time),
		
		write(Time), nl,
		write(Port), nl.
		
%======================================================
create_port(Port, N, Heigth,Lines, Columnns):-	
		
		port_lines(Lines),
		port_columns(Columnns),
		port_heigth(Heigth),
		N is Lines * Columnns * Heigth,
		length(Port, N).
		
%======================================================
boat_length_sum(N, Sum):-	
		
		boat(Boat), 
		length(Boat, N),
		get_sum_id(Boat, Sum).

		
get_sum_id([], Sum):-	Sum  = 0.
get_sum_id([[ID | _ ] | Rest], Sum):-	

		get_sum_id(Rest, Sum2),
		Sum is ID + Sum2.

%======================================================
create_cardinality(Len, N, Card):-	

		Num is N - 1,
		Zeros is Len - Num,
		create_cardinality_rest(2, N, Rest),
		append([1-Zeros], Rest, Card).
		
create_cardinality_rest(Min, N, Rest):-	

		Min == N,
		Rest = [Min-1].
		
create_cardinality_rest(Min, N, Rest):-	

		append([Min-1], Card, Rest),
		NewMin is Min + 1,
		create_cardinality_rest(NewMin, N, Card).
		
%======================================================
create_types(Types):-	

		boat(Boat),
		create_types_rest(Boat, Types).
		
create_types_rest([], Types):-	Types = [].
create_types_rest([ [_,Type,_,_] | Rest], Types):-	
		
		create_types_rest(Rest, Types2),
		append([Type], Types2, Types).
		
%======================================================		
create_heigths(Heigths):-	
		
		boat(Boat),
		create_heigths_rest(Boat, Heigths).
		
create_heigths_rest([], Heigths):-	Heigths = [].
create_heigths_rest([ [_,_,Heigth,_] | Rest], Heigths):-	
		
		create_heigths_rest(Rest, Heigths2),
		append([Heigth], Heigths2, Heigths).

%======================================================
create_expeditions(Expeditions):-	

		boat(Boat),
		create_expeditions_rest(Boat, Expeditions).
		
create_expeditions_rest([], Expeditions):-	Expeditions = [].
create_expeditions_rest([ [_,_,_,Exp] | Rest], Expeditions):-	
		
		create_expeditions_rest(Rest, Expeditions2),
		append([Exp], Expeditions2, Expeditions).


%======================================================	
create_restrictions(Port, Heigth, Types, Weigths):-

			
		create_restrictions_rest(Port, Port, Heigth, Heigth, Types, Weigths).

create_restrictions_rest([_ | []], _, _, _, _, _).
create_restrictions_rest([_ | Rest], [_ | [_ | _]],1 , Heigth, Types, Weigths):-	

		create_restrictions_rest(Rest, Rest, Heigth, Heigth, Types, Weigths).
			
create_restrictions_rest([ID1 | Rest], [_ | [ID2 | _]], Min, Heigth, Types, Weigths):-	

		element(ID1, Types, Type1),
		element(ID2, Types, Type2),
		
		element(ID1, Weigths, Weigth1),
		element(ID2, Weigths, Weigth2),
		
		Type1 #>= Type2,
		Weigth1 #=< Weigth2,
		
		NewMin is Min - 1,
		create_restrictions_rest(Rest, Rest, NewMin, Heigth, Types, Weigths).
		
%======================================================	
timing(Port,Len, Heigth, Columnns, Types, Weigths, Expeditions, Time):-		
					
		max_member(MaxExp, Expeditions),
		total_timing(Port,Len, Heigth, Columnns, Types, Weigths, Expeditions,1,1, MaxExp, Time).

total_timing(_,Len, _, _, _, _, _,Index, _, _, Time):-	Index >= Len, Time is 0.		
total_timing(Port, Len, Heigth, Columnns, Types, Weigths, Expeditions, Index, MinExp, MaxExp, Time):-	

		get_list(Port, Heigth, Index, Vars), % write(Vars), nl,
		calculate_vars_time(Vars, Heigth, Columnns, Types, Weigths, Expeditions,Index, MinExp, MaxExp, Time1),
				
		NewIndex is Index +  Heigth,
		
		total_timing(Port, Len, Heigth, Columnns, Types, Weigths, Expeditions, NewIndex, MinExp, MaxExp, Time2),
		Time #= Time1 + Time2.
		

get_list(_, 0, _, Vars):-	Vars = [].
get_list(Port, Heigth, Index, Vars):-	

		nth1(Index, Port, Var),
		NewIndex is Index + 1,
		NewHeigth is Heigth - 1,
		get_list(Port, NewHeigth, NewIndex, Vars2),
		append([Var], Vars2, Vars).
		
calculate_vars_time(Vars, Heigth, Columnns, Types, Weigths, Expeditions,Index, MinExp, MaxExp, Time):-	

		calculate_x_y_time(Index, Heigth, Columnns, TimeXY),
		get_vars_time(Vars, TimeXY, Types, Weigths, Expeditions, MinExp, MaxExp, Time).
		
calculate_x_y_time(Index, Heigth, Columnns, TimeXY):-	


		I is Index - 1,
		I1 is I // Heigth,
		
		Y is I1 // Columnns,
		X is I1 rem Columnns,	
		
		NewY is Y + 1,
		NewX is X + 1,
		
		Diff2 is sqrt(NewX * NewX + NewY * NewY),
		Diff is integer(Diff2),
		
		TimeXY is 2* Diff * 100.

		
get_vars_time(_, _, _, _, _, MinExp, MaxExp, Time):-	MinExp > MaxExp, Time is 0.
get_vars_time(Vars, TimeXY, Types, Weigths, Expeditions, MinExp, MaxExp, Time):-	

		get_vars_time_each(Vars, Types, Weigths, Expeditions, MinExp, Time1),

		Time1 #= 0 #<=> B,
		eval_time(Time1, TimeXY, B, NewTime1),
		
		NewMin is MinExp + 1,
		get_vars_time(Vars, TimeXY, Types, Weigths, Expeditions, NewMin, MaxExp, Time2),
		
		Time #= NewTime1 + Time2.
		
		
		

eval_time(_, _, B, NewTime1):-	B == 1, NewTime1 is 0.
eval_time(Time1, TimeXY, B, NewTime1):- NewTime1 #= Time1 + TimeXY.

get_vars_time_each([], _, _, _, _, Time):-	Time is 0.
get_vars_time_each([ID | Rest], Types, Weigths, Expeditions, MinExp, Time):-	

		
		
		get_vars_time_each(Rest, Types, Weigths, Expeditions, MinExp, Time2),
		
		
		Time2 #= 0 #<=> B,
		eval_time_bellow(ID, Types, Weigths, Expeditions, MinExp, B, Time1),
				
		
		
		Time #= Time1 + Time2.
		

eval_time_bellow(ID, Types, Weigths, Expeditions, MinExp, B, Time):-	


		 
		B == 1,
		
		element(ID, Expeditions, Exp),
		
		Exp #= MinExp #<=> B2,	
		eval_time_bellow_exp(ID, Types, Weigths, B2, Time).
		
		
		
eval_time_bellow(ID, Types, Weigths, _, _, B, Time):-	

	
		element(ID, Types, Type),
		element(ID, Weigths, Weigth),
		
		get_time_exp(Type, Weigth, Time).
		
		
		

eval_time_bellow_exp(_, _, _, B, Time):-	B == 0, Time is 0.
eval_time_bellow_exp(ID, Types, Weigths, B, Time):-	
		
		
		element(ID, Types, Type),
		element(ID, Weigths, Weigth),
		
		get_time_exp(Type, Weigth, Time).
		
get_time_exp(Type, Weigth, Time):-	


		Factor #= 1 / Type,				
		Time #= Factor * 60 * Weigth.
		
		
		




		
