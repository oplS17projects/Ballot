# Ballot

## Serey Morm/Brandon Karl
### April 29, 2017

# Overview
Our project provides a simple and very clean interface for users to find food in a certain location. This is an application where someone can enter a type of food, a space, then a location in order to return results for that search. This project was powered by the Yelp API as that is where we are retrieving our food data. I was responsible for much of the back-end work for this project.

The goal of this project was to have a nice clean interface for the user to use, with only the information they desired being shown. No ads or useless information fro other restaurants. This would also allow the user to find new places to eat in their area they might not have tried before.


**Authorship note:** All of the code described here was written by Myself and Serey Morm.

# Libraries Used
The code uses four libraries:

```
lang racket/gui
(require net/url)
(require json)
(require 2htdp/image)
```

* The ```racket/gui``` library was used to create the actual GUI for the project so the user would have an interface.
* The ```net/url``` library provided us the ability to access the Yelp API from a node server we had previously set up, since Yelp uses so many keys.
* The ```json ``` library was used to retrieve the raw data and turn it into json format where it could be easily searched to retrieve the information about the restaurants.
* The ```2htdp/image``` library was used to retrieve images from the web using a link from the Yelp API

# Key Code Excerpts

Here is a discussion of my portion of the work. This includes some of the ideas we've unwrapped in class.

## 1. Keeping it Functional

This is the snippet of the front-end section of the program that uses `racket/gui`. Each portion of the information in the front-end all required an "initial state" or a "placeholder". When the program is rendered, it will display the default value of each element. Once the request has been made and the callback function has been called. It will then be re-rendered with updated information.

```
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
```

One of the most challenging obstacle about GUI is when we tried to implement two input boxes for better clarity to the user, having one text-field for the selection of food and location. The problem was, the function synchronously makes the API request without waiting for both of the input was given from the user.

In hindsight, because we didn't know much about promises at the time, I felt as if that was the solution to our problem. Similar to AJAX requests in other programming languages, there is an asynchronous call, meaning that it "delays" or "promises" the function to be called AFTER the input has been given from the user.

So our solution was to make the API request `lazy`, so that when an input has been given from the user, the program will then force the promise to give us the updated result. Our callback acts as a `lazy` evaluation, but it was challenging to achieve because we would've had to also retrieve the text from the other text-field as well.
 
## 2. Making the Request, Lazily

This function is responsible for event handling after the `enter` key has been pressed inside the test field. Because we wanted to do everything we can to stay away from `set!` to keep our program purely functional, this function handles the given data similarly to `GET` requests in other languages such as Swift, or JavaScript. Without changing states and mutating any of our input data, it takes the event from our text-area from the front-end and directly applies it to our request.

NOTE: The reason why I used `t` and `e` as variables for this function is because I wanted to follow the standards from the Racket documentation for event handling with GUI. `t` is for `text` and `e` is for `event`

```
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
```

Because Yelp was the only API that specific information that allowed us to retrieve data related to food businesses, we had no other choice, but to use Yelp. The problem was, we had no idea how we can authenticate OAuth2 in Racket, because that was a tangent of it's own.

To simplify this problem so that we can have access to Yelp, I deployed an API on AWS that authenticates to Yelp, so that we can make requests from our Racket program without OAuth2 authentication.

In short, `sendyelp` is mainly responsible for acting as the callback function that asks the API for the JSON with the given text and event when called. It  acts as a `lazy` evaluation because it has to wait for the `enter` key to be pressed in order for the function to be evaluated.

## 3. Recursion and Accumulate

This specific function takes four lists. More specifically, each of the four lists are filled with specific data for each businesses retrieved. For example, names would include all ~50 businesses, and photos will include all photos.

This function essentially takes all of this list, recurses through all four lists and stitches each index together to create a whole new list with the four data combined. Finally, the function will create a new lists of all the businesses with all the names and only the information we needed. 

In hindsight, we should've used map which will allow us to do this with less code so that it would be easier for other people to read and understand the code, or simply makes it easier to debug because that is essentially the paradigm of recursion functions itself.

Another note, we should've also included the location of the businesses which is also part of the JSON.

```
(define (combiner names photos prices phones)
  (if (null? names)
      '()
      (cons (list (car names) (car photos) (car prices) (car phones)) (combiner (cdr names) (cdr photos) (cdr prices) (cdr phones))))
  )
```
Takes four lists, cons the first element of all four lists, and recurses through each cell until null.
