# Ballot

## Brandon Karl/Serey Morm
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

Here I will be showing code excerpts from code I specifically wrote for this project. This mostly includes retrieving and formatting the data. 

## 1. Using Foldr and Map to Create Easily Accessible Data

The following code takes in the data from the API that has been converted to json format. the variable ```yelp``` is the json data for the restaurants.

```
  (define (businessData) (foldr cons '() (hash-ref yelp 'businesses)))
  (define (combinations) (combiner (businessNames) (businessPhotos) (businessPrice) (businessPhone)))
  (define (businessNames) (map (lambda (x) (hash-ref x 'name)) (businessData)))
  (define (businessPhotos) (map (lambda (x) (hash-ref x 'image_url)) (businessData)))
  (define (businessPrice) (map (lambda (x) (hash-ref x 'price (lambda () "No price found!"))) (businessData)))
  (define (businessPhone) (map (lambda (x) (hash-ref x 'display_phone (lambda () "No number found!"))) (businessData)))
```
 
Essentially, the first foldr creates a list called ```businessData``` by folding each element of the json object, each time referencing the business portion of the ojbect. This created a list, where each element was a json object for a business. 

Since we wanted to get the data for each business, after that I mapped the ```businessData``` list, searching for whatever piece of information I was looking for, like name or phone number. At this point all the important data had been retrieved from the json format and put into a list which could be put to the screen.
 
## 2. Using Procedural Abstraction to Write to the GUI

The following code writes the data created above into the GUI. Before it does this, the information was concatenated into one list using Serey's code. That list is called ```combinations``. Basically each element of combinations is its own business.

```
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
```

This code used procedural abstraction because it doesn’t let the user know how it retrieved the information from the business combinations. All they can do is reference a business by number, and get it's information using accessor functions like ```getName``` or ```getPrice```. 

## 3. Object orientation

Once the data has been accessed, an object is created so it can be written to the screen. This object immediately calls the  ```changedata ```. The data from part 1 is also within this object. So creating this object automatically updates the GUI. 

```
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
```

In addition to doing that, the object also must have a state variable to know if it should create a button. When the program starts there should be no button, but once there is data there should be one. It also needs state to keep track of which piece of data its showing. the ```indexstart``` variable does both of those things in that ```indexstart``` is initially 0, which means no button, and goes up each time, counting the index of the data. 
