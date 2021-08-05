//
//  FCategory.swift
//  ToDoSwift
//
//  Created by Player Ghost on 06/07/20.
//  Copyright © 2020 Player Ghost. All rights reserved.
//

import UIKit
import Firebase

class FCategory: FModel {
    var name: String?
    
    override init(){
        super.init()
    }
    
    override init(snapshot: DataSnapshot) {
        super.init(snapshot: snapshot)
        
        let snapshot = snapshot.value as! [String: Any]
        self.name = snapshot["name"] as? String
    }
    
    override func toDtictionary () -> [String: Any]{
        return ["name": self.name!]
    }
}
