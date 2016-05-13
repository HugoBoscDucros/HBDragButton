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
        
        self.dragButton2.delegate = self
        self.dragButton2.slidableStyle()
        self.dragButton3.delegate = self
        self.dragButton3.slidableStyle()
        self.dragButton3.endStyle = "ComingBack"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.dragButton.delegate = self
        self.dragButton.autoSet()
        //self.dragButton.translatesAutoresizingMaskIntoConstraints = true
        //self.dragButton.layer.cornerRadius = 38//self.dragButton.frame.size.height/2
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
    
}

