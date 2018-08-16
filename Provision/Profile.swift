//
//  Profile.swift
//  Provision
//
//  Created by Dalton Claybrook on 8/15/18.
//  Copyright © 2018 Claybrook Software, LLC. All rights reserved.
//

import Foundation
import Security

enum ProfileError: Error {
  case invalidPlist
  case failedCast(key: String)
  case decoderError
}

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

extension Profile {
  init(signedData: Data) throws {
    var aDecoder: CMSDecoder? = nil
    CMSDecoderCreate(&aDecoder)
    guard let decoder = aDecoder else {
      throw ProfileError.decoderError
    }

    _ = signedData.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) in
      CMSDecoderUpdateMessage(decoder, UnsafeRawPointer(pointer), signedData.count)
    }

    CMSDecoderFinalizeMessage(decoder)

    var cfData: CFData?
    CMSDecoderCopyContent(decoder, &cfData)
    guard let outCFData = cfData else {
      throw ProfileError.decoderError
    }

    try self.init(data: outCFData as Data)
  }

  init(data: Data) throws {
    guard let propertyList = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
      throw ProfileError.invalidPlist
    }

    platforms = try propertyList.castValue(for: "Platform")
    UUID = try propertyList.castValue(for: "UUID")
    developerCertificates = try propertyList.castValue(for: "DeveloperCertificates")
    teamName = try propertyList.castValue(for: "TeamName")
    expirationDate = try propertyList.castValue(for: "ExpirationDate")
    creationDate = try propertyList.castValue(for: "CreationDate")
    entitlements = try propertyList.castValue(for: "Entitlements")
    applicationIdentifierPrefix = try propertyList.castValue(for: "ApplicationIdentifierPrefix")
    teamIdentifier = try propertyList.castValue(for: "TeamIdentifier")
    name = try propertyList.castValue(for: "Name")
    provisionedDevices = try propertyList.castValue(for: "ProvisionedDevices")
    appIDName = try propertyList.castValue(for: "AppIDName")
  }
}

private extension Dictionary where Key == String, Value == Any {
  func castValue<T>(for key: String) throws -> T {
    guard let value = self[key] as? T else {
      throw ProfileError.failedCast(key: key)
    }
    return value
  }
}
