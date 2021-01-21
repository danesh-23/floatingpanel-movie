//
//  FirebaseHandler.swift
//  FloatingPanel
//
//  Created by Danesh Rajasolan on 2021-01-19.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseUI

class FirebaseHandler: NSObject {
    
    func showLoginScreen() -> UIViewController {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers = [FUIEmailAuth()]
        authUI?.providers = providers
        let authVC = authUI!.authViewController()
        authVC.modalPresentationStyle = .fullScreen
        return authVC
    }
    
    func addFavoritedMovies(string: String, add: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).updateData(["favorite_movies": (add ? FieldValue.arrayUnion([string]) : FieldValue.arrayRemove([string]))])
    }
    
    func getTextFieldData(completion: @escaping ([Any]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            guard let data = snapshot?.data() else { return }
            let user = Users(name: data["name"] as! String, age: data["age"] as! String, gender: data["gender"] as! String, favorite_movies: data["favorite_movies"] as? [String])
            var textData = [Any]()
            textData.append(user.name)
            textData.append(user.gender)
            textData.append(user.age)
            var string = ""
            for values in user.favorite_movies! {
                string = values + "\n" + string
            }
            textData.append(string)
            completion(textData)
        }
    }
    
    func saveProfile(name: String, age: String, gender: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).updateData(["name" : name, "age": age, "gender": gender])
    }
}

extension FirebaseHandler: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        guard error == nil else { print(error?.localizedDescription); return }
        let uid = authDataResult?.user.uid
        NotificationCenter.default.post(name: NSNotification.Name("userRegistered"), object: nil, userInfo: ["userRegistered" : true])
        Firestore.firestore().collection("users").document(uid!).setData(["name" : "Enter your name", "age": "Enter your age", "gender": "Enter your gender", "favorite_movies": [""]])
    }
}
