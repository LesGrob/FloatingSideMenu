//
//  SideMenuItemController.swift
//  Chatter
//
//  Created by Nick Kurochkin on 06.03.2020.
//  Copyright © 2020 Nick Kurochkin. All rights reserved.
//

import UIKit
import Foundation

open class SideMenuItemController: UIViewController {
    public var sideMenuDelegate: SideMenuDelegate?
    public internal(set) var proportion: CGFloat = 1.0
}
