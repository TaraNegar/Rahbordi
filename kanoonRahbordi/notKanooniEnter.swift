//
//  notKanooniEnter.swift
//  kanoonRahbordi
//
//  Created by negar on 96/Khordad/07 AP.
//  Copyright © 1396 negar. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class notKanooniEnter: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var backGround: UIImageView!
    @IBOutlet weak var userPhoneNum: UITextField!
    
    @IBOutlet weak var warning: UILabel!
    @IBOutlet weak var userReshtePicker: UIPickerView!
    var isLoggedIn: [NSManagedObject] = []

    var reshteSelect : Int = 0
    
    var courses =   ["چهارم ریاضی","چهارم تجربی","چهارم انسانی","هنر","منحصرا زبان","سوم ریاضی","سوم تجربی","سوم انسانى","دهم ریاضی","دهم تجربی","دهم انسانی","نهم","هشتم","هفتم","ششم دبستان","پنجم دبستان","چهارم دبستان","سوم دبستان","دوم دبستان","اول دبستان"]
    
    func pickvariew(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return courses[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return courses.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reshteSelect = row
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let googooliBlue = UIColor(red: 0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1.0)

        let attributedString = NSAttributedString(string: courses[row], attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 17.0),         NSForegroundColorAttributeName:googooliBlue])
        return attributedString
    }
    
    
    func pickerRowToGroupCode() -> Int {
        var groupCode = 0
        switch reshteSelect {
        case 0:
            groupCode = 1
        case 1:
            groupCode = 3
        case 2:
            groupCode = 5
        case 3:
            groupCode = 7
        case 4:
            groupCode = 9
        case 5:
            groupCode = 21
        case 6:
            groupCode = 22
        case 7:
            groupCode = 23
        case 8:
            groupCode = 24
        case 9:
            groupCode = 25
        case 10:
            groupCode = 26
        case 11:
            groupCode = 27
        case 12:
            groupCode = 31
        case 13:
            groupCode = 33
        case 14:
            groupCode = 35
        case 15:
            groupCode = 41
        case 16:
            groupCode = 43
        case 17:
            groupCode = 45
        case 18:
            groupCode = 46
        case 19:
            groupCode = 47
        default:
            groupCode = 0
        }
        
        return groupCode
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userReshtePicker.delegate = self
        userReshtePicker.dataSource = self
        backGround.image = #imageLiteral(resourceName: "notKanooniEnter")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadTags(phoneNumber: Int, gpCode: Int,completionHandler: @escaping (String? , Error?) -> ()) {
        Alamofire.request("http://www.kanoon.ir/Amoozesh/api/Document/SendActivationCode?m=\(phoneNumber)&g=\(gpCode)")
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let res: String = value as? String
                    {
                        completionHandler(res, nil)
                    }
                    
                case .failure(let error):
                    completionHandler(nil, error)
                }
        }
        
    }
    
    func getanswer(phoneNumber: Int, EnterCode: Int,completionHandler: @escaping (Int? , Error?) -> ()) {
        Alamofire.request("http://www.kanoon.ir/Amoozesh/api/Document/CheckActivationKey?m=\(phoneNumber)&key=\(EnterCode)")
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let res: Int = value as? Int
                    {
                        completionHandler(res, nil)
                    }
                    
                case .failure(let error):
                    completionHandler(nil, error)
                }
        }
        
    }
    
    @IBAction func notKanooniEnterButton(_ sender: UIButton) {
        guard let phones = userPhoneNum.text else{
            warning.text = "لطفا اطلاعات را کامل وارد کنید"
            return
            
        }
        
        
        var answers: String?
        
        if phones != "" {
            self.downloadTags(phoneNumber: Int(phones)!, gpCode:self.pickerRowToGroupCode()
            ){answer, error in
                answers = answer
                if answers == "ok"{
                    
                    let alertController = UIAlertController(title: "ورود کد", message: "", preferredStyle: .alert)
                    
                    let saveAction = UIAlertAction(title: "ارسال دوباره", style: .default, handler: {
                        alert -> Void in
                        
                        self.downloadTags(phoneNumber: Int(phones)!, gpCode: self.pickerRowToGroupCode()
                        ){answer, error in
                            answers = answer
                        }
                        self.present(alertController, animated: true, completion: nil)
                    })
                    
                    let cancelAction = UIAlertAction(title: "تایید", style: .default, handler: {
                        (action : UIAlertAction!) -> Void in
                        
                        let firstTextField = alertController.textFields![0] as UITextField
                        if firstTextField.text != ""{
                            self.getanswer(phoneNumber: Int(phones)!, EnterCode: Int(firstTextField.text!)!){ res , error in
                                if res == 1{
                                    guard let appDelegate =
                                        UIApplication.shared.delegate as? AppDelegate else {
                                            return
                                    }
                                    let managedContext =
                                        appDelegate.persistentContainer.viewContext
                                    
                                    // 2
                                    let entity =
                                        NSEntityDescription.entity(forEntityName: "Shomarande",
                                                                   in: managedContext)!
                                    
                                    let person = NSManagedObject(entity: entity,
                                                                 insertInto: managedContext)
                                    
                                    
                                    person.setValue(self.pickerRowToGroupCode(), forKeyPath: "shomare")
                                    
                                    // 4
                                    do {
                                        try managedContext.save()
                                        self.isLoggedIn.append(person)
                                        self.performSegue(withIdentifier: "notKanooniValidEnterSegue", sender: self)
                                    } catch let error as NSError {
                                        print("Could not save. \(error), \(error.userInfo)")
                                    }
                                    
                                }
                                    
                                else{
                                    
                                    self.warning.text = "کد ارسالی صحیح نیست"
                                }
                            }
                        }
                        
                    })
                    
                    alertController.addTextField { (textField : UITextField!) -> Void in
                        textField.placeholder = "کد ارسال شده را وارد کنید"
                    }
                    
                    alertController.addAction(saveAction)
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                else{
                    self.warning.text = "اطلاعات صحیح نیست"
                }
            }
            
        }
        else {
            warning.text = "لطفا اطلاعات را کامل وارد کنید"
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "notKanooniValidEnterSegue"{
            let viewset = segue.destination as! UITabBarController
            let mainview = viewset.viewControllers?[0] as! mainView
            mainview.groupCode = self.pickerRowToGroupCode()
        }
    }
}

/*
 New blood joins this earth,
 And quickly he's subdued.
 Through constant pained disgrace
 The young boy learns their rules.
 
 With time the child draws in.
 This whipping boy done wrong.
 Deprived of all his thoughts
 The young man struggles on and on he's known
 A vow unto his own,
 That never from this day
 His will they'll take away.
 
 What I've felt,
 What I've known
 Never shined through in what I've shown.
 Never be.
 Never see.
 Won't see what might have been.
 
 What I've felt,
 What I've known
 Never shined through in what I've shown.
 Never free.
 Never me.
 So I dub thee unforgiven.
 
 They dedicate their lives
 To running all of his.
 He tries to please them all –
 This bitter man he is.
 
 Throughout his life the same –
 He's battled constantly.
 This fight he cannot win –
 A tired man they see no longer cares.
 
 The old man then prepares
 To die regretfully –
 That old man here is me.
 
 What I've felt,
 What I've known
 Never shined through in what I've shown.
 Never be.
 Never see.
 Won't see what might have been.
 
 What I've felt,
 What I've known
 Never shined through in what I've shown.
 Never free.
 Never me.
 So I dub thee unforgiven.
 
 [Solo]
 
 What I've felt,
 What I've known
 Never shined through in what I've shown.
 Never be.
 Never see.
 Won't see what might have been.
 
 What I've felt,
 What I've known
 Never shined through in what I've shown.
 Never free.
 Never me.
 So I dub thee unforgiven.
 
 Never free.
 Never me.
 So I dub thee unforgiven.
 
 You labelled me,
 I'll label you.
 So I dub thee unforgiven.
 
 Never free.
 Never me.
 So I dub thee unforgiven.
 
 You labelled me,
 I'll label you.
 So I dub thee unforgiven.
 
 Never free.
 Never me.
 So I dub thee unforgiven.
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


