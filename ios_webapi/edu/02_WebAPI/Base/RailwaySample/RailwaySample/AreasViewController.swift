import UIKit

/// 地域一覧シーン用ビューコントローラ
class AreasViewController: UITableViewController {
    /// 地域取得Web APIのURL
    private static let baseURLString = "http://express.heartrails.com/api/json?method=getAreas"
    
    /// 地域一覧用の配列
    var areas = [String]()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 地域取得Web APIへリクエスト
        self.requestAreas()
    }
    
    // MARK: - HTTPリクエストとJSON解析
    
    /**
     地域の一覧をWeb APIから取得。
     取得した地域は、このオブジェクトのプロパティへ格納。
     */
    func requestAreas() {
        
        /*
         TODO: Web APIへアクセスしてJSONを受け取る処理を実装する。
               受け取ったJSONの解析には、下に用意したparseAreaJSONメソッド（実装が必要）を利用する。
         */
        
        
        
        
    }
    
    /**
     NSDataとして受け取ったJSONを解析し、文字列の配列として返す。
     
     - parameter data: 解析対象のJSONを表すNSData
     - returns: 地域名の配列
     */
    private func parseAreaJSON(data: NSData) -> [String] {
        
        /*
         TODO: 引数として受け取ったNSDataをJSONとして解析する処理を実装する。
        */
        
        // 仮実装
        return []
        
        
        
        
    }

    // MARK: - Table view data source

    /// セクションごとのデータ数を返す
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count
    }

    /// 表示するセルを作成して返す
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルの取得には、シーン上でセルに設定したidentifierを指定
        let cell = tableView.dequeueReusableCellWithIdentifier("areaCell", forIndexPath: indexPath)
        cell.textLabel?.text = areas[indexPath.row]

        return cell
    }

    // MARK: - Navigation

    /// 画面遷移時のコールバック
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let dest = segue.destinationViewController as? LinesViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }

        dest.area = areas[indexPath.row]
    }
}
