//
//  SideMenuItemController.swift
//  Chatter
//
//  Created by Nick Kurochkin on 06.03.2020.
//  Copyright © 2020 Nick Kurochkin. All rights reserved.
//

import UIKit
import Foundation

/// Menu item UIViewController.
open class SideMenuItemController: UIViewController {
    /// Menu drawer delegate to toggle menu from controller and to change menu item from controller.
    public var sideMenuDelegate: SideMenuDelegate?
    /// Proportion to previous frame size.
    public internal(set) var proportion: CGFloat = 1.0
    /// Proportion to UIScreen.main.bounds.
    public internal(set) var absoluteProportion: CGFloat = 1.0
    
    /**
    Relayout view & it's subviews.
    - Parameters:
       - proportion : proportion to previous frame size.
    */
    internal func relayoutViewWithSubviews(proportion: CGFloat) {
        self.proportion = proportion
        self.relayoutSubviews(in: self.view)
    }
    
    private func relayoutSubviews(in view: UIView) {
        for view in view.subviews {
            view.frame = CGRect(
                x: view.frame.minX * self.proportion,
                y: view.frame.minY * self.proportion,
                width: view.frame.width * self.proportion,
                height: view.frame.height * self.proportion )
            self.relayoutSubviews(in: view)
        }
    }
    
    /**
    Disable/enable view interaction .
    - Parameters:
        - dimm : disable/enable parameter.
    */
    internal func disableViewInteraction(_ dimm: Bool) {
        for item in view.subviews {
            item.isUserInteractionEnabled = !dimm
        }
    }
}
