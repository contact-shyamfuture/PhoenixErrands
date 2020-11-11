//
//  UIKitExtensions.swift
//
//
//  Created by   05/10/18.
//  Copyright © 2018 iOS Dev. All rights reserved.
//
import Foundation
import UIKit
import AVFoundation

extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension UIViewController {
    func showAlertWithSingleButton(title: String, message: String, okButtonText: String, completion: CompletionHandler?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: okButtonText, style: .default) { (action) in
            completion?()
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithDoubleButtons(title: String, message: String, okButtonText: String, cancelButtonText: String, completion: CompletionHandler?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelButtonText, style: .default) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: okButtonText, style: .default) { (action) in
            completion?()
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func showLeftSideBarView(letftBarView: UIView) {
        
        UIView.animate(withDuration: 0.5, animations: {
            letftBarView.frame = CGRect(x: 0, y: letftBarView.frame.origin.y, width: letftBarView.frame.size.width, height: letftBarView.frame.size.height)
            self.view.alpha = 0.5
        }) { (finished) in
            
        }
    }
    
    func hideLeftSideBarView(letftBarView: UIView) {
        
        UIView.animate(withDuration: 0.5, animations: {
            letftBarView.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: letftBarView.frame.origin.y, width: letftBarView.frame.size.width, height: letftBarView.frame.size.height)
            self.view.alpha = 1.0
        }) { (finished) in
            letftBarView.removeFromSuperview()
        }
    }
    
    func addLoaderView() {
        self.view.showCustomLoader()
    }
    
    func removeLoaderView() {
        self.view.removeCustomLoader()
    }
    
    func showNetworkNotReachableWarningMessage() {
        // self.showAlertWithSingleButton(title: warningAlertTitle, message: alertNetworkNotRechableMessage, okButtonText: okText, completion: nil)
    }
    
    
    
    // Monitor for network connection status
    func enableNetworkMonitoringStatus(completion: NetworkObserverCompletionHandler?) {
        //        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
//        let status = self.getNetworkStatus()
        NotificationCenter.default.addObserver(forName: .flagsChanged, object: Network.reachability, queue: nil) { (notification) in
            let status = self.getNetworkStatus()
            completion?(status)
        }
    }
    
    func getNetworkStatus() -> Network.Status {
        guard let status = Network.reachability?.status else { return Network.Status.unreachable }
        switch status {
        case .unreachable:
            showNetworkNotReachableWarningMessage()
            break
        case .wifi:
            break
        case .wwan:
            break
        }
        return status
    }
    //
    //
    //    @objc func statusManager(_ notification: NSNotification) {
    //        updateUserInterface()
    //    }
    
    func disableNetworkMonitor() {
        NotificationCenter.default.removeObserver(self, name: .flagsChanged, object: nil)
    }

}
extension UIImage {
    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        return gif(data: imageData)
    }
}

extension UIView {
    func rounded(with radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func hideViewWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc func dismiss() {
        self.removeFromSuperview()
    }
    
    func showCustomLoader() {
        let loaderView = CustomLoaderView.instanceFromNib()
        loaderView.initialize()
        if let window = UIApplication.shared.keyWindow {
            loaderView.frame = window.frame
            loaderView.center = window.center
            if window.subviews[window.subviews.count - 1].isKind(of: CustomLoaderView.self) {
                window.subviews[window.subviews.count - 1].removeFromSuperview()
                window.addSubview(loaderView)
            } else {
                window.addSubview(loaderView)
            }
        }
    }
    
    func removeCustomLoader() {
        if let subViews = self.window?.subviews {
            for subview in subViews {
                if subview is CustomLoaderView, let loaderView = subview as? CustomLoaderView {
                    loaderView.removeFromSuperview()
                    return
                }
            }
        }
    }
    
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc open func keyboardWillShow(_ notification: Notification) {}
    
    @objc open func keyboardWillHide(_ notification: Notification) {}
    
    func unRegisterKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension UIButton {
    func addRightBorder(borderColor: UIColor, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        border.frame = CGRect(x: self.frame.size.width,y: 0, width:borderWidth, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
}

extension UITextField {
    func setTextBorder(broderColor: UIColor) {
        self.layer.masksToBounds = true
        self.layer.borderColor = broderColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 2
    }
}

extension UILabel {
    func addUnderline(textRange: NSRange = NSMakeRange(0, 0), _ font: UIFont? = UIFont(name: "Roboto-Regular", size: 14.0), _ textColor: UIColor?) {
        guard let text = text else { return }
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
        if let textFont = font {
            attributedText.addAttribute(NSAttributedString.Key.font, value: textFont, range: textRange)
        }
        
        if let textColor = textColor {
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: textRange)
        }
        
        // Add other attributes if needed
        self.attributedText = attributedText
    }
}

extension UITextView: UITextViewDelegate {
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}

extension UIColor {
    static let customRed = UIColor.init(red: 143, green: 0, blue: 0, alpha: 1)
    static let customGreen = UIColor.init(red: 118.0/255.0, green: 204.0/255.0, blue: 32.0/255.0, alpha: 1.0)
    static let customYellow = UIColor.init(red: 225.0/255.0, green: 145.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}




