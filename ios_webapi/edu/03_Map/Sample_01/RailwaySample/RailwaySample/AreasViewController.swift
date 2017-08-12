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
        // 1. URLには日本語などを含んでいないため、%を利用した形式への変換なし
        let urlString = AreasViewController.baseURLString
        
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
                self.areas = self.parseAreaJSON(data)
                
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
     - returns: 地域名の配列
     */
    private func parseAreaJSON(data: NSData) -> [String] {
        // JSONデータ全体をディクショナリに変換
        guard let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments))
            as? Dictionary<String, AnyObject> else { print("JSONではない"); return [] }
        
        // 全体のディクショナリから、キーresponseの部分だけをディクショナリとして取得
        guard let response = json["response"] as? Dictionary<String, AnyObject>
            else { print("JSON内にキーresponseが存在しない"); return [] }
        
        // responseの部分のディクショナリから、キーareaの部分を文字列の配列として取得
        guard let areas = response["area"] as? [String]
            else { print("JSON内にキーareaが存在しない"); return [] }
        
        // 解析結果を返す
        return areas
    }

    // MARK: - Table view data source

    /// セクションごとのデータ数を返す
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count
    }

    /// 表示するセルを作成して返す
    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
