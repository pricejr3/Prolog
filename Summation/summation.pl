
summation(TEST, TARGET, VAR) :- comb(VAR, TEST), addition_enforce(VAR, TARGET), !.  



% Enforce that the empty list is not returned as a true answer.
addition_enforce(VAR, TARGET) :-
    VAR = [_|_],
    addition(VAR, TARGET).


comb([], []).
comb([H1|T], [H1|T2]) :- comb(T, T2).
comb(TEST, [_|T]) :- comb(TEST, T).

%addition([], []).
addition([], 0).
addition([H1|T1], VALUE) :- addition(T1, T2), VALUE is H1 + T2.





