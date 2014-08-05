SnappyClonish
=============

Demo of iOS snap chat clone to show iOS development skills.

Users send & receive photos & video messages that self destruct after 10 seconds.

UImagePickerController captures photos & videos. 
Photos are compressed and shown in UIImage views.
Videos are limited to 10 seconds.
Videos are shown with MPMoviePlayerController (MediaPlayer framework).

Parse.com cloud storage handles the user accounts & message storage.

UITabBarController is used to make tab-based navigation.

Storyboard, seques, table views, and view controllers were created.

Design
=======
* Start with empty project in XCode.
* Add UITabBarController & define main tabs.
* Stub out login and signup screens.
* Use graphics from templates.

Add Parse.com and Add Friends
=============================
* Add Parse.com baas platform.
* Add Parse.com user account management.
* Create and save a new user in Parse.com data store. 
* Show error message if something goes wrong with UIAlertView.
* Login screen and save user info on the device.

User Relations with Parse.com
==============================
* Add "friends" in app to have Parse user objects relate with each other.
* New screen to get all available users, add or delete them as friends.
* Populate main friends screen with list of friends.

Capture Photo & Video
=====================
* Load UIImagePickerController for the default camera view to capture photo and video. 
* Save captured media to photo album and then let user choose friends to receive the self destructing message.
* Upload photo or video to Parse.com and save message details to include sender and receiver.

Retrieve & View Data
====================
* Download and display messages from Parse.com into our app.
* Query Parse.com to get all the unseen messages for the logged in user. 
* View photos on view controller that will timeout after 10 seconds. 
* Show video with MPMoviePlayerController.
