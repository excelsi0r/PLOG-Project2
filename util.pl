random_between(Min, Max, Nr):-	

		Min1 is float(Min),
		
		
		Max2 is float(Max),
		Max1 is Max2 + 1.0,
		
		random(Min1, Max1, N),
		
		Nr is integer(N).
		

		
		
		