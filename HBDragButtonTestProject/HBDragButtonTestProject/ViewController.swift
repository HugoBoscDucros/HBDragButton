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
        
        self.dragButton3.answerThePhoneStyle()
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

extension UIView {
    func answerThePhoneStyle() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
}

