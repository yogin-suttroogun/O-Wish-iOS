//
//  ViewController.swift
//  O'Wish
//
//  Created by SUTTROOGUN Yogin Kumar on 07/03/2018.
//  Copyright © 2018 SUTTROOGUN Yogin Kumar. All rights reserved.
//

import UIKit
import Alamofire

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTxtFld: DesignableTextField!
    @IBOutlet weak var passwordTxtFld: DesignableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func login(_ sender: Any) {
        
        if(emailTxtFld.text! == "admin" && passwordTxtFld.text! == "admin"){
            performSegue(withIdentifier: "adminProfile", sender: nil)
        }else{
            let isEmailValid = Validator().isValidEmail(email: emailTxtFld.text!)
            let isPasswordValid = Validator().isPasswordValid(password: passwordTxtFld.text!)
            
            if !isEmailValid {
                alertMessage(title: "Invalid", msg: "Please enter a valid email address.")
                return
            }

            if !isPasswordValid {
                alertMessage(title: "Invalid", msg: "Please enter a valid password.")
                return
            }
        }
        
        checkEmailValidity{}
        
        
    }
    
    func alertMessage(title: String, msg: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //    API Calls
    func checkEmailValidity(completed: DownloadComplete){
        let checkEmailURL = "\(CHECK_EMAIL_VALIDITY)\(emailTxtFld.text!)"
        Alamofire.request(checkEmailURL, method: .get)
            .validate()
            .responseJSON{ response in
                let resultValue = response.result.value! as! Bool
                if resultValue {
                    self.performSegue(withIdentifier: "userProfile", sender: nil)
                }else{
                    self.alertMessage(title: "Invalid credentials", msg: "Please check your email and password.")
                }
        }
        completed()
    }

}

extension SignInVC: UITextFieldDelegate {
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

