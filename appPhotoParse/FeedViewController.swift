//
//  FeedViewController.swift
//  appPhotoParse
//
//  Created by MacBook Pro on 1.02.2024.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var postQueue = [Post]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
    }

    @objc func getData(){
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground{(objects, error) in
            if error != nil {
                self.errorMessage(title: "Error", message: error!.localizedDescription)
            }else {
                if objects != nil {
                    if objects!.count > 0 {
                        self.postQueue.removeAll(keepingCapacity: false)
                        
                        for object in objects! {
                            if let userName = object.object(forKey: "postUser") as? String {
                                if let userComment = object.object(forKey: "postComment") as? String {
                                    if let userImage = object.object(forKey: "postImage") as? PFFileObject{
                                        let post = Post(username: userName, userComment: userComment, userImage: userImage)
                                        self.postQueue.append(post)
                                    }
                                }
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newPost"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postQueue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedTableViewCell
        cell.usernameLabel.text = postQueue[indexPath.row].username
        cell.commentLabel.text = postQueue[indexPath.row].userComment
        postQueue[indexPath.row].userImage.getDataInBackground{(data, error) in
            if error == nil {
                if let data = data {
                    cell.postImage.image = UIImage(data: data)
                }
            }
        }
        return cell
    }
    
    func errorMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title:"OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
}
