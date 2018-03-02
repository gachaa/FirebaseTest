//
//  ListViewController.swift
//  FirebaseTest
//
//  Created by 前本英里香 on 2018/02/17.
//  Copyright © 2018年 Erika Maemoto. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController {

    @IBOutlet weak var table: UITableView! //送信したデータを表示するTableView

    var contentArray: [FIRDataSnapshot] = [] //Fetchしたデータを入れておく配列、この配列をTableViewで表示

    var ref: FIRDatabaseReference!

    var selectedSnap: FIRDataSnapshot?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebaseのルートを宣言しておく
        ref = FIRDatabase.database().reference()
        
        //データを読み込むためのメソッド
        self.read()

        //TableViewCellをNib登録、カスタムクラスを作成
        table.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListCell")

        table.delegate = self //デリゲートをセット
        table.dataSource = self  //デリゲートをセット

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //Cellの高さを調節
//        table.estimatedRowHeight = 56
        table.rowHeight = 64
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //画面が消えたときに、Firebaseのデータ読み取りのObserverを削除しておく
        ref.removeAllObservers()
    }

    //ViewControllerへの遷移のボタン
    @IBAction func didSelectAdd() {
        self.transition()
    }

    func read() {
        //FIRDataEventTypeを.Valueにすることにより、なにかしらの変化があった時に、実行
        //今回は、childでユーザーIDを指定することで、ユーザーが投稿したデータの一つ上のchildまで指定することになる
        //自分のidの子を含む部分木を読み込む？
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).observe(.value, with: {(snapShots) in
            if snapShots.children.allObjects is [FIRDataSnapshot] {
                print("snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント

                print("snapShot...\(snapShots)") //読み込んだデータをプリント

                self.reload(snapShots)
            }
        })
    }
    
    //読み込んだデータは最初すべてのデータが一つにまとまっているので、それらを分割して、配列に入れる
    func reload(_ snap: FIRDataSnapshot) {
        if snap.exists() {
            print(snap)
            //FIRDataSnapshotが存在するか確認
            contentArray.removeAll()
            //1つになっているFIRDataSnapshotを分割し、配列に入れる
            for item in snap.children {
                contentArray.append(item as! FIRDataSnapshot)
            }
            // ローカルのデータベースを更新
            ref.child((FIRAuth.auth()?.currentUser?.uid)!).keepSynced(true)
            //テーブルビューをリロード
            table.reloadData()
        }
    }
    
    func delete(deleteIndexPath indexPath: IndexPath) {
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).child(contentArray[indexPath.row].key).removeValue()
        contentArray.remove(at: indexPath.row)
    }
    
    //timestampで保存されている投稿時間を年月日に表示形式を変換する
    func getDate(_ number: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: number)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }
    
    //ViewControllerへの遷移
    func transition() {
        self.performSegue(withIdentifier: "toView", sender: self)
    }
    
    func didSelectRow(selectedIndexPath indexPath: IndexPath) {
        //ルートからのchildをユーザーのIDに指定
        //ユーザーIDからのchildを選択されたCellのデータのIDに指定
        self.selectedSnap = contentArray[indexPath.row]
        self.transition()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toView" {
            let view = segue.destination as! ViewController
            if let snap = self.selectedSnap {
                view.selectedSnap = snap
            }
        }
    }
    
    func query() {
        //"content"の中に、"MIB"という単語があるかを調べる
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).queryOrdered(byChild: "content").queryEqual(toValue: "MIB").observe(.value, with: { (snap) in
            print(snap)
        })
    }

}

extension ListViewController: UITableViewDataSource {
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contentArray.count
    }
    
    //返すセルを決める
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //xibとカスタムクラスで作成したCellのインスタンスを作成
        let cell = table.dequeueReusableCell(withIdentifier: "ListCell") as! ListTableViewCell
        
        //配列の該当のデータをitemという定数に代入
        let item = contentArray[indexPath.row]
        //itemの中身を辞書型に変換
        let content = item.value as! Dictionary<String, AnyObject>
        //contentという添字で保存していた投稿内容を表示
        cell.contentLabel.text = String(describing: content["content"]!)
        //dateという添字で保存していた投稿時間をtimeという定数に代入
        let time = content["date"] as! TimeInterval
        //getDate関数を使って、時間をtimestampから年月日に変換して表示
        cell.postDateLabel.text = self.getDate(time/1000)
        
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    
    //スワイプ削除のメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //デリートボタンを追加
        if editingStyle == .delete {
            //選択されたCellのIndexPathを渡し、データをFirebase上から削除するためのメソッド
            self.delete(indexPath)
            //TableView上から削除
            table.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectRow(selectedIndexPath: indexPath)
    }
}


