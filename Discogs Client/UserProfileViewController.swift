//
//  UserProfileViewController.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 23/10/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit
import OAuthSwift
import SwiftyJSON
import AlamofireImage

class UserProfileViewController: UIViewController {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var aboutMeLabel: UILabel!
    @IBOutlet weak var aboutMeTextField: UITextView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var rankNumberLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var homepageTextField: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var sellerRatingLabel: UILabel!
    @IBOutlet weak var sellerRatingNumberLabel: UILabel!
    @IBOutlet weak var buyerRatingLabel: UILabel!
    @IBOutlet weak var buyerRatingNumberRating: UILabel!
    
    var profile: UserProfile?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let oauth = OAuthSwiftClient(consumerKey: NewSearchService.key, consumerSecret: NewSearchService.secret, oauthToken: AuthorizeService.token, oauthTokenSecret: AuthorizeService.tokenSecret, version: OAuthSwiftCredential.Version.oauth1)
        oauth.get("https://api.discogs.com/users/twizted_klaun", success: { (response) in
            guard let dataString = response.string else { return }
            self.profile = UserProfile(json: JSON.init(parseJSON: dataString))
            guard let imageURL = URL(string: (self.profile?.avatar)!) else { return }
            self.avatarImage.af_setImage(withURL: imageURL)
        }) { (error) in
            print(error)
        }
        
        
        
    }
    


}
