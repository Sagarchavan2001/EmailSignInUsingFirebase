//
//  ViewController.swift
//  AuthenticationWithFirebase
//
//  Created by STC on 06/09/23.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {
    private let label : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Sign IN "
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    private let email : UITextField = {
        let email = UITextField()
        email.placeholder = "Enter E-Mail"
        email.layer.borderWidth = 1
        return email
    }()
    private let password : UITextField = {
        let password = UITextField()
        password.placeholder = "Enter Password"
        password.layer.borderWidth = 1
        password.isSecureTextEntry = true
        return password
    }()
    private let button : UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("sign In", for: .normal)
        return button
    }()
    private let signUpButton : UIButton = {
        let signUpButton = UIButton()
        signUpButton.backgroundColor = .red
        
        signUpButton.setTitle("log Out", for: .normal)
        return signUpButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(label)
        view.addSubview(email)
        view.addSubview(password)
        view.addSubview(button)
        button.addTarget(self, action: #selector(tabbutton), for: .touchUpInside)
        
        if FirebaseAuth.Auth.auth().currentUser != nil
        {
            label.isHidden  = true
            email.isHidden  = true
            password.isHidden  = true
            button.isHidden  = true
            view.addSubview(signUpButton)
            signUpButton.frame = CGRect(x: 20, y: 50, width: view.frame.size.width - 40, height: 52)
            signUpButton.addTarget(self, action: #selector(logOutTap), for: .touchUpInside)
        }
    }
    @objc private func logOutTap(){
        do{
            try FirebaseAuth.Auth.auth().signOut()
            label.isHidden  = false
            email.isHidden  = false
            password.isHidden  = false
            button.isHidden  = false
            signUpButton.removeFromSuperview()
        }catch{
            print("An error Occured..")
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 80)
        email.frame = CGRect(x: 20, y: label.frame.origin.y+label.frame.size.height+10,
                             width: view.frame.width - 40, height: 50)
        password.frame = CGRect(x: 20, y: email.frame.origin.y+email.frame.size.height+10,
                                width: view.frame.width - 40,
                                height: 50)
        button.frame = CGRect(x: 20, y: password.frame.origin.y+password.frame.size.height+10,
                              width: view.frame.width - 40,
                              height: 50)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser == nil{
            email.becomeFirstResponder()
        }
       
    }
    @objc private func tabbutton(){
     print("hhh")
        guard let email1 = email.text, !email1.isEmpty, let password1 = password.text,
              !password1.isEmpty else
        {
            print("missing field data...")
            return
        }
        //get auth
        FirebaseAuth.Auth.auth().signIn(withEmail: email1, password: password1, completion: { [weak self] result,error in guard let strongSelf = self else{
            return
        }
            guard error == nil else{
                strongSelf.showCreateAccount(email: email1, password: password1)
                return
            }
            print("sign in successs.....")
            strongSelf.label.isHidden = true
            strongSelf.email.isHidden = true
            strongSelf.password.isHidden = true
            strongSelf.button.isHidden = true

        })
        }
    func showCreateAccount(email : String,password : String){
        let alert = UIAlertController(title: "Create Account", message: "Would You Like TO Create Account", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "continue..", style: .default, handler: {
            _ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password,completion: {[weak self] result ,error in
                guard let strongSelf = self else{
                    return
                }
                    guard error == nil else{
                        print("Account Creation Failed...")
                        return
                    }
                    print("sign in successs.....")
                    strongSelf.label.isHidden = true
                    strongSelf.email.isHidden = true
                    strongSelf.password.isHidden = true
                    strongSelf.button.isHidden = true

                })
        }))
        alert.addAction(UIAlertAction(title: "Cancel..", style: .cancel, handler: {
            _ in
        }))
        present(alert,animated: true)
    }


}

