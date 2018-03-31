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
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgVWCollectionVW:UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        defaultConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backButton(image: "back")
        self.navigationItem.title = "Capture Images"
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
    
        imagePicker.delegate = self
        
        imgVWCollectionVW.register(UINib(nibName: ImageCollectionViewCell.stringRepresentation, bundle: nil), forCellWithReuseIdentifier: ImageCollectionViewCell.stringRepresentation)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 40, left: 0, bottom: 10, right: 0)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        imgVWCollectionVW!.collectionViewLayout = layout
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        dateTXT.inputAccessoryView = keyboardToolbar
    }
    
    @objc func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateTXT.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        //self.view.endEditing(true)
    }
    
    @objc func doneAction(){
        if (dateTXT.text?.isEmpty)! {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            dateTXT.text = formatter.string(from: Date())
            //dismiss date picker dialog
        }
        //For date formate
        self.view.endEditing(true)
    }
    
    func validation() -> Bool {
        if (dateTXT.text?.isEmpty)! {
            self.showAlert(title: "", message: "Enter date.")
            return false
        }
        if ServeyTrackerManager.share.arrImages.count == 0 {
            self.showAlert(title: "", message: "Please select image at lest one.")
            return false
        }
        return true
    }
    
    @IBAction func btnNextAction(sender:UIButton) {
        if validation() {
            let stringRepresentation = ServeyTrackerManager.share.arrImages.joined(separator: ",")
               print(stringRepresentation)
            
            ServeyTrackerManager.share.paramsTnxService[DictionaryKey.date] = dateTXT.text
            ServeyTrackerManager.share.paramsTnxService[DictionaryKey.activityImage] = stringRepresentation
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: HotsoptsScreen4VC.stringRepresentation)
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
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
        let uuid = UUID().uuidString
        let name = "\(uuid).jpg"
        ServeyTrackerManager.share.arrImages.append(name)
        print(uuid)
        self.saveImageDocumentDirectory(image: image!, imgName: name)
        imgVWCollectionVW.reloadData()
        self.dismiss(animated: true, completion: nil)
   }
}

extension HotsoptsScreen3VC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  ServeyTrackerManager.share.arrImages != nil {
            return ServeyTrackerManager.share.arrImages.count
        }
         return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.stringRepresentation, for: indexPath) as! ImageCollectionViewCell
        cell.imgView.backgroundColor = UIColor.black
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteImage(sender:)), for: .touchUpInside)
        let Imgname = self.getImage(imgName: ServeyTrackerManager.share.arrImages[indexPath.row])
        cell.imgView.image = UIImage(contentsOfFile: Imgname!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 100, height: 100)
    }
    
    @objc func deleteImage(sender:UIButton) {
        let Imgname = self.getImage(imgName: ServeyTrackerManager.share.arrImages[sender.tag])
        self.removeImageFromDocumentDir(itemName: Imgname!)
        ServeyTrackerManager.share.arrImages.remove(at: sender.tag)
        imgVWCollectionVW.reloadData()
    }
    
}
