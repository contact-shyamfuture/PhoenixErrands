//
//  EditProfileVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 09/10/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireObjectMapper
import Localize_Swift
import SVPinView
import FlagPhoneNumber

class EditProfileVC: BaseViewController {

    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var otpContentView: RoundUIView!
    @IBOutlet weak var otpMainView: UIView!
    @IBOutlet weak var fullImage: UIImageView!
    @IBOutlet weak var fullImgView: UIView!
    @IBOutlet weak var btnUpdateOutlet: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    var placeHolderArr : NSArray?
    var profileDetailsList : ProfileDetails?
    var existingPhone : String?
    @IBOutlet weak var tableViewProfileUpdate: UITableView!
    var prescirptionImg = [UIImage]()
    var imagePicker = UIImagePickerController()
    var userSelectedImage : UIImage?
    var imgName : String?
    var otpValues = Int()
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fullImgView.isHidden = true
        self.tableViewProfileUpdate.delegate = self
        self.tableViewProfileUpdate.dataSource = self
        self.otpMainView.isHidden = true
        self.otpContentView.isHidden = true
        
        pinView.didFinishCallback = didFinishEnteringPin(pin:)
        pinView.didChangeCallback = { pin in
            print("The entered pin is \(pin)")
        }

       // UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear//Constants.App.statusBarColor
        self.tableViewProfileUpdate.register(UINib(nibName: "UpdateProfilePhoneFieldTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "UpdateProfilePhoneFieldTableViewCell")
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        if profileDetailsList?.phone != nil {
            existingPhone = String((profileDetailsList?.phone)!)
        }
        if Localize.currentLanguage() == "en" {
            btnUpdateOutlet.setTitle("Update", for: .normal)
            self.placeHolderArr = ["First Name" , "Last Name" , "Email", "Phone"]
            headerView.lblHeaderTitle.text = "Update Profile"
        }else{
            btnUpdateOutlet.setTitle("Mettre à jour", for: .normal)
            self.placeHolderArr = ["Prénom" , "Nom de famille" , "Email", "Téléphone"]
            headerView.lblHeaderTitle.text = "Mettre à jour le profile"
        }
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.notificationValueView.isHidden = true
        headerView.imgProfileIcon.isHidden = true
        self.tabBarView.isHidden = true
        self.imagePicker.delegate = self
        imgProfile.layer.borderWidth = 0.5
        imgProfile.layer.masksToBounds = false
        imgProfile.layer.borderColor = UIColor.black.cgColor
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.clipsToBounds = true
        if UserDefaults.standard.string(forKey: PreferencesKeys.userImage) != nil {
            let urlMain = APIConstants.baseImageURL + UserDefaults.standard.string(forKey: PreferencesKeys.userImage)!
            self.imgProfile.sd_setImage(with: URL(string: urlMain))
            if let data = try? Data(contentsOf: URL(string: urlMain)!)
            {
                let image: UIImage = UIImage(data: data)!
                userSelectedImage = image
            }
        }
        profileDetailsList?.stringPhone =  "+" + String((profileDetailsList?.phone)!)
    }
    
    @IBAction func imageViewCancelBtnAction(_ sender: Any) {
        self.fullImgView.isHidden = true
    }
    
    @IBAction func btnUpdateAction(_ sender: Any) {
        let obj = UserProfile()
        obj.userFirstName = profileDetailsList?.userFirstName
        obj.userLastName = profileDetailsList?.userLastName
        obj.userEmail = profileDetailsList?.email
        let phoneString = profileDetailsList?.stringPhone.replacingOccurrences(of: "+", with: "", options: NSString.CompareOptions.literal, range: nil)
        obj.phone = phoneString
        if existingPhone != nil {
            if String((profileDetailsList?.stringPhone)!) == existingPhone {
                 obj.is_changed = 0
            }else{
                obj.is_changed = 1
            }
        }else{
            obj.is_changed = 1
        }
        
        if obj.userFirstName == nil || obj.userFirstName == "" {
            
            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please enter first name", okButtonText: okText, completion: nil)
            
        } else if obj.userLastName == nil || obj.userLastName == "" {
            
            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please enter last name", okButtonText: okText, completion: nil)
            
        }else if obj.userEmail == nil || obj.userEmail == "" {
            
            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please enter email", okButtonText: okText, completion: nil)
            
        }else if obj.phone == nil || obj.phone == "" {
            
            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please enter mobile number", okButtonText: okText, completion: nil)
        }else{
            if let params = self.validateUserInputs(user: obj) {
                if let img = userSelectedImage {
                    let data = img.jpegData(compressionQuality: 0)
                    
                    self.requestWith(endUrl: "http://phoenix.smtechnoservice.com/api/editprofile", imageData: data, parameters: params)
                }else{
                    self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please select profile picture", okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    @IBAction func captureImageBtnAction(_ sender: Any) {
        self.selectUserImageAction()
    }
    
    func validateUserInputs(user: UserProfile) -> [String: Any]? {
        return user.toJSON()
    }
    
    @IBAction func ottpViewCancel(_ sender: Any) {
        self.otpMainView.isHidden = true
        self.otpContentView.isHidden = true
    }
    
    @IBAction func otpSubmitView(_ sender: Any) {
        
    }
    
    func didFinishEnteringPin(pin:String) {
           //showAlert(title: "Success", message: "The Pin entered is \(pin)")
        let data = String(otpValues)
        if data == pin {
            
            let obj = UserProfile()
            obj.userFirstName = profileDetailsList?.userFirstName
            obj.userLastName = profileDetailsList?.userLastName
            obj.userEmail = profileDetailsList?.email
            let phoneString = profileDetailsList?.stringPhone.replacingOccurrences(of: "+", with: "", options: NSString.CompareOptions.literal, range: nil)
            obj.phone = phoneString
            obj.is_changed = 0
            if obj.userFirstName == nil || obj.userFirstName == "" {
                self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please enter first name", okButtonText: okText, completion: nil)
            } else if obj.userLastName == nil || obj.userLastName == "" {
                self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please enter last name", okButtonText: okText, completion: nil)
                
            }else if obj.userEmail == nil || obj.userEmail == "" {
                
                self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please enter email", okButtonText: okText, completion: nil)
                
            }else if obj.phone == nil || obj.phone == "" {
                
                self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please enter mobile number", okButtonText: okText, completion: nil)
            }else{
                if let params = self.validateUserInputs(user: obj) {
                    if let img = userSelectedImage {
                        let data = img.jpegData(compressionQuality: 0)
                        
                        self.requestWith(endUrl: "http://phoenix.smtechnoservice.com/api/editprofile", imageData: data, parameters: params)
                    }
                }
            }
            
        }else{
            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Otp does not match", okButtonText: okText, completion: {
                self.pinView.clearPin()
            })
        }
    }
}

extension EditProfileVC : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (placeHolderArr?.count)!
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "RegisterFieldCell") as! RegisterFieldCell
            Cell.txtField.placeholder = (placeHolderArr![indexPath.row] as! String)
            Cell.txtField.tag = indexPath.row
            Cell.txtField.delegate = self
            Cell.txtField.text = profileDetailsList?.userFirstName ?? ""
            Cell.txtField.keyboardType = .default
            Cell.txtField.isUserInteractionEnabled = true
            return Cell
        case 1:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "RegisterFieldCell") as! RegisterFieldCell
            Cell.txtField.placeholder = (placeHolderArr![indexPath.row] as! String)
            Cell.txtField.tag = indexPath.row
            Cell.txtField.delegate = self
            Cell.txtField.text = profileDetailsList?.userLastName ?? ""
            Cell.txtField.keyboardType = .default
            Cell.txtField.isUserInteractionEnabled = true
            return Cell
        case 2:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "RegisterFieldCell") as! RegisterFieldCell
            Cell.txtField.placeholder = (placeHolderArr![indexPath.row] as! String)
            Cell.txtField.tag = indexPath.row
            Cell.txtField.delegate = self
            Cell.txtField.text = profileDetailsList?.email ?? ""
            Cell.txtField.keyboardType = .emailAddress
            Cell.txtField.isUserInteractionEnabled = false
            return Cell
        case 3:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "UpdateProfilePhoneFieldTableViewCell") as! UpdateProfilePhoneFieldTableViewCell
            Cell.txtPhoneNumber.placeholder = (placeHolderArr![indexPath.row] as! String)
            Cell.txtPhoneNumber.tag = indexPath.row
            Cell.txtPhoneNumber.delegate = self
