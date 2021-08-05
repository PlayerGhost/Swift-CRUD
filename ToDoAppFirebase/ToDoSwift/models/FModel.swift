//
//  FModel.swift
//  ToDoSwift
//
//  Created by Player Ghost on 06/07/20.
//  Copyright © 2020 Player Ghost. All rights reserved.
//

import UIKit
import Firebase

class FModel: NSObject {
    var ref: DatabaseReference?
    
    override init(){
        super.init()
    }
    
    init(snapshot: DataSnapshot) {
        super.init()
        
        self.ref = snapshot.ref
    }
    
    func toDtictionary () -> [String: Any]{
        return [:]
    }
}
