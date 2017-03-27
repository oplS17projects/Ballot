# Ballot

When deciding where we want to have lunch or dinner, we tend to be very indecisive. What if we had a handy Racket program that will help you decide based on what kind of food you want at the time? 

## Making the Request

Because it is rather cumbersome to make authenticate with OAuth (see https://oauth.net) to access Yelp, we've created our own API to access Yelp without authentication.

To make the request, we will be using the `net/url` library to make the GET request to the endpoint.

## Parsing the JSON

To ease this process, we had to learn how <a href="https://docs.racket-lang.org/reference/dicts.html" target="_blank">dictionaries</a> function in Racket. (i.e. accessing an element given a key, retrieval, etc.) After we've received a response from the API, we will convert the pure port to a string, so we can convert it to a <a href="https://docs.racket-lang.org/json/" target="_blank">JSON</a> as well.

After we have our JSON that has been binded to a symbol in our environment, this is where the parsing really happens. Using accumulate, or <a href="https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Fprivate%2Flist..rkt%29._foldr%29%29" target="_blank">foldr</a>, we will create a list of businesses retrieved from the end point. Then, we will use <a href="https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Fprivate%2Fmap..rkt%29._map%29%29" target="_blank">map</a> to create our final list that will contain only the information that we will use to render in the application.
##### Keys to Map
<ul>
  <li>Name</li>
  <li>Location</li>
  <li>Open Status</li>
  <li>Rating</li>
  <li>Image URL for Rendering</li>
</ul> 

## Rendering the Information

To render the information, it will require us to use the <a href="https://docs.racket-lang.org/draw/" target="_blank">`racket/draw`</a> library.

##### Render Checklist
<ul>
  <li> Create a responsive frame </li>
  <li> Render response image for each businesses, with a size constraint </li>
  <li> Button Rendering for randomizing each businesses </li>
</ul> 

## To Be Determined

<ul>
  <li> How we will random each businesses to render </li>
  <li> Avoiding collisions when randomizing </li>
  <li> Rendering a UI that will be both responsive, and usable </li>
  <li> Making the front-end communicate with the back end to retrieve user inputs </li>
</ul>

