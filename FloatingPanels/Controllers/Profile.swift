//
//  Profile.swift
//  FloatingPanels
//
//  Created by Danesh Rajasolan on 2021-01-21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class Profile: UIViewController {

    @IBOutlet weak var favMovies: UITextView!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var name: UITextField!
    
    let firebaseHandler = FirebaseHandler()
    var uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        uid = Auth.auth().currentUser?.uid
        if uid != nil {
//            print("here")
            firebaseHandler.getTextFieldData { (datas) in
                self.name.text = datas[0] as? String
                self.age.text = datas[1] as? String
                self.gender.text = datas[2] as? String
                self.favMovies.text = datas[3] as? String ?? ""
            }
        } else {
            let alertVC = UIAlertController(title: "Account Not Detected", message: "You need to create an account to see your profile", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: { (action) in
                self.tabBarController?.selectedIndex = 0
            }))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        if uid != nil {
            firebaseHandler.saveProfile(name: self.name.text ?? "", age: self.age.text ?? "", gender: self.gender.text ?? "")
        } else {
            
        }
    }

}
