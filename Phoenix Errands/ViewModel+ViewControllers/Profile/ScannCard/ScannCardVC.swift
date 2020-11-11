//
//  ScannCardVC.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 22/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import PayCardsRecognizer

class ScannCardVC: UIViewController
{
    var recognizer: PayCardsRecognizer!
    @IBOutlet weak var scanView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recognizer = PayCardsRecognizer(delegate: self, resultMode: .sync, container: self.scanView, frameColor: .green)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recognizer.startCamera()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        recognizer.stopCamera()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ScannCardVC: PayCardsRecognizerPlatformDelegate
{
    func payCardsRecognizer(_ payCardsRecognizer: PayCardsRecognizer, didRecognize result: PayCardsRecognizerResult){
        
        let number = result.recognizedNumber // Card number
        let cardHolderName = result.recognizedHolderName // Card holder
        let ExpDateMonth = result.recognizedExpireDateMonth // Expire month
        let ExpDateYear = result.recognizedExpireDateYear // Expire year
        print("number==\(String(describing: number))")
        print("cardHolderName==\(String(describing: cardHolderName))")
        print("ExpDateMonth==\(String(describing: ExpDateMonth))")
        print("ExpDateYear==\(String(describing: ExpDateYear))")
        self.navigationController?.popViewController(animated: true)
    }
}

