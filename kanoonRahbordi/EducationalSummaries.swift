//
//  EducationalSummaries.swift
//  kanoonRahbordi
//
//  Created by negar on 96/Tir/13 AP.
//  Copyright © 1396 negar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SummeriesCollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var nameOfTheTeacher: UILabel!
    @IBOutlet weak var pictureOfThePdf: UIImageView!

}
class EducationalSummaries: UIViewController {

    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    var summArr = [SummaryInfo]()
    var sumcrsid = Int()
    var sumsbjid = Int()
    var groupCode = Int()
    var subName = String()
    
    @IBOutlet weak var downButt: UIButton!
    @IBOutlet weak var summeryCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func downloadSummary (url : String? , completionHandler : @escaping (SummaryInfo? , Error?) -> ()){
        var sumInfo = SummaryInfo()
        if let urlstr = url{
            Alamofire.request(urlstr).responseJSON{
                response in
                switch response.result{
                case . success(let value):
                    let jsonresponse = JSON(value)
                    if let jsonArray = jsonresponse.array{
                        for summaries in jsonArray{
                            sumInfo.LessonSummaryTitle = summaries["LessonSummaryTitle"].string!
                            sumInfo.ProfileId = summaries["ProfileId"].int!
                            sumInfo.Rid = summaries["Rid"].int!
                            sumInfo.SumObjId = summaries["SumObjId"].int!
                            sumInfo.TeacherName = summaries["TeacherName"].string!
                            completionHandler(sumInfo , nil)
                        }
                    }
                case .failure(let error):
                    completionHandler(nil, error)
                }
            }
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
