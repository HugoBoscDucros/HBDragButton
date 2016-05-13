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
    //var minWidth:CGFloat!
    

// MARK: - Action
    
    @IBAction func dragViewDragged(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self)
        let minWidth = self.draggableAreaView.frame.origin.x * 2 + self.draggableAreaView.frame.size.width
        let minOriginX = self.initalFrame.origin.x + self.initalFrame.size.width - minWidth
        if sender.state == .Began {
            self.translationX = 0
            
        } else if sender.state == .Ended {
            if !self.isDragged {
                UIView.animateWithDuration(0.5) {
                    self.frame = self.initalFrame
                }
            }
        } else {
            if translation.x > 0 && self.frame.size.width > minWidth {
                let m = translation.x - self.translationX
                self.translationX = translation.x
                if self.frame.size.width - m >= minWidth {
                    self.frame = CGRectMake(self.frame.origin.x + m, self.frame.origin.y, self.frame.size.width - m, self.frame.size.height)
                } else {
                    self.frame = CGRectMake(minOriginX, self.frame.origin.y, minWidth, self.frame.size.height)
                }
                
                if self.frame.size.width <= minWidth {
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
    
    func backToInitialFrame(animated:Bool) {
        self.isDragged = false
        if animated {
            UIView.animateWithDuration(0.5) {
                self.frame = self.initalFrame
            }
        } else {
            self.frame = self.initalFrame
        }
    }
    
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
        let widthConstraint = NSLayoutConstraint(item: self.draggableAreaView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.draggableAreaView.frame.size.width)
        let heightConstraint = NSLayoutConstraint(item: self.draggableAreaView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.draggableAreaView.frame.size.height)
        print(self.draggableAreaView.frame)
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: self.draggableAreaView, attribute: .Leading, multiplier: 1, constant: self.draggableAreaView.frame.origin.x)
        let topConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: self.draggableAreaView, attribute: .Top, multiplier: 1, constant: self.draggableAreaView.frame.origin.y)
        
        self.draggableAreaView.addConstraint(widthConstraint)
        self.draggableAreaView.addConstraint(heightConstraint)
        self.addConstraint(leftConstraint)
        self.addConstraint(topConstraint)
        
        self.initalFrame = self.frame
        //self.minWidth = self.draggableAreaView.frame.origin.x * 2 + self.draggableAreaView.frame.size.width
        //self.translatesAutoresizingMaskIntoConstraints = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(HBDragButton.dragViewDragged))
        self.draggableAreaView.addGestureRecognizer(panGesture)
     }
    
}
