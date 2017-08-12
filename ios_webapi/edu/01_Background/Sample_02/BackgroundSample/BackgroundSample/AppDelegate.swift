import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /// アプリが起動して、準備ができた後に呼ばれるコールバック
    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 通知タイプを格納した設定を作成
        let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        
        // 通知タイプの登録と、ユーザへの通知許可の依頼
        application.registerUserNotificationSettings(settings)
        
        // アプリがローカル通知から起動した場合は、バッジをクリア
        if (launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey]
            as? UILocalNotification) != nil {
            
            application.applicationIconBadgeNumber = 0
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    /// アプリがバックグラウンドへ移行した直後に呼ばれるコールバック
    func applicationDidEnterBackground(application: UIApplication) {
        NSLog("バックグラウンドへ移行")
        
        // バックグラウンドで利用できる、残り時間を表示
        NSLog("残り時間:\(application.backgroundTimeRemaining)")
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
    
    /// アプリがフォアグラウンドorバックグラウンドの状態（停止していない状態）で、
    /// ローカル通知を受信した際に呼ばれるコールバック
    func application(application: UIApplication,
                     didReceiveLocalNotification notification: UILocalNotification) {
        
        // 通知領域からローカル通知を削除し、アプリアイコンに表示されたバッジをクリア
        application.cancelLocalNotification(notification)
        application.applicationIconBadgeNumber = 0
}
}
