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
    
    private var menuItems: [SideMenuItem] = []
    public var items: [SideMenuItem] { get { return menuItems } }
    
    private var menuPath: SideMenuPath = SideMenuPath()
    public var path: SideMenuPath { get { return self.menuPath } }
    
    public var menuState: SideMenuState { get { return drawer.menuState } }
    
    public var menuItemCellClass: SideMenuItemCellDelegate.Type = SideMenuItemCell.self
    
    public var openSwipeIsEnabled: Bool = true
    public var closeSwipeIsEnabled: Bool = true
    
    public var topView: UIView?
    public var bottomView: UIView?
    
    
    public init(items: [SideMenuItem]) {
        super.init(nibName: nil, bundle: nil)
        self.menuItems = items
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
        guard index >= 0, index < menuItems.count, index != menuPath.selectedIndex else { return }
        
        let newPath = SideMenuPath(previousIndex: menuPath.selectedIndex, selectedIndex: index)
        drawer.drawMenu(for: newPath)
        menuPath = newPath
    }
    
    
    public func validPath(path: SideMenuPath) -> Bool {
        return (path.previousIndex == nil || (path.previousIndex! >= 0 && path.previousIndex! < menuItems.count)) &&
            (path.selectedIndex == nil || (path.selectedIndex! >= 0 && path.selectedIndex! < menuItems.count))
    }
}
