//
//  TweetViewController.swift
//  Twitter
//
//  Created by Mina Sedhom on 9/29/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit


protocol TweetDelegate {
    func relaodTweets()
}

class TweetViewController: UIViewController, UITextViewDelegate {
    
//    var delegate: TweetDelegate?
//    var reloadTweetsAfterDismiss: (()->())?

    let maxLength = 280
    
    func textViewDidChange(_ textView: UITextView) {
        charCountLabel.text = "\(maxLength - textView.text.count)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= maxLength
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear called.....")
        if let homeVC = presentingViewController as? HomeTableViewController {
            DispatchQueue.main.async {
                homeVC.loadTweetsList()
                homeVC.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tweetTextField: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweet(_ sender: Any) {
        if (!tweetTextField.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextField.text, success: {
                // Create new Alert
                           let dialogMessage = UIAlertController(title: "Yaaay!", message: "Your tweet has been posted.", preferredStyle: .alert)
                           // Create OK button with action handler
                           let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                self.dismiss(animated: true, completion: nil)
                            })
                           //Add OK button to a dialog message
                            //self.delegate?.relaodTweets()
                           dialogMessage.addAction(ok)
                           // Present Alert to
                           self.present(dialogMessage, animated: true, completion: nil)
            }, failure: { (error) in
                print("Error posting tweet \(error)")
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            // Create new Alert
            let dialogMessage = UIAlertController(title: "Alert", message: "Please enter some text first to tweet.", preferredStyle: .alert)
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
             })
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
            //self.dismiss(animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextField.delegate = self
        tweetTextField.becomeFirstResponder()
        tweetTextField.layer.borderWidth = 1
        tweetTextField.layer.cornerRadius = 10
        tweetTextField.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
}
