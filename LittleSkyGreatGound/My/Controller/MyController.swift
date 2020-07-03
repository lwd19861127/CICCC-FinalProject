//
//  MyController.swift
//  LittleSkyGreatGound
//
//  Created by WendaLi on 2020-06-29.
//  Copyright © 2020 WendaLi. All rights reserved.
//

import Foundation
import Amplify

protocol MyControllerDelegate: class {
  func updateUI(forIsSignedInStatus isSignedIn: Bool, withUserName userName: String)
}

class MyController {
    
    static let defaultUserName = "Press to Login"
    weak var delegate: MyControllerDelegate?
    
    var user: User?
    var authSession = AuthSession()

    static let shared = MyController()
    
    init(){}
    
    func fetchCurrentAuthSession() {
        _ = Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                if session.isSignedIn {
                    self.getCurrentUser()
                }else {
                    self.updateSignStatusAndMyViewUI(forIsSignedInStatus: false, withUserName: MyController.defaultUserName)
                }
                print("Is user signed in - \(session.isSignedIn)")
            case .failure(let error):
                self.updateSignStatusAndMyViewUI(forIsSignedInStatus: false, withUserName: MyController.defaultUserName)
                print("Fetch session failed with error \(error)")
            }
        }
    }
    
    func signInWithWebUI() {
        _ = Amplify.Auth.signInWithWebUI(presentationAnchor: UIApplication.shared.windows.first!) { result in
            switch result {
            case .success(_):
                self.getCurrentUser()
                print("Sign in succeeded")
            case .failure(let error):
                self.fetchCurrentAuthSession()
                print("Sign in failed \(error)")
            }
        }
    }
    
    func signOut() {
        user = nil
        let options = AuthSignOutRequest.Options(globalSignOut: true)
        _ = Amplify.Auth.signOut(options: options) { result in
            switch result {
            case .success:
                print("Successfully signed out")
            case .failure(let error):
                print("Sign out failed with error \(error)")
            }
            self.updateSignStatusAndMyViewUI(forIsSignedInStatus: false, withUserName: MyController.defaultUserName)
        }
    }
    
    func listenSignInAndOut() {
        _ = Amplify.Hub.listen(to: .auth) { (payload) in
            switch payload.eventName {
//            case HubPayload.EventName.Auth.signedIn:
//                print("==HUB== User signed In, update UI")
//                // if you want to get user attributes
//                self.getCurrentUser()
//            case HubPayload.EventName.Auth.signedOut:
//                self.updateAuthSessionIsSignedIn(forIsSignedInStatus: false)
//                print("==HUB== User signed Out, update UI")
            case HubPayload.EventName.Auth.sessionExpired:
                self.updateSignStatusAndMyViewUI(forIsSignedInStatus: false, withUserName: MyController.defaultUserName)
                print("==HUB== Session expired, show sign in aui")
            default:
                //print("==HUB== \(payload)")
                break
            }
        }
    }

    func getCurrentUser() {
        guard let user = Amplify.Auth.getCurrentUser() else {
            self.updateSignStatusAndMyViewUI(forIsSignedInStatus: false, withUserName: MyController.defaultUserName)
            print("Could not get user, perhaps the user is not signed in")
            return
        }
        self.user = User(id: user.userId, userName: user.username)
        self.updateSignStatusAndMyViewUI(forIsSignedInStatus: true, withUserName: user.username)
        fetchAttributes()
    }
    
    func updateSignStatusAndMyViewUI(forIsSignedInStatus isSignedIn: Bool, withUserName userName: String) {
        DispatchQueue.main.async() {
            self.authSession.isSignedIn = isSignedIn
            self.delegate?.updateUI(forIsSignedInStatus: isSignedIn, withUserName: userName)
        }
    }
    
    func fetchAttributes() {
        _ = Amplify.Auth.fetchUserAttributes() { result in
                switch result {
                case .success(let attributes):
                    for attribute in attributes {
                        if attribute.key.rawValue == "email" {
                            self.user?.userEmail = attribute.value
                        }
                    }
                    print("User attributes - \(attributes)")
                case .failure(let error):
                    print("Fetching user attributes failed with error \(error)")
                }
        }
    }
}
