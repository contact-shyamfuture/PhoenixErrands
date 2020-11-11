//
//  ServiceQuestionAnswerVC.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import Localize_Swift
import Foundation
import Alamofire
import AlamofireObjectMapper

class ServiceQuestionAnswerVC: BaseViewController {

    @IBOutlet weak var lblQuestionName: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressBarWidth: NSLayoutConstraint!
    @IBOutlet weak var questionAnswerTable: UITableView!
    var optionArray : NSArray?
    var cellValue : Int = 0
    var serviceID : String?
    var isprovider : Bool?
    var postalCode : String?
    @IBOutlet weak var btnCarryOnOutlet: UIButton!
    
    
    var shownIndexes : [IndexPath] = []
    let CELL_HEIGHT : CGFloat = 60
    
    lazy var viewModel: QuestionAnswerVM = {
        return QuestionAnswerVM()
    }()
    
    var setDetails = QuestionAnswerModel()
    var questionSetUserArr : [QuestionAnswerUserList]?
    var questionSetProviderArr : [QuestionAnswerProviderList]?
    var progress = Progress(totalUnitCount: 0)
    
    var prescirptionImg = [UIImage]()
    var selectedServiceImage = [String]()
    var imagePicker = UIImagePickerController()
    var userSelectedImage : UIImage?
    
    var checked = [Bool]()
    var blockShadowVw = UIView()
    
    var selectedCheckBoxRowIndex = [Int]()
    var selectedCheckBoxRowIndexValue = [String]()
    let dataNotFound = Localize.currentLanguage() == "en" ? "Data not found" : "Données non trouvées"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = false
        headerView.notificationValueView.isHidden = true
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.lblHeaderTitle.text = "Questions and Answers"
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        
        self.view.addSubview(blockShadowVw)
        blockShadowVw.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        blockShadowVw.backgroundColor = .white
        
        tabBarView.isHidden = true
        self.questionAnswerTable.delegate = self
        self.questionAnswerTable.dataSource = self
        self.optionArray = ["I want to find a provider quickly" , "I'm looking for quotes for a service that will take place later", "I'm testing Stootie to understand how it works"]
        self.questionAnswerTable.register(UINib(nibName: "QuestionCheckBoxCell", bundle: Bundle.main), forCellReuseIdentifier: "QuestionCheckBoxCell")
        
