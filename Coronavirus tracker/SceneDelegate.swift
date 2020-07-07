//
//  SceneDelegate.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 28/02/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import UIKit



class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.window = self.window ?? UIWindow()
        
        settingTabBarAndNetworking()
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    
    private func settingTabBarAndNetworking() {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        
                // setup tab bar controller appearance
                tabBarController.tabBar.tintColor = K.Colors.red
                tabBarController.tabBar.barTintColor = .black
                tabBarController.showSpinner(onView: tabBarController.view)
      

                let resources = Resource<StatisticsData>(for: .all)
               
                StatisticsManager().loadStats(resources: resources) {  (result) in
                         switch result {
                         case .failure(let error):
                             print(error)
                             DispatchQueue.main.async {
                                tabBarController.createYesNoAlert(title: "Network problem", message: "Please refresh the connection") {
                                    self.settingTabBarAndNetworking()
                                }
                             }
                             
                         case .success(let data):
                             DispatchQueue.main.async {
                                let stateController = StateController()
                                stateController.statisticsListViewModel.populateListViewModels(with: data)
         
                                 for childVC in tabBarController.viewControllers ?? [] {
                                           if let vc = childVC as? StateControllerProtocol {
                                               print("State Controller Passed To:")
                                               vc.setState(state: stateController)
                                            tabBarController.removeSpinner()
                                           }
                                       }
                             }
                         }
                     }
                self.window!.rootViewController = tabBarController //Set the rootViewController to our modified version with the StateController instances
                self.window!.makeKeyAndVisible()
    }
    
  
    
  
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

