//
//  GlossExtensions.swift
//  Pods
//
//  Created by Rahul Katariya on 26/04/16.
//
//

import Gloss

/**
 Convenience operator for decoding JSON to array of Decodable objects
 */
public func <~~ <T: CollectionType where T.Generator.Element: Decodable>(key: String, json: JSON) -> T? {
    return Decoder.decodeDecodableCollection(key)(json)
}

/**
 Convenience operator for encoding array of Encodable objects to JSON
 */
public func ~~> <T: CollectionType where T.Generator.Element: Encodable>(key: String, property: T?) -> JSON? {
    return Encoder.encodeEncodableCollection(key)(property)
}

public extension Decoder {
    /**
     Returns function to decode JSON to value type
     for objects that conform to the Decodable protocol
     
     :parameter: key JSON key used to set value
     :parameter: keyPathDelimiter Delimiter used for nested keypath keys
     
     :returns: Function decoding JSON to an optional value type
     */
    public static func decodeDecodableCollection<T: CollectionType where T.Generator.Element: Decodable>(key: String, keyPathDelimiter: String = GlossKeyPathDelimiter) -> JSON -> T? {
        return {
            json in
            
            if let jsonArray = json.valueForKeyPath(key, withDelimiter: keyPathDelimiter) as? [JSON] {
                return T.fromJSONArray(jsonArray) as? T
            }
            
            return nil
            
        }
    }
}

public extension Encoder {
    
    /**
     Returns function to encode array as JSON
     for objects the conform to the Encodable protocol
     
     :parameter: key Key used to create JSON property
     
     :returns: Function encoding array to optional JSON
     */
    public static func encodeEncodableCollection<T: CollectionType where T.Generator.Element: Encodable>(key: String) -> T? -> JSON? {
        return {
            array in
            
            if let array = array {
                var encodedArray: [JSON] = []
                
                for model in array {
                    if let json = model.toJSON() {
                        encodedArray.append(json)
                    }
                }
                
                return [key : encodedArray]
            }
            
            return nil
        }
    }
    
}

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