        self.questionAnswerTable.register(UINib(nibName: "TextBoxCell", bundle: Bundle.main), forCellReuseIdentifier: "TextBoxCell")
        self.imagePicker.delegate = self
        self.initializeViewModel()
        if Localize.currentLanguage() == "en" {
            btnCarryOnOutlet.setTitle("Carry on", for: .normal)
            headerView.lblHeaderTitle.text = "Questions and Answers".localized();
        }else{
            btnCarryOnOutlet.setTitle("Continuer", for: .normal)
            headerView.lblHeaderTitle.text = "Questions et réponses".localized();
        }
        self.getQuestionSetDetails(lang: Localize.currentLanguage())
    }
    
    func getQuestionSetDetails(lang : String){
        viewModel.getQuestionSetDetailsToAPIService(serviceID: serviceID!, lang: lang)
    }
    
    
    func initializeViewModel() {
        
        viewModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
        
        viewModel.refreshViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if (self?.viewModel.questionSetDetails.status) == 200 {
                    self?.blockShadowVw.isHidden = true
                    self!.setDetails = (self?.viewModel.questionSetDetails)!
                    self!.questionSetUserArr = (self?.viewModel.questionSetDetails.questionSetUserArr)!
                    self!.questionSetProviderArr = (self?.viewModel.questionSetDetails.questionSetProviderArr)!
                    
                    if self!.isprovider == true {
                        
                        let total = self!.questionSetProviderArr?.count
                        self?.progress.completedUnitCount += 1
                        let progressFloat = Float(self!.progress.completedUnitCount)
                        UIView.animate(withDuration: 0.8, animations: { () -> Void in
                            self!.progressView.setProgress(progressFloat / Float(total!), animated: true)
                        })
                        if (self!.questionSetProviderArr?.count)! > 0 {
                            self!.lblQuestionName.text = self!.questionSetProviderArr![self!.cellValue].question
//                            self!.headerView.lblHeaderTitle.text = self!.questionSetProviderArr![self!.cellValue].question
                        }else{
                            self?.blockShadowVw.isHidden = false
                            self?.showAlertWithSingleButton(title: commonAlertTitle, message: self!.dataNotFound, okButtonText: okText){
                                self?.navigationController?.popViewController(animated: true)
                            }
                        }
                        
                    }else{
                        
                        let total = self!.questionSetUserArr?.count
                        self?.progress.completedUnitCount += 1
                        let progressFloat = Float(self!.progress.completedUnitCount)
                        UIView.animate(withDuration: 0.8, animations: { () -> Void in
                            self!.progressView.setProgress(progressFloat / Float(total!), animated: true)
                        })
                        if (self!.questionSetUserArr?.count)! > 0 {
//                            self!.headerView.lblHeaderTitle.text = self!.questionSetUserArr![self!.cellValue].question
                            self!.lblQuestionName.text = self!.questionSetUserArr![self!.cellValue].question
                        }else{
                            self?.blockShadowVw.isHidden = false
                            self?.showAlertWithSingleButton(title: commonAlertTitle, message: self!.dataNotFound, okButtonText: okText){
                                self?.navigationController?.popViewController(animated: true)
                            }
                        }
                        
                       // self!.headerView.lblHeaderTitle.text = self!.questionSetUserArr![self!.cellValue].question
                    }
                    
                    self!.questionAnswerTable.reloadData()
                }else{
                    self?.blockShadowVw.isHidden = false
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: self!.dataNotFound, okButtonText: okText){
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    
    @IBAction func btnCarryOnAction(_ sender: Any) {
        shownIndexes.removeAll()
        if isprovider == true {
            let total = questionSetProviderArr?.count
            self.progress.completedUnitCount += 1
            let progressFloat = Float(self.progress.completedUnitCount)
            UIView.animate(withDuration: 0.8, animations: { () -> Void in
                self.progressView.setProgress(progressFloat / Float(total!), animated: true)
            })
            if questionSetProviderArr != nil  && ((questionSetProviderArr?.count)! - 1) > cellValue {
                cellValue +=  1
                progressBarWidth.constant += 60
                UIView.transition(with: questionAnswerTable,
                                  duration: 1.35,
                                  options: [],
                                  animations: { self.questionAnswerTable.reloadData() })
                
//                headerView.lblHeaderTitle.text = questionSetProviderArr![cellValue].question
                self.lblQuestionName.text = questionSetProviderArr![cellValue].question
            }else{
                let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "ServiceSearchVC") as? ServiceSearchVC
                vc!.questionSetProviderArr = questionSetProviderArr
                vc!.serviceID = serviceID
                vc!.isprovider = isprovider
                vc!.postalCode = postalCode
                vc!.imageList = selectedServiceImage
                self.navigationController?.pushViewController(vc!, animated: false)
            }
        }else{
            
            selectedCheckBoxRowIndex = [Int]()
            selectedCheckBoxRowIndexValue = [String]()
            let total = questionSetUserArr?.count
            self.progress.completedUnitCount += 1
            let progressFloat = Float(self.progress.completedUnitCount)
            UIView.animate(withDuration: 0.8, animations: { () -> Void in
                self.progressView.setProgress(progressFloat / Float(total!), animated: true)
            })
            
            if questionSetUserArr != nil  && ((questionSetUserArr?.count)! - 1) > cellValue {
                cellValue +=  1
                progressBarWidth.constant += 60
                UIView.transition(with: questionAnswerTable,
                                  duration: 1.35,
                                  options: [],
                                  animations: { self.questionAnswerTable.reloadData() })
//                headerView.lblHeaderTitle.text = questionSetUserArr![cellValue].question
                self.lblQuestionName.text = questionSetUserArr![cellValue].question
            }else{
                let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "ServiceSearchVC") as? ServiceSearchVC
                vc!.questionSetUserArr = questionSetUserArr
                vc!.serviceID = serviceID
                vc!.isprovider = isprovider
                vc!.postalCode = postalCode
                vc!.imageList = selectedServiceImage
                self.navigationController?.pushViewController(vc!, animated: false)
            }
        }
    }
    
    func AddPrescriptionImage(indexPath : Int){
        selectUserImageAction()
    }
    
    func removePrescriptionImage(indexPath : Int){
        print("Tab Cancel tag : \(indexPath)")
        self.prescirptionImg.remove(at: indexPath)
        self.questionAnswerTable.reloadData()
    }
}

