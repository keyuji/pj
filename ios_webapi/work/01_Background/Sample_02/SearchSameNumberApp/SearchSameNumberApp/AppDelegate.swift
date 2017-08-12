import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /// アプリ起動時のコールバック
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // 通知タイプを格納した設定を作成
        let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        
        // 通知タイプの登録と、ユーザヘの通知許可依頼
        application.registerUserNotificationSettings(settings)
        
        // アプリがローカル通知から起動した場合は、バッジをクリア
        if (launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification) != nil {
            application.applicationIconBadgeNumber = 0
        }

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /// フォアグラウンドorバックグラウンドでローカル通知を受け取った際のコールバック
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // 通知領域からローカル通知を削除し、アプリアイコンに表示されたバッジをクリア
        application.cancelLocalNotification(notification)
        application.applicationIconBadgeNumber = 0
    }
}
