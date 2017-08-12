import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /// アプリが起動して、準備ができた後に呼ばれるコールバック
    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
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
}
