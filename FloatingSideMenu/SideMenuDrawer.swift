//
//  SideMenuPresenter.swift
//  Chatter
//
//  Created by Nick Kurochkin on 06.03.2020.
//  Copyright © 2020 Nick Kurochkin. All rights reserved.
//

import Foundation
import UIKit

internal class SideMenuDrawer {
    private var controller: SideMenu!
    private var decorator: SideMenuDecorator!
    
    var menuState: SideMenuState = .menu
    
    init(controller: SideMenu) {
        self.controller = controller
        self.decorator = SideMenuDecorator(controller: self.controller)
        self.decorator.delegate = self
        self.setupControllers()
    }
    
    private func setupControllers() {
        for item in controller.items {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectControllerView(_:)))
            let slideGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(slideController(_:)))
            
            item.viewController.view.addGestureRecognizer(tapGesture)
            item.viewController.view.addGestureRecognizer(slideGestureRecognizer)
        }
    }
}

//  MARK:- menu drawing functions
extension SideMenuDrawer {
    func drawMenu(for path: SideMenuPath) {
        guard controller.validPath(path: path) else { return }
        let oldPath = controller.path
        
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            if oldPath.previousIndex != path.selectedIndex {
                if let index = oldPath.previousIndex {
                    let rect = CGRect(
                        x: UIScreen.main.bounds.width,
                        y: (self.decorator.itemViewFullSize.height - self.decorator.itemViewSmallSize.height)/2,
                        width: self.decorator.itemViewSmallSize.width,
                        height: self.decorator.itemViewSmallSize.height)
                    
                    self.relayoutView(
                        viewController: self.controller.items[index].viewController,
                        with: rect,
                        alpha: 0)
                    
                   self.disableViewIteraction(viewController: self.controller.items[index].viewController, true)
                }
            }
            
            if let previousIndex = path.previousIndex {
                let x = self.decorator.itemViewFullSize.width * 0.615
                let y = (self.decorator.itemViewFullSize.height - self.decorator.itemViewSmallSize.height)/2
                let rect = CGRect(
                    x: x,
                    y: y,
                    width: self.decorator.itemViewSmallSize.width,
                    height: self.decorator.itemViewSmallSize.height)
                
                self.relayoutView(
                    viewController: self.controller.items[previousIndex].viewController,
                    with: rect,
                    alpha: 0.5)
                
                self.disableViewIteraction(viewController: self.controller.items[previousIndex].viewController, true)
            }
            
            if let selectedIndex = path.selectedIndex {
                let x = self.decorator.itemViewFullSize.width * self.decorator.itemListProcent
                let y = (self.decorator.itemViewFullSize.height - self.decorator.itemViewMediumSize.height)/2
                let rect = CGRect(
                    x: x,
                    y: y,
                    width: self.decorator.itemViewMediumSize.width,
                    height: self.decorator.itemViewMediumSize.height)
                
                self.relayoutView(
                    viewController: self.controller.items[selectedIndex].viewController,
                    with: rect,
                    alpha: 1)
                self.controller.view.bringSubviewToFront(self.controller.items[selectedIndex].viewController.view)
               
                self.disableViewIteraction(viewController: self.controller.items[selectedIndex].viewController, true)
            }
            
            self.drawItemList(for: path)
        }, completion: nil)
    }
}

//  MARK:- controller drawing functions
extension SideMenuDrawer {
    private func expandController() {
        guard let index = controller.path.selectedIndex else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0.1,usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            let rect = CGRect(
                x: 0,
                y: 0,
                width: self.decorator.itemViewFullSize.width,
                height: self.decorator.itemViewFullSize.height)
            
            self.relayoutView(
                viewController: self.controller.items[index].viewController,
                with: rect,
                alpha: 1)
            self.controller.items[index].viewController.view.layer.cornerRadius = 0
        }, completion: { _ in
            self.menuState = .controller
            self.disableViewIteraction(viewController: self.controller.items[index].viewController, false)
        })
    }
    
    private func collapseController() {
        guard let index = controller.path.selectedIndex else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            let x = self.decorator.itemViewFullSize.width * self.decorator.itemListProcent
            let y = (self.decorator.itemViewFullSize.height - self.decorator.itemViewMediumSize.height)/2
            let rect = CGRect(
                x: x,
                y: y,
                width: self.decorator.itemViewMediumSize.width,
                height: self.decorator.itemViewMediumSize.height)
            
            self.relayoutView(
                viewController: self.controller.items[index].viewController,
                with: rect,
                alpha: 1)
            
            self.controller.items[index].viewController.view.layer.cornerRadius = self.decorator.controllerRadius
        }, completion: { _ in
            self.menuState = .menu
            self.disableViewIteraction(viewController: self.controller.items[index].viewController, true)
        })
    }
}

