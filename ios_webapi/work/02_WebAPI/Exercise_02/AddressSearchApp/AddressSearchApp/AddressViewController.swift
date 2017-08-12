import UIKit

/// 住所を表すタプル
typealias Address =
    (prefecture: String, city: String, town: String, postal: String, latitude: Double, longitude: Double)

/// 住所検索結果一覧画面用のビューコントローラ
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
        
        /*
         TODO: 上で取得した入力値をもとに、Web APIへリクエストを行う。
               検索結果を、テーブルビューに表示する。
               JSONの解析には、下方に定義しているparseAddressJSONメソッド（内容の実装は必要）を利用
         */
        
        
        
        
        
        
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
        /*
         TODO: JSONの解析を行い、結果を配列として返す。
               データが取得できなかった場合など、何らかの理由で解析に失敗した場合は空の配列[]を返す。
         */
        
        // 仮実装
        return []
    }
}
