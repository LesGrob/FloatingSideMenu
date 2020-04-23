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
    public internal(set) var absoluteProportion: CGFloat = 1.0
    
    internal func relayoutSubviews(proportion: CGFloat) {
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
    
    internal func disableViewIteraction(_ dimm: Bool) {
        for item in view.subviews {
            item.isUserInteractionEnabled = !dimm
        }
    }
}
