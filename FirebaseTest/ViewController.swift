//
//  ViewController.swift
//  FirebaseTest
//
//  Created by 前本英里香 on 2018/02/03.
//  Copyright © 2018年 Erika Maemoto. All rights reserved.
//
/*
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
*/
import UIKit
import Firebase //Firebaseをインポート

class ViewController: UIViewController, UITextFieldDelegate {
    
    let ref = FIRDatabase.database().reference() //FirebaseDatabaseのルートを指定
    
    @IBOutlet var textField: UITextField! //投稿のためのTextField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self //デリゲートをセット
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //投稿ボタン
    @IBAction func post(sender: UIButton) {
        //投稿のためのメソッド
        create()
    }
    
    func create() {
        //textFieldになにも書かれてない場合は、その後の処理をしない
        guard let text = textField.text else { return }
        
        //ロートからログインしているユーザーのIDをchildにしてデータを作成
        //childByAutoId()でユーザーIDの下に、IDを自動生成してその中にデータを入れる
        //setValueでデータを送信する。第一引数に送信したいデータを辞書型で入れる
        //今回は記入内容と一緒にユーザーIDと時間を入れる
        //FIRServerValue.timestamp()で現在時間を取る
        //self.ref.child((FIRAuth.auth()?.currentUser?.uid)!).childByAutoId().setValue(["user": (FIRAuth.auth()?.currentUser?.uid)!,"content": text, "date": FIRServerValue.timestamp()])
    }
    
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

