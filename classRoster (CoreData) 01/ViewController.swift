//
//  ViewController.swift
//  Class Roster (Core Data)
//
//  Created by Jeff Chavez on 9/3/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var classArray  = [Person]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        initializeArraysWithCoreData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.classArray.sort {$0.lastNameAttribute < $1.lastNameAttribute}
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return classArray.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        var personForRow : Person = classArray[indexPath.row]
        cell.textLabel.text = "\(personForRow.firstNameAttribute) \(personForRow.lastNameAttribute)"
        return cell
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        let context = getContext()
        if editingStyle == UITableViewCellEditingStyle.Delete {
            context.deleteObject(classArray[indexPath.row] as NSManagedObject)
            classArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            context.save(nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        let indexPath = self.tableView.indexPathForSelectedRow()
        if segue.identifier == "showPersonSegue" {
            let destination = segue.destinationViewController as DetailViewController
            destination.selectedPerson = self.classArray[indexPath.row]
        }
    }
    
    func initializeArraysWithCoreData () {
        //get context for coredata
        let context = getContext()
        
        //locate entityName "Person" and assign to fetchEntity
        let fetchEntity = NSFetchRequest(entityName: "Person")
        
        //load classArray with Person entity(s)
        classArray = context.executeFetchRequest(fetchEntity, error: nil) as [Person]
        
        //if this is the user's first launch classArray will be empty (because coredata is empty), so it needs to be loaded with names manually
        if classArray.isEmpty {
            initializeCoreDataWithNames()
        }
    }
    
    func initializeCoreDataWithNames () {
        var studentNames = ["Birkholz": "Nate", "Brightbill": "Matthew", "Chavez": "Jeff", "Ferderer": "Chrstie",
            "Fry": "David", "Gherle": "Adrian", "Hawken": "Jake", "Kazi": "Shams", "Klein": "Cameron",
            "Kolodziejczak": "Kori", "Lewis": "Parker", "Ma": "Nathan", "MacPhee": "Casey", "McAleer": "Brendan", "Mendez": "Brian",
            "Morris": "Mark", "North": "Rowan", "Pham": "Kevin", "Richman": "Will", "Thueringer": "Heather", "Vu": "Tuan",
            "Walkingstick": "Zack", "Wong": "Sara", "Zhang": "Hongyao"]
        var teacherNames = ["Clem": "John", "Johnson": "Brad"]
        
        //get context for coredata
        let context = getContext()
        
        //for each item in studentNames, create a new person entity and assign the first and last name values of studentNames to their corresponding attributes inside coredata. Also assign roleAttribute to 0, which will mark them as a student
        for (lastName, firstName) in studentNames {
            var person: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: context)
            
            person.setValue(firstName, forKey: "firstNameAttribute")
            person.setValue(lastName, forKey: "lastNameAttribute")
            person.setValue(0, forKey: "roleAttribute")
        }
        
        //for each item in studentNames, create a new person entity and assign the first and last name values of studentNames to their corresponding attributes inside coredata. Also assign roleAttribute to 1, which will mark them as a teacher
        for (lastName, firstName) in teacherNames {
            var person: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: context)
            
            person.setValue(firstName, forKey: "firstNameAttribute")
            person.setValue(lastName, forKey: "lastNameAttribute")
            person.setValue(1, forKey: "roleAttribute")
        }
        //relaunch the initializeArraysWithCoreData function. Now that coredata is filled with names as Person entities, we can load them into classArray.
        initializeArraysWithCoreData()
    }

    //this tells coredata to find all of its properties and functions inside AppDelegate
    func getContext() -> NSManagedObjectContext {
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        return context
    }
}