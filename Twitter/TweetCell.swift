//
//  TweetCell.swift
//  Twitter
//
//  Created by Mina Sedhom on 9/26/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    @IBAction func handleRetweetButton(_ sender: Any) {
        let toBeRetweeted = !retweeted
        if(toBeRetweeted) {
            TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
                self.setRetweete(true)
                print("\(self.tweetId): has retweeted!")
            }, failure: { (error) in
                print("Retweet did not succeed: \(error)")
            })
        } else {
            TwitterAPICaller.client?.unRetweet(tweetId: tweetId, success: {
                self.setRetweete(false)
                print("\(self.tweetId): has unretweeded!")
            }, failure: { (error) in
                print("UnRetweet did not succeed: \(error)")

            })
        }
    }
    
    @IBAction func handleFavButton(_ sender: Any) {
        let toBeFavorited = !favorited
        if(toBeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
                print("\(self.tweetId): added to favorites!")
            }, failure: { (error) in
                print("Favorite did not succeed: \(error)")
            })
        } else {
            TwitterAPICaller.client?.unFavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false)
                print("\(self.tweetId): removed from favorites!")
            }, failure: { (error) in
                print("UnFavorite did not succeed: \(error)")

            })
        }
    }
    
    var favorited: Bool = false
    var tweetId: Int = -1
    var retweeted: Bool = false
    
    func setFavorite(_ isFavorited: Bool) {
        favorited = isFavorited
        if (favorited) {
            favButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        } else {
            favButton.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
    }
    
    
    func setRetweete(_ isRetweeted: Bool) {
        retweeted = isRetweeted
        if (retweeted) {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
