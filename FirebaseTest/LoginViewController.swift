//
//  LoginViewController.swift
//  FirebaseTest
//
//  Created by 前本英里香 on 2018/02/08.
//  Copyright © 2018年 Erika Maemoto. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField! // Emailを打つためのTextField
    
    @IBOutlet var passwordTextField: UITextField! //Passwordを打つためのTextField


    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self //デリゲートをセット
        passwordTextField.delegate = self //デリゲートをセット
        passwordTextField.isSecureTextEntry  = true // 文字を非表示に
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //ログインボタン
    @IBAction func didRegisterUser() {
        //ログインのためのメソッド
        login()
    }
    
    //ログインのためのメソッド
    func login() {
        //EmailとPasswordのTextFieldに文字がなければ、その後の処理をしない
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        //signInWithEmailでログイン
        //第一引数にEmail、第二引数にパスワードを取ります
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            //エラーがないことを確認
            if error == nil {
                if let loginUser = user {
                    // バリデーションが完了しているか確認。完了ならそのままログイン
                    if loginUser.isEmailVerified {
                        // 完了済みなら、ListViewControllerに遷移
                        self.transitionToView()
                    }else {
                        // 完了していない場合は、アラートを表示
                        self.presentValidateAlert()
                    }
                }
            }else {
                print("error...\(String(describing: error?.localizedDescription))")
            }
        })
    }
    
    // メールのバリデーションが完了していない場合のアラートを表示
    func presentValidateAlert() {
        let alert = UIAlertController(title: "メール認証", message: "メール認証を行ってください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //ログイン完了後に、ListViewControllerへの遷移のためのメソッド
    func transitionToView()  {
        self.performSegue(withIdentifier: "toVC", sender: self)
    }
    

}

extension LoginViewController: UITextFieldDelegate {
    
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
