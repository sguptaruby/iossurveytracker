//
//  HotsoptsScreen3VC.swift
//  ServeyTrackerApp
//
//  Created by Apple on 23/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class HotsoptsScreen3VC: UIViewController {
    
    @IBOutlet weak var dateTXT:UITextField!
    let datePicker = UIDatePicker()
    var imagePicker = UIImagePickerController()
    @IBOutlet var imgView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        defaultConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backButton(image: "back")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func defaultConfigure() {
        dateTXT.setTextFieldBoader()
        dateTXT.setLeftPaddingPoints(10)
        dateTXT.setRightViewImage(imageName: "calander")
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(donedatePicker), for: .valueChanged)
        dateTXT.inputView = datePicker
        dateTXT.addDoneButton()
        imagePicker.delegate = self
        
    }
    
    @objc func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateTXT.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func btnBrowsAction(sender:UIButton) {
        self.openGallary()
    }
    
    @IBAction func btnCameraAction(sender:UIButton) {
        self.openCamera()
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension HotsoptsScreen3VC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.imgView.image = image
        self.dismiss(animated: true, completion: nil)
}
}
