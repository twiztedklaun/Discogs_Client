//
//  SaveUserInformationService.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 23/12/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit
import OAuthSwift
import SwiftyJSON

extension UserProfile {
func uploadUserData() {
    let oauth = OAuthSwiftClient(consumerKey: NewSearchService.key, consumerSecret: NewSearchService.secret, oauthToken: AuthorizeService.token, oauthTokenSecret: AuthorizeService.tokenSecret, version: OAuthSwiftCredential.Version.oauth1)

    let parameters: [String:Any] = [
        "username": self.username!,
        "name": self.name!,
        "home_page": self.homePage!,
        "location": self.location!,
        "profile": self.profileText!,
        "curr_abbr": self.currency!
    ]
    
    oauth.post(NewSearchService.baseURL + "users/\(String(describing: self.username!))", parameters: parameters, headers: ["Accept": "application/json", "Content-Type":"application/json"], success: { (successResponse) in
        print(successResponse)
    }) { (errorResponse) in
        print(errorResponse)
    }
    }
}
