% parser.pl

problem(diff(params(X), expr(E), wrt(Y), at(T))) -->
  "d(",
  param(X),
  " |-> ",
  expr(E),
  ")/d",
  variable(Y),
  " at ",
  call_param(T).

param([]) -->
  "()",
  !.
param(XS) -->
  "(",
  intros(XS),
  ")".

intros([X|XS]) -->
  variable(X),
  ",",
  intros(XS).
intros([X]) -->
  variable(X).

call_param([]) -->
  "()".
call_param(XS) -->
  "(",
  elims(XS),
  ")".

elims([X|XS]) -->
  constant(X),
  ",",
  elims(XS).
elims([X]) -->
  constant(X).

expr(X + Y) -->
  term(X), "+", expr(Y).
expr(X - Y) -->
  term(X), "-", expr(Y).
expr(E) -->
  term(E).

term(X * Y) -->
  atom(X), "*", term(Y).
term(X / Y) -->
  atom(X), "/", term(Y).
term(E) -->
  atom(E).

atom(E) -->
  constant(E).
atom(E) -->
  variable(E).
atom(E) -->
  "(",
  expr(E),
  ")".

constant(con(C)) -->
  digits(X),
  ".",
  digits(Y),
  {append(X, [46|Y], Z),
   number_codes(C, Z)}.
constant(con(C)) -->
  digits(S),
  {number_codes(C, S)}.

digits([N|NS]) -->
  digit(N),
  digits(NS).
digits([N]) -->
  digit(N).

digit(N) -->
  [C],
  {C >= "0", 
   C =< "9", 
   N is C}.

variable(var(X)) -->
  [C],
  {C >= "a", 
   C =< "z",
   char_code(X, C)}.

test_parse(S) :-
  phrase(problem(P), S),
  write(P).
