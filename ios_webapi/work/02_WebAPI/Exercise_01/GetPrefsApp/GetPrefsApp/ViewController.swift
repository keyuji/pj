import UIKit

class ViewController: UIViewController {
    private static let baseURLString = "http://geoapi.heartrails.com/api/json?method=getPrefectures"
    
    @IBOutlet weak var prefecturesTextView: UITextView!
    
    /// 取得ボタンタップ時の処理
    @IBAction func getPrefectures(sender: UIButton) {
        /*
         TODO: Web APIへリクエストを行う。
               検索結果を、テキストビューに表示する。
               JSONの解析には、下方に定義しているparsePrefecturesJSONメソッド（内容の実装は必要）を利用
         */
        
        
        
        
        
        
    }
    
    /// クリアボタンタップ時の処理
    @IBAction func clear(sender: UIButton) {
        prefecturesTextView.text = "取得結果を表示"
    }
    
    /**
     NSDataとして受け取ったJSONを解析し、文字列として返す。
     
     - parameter data: 解析対象のJSONを表すNSData
     - returns: 全都道府県を改行文字を挟んで結合した文字列
     */
    private func parsePrefecturesJSON(data: NSData) -> String {
        /*
         TODO: JSONの解析を行い、結果を文字列として返す。
               データが取得できなかった場合など、何らかの理由で解析に失敗した場合は空文字列を返す。
         */
        
        // 仮実装
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefecturesTextView.text = "取得結果を表示"
    }
}
