% solver.pl

exec(S) :-
  phrase(problem(P), S),
  solve(P, D),
  !,
  write(D).
exec(S) :-
  \+ phrase(problem(_), S),
  !,
  format('Parse Error', []).
exec(_) :-
  format('Runtime Error', []).

solve(diff(params(X), expr(F), wrt(Y), at(P)), DFDX) :-
  build_lookup(params(X), at(P), lookup_map(Memory)),
  d(expr(F), wrt(Y), expr(G)),
  subst(expr(G), lookup_map(Memory), C),
  DFDX is C.

d(expr(var(X)), wrt(var(X)), expr(con(1))).
d(expr(var(X)), wrt(var(Y)), expr(con(0))) :-
  X \= Y.
d(expr(con(_)), wrt(var(_)), expr(con(0))).
d(expr(X + Y), WRT, expr(DX + DY)) :-
  d(expr(X), WRT, expr(DX)),
  d(expr(Y), WRT, expr(DY)).
d(expr(X - Y), WRT, expr(DX - DY)) :-
  d(expr(X), WRT, expr(DX)),
  d(expr(Y), WRT, expr(DY)).
d(expr(X * Y), WRT, expr(X * DY + Y * DX)) :-
  d(expr(X), WRT, expr(DX)),
  d(expr(Y), WRT, expr(DY)).
d(expr(X / Y), WRT, expr((Y * DX - X * DY) / Y ^ 2)) :-
  d(expr(X), WRT, expr(DX)),
  d(expr(Y), WRT, expr(DY)).

% zip the params and points to construct a lookup map for variables
build_lookup(params([]), at([]), lookup_map([])).
build_lookup(params([var(X)|XS]), at([con(Y)|YS]), lookup_map([(var(X),con(Y))|Memory])) :-
  build_lookup(params(XS), at(YS), lookup_map(Memory)).

% transforming the expression to form an evaluable expression.
subst(expr(var(X)), lookup_map(Memory), C) :-
  mem_lookup(var(X), lookup_map(Memory), con(C)).
subst(expr(con(C)), lookup_map(_), C).
subst(expr(M + N), Memory, P + Q) :-
  subst(expr(M), Memory, P),
  subst(expr(N), Memory, Q).
subst(expr(M - N), Memory, P - Q) :-
  subst(expr(M), Memory, P),
  subst(expr(N), Memory, Q).
subst(expr(M * N), Memory, P * Q) :-
  subst(expr(M), Memory, P),
  subst(expr(N), Memory, Q).
subst(expr(M / N), Memory, P / Q) :-
  subst(expr(M), Memory, P),
  subst(expr(N), Memory, Q).

mem_lookup(var(X), lookup_map([(var(X),con(C))|_]), con(C)) :-
  !.
mem_lookup(var(X), lookup_map([_|Memory]), con(C)) :-
  mem_lookup(var(X), lookup_map(Memory), con(C)).

test :-
  phrase(expr(E), "x+y*z"),
  V = params([var(x), var(y), var(z)]),
  A = at([con(3), con(4), con(5)]),
  build_lookup(V, A, Memory),
  write(expr(E)),
  subst(expr(E), Memory, F),
  X is F,
  write(X).