extension SideMenuDrawer {
    @objc func didSelectControllerView(_ gestureRecognizer: UIGestureRecognizer) {
        guard controller.menuState != .controller, let _ = gestureRecognizer.view?.tag else { return }
        toggleMenu()
    }
    
    @objc func slideController(_ recognizer: UIPanGestureRecognizer) {
        guard let index = recognizer.view?.tag, index == controller.path.selectedIndex else { return }
        
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: self.controller.view).x > 0)
        
        switch recognizer.state {
        case .changed:
            if !gestureIsDraggingFromLeftToRight && (menuState == .controller || !controller.openSwipeIsEnabled ) { return }
            else if gestureIsDraggingFromLeftToRight && (menuState == .menu || !controller.closeSwipeIsEnabled) { return }
            
            guard let rview = recognizer.view else { return }
            let tapX = recognizer.translation(in: controller.view).x / 8
            
            let newHeight =  rview.frame.height - tapX
            let newWidth = rview.frame.width * newHeight/rview.frame.height
            
            let newX = (rview.center.x + tapX) - newWidth/2
            let newY = controller.view.center.y - newHeight/2
            
            if newX < 0 {
                self.expandController()
                return
            }
            if newX > (self.decorator.itemViewFullSize.width * self.decorator.itemListProcent) {
                self.collapseController()
                return
            }
            
            let rect = CGRect(
                x: newX,
                y: newY,
                width: newWidth,
                height: newHeight)
            self.relayoutView(
                viewController: self.controller.items[index].viewController,
                with: rect,
                alpha: 1)
            rview.layer.cornerRadius = newX/(self.decorator.itemViewFullSize.width * self.decorator.itemListProcent) * self.decorator.controllerRadius
        case .ended:
            if let rview = recognizer.view {
                if menuState == .controller {
                    if rview.frame.minX > self.controller.view.frame.width/4 {
                        self.collapseController()
                    } else {
                        self.expandController()
                    }
                } else {
                    if rview.frame.minX < self.controller.view.frame.width/2 {
                        self.expandController()
                    } else {
                        self.collapseController()
                    }
                }
            }
        default:
            break
        }
    }
}

//  MARK:- subviews Drawing
extension SideMenuDrawer {
    private func drawItemList(for path: SideMenuPath) {
        for (index, item) in self.decorator.itemList.subviews.enumerated() {
            guard let view = item as? SideMenuItemCellDelegate else { continue }
            view.select(index == path.selectedIndex)
        }
    }
    
    private func relayoutView(viewController: SideMenuItemController, with frame: CGRect, alpha: CGFloat) {
        let proportion = frame.height / viewController.view.frame.height
        viewController.view.frame = frame
        viewController.view.alpha = alpha
        viewController.absoluteProportion = 1/(UIScreen.main.bounds.height / frame.height)
        viewController.relayoutSubviews(proportion: proportion)
    }
    
    private func disableViewIteraction(viewController: SideMenuItemController, _ dimm: Bool) {
        if controller.disableViewIteraction {
            viewController.disableViewIteraction(dimm)
        }
    }
}

//  MARK:- menu delegate
extension SideMenuDrawer: SideMenuDelegate {
    func selectItem(index: Int) {
        controller.selectItem(index: index)
    }
    
    func toggleMenu() {
        if menuState == .controller {
            collapseController()
            return
        }
        expandController()
    }
}