//            Cell.txtPhoneNumber.text = String((profileDetailsList?.phone)!)
//            Cell.txtPhoneNumber.keyboardType = .numberPad
          //  Cell.txtPhoneNumber!.setFlag(for: .FR)
            Cell.txtPhoneNumber.isUserInteractionEnabled = true
            Cell.txtPhoneNumber.displayMode = .picker
            let phoneNumber = String((profileDetailsList?.stringPhone)!)
            Cell.txtPhoneNumber.set(phoneNumber: phoneNumber)
            Cell.txtPhoneNumber.set(phoneNumber: phoneNumber)
            return Cell
        default:
            return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension EditProfileVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let txtAfterUpdate = textField.text! as NSString
        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
        print("Updated TextField:: \(updateText)")
        switch textField.tag {
        case 0:
            profileDetailsList!.userFirstName = updateText as String
        case 1:
            profileDetailsList!.userLastName = updateText as String
        case 2:
            profileDetailsList?.email = updateText as String
        case 3:
            if updateText != "" {
                profileDetailsList?.stringPhone = updateText as String
            }
        default:
            break
        }
        return true
    }
    
    func viewFullScreenImage(){
        if UserDefaults.standard.string(forKey: PreferencesKeys.userImage) != nil {
            let urlMain = APIConstants.baseImageURL + UserDefaults.standard.string(forKey: PreferencesKeys.userImage)!
            self.fullImage.sd_setImage(with: URL(string: urlMain))
            if let data = try? Data(contentsOf: URL(string: urlMain)!)
            {
                let image: UIImage = UIImage(data: data)!
                userSelectedImage = image
            }
        }
        self.fullImgView.isHidden = false
    }
}

