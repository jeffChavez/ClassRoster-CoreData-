ClassRoster-CoreData-
=====================

This app displays the names of students and teachers for our iOS Code Fellows class inside of a `UITableView`. Upon selecting a person, the user is taken to a `DetailViewController` where they can see specific attributes of that person, like a picture, first and last name, github username, and role. This data is persisted using `CoreData`.

The user can retrieve a GitHub profile image associated with the username they type in the textfield.

![Imgur](http://imgur.com/2Gy5SAT.gif)

The user can select a photo from their photo album, or take a picture from their camera.

![Imgur](http://imgur.com/PQLPZEN.gif)

The app supports both portrait and lanscape orientation
![Imgur](http://i.imgur.com/Iy1u9EW.gif)

###Features
- Data persistance with `CoreData`
- `UITableView`
- `UIImagePicker`
- `UIAlertController`
- Network call to GitHub with `NSURLSession`
- Parsing the JSON Object with `NSJSONSerialization` to get the `profileImageURL`
- Asynchronous calls with `NSOperationQueue`, for downloading the profile image on a separate thread
- AutoLayout, supports portrait and landscape orientation
