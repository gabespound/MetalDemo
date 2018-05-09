//
//  ViewController.swift
//  metalTutorial
//
//  Created by Gabriel Spound on 5/6/18.
//  Copyright © 2018 Gabriel Spound. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tap: UITapGestureRecognizer!
    @IBOutlet var pinch: UIPinchGestureRecognizer!
    @IBOutlet var pan: UIPanGestureRecognizer!
    
    @IBOutlet weak var detailsView: UIView!
    
    @IBOutlet weak var ambientLabel: UILabel!
    @IBOutlet weak var diffuseLabel: UILabel!
    @IBOutlet weak var specLabel: UILabel!
    @IBOutlet weak var shineLabel: UILabel!
    @IBOutlet weak var ambientIntensity: UISlider!
    @IBOutlet weak var diffuseIntensity: UISlider!
    @IBOutlet weak var specIntensity: UISlider!
    @IBOutlet weak var shine: UISlider!
    
    var tapLocX: Float = 0.0
    var tapLocY: Float = 0.0
    

    @IBAction func onPan(_ sender: Any) {
        if(pan.numberOfTouches == 1){
            moveData.camRY = Float(pan.velocity(in: self.mainMetalView).x / 1000)
            moveData.camRX = Float(pan.velocity(in: self.mainMetalView).y / 1000)
        } else if (pan.numberOfTouches == 2){
            moveData.camX = Float(pan.velocity(in: self.mainMetalView).x / 10000)
            moveData.camY = Float(pan.velocity(in: self.mainMetalView).y / 10000)
        }
    }
    @IBAction func onPinch(_ sender: Any) {
        moveData.camZ = Float(self.pinch.velocity / 10.0)
    }
    @IBAction func onTap(_ sender: Any) {
        MetalView.tapLoc.x = Float(tap.location(in: mainMetalView).x * 2.0)
        MetalView.tapLoc.y = Float(tap.location(in: mainMetalView).y * 2.0)
    }
    @IBOutlet weak var sceneControl: UISegmentedControl!
    @IBOutlet weak var wireframeControl: UISegmentedControl!
    
    @IBOutlet weak var mainMetalView: MetalView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sceneChange(_ sender: Any) {
        Renderer.sceneChanged = true
        hide()
    }
    
    @IBAction func wireFrame(_ sender: Any) {
        if(self.wireframeControl.selectedSegmentIndex == 0){
            self.mainMetalView.toggleWireFrame()
        } else {
            self.mainMetalView.toggleWireFrame()
        }
    }
    @IBAction func ambienceChange(_ sender: Any) {
        Preferences.ambient = self.ambientIntensity.value
    }
    @IBAction func diffuseChange(_ sender: Any) {
        Preferences.diffuse = self.diffuseIntensity.value
        print(self.diffuseIntensity.value)
    }
    @IBAction func specChange(_ sender: Any) {
        Preferences.spec = self.specIntensity.value
    }
    @IBAction func shineChange(_ sender: Any) {
        Preferences.shine = 128.0 - self.shine.value
    }

    func hide(){
        ambientLabel.isHidden = !ambientLabel.isHidden
        diffuseLabel.isHidden = !diffuseLabel.isHidden
        specLabel.isHidden = !specLabel.isHidden
        shineLabel.isHidden = !shineLabel.isHidden
        ambientIntensity.isHidden = !ambientIntensity.isHidden
        diffuseIntensity.isHidden = !diffuseIntensity.isHidden
        specIntensity.isHidden = !specIntensity.isHidden
        shine.isHidden = !shine.isHidden
    }
    
    
}
