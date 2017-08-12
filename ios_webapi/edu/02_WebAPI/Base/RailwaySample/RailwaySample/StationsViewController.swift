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
        
        /*
         TODO: Web APIへアクセスしてJSONを受け取る処理を実装する。
         受け取ったJSONの解析には、下に用意したparseStationJSONメソッド（実装が必要）を利用する。
         */
        
        
        
        
    }
    
    /**
     NSDataとして受け取ったJSONを解析し、文字列の配列として返す。
     
     - parameter data: 解析対象のJSONを表すNSData
     - returns: 駅情報タプルの配列
     */
    private func parseStationJSON(data: NSData) -> [StationInfo] {
        
        /*
         TODO: 引数として受け取ったNSDataをJSONとして解析する処理を実装する。
         */
        
        // 仮実装
        return []
        
        
        
        
    }
    
    // MARK: - Table view data source
    
    /// セクションごとのデータ数を返す
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    /// 表示するセルを作成して返す
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルの取得には、シーン上でセルに設定したidentifierを指定
        let cell = tableView.dequeueReusableCellWithIdentifier("stationCell", forIndexPath: indexPath)
        cell.textLabel?.text = stations[indexPath.row].name
        cell.detailTextLabel?.text = line
        
        return cell
    }
}
