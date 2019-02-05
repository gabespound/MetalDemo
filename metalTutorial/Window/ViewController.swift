//
//  ViewController.swift
//  metalTutorial
//
//  Created by Gabriel Spound on 5/6/18.
//  Copyright © 2018 Gabriel Spound. All rights reserved.
//

import UIKit
import iOS_Color_Picker

class ViewController: UIViewController, FCColorPickerViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerObjs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerObjs[row].deletingPathExtension().lastPathComponent
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let str = pickerObjs[row].deletingPathExtension().lastPathComponent
        var imgString = ""
        if (str == "f16") {imgString = "F16s.bmp"}
        
        self.mainMetalView.renderer.scene.model = Model(
            device: self.mainMetalView.renderer.scene.device,
            modelURL: Bundle.main.url(forResource:str, withExtension: "obj")!,
            imageName: imgString)
        self.mainMetalView.renderer.terrainScene.newModel()
        self.mainMetalView.renderer.basicScene.newModel()
    }
    
    @IBOutlet weak var objPicker: UIPickerView!
    var pickerObjs: [URL] = [Bundle.main.url(forResource: "armadillo", withExtension: "obj")!]
    
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
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
    
    let swipeup = UISwipeGestureRecognizer()
    let swipedown = UISwipeGestureRecognizer()
    
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
    @IBOutlet weak var arrowImg: UIImageView!
    
    @IBOutlet weak var mainMetalView: MetalView!
    
    var rot: CGFloat = 3.14159
    var viewCDown: CGFloat = 0.0
    var viewCUp: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewCUp = self.viewBottomConstraint.constant
        self.viewBottomConstraint.constant -= self.detailsView.frame.height
        viewCDown = self.viewBottomConstraint.constant
        self.arrowImg.isUserInteractionEnabled = true
        pickerObjs = Bundle.main.urls(forResourcesWithExtension: "obj", subdirectory: nil)!
        
        self.objPicker.delegate = self
        self.objPicker.dataSource = self
        
       /* swipeup.direction = UISwipeGestureRecognizerDirection.up
        swipeup.addTarget(self, action: Selector(("swipedViewUp")))
        arrowImg.addGestureRecognizer(swipeup)
        
        swipedown.direction = UISwipeGestureRecognizerDirection.down
        swipeup.addTarget(self, action: Selector(("swipedViewDown")))
        arrowImg.addGestureRecognizer(swipedown)*/
        
        
    }

    @IBAction func tapArrow(_ sender: Any) {
        UIView.animate(withDuration: 1){
        self.viewBottomConstraint.constant = self.viewBottomConstraint.constant < 0 ? self.viewCUp : self.viewCDown
            self.arrowImg.transform  = CGAffineTransform.init(rotationAngle: self.rot)
            self.rot = self.rot == 0 ? 3.14159 : 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func arrowUp(_ sender: Any) {
        self.viewBottomConstraint.constant += self.detailsView.frame.height;
    }
    
    @IBAction func arrowDown(_ sender: Any) {
        self.viewBottomConstraint.constant -= self.detailsView.frame.height
    }
    
    func swipedViewUP() {
        //self.viewBottomConstraint.constant += self.detailsView.frame.height;
    }
    
    func swipedViewDown() {
        //self.viewBottomConstraint.constant -= self.detailsView.frame.height
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
    
    @IBAction func changeModel(_ sender: Any) {
        
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
 
    @IBAction func colorPick(_ sender: Any) {
        let colorPicker = FCColorPickerViewController.init()
        colorPicker.color = UIColor(red: CGFloat(self.mainMetalView.clearColor.red), green: CGFloat(self.mainMetalView.clearColor.green), blue: CGFloat(self.mainMetalView.clearColor.blue), alpha: CGFloat(self.mainMetalView.clearColor.alpha))
        colorPicker.delegate = self
        colorPicker.modalPresentationStyle = UIModalPresentationStyle.init(rawValue: 0)!
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    func colorPickerViewController(_ colorPicker: FCColorPickerViewController, didSelect color: UIColor) {
        let r = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let g = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let b = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let a = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        
        color.getRed(r, green: g, blue: b, alpha: a)
        self.mainMetalView.clearColor = MTLClearColor(red: Double(r.pointee), green: Double(g.pointee), blue: Double(b.pointee), alpha: Double(a.pointee))
        self.dismiss(animated: true, completion: nil)
    }
    
    func colorPickerViewControllerDidCancel(_ colorPicker: FCColorPickerViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func hide(){
        /*ambientLabel.isHidden = !ambientLabel.isHidden
        diffuseLabel.isHidden = !diffuseLabel.isHidden
        specLabel.isHidden = !specLabel.isHidden
        shineLabel.isHidden = !shineLabel.isHidden
        ambientIntensity.isHidden = !ambientIntensity.isHidden
        diffuseIntensity.isHidden = !diffuseIntensity.isHidden
        specIntensity.isHidden = !specIntensity.isHidden
        shine.isHidden = !shine.isHidden*/
    }
    
    
}
