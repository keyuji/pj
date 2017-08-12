import UIKit

/// 路線一覧シーン用ビューコントローラ
class LinesViewController: UITableViewController {
    /// 地域名受け取り用
    var area = ""

    /// 路線取得Web APIのベースURL
    private static let baseURLString = "http://express.heartrails.com/api/json?method=getLines&area="
    
    /// 路線一覧用の配列
    var lines = [String]()
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 路線取得Web APIへリクエスト
        self.requestLines()
    }
    
    // MARK: - HTTPリクエストとJSON解析
    
    /**
     路線の一覧をWeb APIから取得。
     取得した路線は、このオブジェクトのプロパティへ格納。
     */
    func requestLines() {
        
        /*
         TODO: Web APIへアクセスしてJSONを受け取る処理を実装する。
         受け取ったJSONの解析には、下に用意したparseLineJSONメソッド（実装が必要）を利用する。
         */
        
        
        
        
    }
    
    /**
     NSDataとして受け取ったJSONを解析し、文字列の配列として返す。
     
     - parameter data: 解析対象のJSONを表すNSData
     - returns: 路線名の配列
     */
    private func parseLineJSON(data: NSData) -> [String] {
        
        /*
         TODO: 引数として受け取ったNSDataをJSONとして解析する処理を実装する。
         */
        
        // 仮実装
        return []
        
        
        
        
    }
    
    // MARK: - Table view data source
    
    /// セクションごとのデータ数を返す
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }
    
    /// 表示するセルを作成して返す
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルの取得には、シーン上でセルに設定したidentifierを指定
        let cell = tableView.dequeueReusableCellWithIdentifier("lineCell", forIndexPath: indexPath)
        cell.textLabel?.text = lines[indexPath.row]
        
        return cell
    }
    
    // MARK: - Navigation
    
    /// 画面遷移時のコールバック
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let dest = segue.destinationViewController as? StationsViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        dest.line = lines[indexPath.row]
    }
}
