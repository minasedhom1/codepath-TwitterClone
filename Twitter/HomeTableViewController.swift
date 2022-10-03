//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Mina Sedhom on 9/25/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeTableViewController: UITableViewController {
    
    var tweetsList = [[String: Any?]]()
    var numberOfTweets: Int!
    let myRefreshControl = UIRefreshControl()
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func viewDidLoad() {  // get called once.
        super.viewDidLoad()
            myRefreshControl.addTarget(self, action: #selector(loadTweetsList), for: .valueChanged)
            tableView.refreshControl = myRefreshControl
            //loadTweetsList()
    }

    override func viewDidAppear(_ animated: Bool) {
        print("ViewDidApearCalled")
        loadTweetsList()
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
        //print(tweet)
        cell.usernameLabel.text = user["name"] as? String
        cell.tweetContentLabel.text = tweet["text"] as? String
        cell.timeLabel.text = tweetTime(createdAt: tweet["created_at"] as! String)

        if let profileImagePath = user["profile_image_url_https"] as? String {
            let profileImageUrl = URL(string: profileImagePath)
            cell.profileImageView.af.setImage(withURL: profileImageUrl!)
        }
        
        cell.tweetId = tweet["id"] as! Int
        cell.setFavorite(tweet["favorited"] as! Bool)
        cell.setRetweete(tweet["retweeted"] as! Bool)
        
        // Bonus - media
        //entities[] -> media[first] .
        let entities = tweet["entities"] as! [String:Any?]
        let media = entities["media"] as? [[String:Any?]] ?? []
        if media.count == 1 {
            print("mediaaaa:\(media.first!["media_url_https"] as! String)")
        }
        
        return cell
    }
    
    func tweetTime(createdAt: String)  -> String{
        let dateFormatter = DateFormatter()
         dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
         dateFormatter.dateFormat = "EEE MMM d HH:mm:ssz yyyy"  //Fri Sep 30 04:49:37 +0000 2022
         let date = dateFormatter.date(from:createdAt)!
        let today = Date()
        let diffComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date, to: today)
        
        let days = diffComponents.day
        let hours = diffComponents.hour
        let minutes = diffComponents.minute
        let seconds = diffComponents.second

        
        if (days! != 0) {
            return "\(days!)d"
        }
        else if (hours! != 0) {
            return "\(hours!)h"
        }
        
        else if (minutes! != 0) {
            return "\(minutes!)m"
        }
            
        else if (seconds! != 0) {
            return "\(seconds!)s"
        }
        else { return  "0s"}
        
         //return date as! String
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
//extension HomeTableViewController: TweetDelegate {
//    func relaodTweets() {
//        self.dismiss(animated: true) {
//            self.loadTweetsList()
//        }
//    }
//
//}
