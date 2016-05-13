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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dragButton.delegate = self
        self.dragButton.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //self.dragButton.layer.cornerRadius = 38//self.dragButton.frame.size.height/2
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.dragButton.backToInitialFrame(true)
    }

    func dragButtonCompleteDragging(dragButton: HBDragButton) {
        //
    }
    
}

