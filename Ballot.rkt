#lang racket/gui

;-------------------------------------------------
;
; To show the first piece of data, call the (show-info)
; function. Shows the name, price and image of the result
; using the food and location variables.
;
;-------------------------------------------------

(require net/url)
(require json)
(require 2htdp/image)

; These will eventually be replaced with whatever the user unters into gui
;(define food "sushi")
;(define location "boston")

;Combines all the info
(define (combiner names photos prices phones)
  (if (null? names)
      '()
      (cons (list (car names) (car photos) (car prices) (car phones)) (combiner (cdr names) (cdr photos) (cdr prices) (cdr phones))))
  )


(define (getName lst)
  (car lst))
(define (getPrice lst)
  (caddr lst))
(define (getPhone lst)
  (cadddr lst))
(define (getPhoto lst)
  (cadr lst))



(define indexstart 0)

(define (make term number yelp)
  (define (usedindex) '())
  (define (businessData) (foldr cons '() (hash-ref yelp 'businesses)))
  (define (combinations) (combiner (businessNames) (businessPhotos) (businessPrice) (businessPhone)))
  (define (businessNames) (map (lambda (x) (hash-ref x 'name)) (businessData)))
  (define (businessPhotos) (map (lambda (x) (hash-ref x 'image_url)) (businessData)))
  (define (businessPrice) (map (lambda (x) (hash-ref x 'price (lambda () "No price found!"))) (businessData)))
  (define (businessPhone) (map (lambda (x) (hash-ref x 'display_phone (lambda () "No number found!"))) (businessData)))
  (define (changedata number)
    (begin
      (send testMsg set-label (getName (list-ref (combinations) number)))
      (send priceMsg set-label (string-append "Price: " (getPrice (list-ref (combinations) number))))
      (send phoneMsg set-label (string-append "Phone: " (getPhone (list-ref (combinations) number))))
      (send image2 set-label (read-bitmap
                              (get-pure-port
                               (string->url
                                (getPhoto (list-ref (combinations) number))))))
      )
    )
  

    
    
  ;(begin (send testMsg set-label (car (list-ref (combinations) number)))
  ;(send image2 set-label (read-bitmap
         ;(get-pure-port
          ;(string->url
           ;(cdr (list-ref (combinations) number))))))
  ;(set! numentered (+ numentered 1)))
  (begin (changedata number)
         (if (= indexstart 0)
             (begin (new button% [parent frame]
             [label "Another one"]
             ; Callback procedure for a button click:
             [callback (lambda (x y) (if (< indexstart (length (combinations)))
                                                 (begin (changedata indexstart)
                                                 (set! indexstart (+ indexstart 1)))
                                                 (begin (set! indexstart 0)
                                                        (changedata indexstart)))
                         )]))
             (begin
               (send frame delete-child (list-ref (send frame get-children) 7))
               (new button% [parent frame]
             [label "Another one"]
             ; Callback procedure for a button click:
             [callback (lambda (x y) (if (< indexstart (length (combinations)))
                                                 (begin (changedata indexstart)
                                                 (set! indexstart (+ indexstart 1)))
                                                 (begin (set! indexstart 0)
                                                        (changedata indexstart)))
                         )])))
         )
  )


;Net/url lib rary does not support retrieving images and printing them, but 2htdp does.
;Basically net-url for images
;(define image (bitmap/url (hash-ref (car businesses) 'image_url)))

;Prints the info for the first location
;(define (print-text-info) (printf "We think you should go to ~a, it costs ~a.~n" name price))
;(define (show-info) (begin (print-text-info) image))


;; Make the request to our endpoint
(define (sendyelp t e)
  (define (url)
    (string-append "http://sample-env.5qpmzezbye.us-east-1.elasticbeanstalk.com/yelpsearch/" (car (string-split (send t get-value))) "/" (cadr (string-split (send t get-value)))))
  (define (myurl) (string->url (url)))
  (define (myport) (get-pure-port (myurl)))
  (define (response) (port->string (myport)))
  (define (yelp) (with-input-from-string
    (response)             
    (λ () (read-json))))
  (if (equal? (send e get-event-type) 'text-field-enter) (make (send t get-value) 0 (yelp)) ""))
;; function to write to screen to be implemented

; THE INITIAL GUI
(define frame (new frame% [label "Yelp App"]
                          [width 500]
                          [height 500]
                          ))
(define titleFont (make-object font% 20 "Arial" 'default 'italic 'bold))

(define welcomeMsg (new message% [parent frame]
                          [label "Lets look for something to eat!"]
                          [auto-resize #t]
                          [font titleFont]
                          ))



(define searchMsg (new message% [parent frame]
                          [label "What do you want to eat?"]
                          [auto-resize #t]
                          ))

(new text-field% [label ""] [parent frame]
                            [vert-margin 10]
                            [horiz-margin 100]
                            [callback sendyelp])
;; Callback for request here

(define testMsg (new message% [parent frame]
                          [label "A fine place to eat will appear once you search!"]
                          [auto-resize #t]
                          [font titleFont]
                          ))

(define priceMsg (new message% [parent frame]
                          [label "Price: None yet!"]
                          [auto-resize #t]
                          ))
(define phoneMsg (new message% [parent frame]
                          [label "Phone: None yet!"]
                          [auto-resize #t]
                          ))

(define image
  (read-bitmap "./yelplogo.png"))
(define image2 (new message% [parent frame] [label image]))


(send frame show #t)






