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
        
        // TODO: この画面が表示された時に、myMessageのmessageプロパティをKVOで監視
        
        
        
        
        print("監視開始！")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // TODO: この画面が非表示になった時に、監視を解除
        
        
        
        
        print("監視解除！")
    }
    
    /// TODO: 監視対象の値変更時に通知が届くコールバック
    
    
    
    
}
