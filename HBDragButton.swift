//
//  HBDragButton.swift
//  HBDragButtonTestProject
//
//  Created by Bosc-Ducros Hugo on 12/05/2016.
//  Copyright © 2016 Bosc-Ducros Hugo. All rights reserved.
//

import UIKit

protocol HBDragButtonDelegate {
    func dragButtonCompleteDragging(dragButton:HBDragButton)
}

class HBDragButton: UIView {
    
    @IBOutlet weak var draggableAreaView: UIView!
    
    var delegate:HBDragButtonDelegate?
    
    var translationX:CGFloat = 0
    var isDragged = false
    var initalFrame:CGRect!
    

// MARK: - Action
    
    @IBAction func dragViewDragged(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self)
        if sender.state == .Began {
            self.translationX = 0
        } else if sender.state == .Ended {
            if !self.isDragged {
                UIView.animateWithDuration(0.5) {
                    self.frame = self.initalFrame
                }
            }
        } else {
            if translation.x > 0 && self.frame.size.width > 58 {
                let m = translation.x - self.translationX
                self.translationX = translation.x
                if self.frame.size.width - m >= 58 {
                    self.frame = CGRectMake(self.frame.origin.x + m, self.frame.origin.y, self.frame.size.width - m, self.frame.size.height)
                } else {
                    self.frame = CGRectMake(242, self.frame.origin.y, 58, self.frame.size.height)
                }
                
                if self.frame.size.width <= 58 {
                    if self.delegate != nil {
                        self.delegate!.dragButtonCompleteDragging(self)
                    }
                   print("Well Done !!!")
                    
                    //TODO make style modification & ending animation for complete dragging
                    //self.dragView.backgroundColor = padamRed
                    self.isDragged = true
                }
            }
        }
    }
    
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
        let widthConstraint = NSLayoutConstraint(item: self.draggableAreaView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.draggableAreaView.frame.size.width)
        let heightConstraint = NSLayoutConstraint(item: self.draggableAreaView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.draggableAreaView.frame.size.height)
        let leftConstraint = NSLayoutConstraint(item: self.draggableAreaView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: self.draggableAreaView.frame.origin.x)
        let topConstraint = NSLayoutConstraint(item: self.draggableAreaView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: self.draggableAreaView.frame.origin.y)
        
        self.draggableAreaView.addConstraint(widthConstraint)
        self.draggableAreaView.addConstraint(heightConstraint)
        self.draggableAreaView.addConstraint(leftConstraint)
        self.draggableAreaView.addConstraint(topConstraint)
        
        self.initalFrame = self.frame
        self.translatesAutoresizingMaskIntoConstraints = true
     }
    
}
