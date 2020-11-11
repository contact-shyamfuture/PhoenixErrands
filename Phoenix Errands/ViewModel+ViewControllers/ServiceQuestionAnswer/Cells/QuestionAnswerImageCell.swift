//
//  QuestionAnswerImageCell.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 06/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit

protocol PrescriptionImageProtocal {
    func AddPrescriptionImage(indexPath : Int)
    func removePrescriptionImage(indexPath : Int)
}

class QuestionAnswerImageCell: UITableViewCell , UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, AddPrescriptionImageProtocal{

    @IBOutlet weak var imageCollection: UICollectionView!
    var prescriptionImage : PrescriptionImageProtocal?
    var prescirptionImg = [UIImage]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageCollection.delegate = self
        self.imageCollection.dataSource = self
        self.imageCollection.reloadData()
    }
    func captureImage(indexPath : Int){
        self.prescriptionImage?.AddPrescriptionImage(indexPath: indexPath)
    }
    func removeImage(indexPath : Int){
        self.prescriptionImage?.removePrescriptionImage(indexPath: indexPath)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        if prescirptionImg != nil && self.prescirptionImg.count > 0 {
            return self.prescirptionImg.count + 1
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath as IndexPath) as! ImageCollectionCell
        cell.addImageButtonAOutlet.tag = indexPath.row
        cell.addImageDelegate = self
        if indexPath.row == 0 {
            cell.btnPrescriptionImageOutlet.isHidden = true
            cell.imageAdd.isHidden = false
            cell.imageDocFile.image = UIImage(named: "")
        }else{
            cell.btnPrescriptionImageOutlet.tag = indexPath.row - 1
            cell.btnPrescriptionImageOutlet.isHidden = false
            cell.imageAdd.isHidden = true
            cell.imageDocFile.image = prescirptionImg[indexPath.row - 1]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = 85//(collectionView.frame.width - (10 + 10))/2 //150
        let height: CGFloat = 100
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }else{
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }else{
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 20)
    }
    
}

