# Ballot

### Statement 

When deciding where we want to have lunch or dinner, we tend to be very indecisive. What if we had a handy program that will help you decide based on what kind of food you want at the time? 

## Analysis

Parsing JSON object responses today in popular languages such as `JavaScript`, `Swift`, `Ruby`, etc. typically involves mapping and filtering through dictionaries of information. Working through this project, it will require us to map and filter through a lot of objects in order to get the result that we want.

Because our interface requires input from the user, we will be using state-modification as well. State-modification will be used to change the default state of an object that has been binded to the global environment. We will be forced to use `set!` to change the value of each object so it can be interpolated into the URL Request Strings to make the `GET` request.

## External Technologies and Data Sets

To retrieve data for rendering, we will be making `HTTP GET` requests to Yelp<a href="https://www.yelp.com/developers" target="_blank">Yelp</a>. Because it's rather cumbersome to make requests through OAuth (a standard for authenticating to a secure API, see https://oauth.net) to gain access to Yelp, we've deployed our own API on Heroku which completely disbands the whole process of authentication. 

In order to make this happen, we will be using the `net/url` library to make the GET request to the endpoint.

#### Parsing the JSON

To ease this process, we have to learn how <a href="https://docs.racket-lang.org/reference/dicts.html" target="_blank">dictionaries</a> function in Racket. (i.e. accessing an element given a key, retrieval, etc.) After obtaining a response from the API, we will convert the pure port to a string, so we can convert it to a <a href="https://docs.racket-lang.org/json/" target="_blank">JSON</a> as well.

After obtaining the JSON and binding it to our environment, this is where the parsing really happens. Using accumulate, or <a href="https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Fprivate%2Flist..rkt%29._foldr%29%29" target="_blank">foldr</a>, we will create a list of businesses retrieved from the end point. Then, we will use <a href="https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Fprivate%2Fmap..rkt%29._map%29%29" target="_blank">map</a> to create our final list that will contain only the information that we will use to render in the application.
##### Keys to Map
<ul>
  <li>Name</li>
  <li>Location</li>
  <li>Open Status</li>
  <li>Rating</li>
  <li>Image URL for Rendering</li>
  <li>Possibly more..?</li>
</ul> 

##### Rendering the Information

To render the information, it will require us to use the <a href="https://docs.racket-lang.org/draw/" target="_blank">`racket/draw`</a> library.
 

## Deliverable and Demonstration

The final product of this application will be a program that will,
<ol>
  <li>Allow users to enter the type of `food` and the `location`</li>
  <li>Use the user's input to make a request to Yelp
  <li>Render a random point-of-interest related to the search term</li>
  <li>User will be able to "Shuffle" for another restaurant</li>
  <li>Error Handling: Render something if Yelp doesn't return any points-of-interest</li>
</ol>

As well as a working program, the information will be rendered in a GUI frame.

##### Render Checklist
<ul>
  <li> Create a responsive frame </li>
  <li> Render response image for each businesses, with a size constraint </li>
  <li> Button Rendering for "shuffling" each businesses </li>
</ul>

##### Possible Features

<ul>
  <li> How we will random each businesses to render </li>
  <li> Avoiding collisions when randomizing </li>
  <li> Rendering a UI that will be both responsive, and usable </li>
  <li> Making the front-end communicate with the back end to retrieve user inputs </li>
</ul>

#### Evaluation of Results

If we are able to render such information in a working frame, then we will know that we have successfully implemented the program.

## Architecture Diagram

