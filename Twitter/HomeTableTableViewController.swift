//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Mina Sedhom on 9/25/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeTableTableViewController: UITableViewController {
    
    var tweetsList = [[String: Any?]]()
    var numberOfTweets: Int!
    let myRefreshControl = UIRefreshControl()
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

            loadTweetsList()
            myRefreshControl.addTarget(self, action: #selector(loadTweetsList), for: .valueChanged)
            tableView.refreshControl = myRefreshControl
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
                if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1135610715, green: 0.628205061, blue: 0.9471727014, alpha: 1)
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.1135610715, green: 0.628205061, blue: 0.9471727014, alpha: 1)
    }
    
    @objc func loadTweetsList() {
        
        numberOfTweets = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [[String: Any?]]) in
            self.tweetsList.removeAll()
            self.tweetsList.append(contentsOf: tweets)
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            //print(self.tweetsList)

        }, failure: { (error) in
            print("Could not retrive tweets :( . Error data: " + error.localizedDescription)
        })
        
    }
    
    func loadMoreTweets(){
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets += 20
        
        let myParams = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [[String: Any?]]) in
            self.tweetsList.removeAll()
            self.tweetsList.append(contentsOf: tweets)
            self.tableView.reloadData()

        }, failure: { (error) in
            print("Could not retrive tweets :( . Error data: " + error.localizedDescription)
        })
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        let tweet = tweetsList[indexPath.row]
        let user = tweet["user"] as! [String:Any?]

        cell.usernameLabel.text = user["name"] as? String
        cell.tweetContentLabel.text = tweet["text"] as? String
        
        if let profileImagePath = user["profile_image_url_https"] as? String {
            let profileImageUrl = URL(string: profileImagePath)
            cell.profileImageView.af.setImage(withURL: profileImageUrl!)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetsList.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetsList.count {
            loadMoreTweets()
        }
    }

}
