# StackOverflowClient
---------------------

## Initial
----------
Add initial files & functionality for the StackOverflow Client App

* Create your burger menu via a custom container controller. Setup both a burger button and slide recognizer.
* Using WKWebView, implement the OAuth workflow to get an auth token
* Use lazy loading on at least one of your properties

## Questions
------------------------
* Create a SearchQuestionViewController with a table view and search bar
* Create a StackOverFlowService class that will act as your network controller
* Create a method to fetch questions based on a search term
* Lazily load the question's avatar image

Lifted code on putting up an AlertView from StackOverflow.

## Profile
----------
* Create a way to be able to switch view controllers using your burger menu
* Create a profile view controller that shows the logged in users stack overflow information
* Disable arc on the profile view controller. you will need to use manual-retain-release practices for this VC

## Questions
-------------
* As my user account at Stack Overflow had no questions associated with it, the "items" array in the returned JSON data for the /me/questions?order=desc&sort=activity&site=stackoverflow request is empty and there's no real data to display. this is the same for all the other "me" commands. So, Brad OK'd just implementing the Search and My Profile commands.
