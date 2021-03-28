//
//  TestTable.swift
//  aerie
//
//  Created by jillianli on 2021/3/28.
//  Copyright © 2021 Christopher Ching. All rights reserved.
//

import UIKit

class TestTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTest") as! ManagePostViewCell
        cell.textLabel?.text = "Testing"
        return cell
    }
    
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    
   // @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isScrollEnabled = true
        self.tableView.alwaysBounceVertical = true
        
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.hideKeyboardWhenTappedElseWhere()
        self.cellHeight?.constant = CGFloat(Double(50) * 111)
        // Do any additional setup after loading the view.
    }
    
    //return height of each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
