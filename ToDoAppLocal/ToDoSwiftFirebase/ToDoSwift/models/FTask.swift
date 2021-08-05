//
//  FTask.swift
//  ToDoSwift
//
//  Created by Player Ghost on 06/07/20.
//  Copyright © 2020 Player Ghost. All rights reserved.
//

import UIKit
import Firebase

class FTask: FModel {
    var name: String?
    var done: Bool?
    var priority: Int?
    
    override init() {
        super.init()
    }
    
    override init(snapshot: DataSnapshot) {
        super.init(snapshot: snapshot)
        
        let snapshot = snapshot.value as! [String: Any]
        self.name = snapshot["name"] as? String
        self.done = snapshot["done"] as? Bool
        self.priority = snapshot["priority"] as? Int
    }
    
    override func toDtictionary () -> [String: Any]{
        return ["name": self.name!, "done": self.done!, "priority": self.priority!]
    }
}
