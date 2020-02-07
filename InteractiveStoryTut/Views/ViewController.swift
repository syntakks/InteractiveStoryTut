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
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
            self.nameFieldBottomConstraint.constant = keyboardFrame.size.height + 10
            UIView.animate(withDuration: 0.8) { // Look into this. 
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.nameFieldBottomConstraint.constant = 40
        UIView.animate(withDuration: 0.8) { // Look into this.
            // It must make a list of all the views that need to be changed in the next frame and then animates
            // All of them accordingly. 
            self.view.layoutIfNeeded()
        }
    }
}

// This catches all instances of the done button being pressed in this view controller
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

