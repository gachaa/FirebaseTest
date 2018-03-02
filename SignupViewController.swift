//
//  SignupViewController.swift
//  FirebaseTest
//
//  Created by 前本英里香 on 2018/02/08.
//  Copyright © 2018年 Erika Maemoto. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField! // Emailを打つためのTextField
    
    @IBOutlet var passwordTextField: UITextField! //Passwordを打つためのTextField

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self //デリゲートをセット
        passwordTextField.delegate = self //デリゲートをセット
        passwordTextField.isSecureTextEntry = true // 文字を非表示に
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ログインしていれば、遷移
        //FIRAuthがユーザー認証のためのフレーム
        //checkUserVerifyでチェックして、ログイン済みなら画面遷移
        print("ログイン済みかチェック")
        if self.checkUserVerify() {
            self.transitionToView()
        }
    }

    
    //サインアップボタン
    @IBAction func willSignup() {
        //サインアップのための関数
        signup()
    }
    //ログイン画面への遷移ボタン
    @IBAction func willTransitionToLogin() {
        transitionToLogin()
    }
    
    //Signupのためのメソッド
    func signup() {
        //emailTextFieldとpasswordTextFieldに文字がなければ、その後の処理をしない
        guard let email = emailTextField.text else  { return }
        guard let password = passwordTextField.text else { return }
        print("文字がある")
        //FIRAuth.auth()?.createUserWithEmailでサインアップ
        //第一引数にEmail、第二引数にパスワード
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            //エラーなしなら、認証完了
            if error == nil{
                // メールのバリデーション(ユーザー認証)を行う
                user?.sendEmailVerification(completion: { (error) in
                    if error == nil {
                        // エラーがない場合にはそのままログイン画面に飛び、ログインしてもらう
                        self.transitionToLogin()
                    }else {
                        print("\(String(describing: error?.localizedDescription))")
                    }
                })
            }else {
                
                print("\(String(describing: error?.localizedDescription))")
            }
        })
    }
    
    // ログイン済みかどうかと、メールのバリデーションが完了しているか確認
    func checkUserVerify()  -> Bool {
        guard let user = FIRAuth.auth()?.currentUser else { return false }
        return user.isEmailVerified
    }
    
    //ログイン画面への遷移
    func transitionToLogin() {
        print("tTL")
        self.performSegue(withIdentifier: "toLogin", sender: self)
    }
    //ListViewControllerへの遷移
    func transitionToView() {
        self.performSegue(withIdentifier: "toView", sender: self)
    }
    
    

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignupViewController: UITextFieldDelegate {
    
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
