//
//  Profile.swift
//  Provision
//
//  Created by Dalton Claybrook on 8/15/18.
//  Copyright © 2018 Claybrook Software, LLC. All rights reserved.
//

import Foundation

struct Profile {
  let platforms: [String]
  let UUID: String
  let developerCertificates: [Data]
  let teamName: String
  let expirationDate: Date
  let creationDate: Date
  let entitlements: [String: Any]
  let applicationIdentifierPrefix: [String]
  let teamIdentifier: [String]
  let name: String
  let provisionedDevices: [String]
  let appIDName: String
}
