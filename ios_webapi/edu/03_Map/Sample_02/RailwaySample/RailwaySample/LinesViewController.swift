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
        // 1. リクエスト先のURL文字列を作成
        //    今回はクエリ文字列に日本語が入るため、%を利用した形式に変換
        let encodedArea =
            area.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        let urlString = LinesViewController.baseURLString + encodedArea
        
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
                // 地域情報JSONの解析用メソッドを呼び出し、結果をプロパティへ設定
                self.lines = self.parseLineJSON(data)
                
                // テーブルの表示を更新
                self.tableView.reloadData()
            })
        }
        
        // 7. タスクを実行
        task.resume()
    }
    
    /**
     NSDataとして受け取ったJSONを解析し、文字列の配列として返す。
     
     - parameter data: 解析対象のJSONを表すNSData
     - returns: 路線名の配列
     */
    private func parseLineJSON(data: NSData) -> [String] {
        // JSONデータ全体をディクショナリに変換
        guard let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments))
            as? Dictionary<String, AnyObject> else { print("JSONではない"); return [] }

        // 全体のディクショナリから、キーresponseの部分だけをディクショナリとして取得
        guard let response = json["response"] as? Dictionary<String, AnyObject>
            else { print("JSON内にキーresponseが存在しない"); return [] }
        
        // responseの部分のディクショナリから、キーlineの部分を文字列の配列として取得
        guard let lines = response["line"] as? [String]
            else { print("JSON内にキーlineが存在しない"); return [] }
        
        // 解析結果を返す
        return lines
    }
    
    // MARK: - Table view data source
    
    /// セクションごとのデータ数を返す
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }
    
    /// 表示するセルを作成して返す
    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
