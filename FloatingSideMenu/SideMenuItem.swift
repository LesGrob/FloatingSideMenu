//
//  SideMenuItem.swift
//  Chatter
//
//  Created by Nick Kurochkin on 03.03.2020.
//  Copyright © 2020 Nick Kurochkin. All rights reserved.
//

import UIKit
import Foundation

public class SideMenuPath {
    public var previousIndex: Int? = nil
    public var selectedIndex: Int? = nil
    
    init(){}
    
    public init(previousIndex: Int?, selectedIndex: Int?){
        self.previousIndex = previousIndex
        self.selectedIndex = selectedIndex
    }
}

open class SideMenuItem {
    public var icon: UIImage?
    public var title: String
    public var viewController: SideMenuItemController
    
    public init(icon: UIImage?, title: String, viewController: SideMenuItemController) {
        self.icon = icon
        self.title = title
        self.viewController = viewController
    }
}

public protocol SideMenuItemCellDelegate: UIView {
    func select(_ select: Bool)
    func setData(item: SideMenuItem)
    static func cellHeight(stackWidth: CGFloat) -> CGFloat
}

public class SideMenuItemCell: UIView, SideMenuItemCellDelegate {
    var icon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .gray
        return view
    }()
    
    var title: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.textColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var titleLeadingConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(icon)
        self.addSubview(title)
        
        addConstraints([
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.heightAnchor.constraint(equalToConstant: 22),
            icon.widthAnchor.constraint(equalToConstant: 22),
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
        ])
        addConstraints([
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        titleLeadingConstraint = title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 15)
        titleLeadingConstraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setData(item: SideMenuItem) {
        self.title.text = item.title
        if let icon = item.icon {
            self.icon.image = icon.withRenderingMode(.alwaysTemplate)
            self.titleLeadingConstraint.constant = 15
        } else  {
            self.icon.image = nil
            self.titleLeadingConstraint.constant = -22
        }
    }
    
    public func select(_ select: Bool) {
        icon.tintColor = select ? UIColor.white : .gray
        title.textColor = select ? UIColor.white : .gray
    }
    
    public static func cellHeight(stackWidth: CGFloat) -> CGFloat {
        return 52
    }
}
