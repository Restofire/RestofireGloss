//
//  GlossUtils.swift
//  Restofire-Gloss
//
//  Created by Rahul Katariya on 24/04/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import Restofire
import Alamofire
import Gloss

public class GlossUtils {
    
    /// Creates a response serializer that returns a GLOSS object constructed from
    /// the response data using `NSJSONSerialization` with the specified reading options.
    ///
    /// - returns: A GLOSS object response serializer.
    public static func GLOSSResponseSerializer<M: Decodable>() -> ResponseSerializer<M, NSError> {
        return ResponseSerializer { _, _, data, error in
            guard error == nil else { return .Failure(error!) }
            
            guard let validData = data where validData.length > 0 else {
                let failureReason = "JSON could not be serialized. Input data was nil or zero length."
                let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            do {
                let JSONObject = try NSJSONSerialization.JSONObjectWithData(validData, options: .AllowFragments)
                if let JSONObject = JSONObject as? JSON, let value = M(json: JSONObject) {
                    return .Success(value)
                } else {
                    let error = NSError(domain: "com.rahulkatariya.Restofire-Gloss", code: -1, userInfo: [NSLocalizedDescriptionKey:"TypeMismatch(Expected \(M.self), got \(JSONObject.dynamicType))"])
                    return .Failure(error)
                }
            } catch {
                return .Failure(error as NSError)
            }
        }
    }
    
    /// Creates a response serializer that returns a GLOSS object constructed from
    /// the response data using `NSJSONSerialization` with the specified reading options.
    ///
    /// - returns: A GLOSS object response serializer.
    public static func GLOSSResponseSerializer<M: CollectionType where M.Generator.Element: Decodable>() -> ResponseSerializer<M, NSError> {
        return ResponseSerializer { _, _, data, error in
            guard error == nil else { return .Failure(error!) }
            
            guard let validData = data where validData.length > 0 else {
                let failureReason = "JSON could not be serialized. Input data was nil or zero length."
                let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            do {
                let JSONArray = try NSJSONSerialization.JSONObjectWithData(validData, options: .AllowFragments)
                if let JSONArray = JSONArray as? [JSON], let value = M.fromJSONArray(JSONArray) as? M {
                    return .Success(value)
                } else {
                    let error = NSError(domain: "com.rahulkatariya.Restofire-Gloss", code: -1, userInfo: [NSLocalizedDescriptionKey:"TypeMismatch(Expected \(M.self), got \(JSONArray.dynamicType))"])
                    return .Failure(error)
                }
            } catch {
                return .Failure(error as NSError)
            }
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
