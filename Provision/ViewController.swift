//
//  ViewController.swift
//  Provision
//
//  Created by Dalton Claybrook on 8/15/18.
//  Copyright © 2018 Claybrook Software, LLC. All rights reserved.
//

import Cocoa
import Security

class ViewController: NSViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let profileURL = Bundle.main.url(forResource: "enterprise", withExtension: "mobileprovision")!
    let data = try! Data(contentsOf: profileURL)
    let profile = try! Profile(signedData: data)
    print("profile: \(profile)")
  }
}

