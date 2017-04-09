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

;Creates a link to retrieve the info
(define url (string-append "http://ballotyelp.herokuapp.com/yelpsearch/" food "/" location))
(define myurl (string->url url))
(define myport (get-pure-port myurl))
(define response (port->string myport))

;Uses port and creates a JSON
(define json-data (with-input-from-string response (λ () (read-json))))

;First layer of the JSON is the businesses
(define businesses (hash-ref json-data 'businesses))

;Second layer is the individual business information, first layer returns a list, so
;we need to use the dirst elemtn of this list
(define name (hash-ref (car businesses) 'name))
(define price (hash-ref (car businesses) 'price))

;Net/url lib rary does not support retrieving images and printing them, but 2htdp does.
;Basically net-url for images
(define image (bitmap/url (hash-ref (car businesses) 'image_url)))

;Prints the info for the first location
(define (print-text-info) (printf "We think you should go to ~a, it costs ~a.~n" name price))
(define (show-info) (begin (print-text-info) image))










