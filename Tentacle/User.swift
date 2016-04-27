//
//  User.swift
//  Tentacle
//
//  Created by Matt Diephouse on 4/12/16.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Decodable

/// A User on GitHub.
public struct User: Hashable, CustomStringConvertible {
    /// The unique ID of the user.
    public let ID: String
    
    /// The user's login/username.
    public let login: String
    
    /// The URL of the user's GitHub page.
    public let URL: NSURL
    
    /// The URL of the user's avatar.
    public let avatarURL: NSURL
    
    /// The user's name if they've set one.
    public let name: String?
    
    /// The user's public email address if they've set one.
    public let email: String?
    
    /// The URL of the user's website if they've set one
    public let websiteURL: NSURL?
    
    /// The user's company if they've set one.
    public let company: String?
    
    /// The date that the user joined GitHub.
    public let joinedDate: NSDate
    
    public let location: String?
    
    public var hashValue: Int {
        return ID.hashValue
    }
    
    public var description: String {
        return login
    }
    
    public init(ID: String, login: String, URL: NSURL, avatarURL: NSURL, name: String?, email: String?, websiteURL: NSURL?, company: String?, joinedDate: NSDate, location: String?) {
        self.ID = ID
        self.login = login
        self.URL = URL
        self.avatarURL = avatarURL
        self.name = name
        self.email = email
        self.websiteURL = websiteURL
        self.company = company
        self.joinedDate = joinedDate
        self.location = location
    }
}

public func ==(lhs: User, rhs: User) -> Bool {
    return lhs.ID == rhs.ID
        && lhs.login == rhs.login
        && lhs.URL == rhs.URL
        && lhs.avatarURL == rhs.avatarURL
        && lhs.name == rhs.name
        && lhs.email == rhs.email
        && lhs.websiteURL == rhs.websiteURL
        && lhs.company == rhs.company
        && lhs.joinedDate == rhs.joinedDate
}

extension User: ResourceType {
    public static func decode(json: AnyObject) throws -> User {
        return try User(
            ID: String(json => "id"),
            login: json => "login",
            URL: json => "url",
            avatarURL: json => "avatar_url",
            name: json =>? "name",
            email: json =>? "email",
            websiteURL: json =>? "blog",
            company: json =>? "company",
            joinedDate: json => "created_at",
            location: json => "location"
        )
    }
}
