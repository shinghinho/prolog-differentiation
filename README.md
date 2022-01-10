# Prolog Differentiation

A simple differentiation tool written in Prolog. 

## Evaluating derivative

```
|: d((x) |-> x*x)/dx at (3)
6
|: d((x) |-> 3*x*x+4*x+3)/dx at (3)
22
```

## Multivariable case

Technically this is computing the partial derivative, but the \partial symbol is hard to type.

```
> d((x,y) |-> x*x*y)/dx at (3,4)
24
> d((x,y) |-> x*x*y)/dy at (3,4)
9
```

## Usage

Load `main.pl` using the prolog interpreter and evaluate `main`.

```prolog
?- main.
=== Differentiation ===
|: d((x) |-> x)/dx at (3)
1
|: 
```

## TODO

+ Rewrite the parser (inefficient and cannot handle spaces at the moment)
+ Rewrite the differentiation algorithm using forward AD (right now it's symbolic => building up symbolic expressions) (easy to fix, eval the expr when transforming)
