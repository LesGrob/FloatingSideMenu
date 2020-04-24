//
//  SideMenu.swift
//  Chatter
//
//  Created by Nick Kurochkin on 03.03.2020.
//  Copyright © 2020 Nick Kurochkin. All rights reserved.
//

import Foundation
import UIKit

/// Menu state.
public enum SideMenuState {
    case menu
    case controller
}

/// Menu class.
open class SideMenu: UIViewController {
    private var drawer: SideMenuDrawer!
    
    /// Items of menu.
    public private(set) var items: [SideMenuItem] = []
    /// Current menu path.
    public private(set) var path: SideMenuPath = SideMenuPath()
    /// Current menu state.
    public var menuState: SideMenuState { get { return drawer.menuState } }
    /// Menu item cell. Uses to create custom menu items.
    public var menuItemCellClass: SideMenuItemCellDelegate.Type = SideMenuItemCell.self
    
    /// Enable swipe to expand view.
    public var openSwipeIsEnabled: Bool = true
    /// Enable swipe to collapse view.
    public var closeSwipeIsEnabled: Bool = true
    /// Disable interaction on view when it collapsed.
    public var disableViewInteraction: Bool = true
    
    /// Custom top view in menu.
    public var topView: UIView?
    /// Custom bottom view in menu.
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
    
    /**
     Call this function to select menu item.
     - Parameters:
        - index : index of item to show
     */
    public func selectItem(index: Int) {
        guard index >= 0, index < items.count, index != path.selectedIndex else { return }
        
        let newPath = SideMenuPath(previousIndex: path.selectedIndex, selectedIndex: index)
        drawer.drawMenu(for: newPath)
        path = newPath
    }
    
    /**
    Call this function to check path vilidity.
    - Parameters:
        - path : path to be checked for validity
    */
    public func validPath(path: SideMenuPath) -> Bool {
        return (path.previousIndex == nil || (path.previousIndex! >= 0 && path.previousIndex! < items.count)) &&
            (path.selectedIndex == nil || (path.selectedIndex! >= 0 && path.selectedIndex! < items.count))
    }
}