extension EditProfileVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func selectUserImageAction() {
        
        let alert:UIAlertController=UIAlertController(title: nil , message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let viewAction = UIAlertAction(title: "View Image", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.viewFullScreenImage()
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive)
        {
            UIAlertAction in
        }
        
        alert.addAction(viewAction)
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x:view.frame.size.width / 2, y: view.frame.size.height,width: 200,height : 200)
        }
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: open camera method
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
            
        }else{
            
            let alertController = UIAlertController(title: commonAlertTitle, message: "Device has no camera", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: open gallary method
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: PickerView Delegate Methods
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        userSelectedImage = selectedImage
        imgProfile.image = selectedImage
        dismiss(animated:true, completion: nil)
    }
    
    //MARK: PickerView Delegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        print("picker cancel.")
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileVC {
    func requestWith(endUrl: String, imageData: Data?, parameters: [String : Any], onCompletion: ((Any?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        let url = "http://phoenixerrands.com/public/api/editprofile"
        let headers = ["Content-type": "multipart/form-data", "Accept": "application/json", "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!]
        self.addLoaderView()
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let data = imageData{
                multipartFormData.append(data, withName: "image", fileName: "12345" , mimeType: "")
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
                
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted * 100)")
                })
                upload.responseJSON { response in
                    upload.responseJSON { response in
                        self.removeLoaderView()
                        guard let result = response.result.value else { return }
                        print("\(result)")
                        let resultDic = result as! Dictionary<String,Any>
                        let status = resultDic["status"] as! Int
                        if (resultDic["otp"] != nil) {
                            self.otpMainView.isHidden = false
                            self.otpContentView.isHidden = false
                            self.otpValues = resultDic["otp"] as! Int
                        }else{
                            self.otpMainView.isHidden = true
                            self.otpContentView.isHidden = true
                            if status == 200 {
                                self.showAlertWithSingleButton(title: commonAlertTitle, message: "Profile update successfull", okButtonText: okText, completion: {
                                    self.navigationController?.popViewController(animated: true)
                                })
                            }else{
                                self.showAlertWithSingleButton(title: commonAlertTitle, message: "Profile update faild", okButtonText: okText, completion: nil)
                            }
                        }
                    }
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    onCompletion?(nil)
                }
            case .failure(let error):
                self.removeLoaderView()
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
}
extension EditProfileVC: FPNTextFieldDelegate {
    
    
    
   /// The place to present/push the listController if you choosen displayMode = .list
   func fpnDisplayCountryList() {
      let navigationViewController = UINavigationController(rootViewController: listController)
      
      present(navigationViewController, animated: true, completion: nil)
   }

   /// Lets you know when a country is selected
   func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
      print(name, dialCode, code) // Output "France", "+33", "FR"
   }

   /// Lets you know when the phone number is valid or not. Once a phone number is valid, you can get it in severals formats (E164, International, National, RFC3966)
   func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
      if isValid {
         // Do something...
         textField.getFormattedPhoneNumber(format: .E164)         // Output "+33600000001"
         textField.getFormattedPhoneNumber(format: .International)  // Output "+33 6 00 00 00 01"
         textField.getFormattedPhoneNumber(format: .National)       // Output "06 00 00 00 01"
         textField.getFormattedPhoneNumber(format: .RFC3966)       // Output "tel:+33-6-00-00-00-01"
         textField.getRawPhoneNumber()                               // Output "600000001"
        profileDetailsList?.stringPhone = textField.getFormattedPhoneNumber(format: .E164)!
      } else {
         // Do something...
      }
   }
}
