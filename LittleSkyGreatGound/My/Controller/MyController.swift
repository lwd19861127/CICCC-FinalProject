//
//  MyController.swift
//  LittleSkyGreatGound
//
//  Created by WendaLi on 2020-06-29.
//  Copyright © 2020 WendaLi. All rights reserved.
//

import Foundation
import Amplify

class MyController {
    
    var userData = UserData()
    var authSession = IsSignedIn()
    {
        didSet {
            NotificationCenter.default.post(name: MyController.userDataUpdatedNotification, object: nil)
        }
    }
    static let shared = MyController()
    static let userDataUpdatedNotification = Notification.Name("MyController.userDataUpdated")
    
    init(){}
    
    func fetchCurrentAuthSession() {
        _ = Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                self.fetchUserAttributes()
                print("Is user signed in - \(session.isSignedIn)")
            case .failure(let error):
                print("Fetch session failed with error \(error)")
            }
        }
    }
    
    func signInWithWebUI() {
        _ = Amplify.Auth.signInWithWebUI(presentationAnchor: UIApplication.shared.windows.first!) { result in
            switch result {
            case .success(_):
                print("Sign in succeeded")
            case .failure(let error):
                print("Sign in failed \(error)")
            }
        }
    }
    
    func signOut() {
        _ = Amplify.Auth.signOut() { result in
            switch result {
            case .success:
                print("Successfully signed out")
            case .failure(let error):
                print("Sign out failed with error \(error)")
            }
        }
    }
    
    func listenSignInAndOut() {
        _ = Amplify.Hub.listen(to: .auth) { (payload) in
            switch payload.eventName {
            case HubPayload.EventName.Auth.signedIn:
                print("==HUB== User signed In, update UI")
                // if you want to get user attributes
                self.fetchUserAttributes()
            case HubPayload.EventName.Auth.signedOut:
                self.authSession.isSignedIn = false
                print("==HUB== User signed Out, update UI")
            case HubPayload.EventName.Auth.sessionExpired:
                self.authSession.isSignedIn = false
                print("==HUB== Session expired, show sign in aui")
            default:
                //print("==HUB== \(payload)")
                break
            }
        }
    }

    func fetchUserAttributes() {
        _ = Amplify.Auth.fetchUserAttributes() { (result) in
            switch result {
            case .success(let attributes):
                for attribute in attributes {
                    if attribute.key.rawValue == "email" {
                        let email = attribute.value.split(separator: "@")
                        self.userData.userID = String(email[0])
                    }
                }
                self.authSession.isSignedIn = true
                print("User attribtues - \(attributes)")
            case .failure(let error):
                print("Fetching user attributes failed with error \(error)")
            }
        }
    }
}
