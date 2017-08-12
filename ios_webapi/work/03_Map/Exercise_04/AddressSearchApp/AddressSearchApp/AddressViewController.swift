import UIKit

/// 住所を表すタプル
typealias Address =
    (prefecture: String, city: String, town: String, postal: String, latitude: Double, longitude: Double)

/// 住所検索結果一覧シーン用のビューコントローラ
class AddressViewController: UITableViewController {
    
    private static let baseURLString =
        "http://geoapi.heartrails.com/api/json?method=searchByPostal&postal="
    
    /// 住所情報の格納用
    var addresses: [Address] = []

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // 検索バーのdelegateにビューコントローラ自身を設定
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    /// 表の行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }

    /// セルの作成
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addressCell", forIndexPath: indexPath)
        
        let address = addresses[indexPath.row]
        
        cell.textLabel?.text = "\(address.city) \(address.town)"
        cell.detailTextLabel?.text = address.prefecture

        return cell
    }

    // MARK: - Navigation

    // 画面遷移時のコールバック
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let dest = segue.destinationViewController as? MapViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        dest.address = addresses[indexPath.row]
    }
}

// MARK: - UISearchBarDelegate

/// ビューコントローラにUISearchBarDelegateを適用
extension AddressViewController: UISearchBarDelegate {
    /// キーボードの検索ボタンが押された際のコールバック
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        defer {
            searchBar.resignFirstResponder()
        }
        
        // 7桁の数字以外が入力された場合は、検索を行わずデータをクリアする
        guard let postal = searchBar.text
            where postal.characters.count == 7 && Int(postal) != nil
        else {
            print("不正な入力");
            searchBar.text = ""
                
            // 以前の検索結果を削除して、テーブルビューを再表示
            addresses.removeAll()
            tableView.reloadData()
            return
        }
        
        // 1. リクエスト先のURL文字列を作成
        let urlString = AddressViewController.baseURLString + postal
        print(urlString)
        
        // 2. リクエスト先のURLを指定して、NSURLを作成
        let url = NSURL(string: urlString)!
        
        // 3. NSURLRequestを作成
        let request = NSURLRequest(URL: url)
        
        // 4. NSURLSessionConfigurationを準備
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        // 5. NSURLSessionを作成
        let session = NSURLSession(configuration: config)
        
        // 6. NSURLSessionから、データ送受信を行うタスクを作成
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            
            // このブロックを抜ける際に、タスクを完了させて無効化
            defer {
                session.finishTasksAndInvalidate()
            }
            
            // dataがnilでなければ、処理を続行
            guard let data = data else { print("HTTP通信でエラー発生"); return }
            
            // テーブルビューの更新を行うため、メインキューへ処理を依頼
            NSOperationQueue.mainQueue().addOperationWithBlock({
                // 住所JSONの解析用メソッドを呼び出し、結果をプロパティへ設定
                self.addresses = self.parseAddressJSON(data)
                
                // テーブルの表示を更新
                self.tableView.reloadData()
            })
        }
        
        // 7. タスクを実行
        task.resume()
    }
    
    /// 検索バーのキャンセルボタンが押された時の処理
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // 検索バーからカーソルを外すのみ
        searchBar.resignFirstResponder()
    }
    
    /**
     NSDataとして受け取ったJSONを解析し、文字列の配列として返す。
     
     - parameter data: 解析対象のJSONを表すNSData
     - returns: 住所情報タプルの配列
     */
    private func parseAddressJSON(data: NSData) -> [Address] {
        // JSONデータ全体をディクショナリに変換
        guard let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments))
            as? Dictionary<String, AnyObject> else { print("JSONではない"); return [] }
        
        // 全体のディクショナリから、キーresponseの部分だけをディクショナリとして取得
        guard let response = json["response"] as? Dictionary<String, AnyObject>
            else { print("JSON内にキーresponseが存在しない"); return [] }
        
        // responseの部分のディクショナリから、キーlocationの部分を文字列の配列として取得
        // 検索結果が0件の場合、キーにlocationが含まれない
        guard let locations = response["location"] as? [AnyObject]
            else { print("JSON内にキーlocationが存在しない"); return [] }
        
        // 住所情報の配列を、mapメソッドでAddressタプルの配列に変換
        let addressArray = locations.map {
            (location) -> Address in

            // xとyは""で囲まれて返されるため、一旦StringにしてからDoubleに変換
            let prefecture = location["prefecture"] as! String
            let city = location["city"] as! String
            let town = location["town"] as! String
            let postal = location["postal"] as! String
            let latitude = Double(location["y"] as! String)!
            let longitude = Double(location["x"] as! String)!
            
            return (prefecture, city, town, postal, latitude, longitude)
        }
        
        // 解析結果を返す
        return addressArray
    }
}
