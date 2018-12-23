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
    @IBOutlet weak var saveButton: UIButton!
   
    func gatherAndUpdateProfile() {
        guard let username = usernameTextField.text else { return }
        guard let name = nameTextField.text else { return }
        guard let profileInfo = aboutMeTextField.text else { return }
        guard let location = locationTextField.text else { return }
        guard let homePage = homepageTextField.text else { return }
        guard let currency = currencyTextField.text else { return }
        
        profile?.username = username
        profile?.name = name
        profile?.profileText = profileInfo
        profile?.location = location
        profile?.homePage = homePage
        profile?.currency = currency
    }
    
    var profile: UserProfile? {
        didSet {
            guard let imageURL = URL(string: (self.profile?.avatar)!) else { return }
            self.avatarImage.af_setImage(withURL: imageURL)
            usernameTextField.text = profile?.username
            nameTextField.text = profile?.name
            aboutMeTextField.text = profile?.profileText
            locationTextField.text = profile?.location
            homepageTextField.text = profile?.homePage
            currencyTextField.text = profile?.currency
            buyerRatingNumberRating.text = String(describing: profile!.buyerRank!)
            sellerRatingNumberLabel.text = String(describing: profile!.sellerRank!)
            rankNumberLabel.text = String(describing: profile!.rank!)
        }
    }
    
    func getInformationFromEndpoint() {
        let oauth = OAuthSwiftClient(consumerKey: NewSearchService.key, consumerSecret: NewSearchService.secret, oauthToken: AuthorizeService.token, oauthTokenSecret: AuthorizeService.tokenSecret, version: OAuthSwiftCredential.Version.oauth1)
        oauth.get("https://api.discogs.com/users/twizted_klaun", success: { (response) in
            guard let dataString = response.string else { return }
            self.profile = UserProfile(json: JSON.init(parseJSON: dataString))
        }) { (error) in
            print(error)
        }
    }
    
    @IBAction func saveInformation(_ sender: Any) {
        gatherAndUpdateProfile()
        profile?.uploadUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInformationFromEndpoint()
    }

}
