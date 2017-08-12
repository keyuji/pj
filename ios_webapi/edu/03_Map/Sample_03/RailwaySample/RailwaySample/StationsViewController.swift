import UIKit

/// 駅情報のタプルにエイリアスを設定
typealias StationInfo = (name:String, latitude: Double, longitude: Double)

/// 駅一覧シーン用ビューコントローラ
class StationsViewController: UITableViewController {
    /// 路線名受け取り用
    var line = ""
    
    /// 駅取得Web APIのベースURL
    private static let baseURLString = "http://express.heartrails.com/api/json?method=getStations&line="
    
    /// 駅一覧用の配列
    var stations = [StationInfo]()
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 駅取得Web APIへリクエスト
        self.requestStations()
    }
    
    // MARK: - HTTPリクエストとJSON解析
    
    /**
     駅の一覧をWeb APIから取得。
     取得した駅は、このオブジェクトのプロパティへ格納。
     */
    func requestStations() {
        // 1. リクエスト先のURL文字列を作成
        //    今回はクエリ文字列に日本語が入るため、%を利用した形式に変換
        let encodedLine =
            line.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        let urlString = StationsViewController.baseURLString + encodedLine
        
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
                self.stations = self.parseStationJSON(data)
                
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
     - returns: 駅情報タプルの配列
     */
    private func parseStationJSON(data: NSData) -> [StationInfo] {
        // JSONデータ全体をディクショナリに変換
        guard let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments))
            as? Dictionary<String, AnyObject> else { print("JSONではない"); return [] }
        
        // 全体のディクショナリから、キーresponseの部分だけをディクショナリとして取得
        guard let response = json["response"] as? Dictionary<String, AnyObject>
            else { print("JSON内にキーresponseが存在しない"); return [] }
        
        // responseの部分のディクショナリから、キーstationの部分をオブジェクトの配列として取得
        guard let stations = response["station"] as? [AnyObject]
            else { print("JSON内にキーstationが存在しない"); return [] }
        
        // 駅情報の配列を、mapメソッドでStationInfoタプルの配列に変換
        let stationInfoArray = stations.map {
            (station) -> StationInfo in
            
            let name = station["name"] as! String
            let latitude = station["y"] as! Double
            let longitude = station["x"] as! Double
            
            return (name, latitude, longitude)
        }
        
        // 解析結果を返す
        return stationInfoArray
    }
    
    // MARK: - Table view data source
    
    /// セクションごとのデータ数を返す
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    /// 表示するセルを作成して返す
    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルの取得には、シーン上でセルに設定したidentifierを指定
        let cell = tableView.dequeueReusableCellWithIdentifier("stationCell", forIndexPath: indexPath)
        cell.textLabel?.text = stations[indexPath.row].name
        cell.detailTextLabel?.text = line
        
        return cell
    }
    
    // MARK: - Navigation
    
    /// 画面遷移時のコールバック
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let dest = segue.destinationViewController as? MapViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        dest.station = stations[indexPath.row]
    }
}
