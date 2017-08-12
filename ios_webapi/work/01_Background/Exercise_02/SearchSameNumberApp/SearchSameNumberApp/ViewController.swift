import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton!
    
    /// 入力値と同じ数値を、ランダムな数値から探す
    @IBAction func startSearch(sender: UIButton) {
        resultLabel.text = "検索中…"
        
        defer {
            inputTextField.text = ""
            inputTextField.resignFirstResponder()
        }
        
        // 入力桁数のチェック
        guard let text = inputTextField.text where text.characters.count < 6
        else {
            resultLabel.text = "桁数が大きすぎます。"
            return
        }
        
        // 整数チェックおよび入力範囲のチェック
        guard let number = Int(text) where (0...99999).contains(number)
        else {
            resultLabel.text = "0から99,999の範囲で入力してください。"
            return
        }
        
        NSLog("開始")
        
        // バックグラウンド実行時間延長を要求
        let application = UIApplication.sharedApplication()
        let taskId = application.beginBackgroundTaskWithExpirationHandler { 
            NSLog("残り時間わずか")
        }
        
        // インジケータを表示して、ボタンを無効化
        indicator.startAnimating()
        button.enabled = false
        
        // 検索（時間のかかる処理であるため、非同期で実行）
        let queue = NSOperationQueue()
        queue.addOperationWithBlock { 
            // 検索実行
            let count = self.searchNumber(number)
            NSLog("発見！")
            
            // ビューの操作は、メインキューで実行
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.resultLabel.text = "\(count)回目で\(number)発見"
                
                // インジケータを非表示にし、ボタンを有効化
                self.indicator.stopAnimating()
                self.button.enabled = true
            })
            
            // バックグラウンド処理の完了をシステムへ通知
            application.endBackgroundTask(taskId)
        }
    }
    
    /**
     目的の整数を見つけるまで、ランダムな整数を作成して探すメソッド。
     
     - parameter number: 目的の整数
     - returns: 見つかるまでの試行回数
     */
    func searchNumber(number: Int) -> Int {
        var count = 0
        
        while true {
            count += 1
            
            // ランダムな整数を作成し、目的の数値が見つかったら終了
            let random = Int(arc4random_uniform(100000000))
            if number == random {
                break
            }
        }
        return count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
