//
//  GlossResponseSerializable.swift
//  Restofire-Gloss
//
//  Created by Rahul Katariya on 24/04/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import Restofire
import Alamofire
import Gloss

public extension ResponseSerializable where Model: Decodable {
    
    /// `GLOSSResponseSerializer`
    public var responseSerializer: ResponseSerializer<Model, NSError> {
        return GlossUtils.GLOSSResponseSerializer()
    }
    
}

public extension ResponseSerializable where Model: CollectionType, Model.Generator.Element: Decodable {
    
    /// `GLOSSResponseSerializer`
    public var responseSerializer: ResponseSerializer<Model, NSError> {
        return GlossUtils.GLOSSResponseSerializer()
    }
    
}
