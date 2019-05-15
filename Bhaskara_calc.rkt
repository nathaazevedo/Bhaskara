; biblioteca
#lang racket
; Web blibliotecas
(require web-server/servlet
         web-server/servlet-env)
(require net/uri-codec)

; Startar web
(define (my-app req)
  ; definicoes pagar pegar do form e jogar para outra pagina
  (define uri (request-uri req))
  (define path (map path/param-path (url-path uri)))    
  (define page (car path))
  
  (cond 
    [(equal? page "main") ; pagina 1
  
     (response/xexpr
      `(html
        (head (title "Bhaskara - Lisp")
            ;  (link ((rel "stylesheet")(href "/style.css")(type "text/css")))
              )
        (body (center(h1  "Caculadora De Bhaskara ")

           (p "Programa para calcular as raízes (x1,x2) e o vértice(Vx,Vy) de uma equação do 2o grau.")

           (form ([method "POST"] [action "/resultado"])
               "     " (input ([type "number"] [name "a"]))
               "x² + " (input ([type "number"] [name "b"]))
               " x + " (input ([type "number"] [name "c"]))
               " = 0 "(br)(br)
               (input ([type "submit"] [value "Calcular"])))                 
    
           ;(img ([src "/formula.png"]))))
          ))))] 
   
    [(equal? page "resultado") ; pagina 2
  
     ; extrair os dados do formulário:
     (define post-data (bytes->string/utf-8 (request-post-data/raw req)))
     (define form-data (form-urlencoded->alist post-data))

     ; Definir variaveis conforme os campos
     (define a (string->number(cdr (assq 'a form-data))))
     (define b (string->number(cdr (assq 'b form-data))))
     (define c (string->number(cdr (assq 'c form-data))))

     ; Calcular delta
     (define delta (- (expt b 2) (* 4 a c)))
     ; Calcular raizes
     (define r1 (/ (+ (- b) (sqrt delta)) (* 2 a)))
     (define r2 (/ (- (- b) (sqrt delta)) (* 2 a)))
     ; Calcular vertices
     (define v1 (/ (- b)     (* 2 a)))
     (define v2 (/ (- delta) (* 4 a)))

     ; apresentar os dados
     (response/xexpr
      `(html
        (head (title "Bhaskara - Lisp")
            ;  (link ((rel "stylesheet")(href "/style.css")(type "text/css")))
              )
        (body (center(h1  "Caculadora De Bhaskara ")
         (p "Raiz 1 = " , (number->string r1))
         (p "Raiz 2 = " , (number->string r2))
         (p "Vertice 1 = " , (number->string v1))
         (p "Vertice 2 = " , (number->string v2))
         (input ([type "button"] [value "Voltar"][onclick "location.href='/main'"]))
         (br)
         ;(img ([src "/formula.png"])))
       
        ))))]
    [else     ; nao encontrou pagina
     (response/xexpr
      `(html
        (body
         (p "Page not found!"))))]))

; Configuracoes web
(serve/servlet my-app
                #:servlet-path "/main"
                #:port 8080
              ;  #:extra-files-paths (list (build-path (current-directory))) ; desta maneira pega o diretario em qualquer computador
                #:servlet-regexp #rx""
)

; Referencias
; Configuracoes da pagina web: https://docs.racket-lang.org/continue/#%28part._.Getting_.Started%29
;                              https://docs.racket-lang.org/continue/
; Passar dados entre paginas: http://matt.might.net/articles/low-level-web-in-racket/