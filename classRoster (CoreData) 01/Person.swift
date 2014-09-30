//
//  Person.swift
//  classRoster (CoreData) 01
//
//  Created by Jeff Chavez on 9/6/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit
import CoreData

@objc(Person)

class Person: NSManagedObject {

    @NSManaged var firstNameAttribute: String
    @NSManaged var lastNameAttribute: String
    @NSManaged var photoAttribute: NSData?
    @NSManaged var gitHubUserNameAttribute: String?
    @NSManaged var gitHubPhotoAttribute: NSData?
    @NSManaged var roleAttribute: Float
    
    convenience init (firstName: String, lastName: String, role: Float) {
        self.init()
        self.firstNameAttribute = firstName
        self.lastNameAttribute = lastName
        self.roleAttribute = role
    }
}