//
//  ViewController.swift
//  FloatingPanel
//
//  Created by Danesh Rajasolan on 2021-01-19.
//

import UIKit
import FloatingPanel

class ViewController: UIViewController, FloatingPanelControllerDelegate {

    let firebaseHandler = FirebaseHandler()
    let networking = Networking()
    
    var initialMovies: [Movie] = []
    var userRegistered: Bool!
    var fpc: FloatingPanelController!

    @IBAction func createAccount(_ sender: Any) {
        if userRegistered {
            self.performSegue(withIdentifier: "seguetomovies", sender: self)
        } else {
            self.present(firebaseHandler.showLoginScreen(), animated: true) {
            print("entered")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fpc = FloatingPanelController()
        fpc.delegate = self
        
        fpc.surfaceView.backgroundColor = UIColor(displayP3Red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        fpc.surfaceView.appearance.cornerRadius = 24.0
        fpc.surfaceView.appearance.shadows = []
        fpc.surfaceView.appearance.borderWidth = 1.0 / traitCollection.displayScale
        fpc.surfaceView.appearance.borderColor = UIColor.black.withAlphaComponent(0.2)
        
        let newsVC = storyboard?.instantiateViewController(identifier: "content") as? FloatingTable
        
        fpc.set(contentViewController: newsVC)
        fpc.track(scrollView: (newsVC?.tableView)!)
        
        fpc.addPanel(toParent: self)
        
        networking.loadData(url: "https://api.themoviedb.org/3/discover/movie?api_key=e6592aa9d71db4ccf161b31f9a8c5c7a&language=en-US&region=US&sort_by=popularity.desc&include_adult=true&include_video=true&page=2&primary_release_year=2021&year=2021") { (movies) in
            self.initialMovies = movies            
            newsVC?.weeklyMovies = self.networking.orderSearchResults(movies)
            
            DispatchQueue.main.async {
                newsVC?.tableView.reloadData()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(userDidRegister), name: NSNotification.Name("userRegistered"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userRegistered = (UserDefaults.standard.object(forKey: "userRegistered") != nil)
    }
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return FloatingPanelStocksLayout()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguetomovies" {
            let destination = segue.destination as! MovieList
            destination.movies = self.initialMovies
        }
    }
    
    @objc private func userDidRegister(_ notification: Notification) {
        if let registered = notification.userInfo?["userRegistered"] as? Bool {
            userRegistered = registered
            UserDefaults.standard.set(true, forKey: "userRegistered")
            self.performSegue(withIdentifier: "seguetomovies", sender: self)
        }
    }

}

class FloatingPanelStocksLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 56.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(absoluteInset: 262.0, edge: .bottom, referenceGuide: .safeArea),
             /* Visible + ToolView */
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 45, edge: .bottom, referenceGuide: .safeArea),
        ]
    }

    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.0
    }
}

