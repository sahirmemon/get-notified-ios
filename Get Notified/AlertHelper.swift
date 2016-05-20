//
//  AlertHelper.swift
//  Get Notified
//
//  Created by Sahir Memon on 5/19/16.
//  Copyright © 2016 Sahir Memon. All rights reserved.
//

import UIKit

// Present an alert with the given title and message in the specified view controller.
func presentAlertWithTitle(title: String!, message: String, viewController: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let action = UIAlertAction(title: "Okay", style: .Cancel, handler: nil)
    alert.addAction(action)
    viewController.presentViewController(alert, animated: true, completion: nil)
}