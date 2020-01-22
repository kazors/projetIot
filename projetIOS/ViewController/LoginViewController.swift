//
//  LoginViewController.swift
//  projetIOS
//
//  Created by etudiant on 22/01/2020.
//  Copyright © 2020 etudiant. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        Analytics.logEvent(AnalyticsEventViewItem, parameters: [
        AnalyticsParameterContentType: "text",
        AnalyticsParameterItemID: "Page de login"
        ])

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        

        // Do any additional setup after loading the view.
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    

    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
      withError error: NSError!) {
        if (error == nil) {
          // Perform any operations on signed in user here.
          // ...
        } else {
          print("\(error.localizedDescription)")
        }
    }
    
    func application(application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "95448986677-fb91mdlk4fm2vmlin53k59j8n07c9k3m.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self  // If AppDelegate conforms to GIDSignInDelegate
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController :GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
      if let error = error {
        // ...
        return
      }

      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if let error = error {
          print("NON")
          return
        }else{
        print("OUI")
        self.performSegue(withIdentifier: "ConnectSegue", sender: nil)
        }
      }
    

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
}
}
