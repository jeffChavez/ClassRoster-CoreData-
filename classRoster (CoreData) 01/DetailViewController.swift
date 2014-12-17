//
//  DetailViewController.swift
//  Class Roster (Core Data)
//
//  Created by Jeff Chavez on 9/3/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate {
    
    var selectedPerson: Person?
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var gitHubUserNameTextField: UITextField!
    @IBOutlet var gitHubPhotoImageView: UIImageView!
    @IBOutlet var gitHubActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var roleSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //fill in textFields with data from selectedPerson
        firstNameTextField.text = selectedPerson?.firstNameAttribute
        lastNameTextField.text = selectedPerson?.lastNameAttribute
        gitHubUserNameTextField.text = selectedPerson?.gitHubUserNameAttribute
        
        //if the roleAttribute is empty (because the user is adding a new person), then set a default role of 0 (student)
        if selectedPerson?.roleAttribute == nil {
            roleSegmentedControl.selectedSegmentIndex = 0
        }
        else {
            //otherwise assign role the selectedPerson's roleAttribute
            roleSegmentedControl.selectedSegmentIndex = Int(selectedPerson!.roleAttribute)
        }
        
        //decide text for title bar
        if firstNameTextField.text == "" && lastNameTextField.text == "" {
            self.title = "Add New Person"
        }
        else {
            self.title = "\(selectedPerson!.firstNameAttribute) \(selectedPerson!.lastNameAttribute)"
        }
        
        //populate imageViews with photos from selectedPerson or use placeholders if selectedPerson data is empty
        if self.selectedPerson?.photoAttribute != nil {
            self.photoImageView.image = UIImage (data: selectedPerson!.photoAttribute!)
        }
        else {
            self.photoImageView.image = UIImage (named: "placeholder.jpg")
        }
        if self.selectedPerson?.gitHubPhotoAttribute != nil {
            self.gitHubPhotoImageView.image = UIImage (data: selectedPerson!.gitHubPhotoAttribute!)
        }
        else {
            self.gitHubPhotoImageView.image = UIImage (named: "gitHubDefault")
        }
        
        //apply imageView styles
        self.photoImageView.layer.cornerRadius = 100.0
        self.photoImageView.layer.masksToBounds = true
        self.photoImageView.layer.borderWidth = 0.5
        self.gitHubPhotoImageView.layer.cornerRadius = 3
        self.gitHubPhotoImageView.layer.masksToBounds = true
        self.gitHubPhotoImageView.layer.borderWidth = 0.5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //when touching outside of the textbox or keyboard, dismiss keyboard
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    //when return is pressed, dismiss keyboard
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //save any changes made
    @IBAction func saveData (sender: AnyObject) {
        
        //reference to our app delegate
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("Person", inManagedObjectContext: context)
        
        //check if person exists, if so fill selectedPerson data with object data
        if selectedPerson? != nil {
            selectedPerson?.firstNameAttribute = firstNameTextField.text
            selectedPerson?.lastNameAttribute = lastNameTextField.text
            selectedPerson?.gitHubUserNameAttribute = gitHubUserNameTextField.text
            selectedPerson!.roleAttribute = Float(roleSegmentedControl.selectedSegmentIndex)
            if photoImageView.image == UIImage (named: "placeholder.jpg") {
                selectedPerson?.photoAttribute = nil
            }
            else {
                selectedPerson?.photoAttribute = UIImagePNGRepresentation(photoImageView.image)
            }
            if gitHubPhotoImageView.image == UIImage (named: "gitHubDefault") {
                selectedPerson?.gitHubPhotoAttribute = nil
            }
            else {
                selectedPerson?.gitHubPhotoAttribute = UIImagePNGRepresentation(gitHubPhotoImageView.image)
            }
        }
        else {
            
            //create new instance of our data model and initialize
            var newPerson = Person(entity: en!, insertIntoManagedObjectContext: context)
            
            //map our properties
            newPerson.firstNameAttribute = firstNameTextField.text
            newPerson.lastNameAttribute = lastNameTextField.text
            newPerson.gitHubUserNameAttribute = gitHubUserNameTextField.text
            newPerson.roleAttribute = Float(roleSegmentedControl.selectedSegmentIndex)
            if photoImageView.image == UIImage (named: "placeholder.jpg") {
                newPerson.photoAttribute = nil
            }
            else {
                newPerson.photoAttribute = UIImagePNGRepresentation(photoImageView.image)
            }
            if gitHubPhotoImageView.image == UIImage (named: "gitHubDefault") {
                newPerson.gitHubPhotoAttribute = nil
            }
            else {
                newPerson.gitHubPhotoAttribute = UIImagePNGRepresentation(gitHubPhotoImageView.image)
            }
        }
        
        //save our context
        context.save(nil)
        
        //navigate back to vc
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func cancelData (sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func choosePhotoIsPressed (sender: AnyObject) {
        var choosePhoto = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        choosePhoto.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == true {
                var imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.allowsEditing = true
                imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(imagePickerController, animated: true, completion: nil)
            }
            else {
                var alert = UIAlertView()
                alert.title = "No Device"
                alert.message = "Your device does not have the proper camera"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
            })
        choosePhoto.addAction(UIAlertAction(title: "Choose Existing", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            var imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            self.presentViewController(imagePickerController, animated: true, completion: nil)
            })
        if self.selectedPerson?.photoAttribute != nil {
            choosePhoto.addAction(UIAlertAction(title: "Delete Photo", style: UIAlertActionStyle.Destructive) { (UIAlertAction) -> Void in
                self.photoImageView.image = UIImage (named: "placeholder.jpg")
                })
        }
        choosePhoto.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
        self.presentViewController(choosePhoto, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        var editedImage = info[UIImagePickerControllerEditedImage] as UIImage
        self.photoImageView.image = editedImage
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func grabGitButton (sender:AnyObject) {
        var alertTextField : UITextField = UITextField()
        var enterGitHubInfo = UIAlertController(title: "Grab Info", message: "What is the peron's GitHub Username?", preferredStyle: UIAlertControllerStyle.Alert)
        enterGitHubInfo.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Username"
            alertTextField = textField
        })
        enterGitHubInfo.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
        enterGitHubInfo.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.gitHubUserNameTextField.text = alertTextField.text
            self.getGitHubProfilePhoto(alertTextField.text)
            })
        self.presentViewController(enterGitHubInfo, animated: true, completion: nil)
    }
    
    var imageDownloadQueue = NSOperationQueue()
    func getGitHubProfilePhoto (searchUsername: String) -> Void {
        self.gitHubActivityIndicator.startAnimating()
        let gitHubURL = NSURL (string: "https://api.github.com/users/\(searchUsername)")
        var profilePhotoURL = NSURL()
        self.imageDownloadQueue.addOperationWithBlock { () -> Void in
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(gitHubURL!, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    println("error1")
                    self.gitHubPhotoImageView.image = UIImage (named: "gitHubDefault")
                    self.gitHubUserNameTextField.text = nil
                    var alert = UIAlertView()
                    alert.title = "Error"
                    alert.message = "There was an error retrieving your GitHub image, please check your WiFi connection"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    self.gitHubActivityIndicator.stopAnimating()
                } else {
                    var err: NSError?
                    var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                    if err != nil {
                        println("error2")
                    } else {
                        if let avatarURL = jsonResult["avatar_url"] as? String {
                            profilePhotoURL = NSURL(string: avatarURL)!
                        }
                        var profilePhotoData = NSData(contentsOfURL: profilePhotoURL)
                        var profilePhotoImage = UIImage (data: profilePhotoData!)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.gitHubPhotoImageView.image = profilePhotoImage
                            self.gitHubActivityIndicator.stopAnimating()
                            if self.gitHubPhotoImageView.image == nil {
                                self.gitHubPhotoImageView.image = UIImage (named: "gitHubDefault")
                                self.gitHubUserNameTextField.text = nil
                                var alert = UIAlertView()
                                alert.title = "Invalid Username"
                                alert.message = "Please enter a valid GitHub Username"
                                alert.addButtonWithTitle("OK")
                                alert.show()
                            }
                        })
                    }
                }
            })
            task.resume()
        }
    }
}