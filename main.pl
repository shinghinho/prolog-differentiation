?- consult(parser).
?- consult(solver).

main :-
  format('==== Differentiation ====\n', []),
  repl.

repl :-
  read_line(S),
  exec(S),
  nl,
  repl.
