import UIKit

class ViewController: UIViewController {
    /// ラベルに表示するための値を提供するオブジェクト
    var myMessage: MyMessage = MyMessage.getInstance()

    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        messageLabel.text = myMessage.message
        
        // この画面が表示された時に、myMessageのmessageプロパティをKVOで監視
        myMessage.addObserver(self, forKeyPath: "message", options: .New, context: nil)
        print("監視開始！")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // この画面が非表示になった時に、監視を解除
        myMessage.removeObserver(self, forKeyPath: "message")
        print("監視解除！")
    }
    
    /// 監視対象の値変更時に通知が届くコールバック
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?,
                            change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        // 変更されたプロパティがmessageで、変更内容が渡されていたら処理を続行
        guard keyPath == "message", let change = change else { return }
        
        // 変更後のmessageプロパティ値を取得できた場合は、ラベルに表示
        guard let newMessage = change[NSKeyValueChangeNewKey] as? String else { return }
        messageLabel.text = newMessage
        
        print(newMessage)
    }
}
