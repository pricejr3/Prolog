% HW3
% Jarred Price 
% 11 October 2016



% Question 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A   (find the maximum number between 2 numbers)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

maxnums([], 0).
maxnums(A, B, MAX):- MAX is max(A, B).




% B   (determine the summataion of a list of simple numbers)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if the list is empty, return zero.
sum([], 0).
sum([H|T], Count) :- sum_list(T, T2), Count is H + T2.


% C   (Using the structures parent(X, Y), male(X), and female(X), write
%      a structure that defines sister(X, Y).
%      
%       sister(SISTER, SIBLING) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Female rules.
female(katie).
female(jill).
female(carrie).

% Male rules.
male(bob).
male(jeff).
male(ryan).

father(bob, katie).
father(bob, jill).
mother(carrie, katie).
mother(carrie, jill).


% Parent rules.
parent(X, Y) :- father(X, Y).
parent(X, Y) :- mother(X, Y).

% Sibling rule
sibling(X, Y) :- parent(Z, X), parent(Z, Y), X \= Y.

% Sister rule here.
sister(SISTER, SIBLING) :- sibling(SISTER, SIBLING), female(SISTER), !.



% D     find the maximum number of a list.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max(LST, MAX) :- max_list(LST, MAX).

% E     Determine if the list is partitionable.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
partitionable(LST, LST1, LST2) :- append(LST1, LST2, LST), sum(LST1, LST1_VAL), sum(LST2, LST2_VAL), LST1_VAL = LST2_VAL, !.
partitionable(LST) :- partitionable(LST, LST1, LST2).


% Question 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% A. getCommon(STATE1, STATE2, PLACE)    
% Gets place names that are common to both STATE1 and STATE2, 
% where STATE1 and STATE2 differ
%           zip    place   state   county        lat    lon
% location(99553,'Akutan','AK','Aleutians East',54.143,-165.7854).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




getCommon(STATE1, STATE2, PLACE) :- stateOne(S1, STATE1, PLACE), stateTwo(S2, STATE2, PLACE), stateIntersection(S1, S2, S3), removeStateDups(S3, S4), printAnswer(S4, PLACE).


stateOne(S1, STATE1, PLACE) :- findall(PLACE, location(_,PLACE,STATE1,_,_,_), S1), !.
stateTwo(S2, STATE2, PLACE) :- findall(PLACE, location(_,PLACE,STATE2,_,_,_), S2), !.

stateIntersection(S1, S2, S3) :- intersection(S1, S2, S3), !.
removeStateDups(S3, S4) :-removeDuplicates(S3, S4),!.

printAnswer(S4, PLACE) :- printList(S4, PLACE).


printStates([H|_], H).
printStates([_|T], H):- printStates(T, H).

printList(S4, PLACE) :- printStates(S4, PLACE).




% HELPERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
removeDuplicates([], []).
removeDuplicates([H|T], [H|T1]) :- subtract(T, [H], T2), removeDuplicates(T2, T1).





intersection([], _, []).

intersection([H1|T1], L2, [H1|T2]) :-member(H1, L2), intersection(T1, L2, T2).

intersection([_|T1], L2, T2) :- intersection(T1, L2, T2).


% B.  getStateInfo(PLACENAME, STATE, ZIPCODE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getStateInfo(PLACENAME, STATE, ZIPCODE) :- location(ZIPCODE,PLACENAME,STATE,_,_,_).





% Question 3
% Parsing English sentences.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Singular Nouns
singularNouns([sun]).
singularNouns([bus]).
singularNouns([deer]).
singularNouns([grass]).
singularNouns([party]).

% Plural Nouns
pluralNouns([suns]).
pluralNouns([buses]).
pluralNouns([grasses]).
pluralNouns([parties]).

% Plural Deer
pluralDeer([deer]).

% Singular Deer
singularDeer([deer]).

% Articles
articles([a]).
articles([and]).
articles([an]).
articles([the]).

% Adverbs
adverbs([loudly]).
adverbs([brightly]).

% Adjectives
adjectives([yellow]).
adjectives([big]).
adjectives([brown]).
adjectives([green]).
adjectives([party]).

% Singluar Verbs
singularVerbs([shines]).
singularVerbs([continues]).
singularVerbs([parties]).
singularVerbs([eats]).

% Plural Verbs
pluralVerbs([shine]).
pluralVerbs([continue]).
pluralVerbs([party]).
pluralVerbs([eat]).






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Special case for PLURAL DEER!!!

sentence(S) :- append(NP3, VP3, S), np_plural2(NP3), vp_plural2(VP3), !.
sentence(S) :- append(NP, VP, S), np(NP), vp(VP), !.
sentence(S) :- append(NP2, VP2, S), np_plural(NP2), vp_plural(VP2), !.

np_plural2([ART3|NP3]) :- articles([ART3]), np2_plural2(NP3).
np_plural2(NP3) :- np2_plural2(NP3).

np2_plural2(NP3) :- pluralDeer(NP3).
np2_plural2([ADJ3|NP3]) :- adjectives([ADJ3]), np2_plural2(NP3).

vp_plural2(VP3) :- pluralVerbs(VP3).
vp_plural2([VERB3|ADV3]) :- pluralVerbs([VERB3]), adverbs(ADV3).


% Singular part %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


np([ART|NP]) :- articles([ART]), np2(NP).
np(NP) :- np2(NP).

np2(NP2) :- singularNouns(NP2).
np2([ADJ|NP2]) :- adjectives([ADJ]), np2(NP2).

vp(VP) :- singularVerbs(VP).
vp([VERB|ADV]) :- singularVerbs([VERB]), adverbs(ADV).



% Plural part %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOUN PHRASE AND VERB PHRASE PLURALITY MUST BE MATCH

% verbs being the same -- Plural


np_plural([ART2|NP2]) :- articles([ART2]), np2_plural(NP2).
np_plural(NP2) :- np2_plural(NP2).

np2_plural(NP2) :- pluralNouns(NP2).
np2_plural([ADJ2|NP2]) :- adjectives([ADJ2]), np2_plural(NP2).

vp_plural(VP2) :- pluralVerbs(VP2).
vp_plural([VERB2|ADV2]) :- pluralVerbs([VERB2]), adverbs(ADV2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



