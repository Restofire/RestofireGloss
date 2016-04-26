//
//  GlossExtensions.swift
//  Pods
//
//  Created by Rahul Katariya on 26/04/16.
//
//

import Gloss

public extension CollectionType where Generator.Element: Decodable {
    
    /**
     Returns array of new instances created from provided JSON array
     
     Note: The returned array will have only models that successfully
     decoded
     
     :parameter: json Array of JSON representations of object
     */
    static func fromJSONArray(jsonArray: [JSON]) -> [Generator.Element] {
        var models: [Generator.Element] = []
        
        for json in jsonArray {
            let model = Generator.Element(json: json)
            
            if let model = model {
                models.append(model)
            }
        }
        
        return models
    }
    
}

public extension CollectionType where Generator.Element: Encodable {
    
    /**
     Objects encoded as JSON Array
     
     :returns: JSON array
     */
    func toJSONArray() -> [JSON]? {
        var jsonArray: [JSON] = []
        
        for json in self {
            if let json = json.toJSON() {
                jsonArray.append(json)
            }
        }
        
        return jsonArray
    }
}
