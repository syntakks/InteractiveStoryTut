//
//  ViewController.swift
//  InteractiveStoryTut
//
//  Created by Stephen Wall on 2/6/20.
//  Copyright © 2020 syntaks.io. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameFieldBottomConstraint: NSLayoutConstraint!
    
    // Clean up observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startAdventure" {
            do {
                if let name = nameField.text {
                    if name == "" {
                        throw AdventureError.nameNotProvided
                    }
                }
            } catch AdventureError.nameNotProvided {
                let alertController = UIAlertController(title: "Name Not Provided", message: "Provide a name to start the story", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                present(alertController, animated: true, completion: nil)
                
            } catch let error {
                fatalError("\(error.localizedDescription)")
            }
            guard let pageController = segue.destination as? PageController else {
                return
            }
            pageController.page = Adventure.story(withName: nameField.text ?? "How did this happen?")
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let info = notification.userInfo,
            let keyboardFrame = info[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
            self.nameFieldBottomConstraint.constant = keyboardFrame.height
        }
    }

    
}

