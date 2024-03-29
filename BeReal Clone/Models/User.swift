//
//  User.swift
//  BeReal Clone
//
//  Created by Efrain Rodriguez on 2/22/23.
//

import Foundation
import ParseSwift


struct User: ParseUser {
    // These are required by 'ParseObject'.
    
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    var lastPostedDate: Date?
    
    
    // These are required by 'ParseUser'
    
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String : [String : String]?]?
    
}
