//
//  Post.swift
//  BeReal Clone
//
//  Created by Efrain Rodriguez on 2/22/23.
//

import Foundation
import ParseSwift

struct Post: ParseObject {
    // These are required by ParseObject
    
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    var location: ParseGeoPoint?
    
    // Your own custom properties
    
    var caption: String?
    var user: User?
    var imageFile: ParseFile?
}
