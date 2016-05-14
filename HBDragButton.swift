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
    var slideStyle = false
    var endStyle = ""
    var maxAnimationDuration:Double = 0.5
    
    
// MARK: - Settings
    
    func autoSet() {
        let widthConstraint = NSLayoutConstraint(item: self.draggableAreaView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.draggableAreaView.frame.size.width)
        let heightConstraint = NSLayoutConstraint(item: self.draggableAreaView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.draggableAreaView.frame.size.height)
        print(self.draggableAreaView.frame)
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: self.draggableAreaView, attribute: .Leading, multiplier: 1, constant: self.draggableAreaView.frame.origin.x)
        let topConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: self.draggableAreaView, attribute: .Top, multiplier: 1, constant: self.draggableAreaView.frame.origin.y)
        
        self.draggableAreaView.addConstraint(widthConstraint)
        self.draggableAreaView.addConstraint(heightConstraint)
        if !slideStyle {
            self.addConstraint(leftConstraint)
        }
        self.addConstraint(topConstraint)
        
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        
        if slideStyle {
            self.initalFrame = self.draggableAreaView.frame
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(HBDragButton.dragViewSlided))
            self.draggableAreaView.addGestureRecognizer(panGesture)
        } else {
            self.initalFrame = self.frame
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(HBDragButton.dragViewDragged))
            self.draggableAreaView.addGestureRecognizer(panGesture)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HBDragButton.rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
        }
    }
    
    func slidableStyle() {
        self.slideStyle = true
        self.autoSet()
    }
    

// MARK: - Action
    
    @IBAction func dragViewDragged(sender: UIPanGestureRecognizer) {
        print("start width = \(self.frame.size.width)")
        let translation = sender.translationInView(self)
        let minWidth = self.draggableAreaView.frame.origin.x * 2 + self.draggableAreaView.frame.size.width
        let minOriginX = self.initalFrame.origin.x + self.initalFrame.size.width - minWidth
        if sender.state == .Began {
            self.translationX = 0
            self.isDragged = false
            self.translatesAutoresizingMaskIntoConstraints = true
        } else if sender.state == .Ended {
            if !self.isDragged {
                let iniWidth = self.initalFrame.size.width
                let width = self.frame.width
                UIView.animateWithDuration(Double((iniWidth - width)/(iniWidth - minWidth)) * self.maxAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
                    self.frame = self.initalFrame
                    }, completion: { (finished) in
                    if finished {
                        self.translatesAutoresizingMaskIntoConstraints = false
                    }
                })
            }
        } else {
            if translation.x > 0 && self.frame.size.width > minWidth {
                let m = translation.x - self.translationX
                self.translationX = translation.x
                //print("width = \(self.frame.size.width)")
                if self.frame.size.width - m >= minWidth {
                    if self.frame.size.width - m > self.initalFrame.width {
                        self.frame = self.initalFrame
                    } else {
                        self.frame = CGRectMake(self.frame.origin.x + m, self.frame.origin.y, self.frame.size.width - m, self.frame.size.height)
                    }
                } else {
                    self.frame = CGRectMake(minOriginX, self.frame.origin.y, minWidth, self.frame.size.height)
                }
                
                if self.frame.size.width <= minWidth {
                    if self.delegate != nil {
                        self.delegate!.dragButtonCompleteDragging(self)
                    }
                    print("Well Done !!!")
                    //print("width = \(self.frame.size.width)")
                    
                    //TODO make style modification & ending animation for complete dragging
                    //self.dragView.backgroundColor = padamRed
                    self.isDragged = true
                }
            }
        }
        print("start width = \(self.frame.size.width)")
    }
    
    @IBAction func dragViewSlided(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self)
        let maxOriginX = self.frame.size.width - self.draggableAreaView.frame.size.width - self.initalFrame.origin.x
        if sender.state == .Began {
            self.translationX = 0
            //self.isDragged = false
        } else if sender.state == .Ended {
            if !self.isDragged {
                let initX = self.initalFrame.origin.x
                let originX = self.draggableAreaView.frame.origin.x
                UIView.animateWithDuration(Double((initX - originX)/(initX - maxOriginX)) * self.maxAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
                    self.draggableAreaView.frame = self.initalFrame
                    }, completion: nil)
            }
        } else {
            if translation.x > 0 {
                let m = translation.x - self.translationX
                self.translationX = translation.x
                if self.draggableAreaView.frame.origin.x + m <= maxOriginX {
                    if self.draggableAreaView.frame.origin.x + m < self.initalFrame.origin.x {
                        self.draggableAreaView.frame = self.initalFrame
                    } else {
                        self.draggableAreaView.frame = CGRectMake(self.draggableAreaView.frame.origin.x + m, self.draggableAreaView.frame.origin.y, self.draggableAreaView.frame.size.width, self.draggableAreaView.frame.size.height)
                    }
                } else {
                    self.draggableAreaView.frame = CGRectMake(maxOriginX, self.draggableAreaView.frame.origin.y, self.draggableAreaView.frame.size.width, self.draggableAreaView.frame.size.height)
                }
                    
                if self.draggableAreaView.frame.origin.x >= maxOriginX {
                    if self.delegate != nil {
                        self.delegate!.dragButtonCompleteDragging(self)
                    }
                    print("Well Done !!! \(self.draggableAreaView.frame.origin.x) && \(maxOriginX)")
                        
                    //TODO make style modification & ending animation for complete dragging
                    //self.dragView.backgroundColor = padamRed
                    if self.endStyle != "ComingBack" {
                        self.isDragged = true
                    }
                }
            }
        }
    }
    
    func backToInitialFrame(animated:Bool) {
        if self.isDragged == true {
            self.isDragged = false
            if self.slideStyle == true {
                if animated {
                    UIView.animateWithDuration(self.maxAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
                        self.draggableAreaView.frame = self.initalFrame
                        }, completion: nil)
                } else {
                    self.draggableAreaView.frame = self.initalFrame
                }
            } else {
                if animated {
                    UIView.animateWithDuration(self.maxAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
                        self.frame = self.initalFrame
                        }, completion: { (finished) in
                            if finished {
                                self.translatesAutoresizingMaskIntoConstraints = false
                            }
                    })
                } else {
                    self.frame = self.initalFrame
                }
            }
        }
    }
    
    func rotated() {
        self.initalFrame = self.frame
    }
    
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
//     override func drawRect(rect: CGRect) {
//        let widthConstraint = NSLayoutConstraint(item: self.draggableAreaView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.draggableAreaView.frame.size.width)
//        let heightConstraint = NSLayoutConstraint(item: self.draggableAreaView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.draggableAreaView.frame.size.height)
//        print(self.draggableAreaView.frame)
//        let leftConstraint = NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: self.draggableAreaView, attribute: .Leading, multiplier: 1, constant: self.draggableAreaView.frame.origin.x)
//        let topConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: self.draggableAreaView, attribute: .Top, multiplier: 1, constant: self.draggableAreaView.frame.origin.y)
//        
//        self.draggableAreaView.addConstraint(widthConstraint)
//        self.draggableAreaView.addConstraint(heightConstraint)
//        self.addConstraint(leftConstraint)
//        self.addConstraint(topConstraint)
//        
//        self.layer.cornerRadius = self.frame.size.height/2
//        
//        self.initalFrame = self.frame
//        //self.minWidth = self.draggableAreaView.frame.origin.x * 2 + self.draggableAreaView.frame.size.width
//        //self.translatesAutoresizingMaskIntoConstraints = true
//        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(HBDragButton.dragViewDragged))
//        self.draggableAreaView.addGestureRecognizer(panGesture)
//     }
    
}
