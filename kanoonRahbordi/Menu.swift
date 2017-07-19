//
//  Menu.swift
//  kanoonRahbordi
//
//  Created by negar on 96/Tir/20 AP.
//  Copyright © 1396 negar. All rights reserved.
//

import UIKit





class MenuTableCell: UITableViewCell {
    
    @IBOutlet weak var menuImg: UIImageView!
    @IBOutlet weak var menuLbl: UILabel!
}

class Menu: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuTable: UITableView!
    
    var menuTitles=["جستجوی دوستان","اشتراک گذاری","سایر محصولات","تغییرات اخیر","بروزرسانی برنامه","درباره ما","خروج"]
    
    var menuImages: [UIImage] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuImages.append(UIImage(named: "menuImage1.png")!)
        menuImages.append(UIImage(named: "menuImage2.png")!)
        menuImages.append(UIImage(named: "menuImage3.png")!)
        menuImages.append(UIImage(named: "menuImage4.png")!)
        menuImages.append(UIImage(named: "menuImage5.png")!)
        menuImages.append(UIImage(named: "menuImage6.png")!)

        self.menuTable.separatorStyle = .none
        
        menuTable.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableCell
        cell.menuLbl.text = menuTitles[indexPath.row]
        cell.menuImg.image = menuImages[indexPath.row]
        

        return cell
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
