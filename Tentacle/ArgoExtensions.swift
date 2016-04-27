//
//  ArgoExtensions.swift
//  Tentacle
//
//  Created by Matt Diephouse on 3/10/16.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Decodable
import Foundation
import Result


internal func decode<T: Decodable>(object: AnyObject) -> Result<T.DecodedType, DecodingError> {
    do {
        return try .Success(T.decode(object))
    } catch let error as DecodingError {
        return .Failure(error)
    } catch {
        fatalError("\(error)")
    }
}

internal func decode<T: Decodable where T.DecodedType == T>(object: AnyObject) -> Result<[T], DecodingError> {
    do {
        return try .Success([T].decode(object))
    } catch let error as DecodingError {
        return .Failure(error)
    } catch {
        fatalError("\(error)")
    }
}

internal func toString(number: Int) -> String {
    return number.description
}