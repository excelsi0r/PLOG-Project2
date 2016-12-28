:- include('config.pl').

:- use_module(library(lists)).
:- use_module(library(clpfd)).
solve:-	
		create_port(Port, Len, Heigth),
		create_types(Types),	
		create_heigths(Weigths),
		create_expeditions(Expeditions),
		
		boat_length_sum(N, _),
		domain(Port, 1, N),
		
		create_cardinality(Len, N, Card),
		global_cardinality(Port, Card),
	
		create_restrictions(Port, Heigth, Types, Weigths),
		
		%timing(Port, Types, Weigths, Expeditions, Time),
		
		labeling([], Port),
		write(Port),write(Exp1), nl.
		
%======================================================
create_port(Port, N, Heigth):-	
		
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
timing(Port, Types, Weigths, Expeditions, Time):-		
					
		max_member(MaxExp, Expeditions),
		total_timing(Port, Types, Weigths, Expeditions,1, MaxExp, Time).
			
total_timing(Port, Types, Weigths, Expeditions, Min, MaxExp, Time).






		
