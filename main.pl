?- consult(parser).
?- consult(solver).

main :-
  format("==== Differentiation ====\n", []),
  repl.

repl :-
  read_line(S),
  (  phrase(problem(P), S)
  -> write(P)
  ;  format("Syntax Error", [])
  ),
  nl,
  repl.
