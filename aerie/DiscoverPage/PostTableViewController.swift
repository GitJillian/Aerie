//
//  TableOfPostTableViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/19.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import UIKit
protocol TableOfPostViewControllerDelegate: AnyObject{
    func tableOfPostViewController(_ vc: PostTableViewController, didSelectLocationWith post: Post?)
}
class PostTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    weak var delegate: TableOfPostViewControllerDelegate?
    var postArray = [Post]()
    var postOperation = PostOperation()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate   = self
        tableView.dataSource = self
        self.hideKeyboardWhenTappedElseWhere()
        loadDataToPostTable()
        checkUpdatedPosts()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postArray.count
    }
    
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let postCell = self.postArray[indexPath.row]
        
        cell.textLabel?.text = "\(postCell.pid)"
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = .secondarySystemBackground
        cell.contentView.backgroundColor = .secondarySystemBackground
        cell.textLabel?.textColor = UIColor(named: "hintText")

        // Configure the cell...

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        let post = postArray[indexPath.row]
        delegate?.tableOfPostViewController(self, didSelectLocationWith: post)
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func loadDataToPostTable(){
        postOperation.getAllPosts(){listOfPost in
            //getting a list of posts and load them to table view
            self.postArray = listOfPost
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func checkUpdatedPosts(){
        postOperation.getPostUpdates{querySnapShots in
            querySnapShots.documentChanges.forEach{
                diff in
                
                let pid = diff.document.data()[Constants.postFields.pidField]
                if diff.type == .added{
                    self.postArray.append(Post(dictionary:diff.document.data())!)
                    
                }
                else if diff.type == .removed{
                    
                    if let index: Int = self.postArray.firstIndex(where: { $0.pid == pid as! String }){
                        self.postArray.remove(at: index)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
