import Foundation

/// 3秒ごとにmessageプロパティの値が変化するクラス
class MyMessage: NSObject {
    
    /// staticなプロパティとして、単一のインスタンスを保持
    private static let instance = MyMessage()
    
    private let messages = ["First", "Second", "Third", "Fourth", "Last"]
    private var current = 0

    /// 今回のKVO監視対象のプロパティ
    dynamic var message: String
    
    class func getInstance() -> MyMessage {
        return self.instance
    }
    
    override private init() {
        message = messages[0]
        super.init()
        
        // 3秒ごとに、自身のchangeMessageメソッドを実行する
        NSTimer.scheduledTimerWithTimeInterval(3, target: self,
                selector: #selector(MyMessage.changeMessage), userInfo: nil, repeats: true)
    }
    
    /// 呼ばれるたびにmessageプロパティの値を変更するメソッド
    func changeMessage() {
        current = current == messages.count - 1 ? 0 : current + 1
        message = messages[current]
    }
}
