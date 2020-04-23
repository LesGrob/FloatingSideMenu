//
//  SideMenu.swift
//  Chatter
//
//  Created by Nick Kurochkin on 03.03.2020.
//  Copyright © 2020 Nick Kurochkin. All rights reserved.
//

import Foundation
import UIKit

public enum SideMenuState {
    case menu
    case controller
}

public protocol SideMenuDelegate {
    func toggleMenu()
    func selectItem(index: Int)
}

open class SideMenu: UIViewController {
    private var drawer: SideMenuDrawer!
    
    public private(set) var items: [SideMenuItem] = []
    public private(set) var path: SideMenuPath = SideMenuPath()
    public var menuState: SideMenuState { get { return drawer.menuState } }
    public var menuItemCellClass: SideMenuItemCellDelegate.Type = SideMenuItemCell.self
    
    public var openSwipeIsEnabled: Bool = true
    public var closeSwipeIsEnabled: Bool = true
    
    public var disableViewIteraction: Bool = true
    
    public var topView: UIView?
    public var bottomView: UIView?
    
    
    public init(items: [SideMenuItem]) {
        super.init(nibName: nil, bundle: nil)
        self.items = items
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        drawer = SideMenuDrawer(controller: self)
        selectItem(index: 0)
    }
    
    public func selectItem(index: Int) {
        guard index >= 0, index < items.count, index != path.selectedIndex else { return }
        
        let newPath = SideMenuPath(previousIndex: path.selectedIndex, selectedIndex: index)
        drawer.drawMenu(for: newPath)
        path = newPath
    }
    
    
    public func validPath(path: SideMenuPath) -> Bool {
        return (path.previousIndex == nil || (path.previousIndex! >= 0 && path.previousIndex! < items.count)) &&
            (path.selectedIndex == nil || (path.selectedIndex! >= 0 && path.selectedIndex! < items.count))
    }
}
