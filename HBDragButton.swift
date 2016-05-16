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

enum HBDragButtonStyle {
    case Drag, Slide
}

enum HBDragButtonEndingStyle {
    case ComeBack, Block, BlockAndGoToCenter, Desapear
}


class HBDragButton: UIView {
    
    @IBOutlet weak var draggableAreaView: UIView!
    
    var delegate:HBDragButtonDelegate?
    
    var translationX:CGFloat = 0
    var isDragged = false
    var isAnimating = false
    var initalFrame:CGRect!
    var maxAnimationDuration:Double = 0.5
    var endingAnimationDuration = 0.3
    var style:HBDragButtonStyle!
    var endingStyle:HBDragButtonEndingStyle!
    
    
// MARK: - Settings
    
    func set(style:HBDragButtonStyle, endingStyle:HBDragButtonEndingStyle) {
        self.style = style
        self.endingStyle = endingStyle
        let widthConstraint = NSLayoutConstraint(item: self.draggableAreaView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.draggableAreaView.frame.size.width)
        let heightConstraint = NSLayoutConstraint(item: self.draggableAreaView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.draggableAreaView.frame.size.height)
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: self.draggableAreaView, attribute: .Leading, multiplier: 1, constant: self.draggableAreaView.frame.origin.x)
        let topConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: self.draggableAreaView, attribute: .Top, multiplier: 1, constant: self.draggableAreaView.frame.origin.y)
        self.draggableAreaView.addConstraint(widthConstraint)
        self.draggableAreaView.addConstraint(heightConstraint)
        self.addConstraint(topConstraint)
        if self.style == .Drag {
            self.addConstraint(leftConstraint)
            self.initalFrame = self.frame
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(HBDragButton.dragViewDragged))
            self.draggableAreaView.addGestureRecognizer(panGesture)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HBDragButton.rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
        } else if self.style == .Slide {
            self.initalFrame = self.draggableAreaView.frame
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(HBDragButton.dragViewSlided))
            self.draggableAreaView.addGestureRecognizer(panGesture)
        }
        
    }
    

// MARK: - Action
    
    @IBAction func dragViewDragged(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self)
        let minWidth = self.draggableAreaView.frame.origin.x * 2 + self.draggableAreaView.frame.size.width
        let minOriginX = self.initalFrame.origin.x + self.initalFrame.size.width - minWidth
        switch sender.state {
        case .Began:
            self.isDragged = false
            self.translatesAutoresizingMaskIntoConstraints = true
        case .Ended:
            self.translationX = 0
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
        default:
            if translation.x > 0 && self.frame.size.width > minWidth {
                let m = translation.x - self.translationX
                self.translationX = translation.x
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
                    
                    let endingStyle:HBDragButtonEndingStyle = self.endingStyle
                    switch endingStyle {
                    case .Block:
                        self.isDragged = true
                    case .BlockAndGoToCenter:
                        self.isDragged = true
                        UIView.animateWithDuration(self.endingAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
                            self.center.x = UIScreen.mainScreen().bounds.width/2
                            }, completion: nil)
                    case .Desapear:
                        //self.isDragged = true
                        UIView.animateWithDuration(self.endingAnimationDuration, delay: 0, options: .CurveEaseIn, animations: {
                            self.alpha = 0
                            }, completion: { (finish) in
                                if finish {
                                    self.frame = self.initalFrame
                                }
                        })
                    default:
                        break
                    }
                }
            }
        }
        
