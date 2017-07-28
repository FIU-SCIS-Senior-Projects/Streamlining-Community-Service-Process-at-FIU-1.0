//
//  UserDBHandler.swift
//  FIUGives
//
//  Created by Kathryn Bello on 7/13/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import Firebase

class UserDBHandler {
    static let sharedInstance = UserDBHandler()
    
    //MARK: Properties
    var userUID = String()
    var currentUser = User.sharedInstance
    var rootRef = Database.database().reference()
    var handle: AuthStateDidChangeListenerHandle? = nil
    
    class func getUserPublicProfileFor(userUDID:String?,completion:@escaping UserProfileCallback){
        
        guard userUDID != nil || userUDID == "" else{
            completion(nil)
            return
        }
        
        let userRef = FirebaseUserRef.child(userUDID!)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            guard (snapshot.value as? NSDictionary) != nil else{
                completion(nil)
                return
            }
            completion(snapshot.value as? NSDictionary)
            
        }) { (error) in
            print(error.localizedDescription)
            completion(nil)
            
        }
        
    }
    
    // Login user.
    func signIn(userEmail: String, userPassword: String) {
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                print("Successful Login")
            }
        }
    }

    
    // Create user with email.
    func createUser(userEmail: String, userPassword: String) {
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { (user, error) in
                if let error = error {
                        print(error.localizedDescription)
                        return
                } else {
                    print("Successful Login")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Main")
                    self.present(vc!, animated: true, completion: nil)
            }
        }
    }
    
    func setUserProfile(UDID:String, name:String, generalLocation:String, profileURL:String){
        
        FirebaseUserRef.child(UDID).child(FirebaseUserKey_name).setValue(name)
        FirebaseUserRef.child(UDID).child(FirebaseUserKey_generalLocation).setValue(generalLocation)
        FirebaseUserRef.child(UDID).child(FirebaseUserKey_thumbnail_URL).setValue(profileURL)
        self.getCurrentUser()
    }
    
    func logoutUser() {
        try! Auth.auth().signOut()
    }
    
    private func getCurrentUser(){
        guard FIRAuth.auth()?.currentUser != nil else{
            return
        }
        
        FirebaseUserRef.child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? NSDictionary else{
                self.firebaseProfileDelegate?.failedToLoadUserProfile?()
                return
            }
            if FirebaseUserHandler.currentUserDictionary == nil{
                FirebaseUserHandler.currentUserDictionary = userDictionary
                NotificationCenter.default.post(name: Notification.Name(rawValue: loggedInNotificationKey), object: self)
            }else{
                FirebaseUserHandler.currentUserDictionary = userDictionary
            }
            FirebaseUserHandler.currentUserObject = FirebaseObjectConverter.dictionaryToUserObject(dictionary: userDictionary, UDID: (FIRAuth.auth()?.currentUser?.uid)!)
            FirebaseUserHandler.currentUDID = (FIRAuth.auth()?.currentUser?.uid)!
            self.firebaseProfileDelegate?.didLoadUserProfile?()
            
        }) { (error) in
            print(error.localizedDescription)
            self.firebaseProfileDelegate?.failedToLoadUserProfile?()
        }
    }
    
}
