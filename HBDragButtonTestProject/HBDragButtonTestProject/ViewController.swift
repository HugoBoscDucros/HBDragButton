//
//  ViewController.swift
//  HBDragButtonTestProject
//
//  Created by Bosc-Ducros Hugo on 12/05/2016.
//  Copyright © 2016 Bosc-Ducros Hugo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, HBDragButtonDelegate {

    @IBOutlet weak var dragButton: HBDragButton!
    @IBOutlet weak var dragButton2: HBDragButton!
    @IBOutlet weak var dragButton3: HBDragButton!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dragButton.answerThePhoneStyle()
        self.dragButton.set(.Drag, endingStyle: .BlockAndGoToCenter)
        self.dragButton.delegate = self
        
        
        
        self.dragButton2.answerThePhoneStyle()
        self.dragButton2.set(.Slide, endingStyle: .Desapear)
        self.dragButton2.delegate = self
        
        self.dragButton3.metalicStyle()
        self.dragButton3.set(.Slide, endingStyle: .ComeBack)
        self.dragButton3.delegate = self
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.dragButton.backToInitialFrame(true)
        self.dragButton2.backToInitialFrame(true)
        self.label.text = "Let's drag a button !"
        self.label.textColor = UIColor.blackColor()
    }

    func dragButtonCompleteDragging(dragButton: HBDragButton) {
        self.label.text = "Well Done !!!"
        self.label.textColor = UIColor.redColor()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.dragButton.backToInitialFrame(false)
    }
    
}

extension HBDragButton {
    func answerThePhoneStyle() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    
    func metalicStyle() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.backgroundColor = UIColor(patternImage: UIImage(named: "Metal")!)
//        let stickOriginX = self.draggableAreaView.frame.origin.x + self.draggableAreaView.frame.size.width/2
//        let stickOriginY = self.draggableAreaView.frame.origin.y + self.draggableAreaView.frame.size.height/2
//        let stickWidth = self.frame.size.width - (stickOriginX * 2)
//        let stickFrame = CGRectMake(stickOriginX, stickOriginY, stickWidth, 2)
//        let stick = UIView(frame: stickFrame)
//        stick.backgroundColor = UIColor.blackColor()
//        //self.insertSubview(stick, aboveSubview: self.draggableAreaView)
//        self.insertSubview(stick, belowSubview: self.draggableAreaView)
    }
}