//        if sender.state == .Began {
//            self.isDragged = false
//            self.translatesAutoresizingMaskIntoConstraints = true
//        } else if sender.state == .Ended {
//            self.translationX = 0
//            if !self.isDragged {
//                let iniWidth = self.initalFrame.size.width
//                let width = self.frame.width
//                UIView.animateWithDuration(Double((iniWidth - width)/(iniWidth - minWidth)) * self.maxAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
//                    self.frame = self.initalFrame
//                    }, completion: { (finished) in
//                    if finished {
//                        self.translatesAutoresizingMaskIntoConstraints = false
//                    }
//                })
//            }
//        } else {
//            if translation.x > 0 && self.frame.size.width > minWidth {
//                let m = translation.x - self.translationX
//                self.translationX = translation.x
//                if self.frame.size.width - m >= minWidth {
//                    if self.frame.size.width - m > self.initalFrame.width {
//                        self.frame = self.initalFrame
//                    } else {
//                        self.frame = CGRectMake(self.frame.origin.x + m, self.frame.origin.y, self.frame.size.width - m, self.frame.size.height)
//                    }
//                } else {
//                    self.frame = CGRectMake(minOriginX, self.frame.origin.y, minWidth, self.frame.size.height)
//                }
//                
//                if self.frame.size.width <= minWidth {
//                    if self.delegate != nil {
//                        self.delegate!.dragButtonCompleteDragging(self)
//                    }
//                    print("Well Done !!!")
//                    
//                    //TODO make style modification & ending animation for complete dragging
//                    //self.dragView.backgroundColor = padamRed
//                    if self.endingStyle == .Block {
//                        self.isDragged = true
//                    } else if self.endingStyle == .BlockAndGoToCenter {
//                        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: {
//                            self.center.x = UIScreen.mainScreen().bounds.width/2
//                            }, completion: nil)
//                    } else if self.endingStyle == .Desapear {
//                        UIView.animateWithDuration(self.maxAnimationDuration, delay: 0, options: .CurveEaseIn, animations: {
//                            self.alpha = 0
//                            }, completion: { (finish) in
//                            if finish {
//                                self.frame = self.initalFrame
//                            }
//                        })
//                    }
//                    
//                }
//            }
//        }
//        print("start width = \(self.frame.size.width)")
    }
    
    @IBAction func dragViewSlided(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self)
        let maxOriginX = self.frame.size.width - self.draggableAreaView.frame.size.width - self.initalFrame.origin.x
        switch sender.state {
        case .Ended :
            self.translationX = 0
            if !self.isDragged {
                let initX = self.initalFrame.origin.x
                let originX = self.draggableAreaView.frame.origin.x
                UIView.animateWithDuration(Double((initX - originX)/(initX - maxOriginX)) * self.maxAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
                    self.draggableAreaView.frame = self.initalFrame
                    }, completion: nil)
            }
        default :
            if translation.x > 0 && self.isAnimating == false {
                print("yi")
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
                    let endingStyle:HBDragButtonEndingStyle = self.endingStyle
                    switch endingStyle {
                    case .Block:
                        self.isDragged = true
                    case .BlockAndGoToCenter:
                        UIView.animateWithDuration(self.endingAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
                            self.draggableAreaView.center.x = UIScreen.mainScreen().bounds.width/2
                            }, completion: nil)
                    case .Desapear:
                        self.isDragged = true
                        self.isAnimating = true
                        UIView.animateWithDuration(self.endingAnimationDuration, delay: 0, options: .CurveEaseIn, animations: {
                            self.alpha = 0
                            print("yo")
                            }, completion: { (finish) in
                                if finish {
                                    self.draggableAreaView.frame = self.initalFrame
                                    self.isAnimating = false
                                    print("ya")
                                }
                        })
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func backToInitialFrame(animate:Bool) {
        if self.isDragged == true {
            self.isDragged = false
            
//            let endingStyle:HBDragButtonEndingStyle = self.endingStyle
//            switch endingStyle {
//            case .Block, .BlockAndGoToCenter :
//                
//                let style:HBDragButtonStyle = self.style
//                switch style {
//                case .Slide:
//                    if animated {
//                        UIView.animateWithDuration(self.maxAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
//                            self.draggableAreaView.frame = self.initalFrame
//                            }, completion: nil)
//                    } else {
//                        self.draggableAreaView.frame = self.initalFrame
//                    }
//                case .Drag:
//                    if animated {
//                        UIView.animateWithDuration(self.maxAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
//                            self.frame = self.initalFrame
//                            }, completion: { (finished) in
//                                if finished {
//                                    self.translatesAutoresizingMaskIntoConstraints = false
//                                }
//                        })
//                    } else {
//                        self.frame = self.initalFrame
//                    }
//                }
//            case.Desapear:
//                UIView.animateWithDuration(self.maxAnimationDuration, delay: 0, options: .CurveEaseIn, animations: {
//                    self.alpha = 1
//                    }, completion: nil)
//            default:
//                break
//            }
            
            //
            
            if self.endingStyle == .Block || self.endingStyle == .BlockAndGoToCenter {
                if self.style == .Slide {
                    if animate {
                        UIView.animateWithDuration(self.maxAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
                            self.draggableAreaView.frame = self.initalFrame
                            }, completion: nil)
                    } else {
                        self.draggableAreaView.frame = self.initalFrame
                    }
                } else if self.style == .Drag {
                    if animate {
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
            } else if self.endingStyle == .Desapear {
                if animate {
                    UIView.animateWithDuration(self.maxAnimationDuration, delay: 0, options: .CurveEaseIn, animations: {
                        self.alpha = 1
                        }, completion: nil)
                } else {
                    self.alpha = 1
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
//
//     }
    
}
