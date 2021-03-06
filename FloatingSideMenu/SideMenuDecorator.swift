//
//  SideMenuDecorator.swift
//  Chatter
//
//  Created by Nick Kurochkin on 03.03.2020.
//  Copyright © 2020 Nick Kurochkin. All rights reserved.
//

import UIKit
import Foundation

/// Menu configuration & initialization.
internal class SideMenuDecorator {
    private var controller: SideMenu!
    public var delegate: SideMenuDelegate?
    
    //    MARK:- configuration
    /// Max size of view.
    var itemViewFullSize: CGSize { return controller.view.frame.size }
    
    /// Medium size proportion.
    var mediumSizeProportion: CGFloat {
        let height = itemViewFullSize.height - 200
        return height/itemViewFullSize.height
    }
    /// Medium size of view.
    var itemViewMediumSize: CGSize {
        return CGSize(width: itemViewFullSize.width * mediumSizeProportion, height: itemViewFullSize.height * mediumSizeProportion)
    }
    
    /// Small size proportion.
    var smallSizeProportion: CGFloat {
        let height = (itemViewFullSize.height - 200)*0.858
        return height/itemViewFullSize.height
    }
    /// Small size of view.
    var itemViewSmallSize: CGSize {
        return CGSize(width: itemViewFullSize.width*smallSizeProportion, height: itemViewFullSize.height*smallSizeProportion)
    }
    
    /// Height of item list.
    var itemListHeight: CGFloat {
        get {
            let maxListHeight = controller.view.frame.height - 200
            let listHeight = CGFloat(controller.items.count * 52)
            return listHeight > maxListHeight ? maxListHeight : listHeight
        }
    }
    
    /// Item list x procent of  itemViewFullSize.
    var itemListProcent: CGFloat = 0.69
    
    /// Radius of collapsed controller view in menu.
    var controllerRadius: CGFloat = 20
    
    /// List of items.
    var itemList: UIStackView! = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK:- init
    init(controller: SideMenu) {
        self.controller = controller
        setupViews()
        setupConstraints()
        setupData()
    }
}

//  MARK:- setup
extension SideMenuDecorator {
    /**
     Basic menu data & view configuring.
     */
    private func setupData() {
        for (index, item) in controller.items.enumerated() {
            // list item setup
            let itemView = controller.menuItemCellClass.init()
            itemView.tag = index
            itemView.setData(item: item)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didSelectMenuItemView))
            itemView.addGestureRecognizer(gesture)
            
            itemList.addArrangedSubview(itemView)
            itemList.addConstraints([
                itemView.heightAnchor.constraint(equalToConstant: 52),
                itemView.leadingAnchor.constraint(equalTo: itemList.leadingAnchor),
                itemView.trailingAnchor.constraint(equalTo: itemList.trailingAnchor),
            ])
            
            // controller setup
            item.viewController.sideMenuDelegate = delegate
            
            item.viewController.view.tag = index
            
            let proportion = itemViewSmallSize.height / item.viewController.view.frame.height
            relayoutSubviews(proportion: proportion, view: item.viewController.view)
            
            let y = (itemViewFullSize.height - itemViewSmallSize.height)/2
            item.viewController.view.frame = CGRect(x: UIScreen.main.bounds.width, y: y, width: itemViewSmallSize.width, height: itemViewSmallSize.height)
            
            
            item.viewController.view.clipsToBounds = true
            item.viewController.view.layer.cornerRadius = controllerRadius
            controller.view.addSubview(item.viewController.view)
            controller.addChild(item.viewController)
        }
    }
    
    /**
    Basic menu top & bottom views configuring.
    */
    private func setupViews() {
        controller.view.addSubview(itemList)
        if let topView = controller.topView {
            topView.translatesAutoresizingMaskIntoConstraints = false
            controller.view.addSubview(topView)
        }
        if let bottomView = controller.bottomView {
            bottomView.translatesAutoresizingMaskIntoConstraints = false
            controller.view.addSubview(bottomView)
        }
    }
    
    /**
    Menu list, top view & bottom view constraints configuring.
    */
    private func setupConstraints() {
        //stack view
        controller.view.addConstraints([
            itemList.heightAnchor.constraint(equalToConstant: itemListHeight),
            itemList.centerYAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.centerYAnchor),
            itemList.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
            itemList.widthAnchor.constraint(equalTo: controller.view.widthAnchor, multiplier: 0.615)
        ])
        
        //top view
        if let topView = controller.topView {
            controller.view.addConstraints([
                topView.topAnchor.constraint(equalTo: controller.view.topAnchor, constant: 40),
                topView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor, constant: 10),
                topView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor, constant: -10),
            ])
        }
        
        //bottom view
        if let bottomView = controller.bottomView {
            controller.view.addConstraints([
                bottomView.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor, constant: -40),
                bottomView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor, constant: 10),
                bottomView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor, constant: -10),
                bottomView.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
    }
    
    /**
    Relayout view subviews.
    - Parameters:
        - proportion : proportion to previous frame size.
        - view : view to relayout.
    */
    private func relayoutSubviews(proportion: CGFloat, view: UIView) {
        for item in view.subviews {
            item.frame = CGRect(
            x: item.frame.minX * proportion,
            y: item.frame.minY * proportion,
            width: item.frame.width * proportion,
            height: item.frame.height * proportion )
        }
    }
}

//  MARK:- menu drawing functions
extension SideMenuDecorator {
    /**
    Tap gesture recognizer action of menu list item.
     */
    @objc func didSelectMenuItemView(_ gestureRecognizer: UIGestureRecognizer) {
        guard let index = gestureRecognizer.view?.tag, let delegate = delegate else { return }
        delegate.selectItem(index: index)
    }
}
