//
//  LoginVC.swift
//  Bookmarkd
//
//  Created by Mikael Son on 9/28/17.
//  Copyright © 2017 SPR. All rights reserved.
//

import UIKit
import SPRingboard

class LoginVC: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var authToken: String?
    
    // MARK: - LoginVC Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
    }

    // MARK: - Helper Functions
    
    private func commonInit() {
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleScreenTapped))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleScreenTapped() {
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    private func showEmptyTextFieldAlert() {
        let alertController = UIAlertController(
            title: nil,
            message: "Please enter a Username and Password to continue.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "OK",
            style: .default
        )
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    // MARK: - IBAction Functions
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        self.usernameTextField.text = "testymctestface"
        self.passwordTextField.text = "kale.persist.testbed.PF7"
        
        guard
            let username = self.usernameTextField.text,
            let password = self.passwordTextField.text,
            username.characters.count != 0,
            password.characters.count != 0
        else {
            self.showEmptyTextFieldAlert()
            return
        }
        
        self.handleScreenTapped()
        let credentials = Credentials(username: username, password: password)
        let cmd = SignInCommand()
        cmd.execute(with: credentials).then { (result) in
            switch result {
            case .success(let model):
                print("returned with success")
                self.authToken = model.token
                self.performSegue(withIdentifier: "loginToBookmarks", sender: nil)
            case .failure:
                print("returned with failure")
            }
        }
    }
    
    // MARK: - Navigation Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let navigationVC = segue.destination as? UINavigationController,
            let vc = navigationVC.viewControllers[0] as? BookmarksVC,
            let username = self.usernameTextField.text,
            let token = self.authToken
        else {
            return
        }
        
        let authentication = Authentication(username: username, token: token)
        vc.authentication = authentication
    }
    
    // MARK: - UITextFieldDelegate Functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            let animateUp = CGAffineTransform(translationX: 0, y: -80)
            self.containerView.transform = animateUp
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.containerView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
