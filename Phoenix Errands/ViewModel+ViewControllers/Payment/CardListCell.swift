//
//  CardListCell.swift
//  Sihatku
//
//  Created by Samir Samanta on 12/04/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
protocol cardActiveInActiveDelegate {
    func cardInActiveActive(index : Int)
}
class CardListCell: UICollectionViewCell {
    
    @IBOutlet weak var btnDesable: UIButton!
    @IBOutlet weak var desableImgView: UIImageView!
    
    @IBOutlet weak var lblCardHolderNAme: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblExpireDate: UILabel!
    @IBOutlet weak var ebaleDesableView: UIView!
    var delegate : cardActiveInActiveDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initializeCellDetails(cellDic : UserCardList){
        lblCardHolderNAme.text = UserDefaults.standard.string(forKey: PreferencesKeys.userFirstName)! + " " + UserDefaults.standard.string(forKey: PreferencesKeys.userLastName)!
        lblCardNumber.text = "XXXX XXXX XXXX " + cellDic.last4!
        let expMonth = cellDic.exp_month
        let expYr = cellDic.exp_year
        lblExpireDate.text = "\(expMonth!) / \(expYr!)"

    }
    
    func setStringAsCardNumberWithSartNumber(Number:Int,withString str:String ,withStrLenght len:Int ) -> String{
        let arr = str
        var CrediteCard : String = ""
        if arr.count > (Number + len) {
            for (index, element ) in arr.enumerated() {
                if index >= Number && index < (Number + len) {
                    CrediteCard = CrediteCard + String("X")
                }else{
                    CrediteCard = CrediteCard + String(element)
                }
            }
          return CrediteCard
        }else{
                print("\(Number) plus \(len) are grether than strings chatarter \(arr.count)")
        }
        print("\(CrediteCard)")
        return str
    }
    @IBAction func btnDesableAction(_ sender: Any) {
        delegate?.cardInActiveActive(index: (sender as AnyObject).tag)
    }
}