extension ServiceQuestionAnswerVC : UITableViewDelegate, UITableViewDataSource , PrescriptionImageProtocal {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isprovider == true {
            if questionSetProviderArr != nil  && (questionSetProviderArr?.count)! > cellValue {
                let count = questionSetProviderArr![cellValue].array_answer
                let array = count!.components(separatedBy: ",")
                if array.count > 0 {
                    return (array.count)
                }else{
                    return 0
                }
            }else{
                return 0
            }
            
        }else{
            if questionSetUserArr != nil  && (questionSetUserArr?.count)! > cellValue {
                let countArray = questionSetUserArr![cellValue].answerArrayList
                if countArray != nil {
                    if countArray!.count > 0 {
                        return (countArray!.count)
                    }else{
                        return 0
                    }
                }else{
                    return 0
                }
            }else{
                return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isprovider == true {
            let data = questionSetProviderArr![cellValue].array_answer
            let array = data!.components(separatedBy: ",")
            if questionSetProviderArr![cellValue].type == "text" {
                let Cell = tableView.dequeueReusableCell(withIdentifier: "TextBoxCell") as! TextBoxCell
                Cell.lblYourText.text = Localize.currentLanguage() == "en" ? "Please enter details concerning your skill below." : "Veuillez entrer les détails concernant votre compétence ci-dessous."
                Cell.questionAnswerTxtView.text = questionSetProviderArr![cellValue].array_answer
                Cell.questionAnswerTxtView.tag = cellValue
                Cell.questionAnswerTxtView.delegate = self
                return Cell
            }else if questionSetProviderArr![cellValue].type == "checkbox" {
                let Cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCheckBoxCell") as! QuestionCheckBoxCell
                Cell.lblQuestionName.text = array[indexPath.row]
                let checkBoxArray = questionSetProviderArr![cellValue].selectedCheckBox
                if checkBoxArray == "" {
                    Cell.imgCheckBox.image = UIImage(named: "checkBox")!
                }else{
                    let arrayCheck = checkBoxArray.components(separatedBy: ",")
                    if arrayCheck.count > indexPath.row {
                        if arrayCheck[indexPath.row] == array[indexPath.row]{
                            Cell.imgCheckBox.image = UIImage(named: "checkBoxSelect")!
                        }else{
                            Cell.imgCheckBox.image = UIImage(named: "checkBox")!
                        }
                    }else{
                        Cell.imgCheckBox.image = UIImage(named: "checkBox")!
                    }
                }
                return Cell
            }else if questionSetProviderArr![cellValue].type == "radio" {
                
                let Cell = tableView.dequeueReusableCell(withIdentifier: "ServiceQuestionAnswerCell") as! ServiceQuestionAnswerCell
                Cell.lblQuestionName.text = array[indexPath.row]
                if questionSetProviderArr![cellValue].selectedIndex != nil {
                    if indexPath.row == questionSetProviderArr![cellValue].selectedIndex {
                       Cell.imgRadioCheck.image = UIImage(named: "RadioRed")!
                    }else
                    {
                        Cell.imgRadioCheck.image = UIImage(named: "Radio")!
                    }
                }else{
                    Cell.imgRadioCheck.image = UIImage(named: "Radio")!
                }
                return Cell
                
            }else if questionSetProviderArr![cellValue].type == "file" {
                
                let Cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAnswerImageCell") as! QuestionAnswerImageCell
                Cell.prescirptionImg = prescirptionImg
                Cell.prescriptionImage = self
                Cell.imageCollection.reloadData()
                return Cell
            }else{
                return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            }
        }else{
            let data = questionSetUserArr![cellValue].array_answer
            let array = data!.components(separatedBy: ",")
            if questionSetUserArr![cellValue].type == "radio" {
                let Cell = tableView.dequeueReusableCell(withIdentifier: "ServiceQuestionAnswerCell") as! ServiceQuestionAnswerCell
                
                if questionSetUserArr![cellValue].selectedIndex != nil {
                    if indexPath.row == questionSetUserArr![cellValue].selectedIndex {
                        Cell.imgRadioCheck.image = UIImage(named: "RadioRed")!
                    }else
                    {
                        Cell.imgRadioCheck.image = UIImage(named: "Radio")!
                    }
                }else{
                    Cell.imgRadioCheck.image = UIImage(named: "Radio")!
                }
                Cell.lblQuestionName.text = array[indexPath.row]
                return Cell
            }else if questionSetUserArr![cellValue].type == "checkbox" {
                
                let dataArr = questionSetUserArr![cellValue].answerArrayList
                
                let Cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCheckBoxCell") as! QuestionCheckBoxCell
                Cell.lblQuestionName.text = dataArr![indexPath.row]
              
                if selectedCheckBoxRowIndex != nil {
                    
                    if selectedCheckBoxRowIndex.contains(indexPath.row) {
                        Cell.imgCheckBox.image = UIImage(named: "checkBoxSelect")!
                    }else{
                        Cell.imgCheckBox.image = UIImage(named: "checkBox")!
                    }
                }else{
                    Cell.imgCheckBox.image = UIImage(named: "checkBox")!
                }
                
                return Cell
            }else if questionSetUserArr![cellValue].type == "text" {
                
               let Cell = tableView.dequeueReusableCell(withIdentifier: "TextBoxCell") as! TextBoxCell
                Cell.lblYourText.text = Localize.currentLanguage() == "en" ? "" : ""
                Cell.questionAnswerTxtView.text = questionSetUserArr![cellValue].array_answer
                Cell.questionAnswerTxtView.tag = cellValue
                Cell.questionAnswerTxtView.delegate = self
                return Cell
            }else if questionSetUserArr![cellValue].type == "file" {
                
                let Cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAnswerImageCell") as! QuestionAnswerImageCell
                Cell.prescirptionImg = prescirptionImg
                Cell.prescriptionImage = self
                Cell.imageCollection.reloadData()
                return Cell
            }else{
                return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (shownIndexes.contains(indexPath) == false) {
            shownIndexes.append(indexPath)
            
            cell.transform = CGAffineTransform(translationX: 0, y: CELL_HEIGHT)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 10, height: 10)
            cell.alpha = 0
            
            UIView.beginAnimations("rotation", context: nil)
            UIView.setAnimationDuration(0.5)
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            cell.alpha = 1
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            UIView.commitAnimations()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isprovider == true {
            if questionSetProviderArr![cellValue].type == "text" {
                return 160
            }else if questionSetProviderArr![cellValue].type == "file"{
                return 185
            }else{
                return UITableView.automaticDimension
            }
        }else{
            if questionSetUserArr![cellValue].type == "text"{
                 return 160
            }else if questionSetUserArr![cellValue].type == "file"{
                return 185
            }else{
                 return UITableView.automaticDimension
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isprovider == true {
            
            if questionSetProviderArr![cellValue].type == "text" {
                
            }else if questionSetProviderArr![cellValue].type == "checkbox" {
                let data = questionSetProviderArr![cellValue].array_answer
                let array = data!.components(separatedBy: ",")
                
                if questionSetProviderArr![cellValue].selectedCheckBox == "" {
                    questionSetProviderArr![cellValue].selectedCheckBox  += array[indexPath.row]
                }else{
                    questionSetProviderArr![cellValue].selectedCheckBox  += "," + array[indexPath.row]
                }
            }else if questionSetProviderArr![cellValue].type == "radio"{
                questionSetProviderArr![cellValue].selectedIndex = indexPath.row
            }
            
        }else{
            
            let data = questionSetUserArr![cellValue].array_answer
            
            let array = data!.components(separatedBy: ",")
            if questionSetUserArr![cellValue].type == "text" {
                
            }else if questionSetUserArr![cellValue].type == "checkbox" {
                
                let dataIndex =  questionSetUserArr![cellValue].answerArrayList![indexPath.row]
                if selectedCheckBoxRowIndex != nil {
                    
                    if selectedCheckBoxRowIndex.contains(indexPath.row) {
                        if let indexs = selectedCheckBoxRowIndex.index(of: indexPath.row) {
                            selectedCheckBoxRowIndex.remove(at: indexs)
                            selectedCheckBoxRowIndexValue.remove(at: indexs)
                            
                            let stringArray = selectedCheckBoxRowIndexValue.map { String($0) }
                            let string = stringArray.joined(separator: ",")
                            questionSetUserArr![cellValue].selectedCheckBox = string
                        }
                    }else{
                        
                        selectedCheckBoxRowIndexValue.append(dataIndex)
                        selectedCheckBoxRowIndex.append(indexPath.row)
                        
                        let stringArray = selectedCheckBoxRowIndexValue.map { String($0) }
                        let string = stringArray.joined(separator: ",")
                        questionSetUserArr![cellValue].selectedCheckBox = string
                    }
                }
                
//                if questionSetUserArr![cellValue].selectedCheckBox == "" {
//                    questionSetUserArr![cellValue].selectedCheckBox  += array[indexPath.row]
//                }else{
//
//                    let string = array[indexPath.row]
//                    if questionSetUserArr![cellValue].selectedCheckBox.contains(string) {
//                      questionSetUserArr![cellValue].selectedCheckBox = questionSetUserArr![cellValue].selectedCheckBox.replacingOccurrences(of: string, with: "")
//                    }else{
//                        questionSetUserArr![cellValue].selectedCheckBox  += "," + array[indexPath.row]
//                    }
//                }
                
            }else if questionSetUserArr![cellValue].type == "radio"{
                questionSetUserArr![cellValue].selectedIndex = indexPath.row
                questionSetUserArr![cellValue].selectedIndexAns = array[indexPath.row]
            }
        }
        self.questionAnswerTable.reloadData()
    }
}
extension ServiceQuestionAnswerVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView){
        if textView.text == "Enter the size in meter square" || textView.text == "Entrez la taille en mètre carré"  {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        if textView.text == "" {
            textView.text = Localize.currentLanguage() == "en" ? "Enter the size in meter square" : "Entrez la taille en mètre carré"
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        let txtAfterUpdate = textView.text! as NSString
        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: text) as NSString
       
//        return true
        
        let RISTRICTED_CHARACTERS = "*,=,+,[,],|,;,:,<,>,/,?,%,@,."
        let set = CharacterSet(charactersIn: RISTRICTED_CHARACTERS)
        let inverted = set.inverted
        let filtered = text.components(separatedBy: inverted).joined(separator: ",")
        
        if text == "" {
            if textView.tag ==  cellValue {
            if isprovider == true {
                let txtAfterUpdate = textView.text! as NSString
                let updateText = txtAfterUpdate.replacingCharacters(in: range, with: text) as NSString
                questionSetProviderArr![cellValue].array_answer = updateText as String
            }else{
                let txtAfterUpdate = textView.text! as NSString
                let updateText = txtAfterUpdate.replacingCharacters(in: range, with: text) as NSString
                questionSetUserArr![cellValue].array_answer = updateText as String
            }
           }
            return true
        }else{
            if isprovider == true {
                 let txtAfterUpdate = textView.text! as NSString
                 let updateText = txtAfterUpdate.replacingCharacters(in: range, with: text) as NSString
                 questionSetProviderArr![cellValue].array_answer = updateText as String
             }else{
                 let txtAfterUpdate = textView.text! as NSString
                 let updateText = txtAfterUpdate.replacingCharacters(in: range, with: text) as NSString
                 questionSetUserArr![cellValue].array_answer = updateText as String
             }
            }
            return filtered != text
        }
    
}



extension ServiceQuestionAnswerVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func selectUserImageAction() {
        
        let alert:UIAlertController=UIAlertController(title: nil , message: nil, preferredStyle: UIAlertController.Style.actionSheet)
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
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
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
        prescirptionImg.append(selectedImage)
        
        if let img = userSelectedImage {
            let data = img.jpegData(compressionQuality: 0)
            self.requestWith(endUrl: "", imageData: data)
        }
        dismiss(animated:true, completion: nil)
    }
    //MARK: PickerView Delegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("picker cancel.")
        dismiss(animated: true, completion: nil)
    }
}

extension ServiceQuestionAnswerVC {
    func requestWith(endUrl: String, imageData: Data?, onCompletion: ((Any?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        let url = "http://phoenixerrands.com/public/api/fileupload"
        let headers = ["Content-type": "multipart/form-data", "Accept": "application/json", "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!]
        self.addLoaderView()
        Alamofire.upload(multipartFormData: { (multipartFormData) in
           
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
                        guard let result = response.result.value else { return }
                        print("\(result)")
                        self.removeLoaderView()
                        self.questionAnswerTable.reloadData()
                        let resultDic = result as! Dictionary<String,Any>
                        if let status = resultDic["status"]{
                            if status as! Int == 200 {
                                let image = resultDic["image"] as! String
                                self.selectedServiceImage.append(image)
                            }else{
                                self.showAlertWithSingleButton(title: commonAlertTitle, message: "Profile update faild", okButtonText: okText, completion: nil)
                            }
                        }else{
                            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Profile update faild", okButtonText: okText, completion: nil)
                        }
                    }
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    onCompletion?(nil)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
}
