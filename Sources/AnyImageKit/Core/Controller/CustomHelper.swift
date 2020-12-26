//
//  CustomHelper.swift
//  AnyImageKit
//
//  Created by RoyLei on 12/26/20.
//  Copyright © 2020 AnyImageProject.org. All rights reserved.
//

import Foundation

public protocol CustomHelperDelegate: AnyObject {
    func showAlert(message: String, actionTitle: String)
}

public class CustomHelper {
    static var defaultHelper = CustomHelper()
    open var delegate:CustomHelperDelegate?
}
