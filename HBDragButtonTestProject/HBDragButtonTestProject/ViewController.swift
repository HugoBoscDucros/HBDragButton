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
        self.dragButton.set(style: .Slide, endingStyle: .Desapear)
        self.dragButton.delegate = self
        
        self.dragButton2.answerThePhoneStyle()
        self.dragButton2.set(style: .Drag, endingStyle: .BlockAndGoToCenter)
        self.dragButton2.delegate = self
        
        self.dragButton3.metalicStyle()
        self.dragButton3.set(style: .Slide, endingStyle: .ComeBack)
        self.dragButton3.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dragButton.backToInitialFrame(animate: true)
        self.dragButton2.backToInitialFrame(animate: true)
        self.label.text = "Let's drag a button !"
        self.label.textColor = UIColor.black
    }

    func dragButtonCompleteDragging(dragButton: HBDragButton) {
        self.label.text = "Well Done !!!"
        self.label.textColor = UIColor.red
    }
    
//    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//        //self.dragButton.backToInitialFrame(false)
//        self.dragButton2.translatesAutoresizingMaskIntoConstraints = false
//    }
    
}

extension HBDragButton {
    func answerThePhoneStyle() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func metalicStyle() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
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

