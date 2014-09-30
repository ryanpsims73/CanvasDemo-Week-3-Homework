//
//  CanvasViewController.swift
//  CanvasDemo
//
//  Created by Ryan Sims on 9/29/14.
//  Copyright (c) 2014 Ryan Sims. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var arrowImage: UIImageView!

    @IBOutlet weak var face1: UIImageView!
    @IBOutlet weak var face2: UIImageView!
    @IBOutlet weak var face3: UIImageView!
    @IBOutlet weak var face4: UIImageView!
    @IBOutlet weak var face5: UIImageView!
    @IBOutlet weak var face6: UIImageView!
    
    var trayViewOrigin = CGPoint()
    var trayIsOpen = Bool()
    var frictionY = CGFloat()
    
    let trayClosePosition = CGFloat(530)
    let trayArrowToggle = CGFloat(180 * M_PI / 180)
    let trayOpenPosition = CGFloat(370)


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // handle opening the tray
        // via panning
        var panTray = UIPanGestureRecognizer(target: self, action: "onPanTray:")
        self.trayView.addGestureRecognizer(panTray)
        
        // setup 
        trayView.frame.origin.y = trayClosePosition
        self.arrowImage.transform = CGAffineTransformMakeRotation(self.trayArrowToggle)
        trayIsOpen = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onPanTray(gestureRecognizer: UIPanGestureRecognizer){
        var location = gestureRecognizer.locationInView(view)
        var translation = gestureRecognizer.translationInView(view)
        var velocity = gestureRecognizer.velocityInView(view)
        
        //println("velocity \(velocity)")
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            // do nothing
            trayViewOrigin = trayView.frame.origin
        }
        else if gestureRecognizer.state == UIGestureRecognizerState.Changed {
            if (self.trayView.frame.origin.y <= self.trayOpenPosition) {
                frictionY = (self.trayOpenPosition - self.trayView.frame.origin.y)/1.5
            } else {
                frictionY = 0
            }
            println("friction \(frictionY)")
            self.trayView.frame.origin.y = (translation.y + frictionY) + trayViewOrigin.y
        }
        else if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            if (velocity.y < 0) {
                UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: nil, animations:{ () -> Void in
                    self.trayView.frame.origin.y = self.trayOpenPosition
                    }) { (finished: Bool) -> Void in
                        if (!self.trayIsOpen) {
                            self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, self.trayArrowToggle)
                        }
                        self.trayIsOpen = true
                    }
            } else {
                UIView.animateWithDuration(0.2, animations:{ () -> Void in
                    self.trayView.frame.origin.y = self.trayClosePosition
                    }) { (finished: Bool) -> Void in
                        if (self.trayIsOpen) {
                            self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, self.trayArrowToggle)
                        }
                        self.trayIsOpen = false
                }
            }
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
