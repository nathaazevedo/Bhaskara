#lang racket

(define a (read))
(define b (read))
(define c (read))

(define delta (- (expt b 2) (* 4 a c)))

(printf "\nAs raizes da equacao sao: \n")

(/ (+ (- b) (sqrt delta)) (* 2 a))
(/ (- (- b) (sqrt delta)) (* 2 a))

(printf "E o vertice da equacao é: \n")
(/ (- b)     (* 2 a))
(/ (- delta) (* 4 a))
