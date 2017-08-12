import UIKit

class ViewController: UIViewController {
    private static let baseURLString = "http://geoapi.heartrails.com/api/json?method=getPrefectures"
    
    @IBOutlet weak var prefecturesTextView: UITextView!
    
    /// 取得ボタンタップ時の処理
    @IBAction func getPrefectures(sender: UIButton) {
        // 1. リクエスト先のURL文字列を作成
        let urlString = ViewController.baseURLString
        
        // 2. リクエスト先のURLを指定して、NSURLを作成
        let url = NSURL(string: urlString)!
        
        // 3. NSURLRequestを作成
        let request = NSURLRequest(URL: url)
        
        // 4. NSURLSessionConfigurationを準備
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        // 5. NSURLSessionを作成
        let session = NSURLSession(configuration: config)
        
        // 6. NSURLSessionから、データ送受信を行うタスクを作成
        let task1 = session.dataTaskWithRequest(request) {
            (data, response, error) in
            
            // このブロックを抜ける際に、タスクを完了させて無効化
            //defer {
            //    session.finishTasksAndInvalidate()
            //}
            
            // dataがnilでなければ、処理を続行
            guard let data = data else { print("HTTP通信でエラー発生"); return }
            
            // ビューの更新を行うため、メインキューへ処理を依頼
            NSOperationQueue.mainQueue().addOperationWithBlock({
                // 都道府県JSONの解析用メソッドを呼び出し、結果を文字列として受け取り
                let result = self.parsePrefecturesJSON(data)
                
                // 結果をラベルへ表示
                self.prefecturesTextView.text = result
            })
        }

        let task2 = session.dataTaskWithRequest(request) {
            (data, response, error) in

            // このブロックを抜ける際に、タスクを完了させて無効化
            defer {
                session.finishTasksAndInvalidate()
            }

            // dataがnilでなければ、処理を続行
            guard let data = data else { print("HTTP通信でエラー発生"); return }

            // ビューの更新を行うため、メインキューへ処理を依頼
            NSOperationQueue.mainQueue().addOperationWithBlock({
                // 都道府県JSONの解析用メソッドを呼び出し、結果を文字列として受け取り
                let result2 = self.parsePrefecturesJSON(data)

                // 結果をラベルへ表示
//                self.prefecturesTextView.textAlignment
                self.prefecturesTextView.text = result2
            })
        }


        // 7. タスクを実行
        task1.resume()
        task2.resume()

    }

    /// クリアボタンタップ時の処理
    @IBAction func clear(sender: UIButton) {
        prefecturesTextView.text = "取得結果を表示"
    }
    
    /**
     NSDataとして受け取ったJSONを解析し、文字として返す。
     
     - parameter data: 解析対象のJSONを表すNSData
     - returns: 都道府県の文字列
     */
    private func parsePrefecturesJSON(data: NSData) -> String {
        // JSONデータ全体をディクショナリに変換
        guard let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments))
            as? Dictionary<String, AnyObject> else { print("JSONではない"); return "" }
        
        // 全体のディクショナリから、キーresponseの部分だけをディクショナリとして取得
        guard let response = json["response"] as? Dictionary<String, AnyObject>
            else { print("JSON内にキーresponseが存在しない"); return "" }
        
        // responseの部分のディクショナリから、キーprefectureの部分を文字列の配列として取得
        // 検索結果が0件の場合、キーにprefectureが含まれない
        guard let prefectures = response["prefecture"] as? [String]
            else { print("JSON内にキーprefectureが存在しない"); return "" }
        
        // 都道府県名の配列を、改行文字を挟んだ単一の文字列に結合
        let result = prefectures.joinWithSeparator("\n")
        
        // 解析結果を返す
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefecturesTextView.text = "取得結果を表示"
    }
}
