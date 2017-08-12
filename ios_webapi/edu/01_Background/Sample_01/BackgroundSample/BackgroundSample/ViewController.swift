import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    /// 入力値の素数判定を行う
    @IBAction func decide(sender: UIButton) {
        resultLabel.text = "判定中…"
        indicator.startAnimating()
        
        defer {
            numberField.text = ""
            numberField.resignFirstResponder()
        }

        guard let text = numberField.text else { return }
        
        // バックグラウンド実行時間延長を要求
        let application = UIApplication.sharedApplication()
        let taskId = application.beginBackgroundTaskWithExpirationHandler { 
            // ここには、時間切れ間際となった場合の処理を記述する
            NSLog("残りわずか:\(application.backgroundTimeRemaining)秒")
        }
        
        NSLog("[処理開始]")
        
        // 時間のかかる処理であるため、非同期で実行
        let queue = NSOperationQueue()
        queue.addOperationWithBlock { 
            // 入力された整数の範囲をチェックして、OKなら処理を続行
            guard text.characters.count < 10,
                let number = Int(text) where (1...500_000_000).contains(number)
            else {
                NSOperationQueue.mainQueue().addOperationWithBlock({ 
                    self.resultLabel.text = "2から500,000,000までの整数を入力してください。"
                    self.indicator.stopAnimating()
                })
                
                NSLog("[処理終了]")
                
                // 処理が完了したことを、システムへ通知
                application.endBackgroundTask(taskId)

                return
            }
            
            // 素数判定
            let isPrimeNumber = (2..<number).reduce(true, combine: {
                (indivisible, n) -> Bool in
                indivisible && number % n != 0
            })
            
            // 結果をラベルに表示
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.resultLabel.text
                    = isPrimeNumber ? "\(number)は素数です。" : "\(number)は素数ではありません。"
                self.indicator.stopAnimating()
            })
            
            NSLog("[処理終了]")
            
            // 処理が完了したことを、システムへ通知
            application.endBackgroundTask(taskId)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
