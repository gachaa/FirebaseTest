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

class ViewController: UIViewController {

    var ref: FIRDatabaseReference!
    
    @IBOutlet var textField: UITextField! //投稿のためのTextField
    
    var isCreate = true //データの作成か更新かを判定、trueなら作成、falseなら更新

    var selectedSnap: FIRDataSnapshot! //ListViewControllerからのデータの受け取りのための変数

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FirebaseDatabaseのルートを指定
        ref = FIRDatabase.database().reference()
        textField.delegate = self //デリゲートをセット
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //selectedSnapがnilならその後の処理をしない
        guard let snap = self.selectedSnap else { return }
        
        //受け取ったselectedSnapを辞書型に変換
        let item = snap.value as! Dictionary<String, AnyObject>
        //textFieldに受け取ったデータのcontentを表示
        textField.text = item["content"] as? String
        //isCreateをfalseにし、更新するためであることを明示
        isCreate = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //投稿ボタン
    @IBAction func post(_ sender: UIButton) {
        create()
//        if isCreate {
//            //投稿のためのメソッド
//            create()
//        }else {
//            //更新するためのメソッド
//            update()
//        }
//        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func create() {
        //textFieldになにも書かれてない場合は、その後の処理をしない
        guard let text = textField.text else { return }
        
        //ロートからログインしているユーザーのIDをchildにしてデータを作成
        //childByAutoId()でユーザーIDの下に、IDを自動生成してその中にデータを入れる
        //setValueでデータを送信する。第一引数に送信したいデータを辞書型で入れる
        //今回は記入内容と一緒にユーザーIDと時間を入れる
        //FIRServerValue.timestamp()で現在時間を取る
        //ここでuserの子が作られてる。
//        self.ref.child((FIRAuth.auth()?.currentUser?.uid)!).childByAutoId().setValue(["user": (FIRAuth.auth()?.currentUser?.uid)!,"content": text, "date": FIRServerValue.timestamp()])

        self.ref.childByAutoId().setValue(["user": (FIRAuth.auth()?.currentUser?.uid)!,"content": text, "date": FIRServerValue.timestamp()])

    }
    
    //更新のためのメソッド
    func update() {
        //ルートからのchildをユーザーIDに指定
        //ユーザーIDからのchildを受け取ったデータのIDに指定
        //updateChildValueを使って更新
        ref.keepSynced(true)
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).child("\(self.selectedSnap.key)").updateChildValues(["user": (FIRAuth.auth()?.currentUser?.uid)!,"content": self.textField.text!, "date": FIRServerValue.timestamp()])
    }
}

extension ViewController: UITextFieldDelegate {
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
