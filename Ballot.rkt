#lang racket

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
(define food "sushi")
(define location "boston")

;Combines all the info
(define (combiner lst1 lst2 lst3 lst4)
  (if (null? lst1)
      '()
      (cons (list (car lst1) (car lst2) (car lst3) (car lst4)) (combiner (cdr lst1) (cdr lst2) (cdr lst3) (cdr lst4))))
  )

;Creates a link to retrieve the info
(define url (string-append "http://ballotyelp.herokuapp.com/yelpsearch/" food "/" location))
(define myurl (string->url url))
(define myport (get-pure-port myurl))
(define response (port->string myport))

;Uses port and creates a JSON
(define yelp (with-input-from-string response (λ () (read-json))))

;First layer of the JSON is the businesses, uses fold
(define businessData (foldr cons '() (hash-ref yelp 'businesses)))

;Gets all the information from the JSON, uses map
(define businessNames (map (lambda (x) (hash-ref x 'name)) businessData))
(define businessPhotos (map (lambda (x) (hash-ref x 'image_url)) businessData))
(define businessPrice (map (lambda (x) (hash-ref x 'price (lambda () "No price found!"))) businessData))
(define businessPhone (map (lambda (x) (hash-ref x 'display_phone (lambda () "No number found!"))) businessData))

;Combines all the data into a usable list, where each element is a different resteraunt
(define combinations (combiner businessNames businessPhotos businessPrice businessPhone))



;Net/url lib rary does not support retrieving images and printing them, but 2htdp does.
;Basically net-url for images
;(define image (bitmap/url (hash-ref (car businesses) 'image_url)))

;Prints the info for the first location
;(define (print-text-info) (printf "We think you should go to ~a, it costs ~a.~n" name price))
;(define (show-info) (begin (print-text-info) image))










