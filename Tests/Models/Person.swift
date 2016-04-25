//
//  Person.swift
//  Restofire-Gloss
//
//  Created by Rahul Katariya on 24/04/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import Gloss

struct Person: Decodable {
    
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init?(json: JSON) {
        guard let id: Int = "id" <~~ json,
            let name: String = "name" <~~ json else { return nil }
        
        self.id = id
        self.name = name
    }
    
}

extension Person: Equatable { }

func ==(lhs: Person, rhs: Person) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
}