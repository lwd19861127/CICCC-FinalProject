//
//  AppDelegate.swift
//  LittleSkyGreatGound
//
//  Created by WendaLi on 2020-06-23.
//  Copyright © 2020 WendaLi. All rights reserved.
//

import UIKit
import Amplify
import AmplifyPlugins

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let apiPlugin = AWSAPIPlugin(modelRegistration: AmplifyModels())
        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
        do {
           try Amplify.add(plugin:apiPlugin)
           try Amplify.add(plugin:dataStorePlugin)
           try Amplify.add(plugin: AWSS3StoragePlugin())
           try Amplify.add(plugin: AWSCognitoAuthPlugin())
           try Amplify.configure()
            
           listenSignInAndOut()
            
           print("Initialized Amplify");
        } catch {
           print("Could not initialize Amplify: \(error)")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func listenSignInAndOut() {
        _ = Amplify.Hub.listen(to: .auth) { (payload) in

            switch payload.eventName {

            case HubPayload.EventName.Auth.signedIn:
                print("==HUB== User signed In, update UI")

                // if you want to get user attributes
                _ = Amplify.Auth.fetchUserAttributes() { (result) in
                    switch result {
                    case .success(let attributes):
                        print("User attribtues - \(attributes)")
                    case .failure(let error):
                        print("Fetching user attributes failed with error \(error)")
                    }
                }

            case HubPayload.EventName.Auth.signedOut:
                print("==HUB== User signed Out, update UI")
                
            case HubPayload.EventName.Auth.sessionExpired:
                print("==HUB== Session expired, show sign in aui")

            default:
                //print("==HUB== \(payload)")
                break
            }
        }

    }

}

