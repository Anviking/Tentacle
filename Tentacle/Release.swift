//
//  Release.swift
//  Tentacle
//
//  Created by Matt Diephouse on 3/3/16.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Foundation
import Decodable

/// A Release of a Repository.
public struct Release: Hashable, CustomStringConvertible {
    /// An Asset attached to a Release.
    public struct Asset: Hashable, CustomStringConvertible {
        /// The unique ID for this release asset.
        public let ID: String

        /// The filename of this asset.
        public let name: String

        /// The MIME type of this asset.
        public let contentType: String

        /// The URL at which the asset can be downloaded directly.
        public let URL: NSURL
        
        /// The URL at which the asset can be downloaded via the API.
        public let APIURL: NSURL

        public var hashValue: Int {
            return ID.hashValue
        }

        public var description: String {
            return "\(URL)"
        }

        public init(ID: String, name: String, contentType: String, URL: NSURL, APIURL: NSURL) {
            self.ID = ID
            self.name = name
            self.contentType = contentType
            self.URL = URL
            self.APIURL = APIURL
        }
    }
    
    /// The unique ID of the release.
    public let ID: String

    /// Whether this release is a draft (only visible to the authenticted user).
    public let draft: Bool

    /// Whether this release represents a prerelease version.
    public let prerelease: Bool
    
    /// The name of the tag upon which this release is based.
    public let tag: String
    
    /// The name of the release.
    public let name: String?
    
    /// The web URL of the release.
    public let URL: NSURL
    
    /// Any assets attached to the release.
    public let assets: [Asset]
    
    public var hashValue: Int {
        return ID.hashValue
    }
    
    public var description: String {
        return "\(URL)"
    }
    
    public init(ID: String, tag: String, URL: NSURL, name: String? = nil, draft: Bool = false, prerelease: Bool = false, assets: [Asset]) {
        self.ID = ID
        self.tag = tag
        self.URL = URL
        self.name = name
        self.draft = draft
        self.prerelease = prerelease
        self.assets = assets
    }
}

public func ==(lhs: Release.Asset, rhs: Release.Asset) -> Bool {
    return lhs.ID == rhs.ID && lhs.URL == rhs.URL
}

public func ==(lhs: Release, rhs: Release) -> Bool {
    return lhs.ID == rhs.ID
        && lhs.tag == rhs.tag
        && lhs.URL == rhs.URL
        && lhs.name == rhs.name
        && lhs.draft == rhs.draft
        && lhs.prerelease == rhs.prerelease
        && lhs.assets == rhs.assets
}

extension Release.Asset: ResourceType {
    public static func decode(json: AnyObject) throws -> Release.Asset {
        return try Release.Asset(
            ID: toString(json => "id"),
            name: json => "name",
            contentType: json => "content_type",
            URL: json => "browser_download_url",
            APIURL: json => "url"
            )
    }
}

extension Release: ResourceType {
    public static func decode(json: AnyObject) throws -> Release {
        return try Release(
            ID: toString(json => "id"),
            tag: json => "tag_name",
            URL: json => "html_url",
            name: json =>? "name",
            draft: json => "draft",
            prerelease: json => "prerelease",
            assets: json => "assets"
            )
    }
}
