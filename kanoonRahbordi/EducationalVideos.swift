//
//  EducationalVideos.swift
//  kanoonRahbordi
//
//  Created by negar on 96/Tir/13 AP.
//  Copyright © 1396 negar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PINRemoteImage
import AVKit
import AVFoundation
//import MediaPlayer

class MoviesCollectionViewCell : UICollectionViewCell{

    @IBOutlet weak var tickImg: UIImageView!
    @IBOutlet weak var tikImage: UIImageView!
    @IBOutlet weak var NameOfTheLabes: UILabel!
    @IBOutlet weak var pictureOfTheTeacher: UIImageView!
    
}
class CollectionHeader: UICollectionReusableView{
    @IBOutlet weak var headerLabel: UILabel!
    
}
class EducationalVideos: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

    @IBOutlet weak var playButt: UIButton!
    @IBOutlet weak var favButt: UIButton!
    @IBOutlet weak var downButt: UIButton!
    @IBOutlet weak var moviesCollection: UICollectionView!
    
    var moviesInfo = [MoviesDara]()
    var sumcrsid = Int()
    var sumsbjid = Int()
    var groupCode = Int()
    var subName = String()
    var pageindex : Int = 1
    var currentIndexPath = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "http://www.kanoon.ir/Amoozesh/api/Document/GetVideoNbA?groupcode=\(groupCode)&sumcrsid=\(sumcrsid)&sumsbjid=\(sumsbjid)&pageindex=\(pageindex)&pagesize=9"
        downloadfilms(url: url){
            moviesinfo , error in
            if moviesinfo != nil {
                self.moviesInfo.append(moviesinfo!)
                self.moviesCollection.reloadData()
            }
            
            else {
                    self.downButt.titleLabel?.text = "تلاش مجدد"
            }
        }
        self.view.backgroundColor =  UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)

        downButt.fullyRound(diameter: 10, borderColor: UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0), borderWidth: 1)
        downButt.backgroundColor = UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0)
        moviesCollection?.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        
        favButt.isHidden = true
        playButt.isHidden = true
        
        favButt.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
        playButt.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        
        
        self.automaticallyAdjustsScrollViewInsets = false;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        switch kind {
        //2
        case UICollectionElementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionHeader", for: indexPath) as! CollectionHeader
            
            headerView.headerLabel.text = subName
            headerView.headerLabel.textColor = UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0)
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        if downButt.titleLabel?.text == "تلاش مجدد"
        {
            self.viewDidLoad()
        }
        else if downButt.titleLabel?.text == "افزودن علاقه مندی"
        {
        
        }
        else if downButt.titleLabel?.text == "بروز رسانی لیست"
        {
            moviesInfo=[]
            pageindex += 1
            self.viewDidLoad()
        }
    }
    
    @IBAction func playButt(_ sender: Any) {
        let link = moviesInfo[currentIndexPath].M3u8Address
        guard let url = URL(string: link) else {
            return
        }
        let player = AVPlayer(url: url)
        
        let controller = AVPlayerViewController()
        controller.player = player
        
        present(controller, animated: true) {
            player.play()
        }
    }
    
    @IBAction func favButt(_ sender: Any) {
    }
    
    func downloadfilms (url : String? , completionHandler : @escaping (MoviesDara? , Error?) -> ()){
        if let urlstr = url{
            Alamofire.request(urlstr).responseJSON{
                response in
                switch response.result{
                case . success(let value):
                    let jsonresponse = JSON(value)
                    if let jsonArray = jsonresponse.array{
                        for movies in jsonArray{
                            let moviesinfo = MoviesDara()
                            moviesinfo.DocumentId = movies["DocumentId"].int!
                            moviesinfo.FileTitle = movies["FileTitle"].string!
                            moviesinfo.M3u8Address = movies["M3u8Address"].string!
                            moviesinfo.TeacherId = movies["TeacherId"].int!
                            moviesinfo.TeacherName = movies["TeacherName"].string!
                            moviesinfo.TeacherPicture = movies["TeacherPicture"].string!
                            completionHandler(moviesinfo , nil)
                        }
                    }
                case .failure(let error):
                    completionHandler(nil, error)
                }
            }
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesInfo.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vidoesCell", for: indexPath) as! MoviesCollectionViewCell
        
        cell.NameOfTheLabes?.text = moviesInfo[indexPath.row].TeacherName
        cell.tikImage?.image = #imageLiteral(resourceName: "blueArrow")
        
        let imageUrl = moviesInfo[indexPath.row].TeacherPicture
        
        cell.pictureOfTheTeacher?.pin_setImage(from: URL(string: imageUrl), completion: { (result) in
        })
        
        let outsideColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1.0)
        let insideColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0)
        
        cell.backgroundColor = insideColor
        cell.fullyRound(diameter: 10, borderColor: outsideColor, borderWidth: 1)
        
        cell.tickImg.image=#imageLiteral(resourceName: "checked")
        cell.tickImg.alpha = 0.5
        cell.tickImg.isHidden=true
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
                let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = moviesCollection.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.playButt.isHidden = false
        self.favButt.isHidden = false
        
        currentIndexPath=indexPath.row
        let cell1 = collectionView.cellForItem(at: indexPath)
        let cell : MoviesCollectionViewCell = cell1 as! MoviesCollectionViewCell
        cell.fullyRound(diameter: 10, borderColor: UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0), borderWidth: 3)
        
    }

    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell1 = collectionView.cellForItem(at: indexPath)
        let cell : MoviesCollectionViewCell = cell1 as! MoviesCollectionViewCell
        cell.fullyRound(diameter: 10, borderColor: UIColor.gray, borderWidth: 0)
        cell.tickImg.isHidden=false
    }
}
