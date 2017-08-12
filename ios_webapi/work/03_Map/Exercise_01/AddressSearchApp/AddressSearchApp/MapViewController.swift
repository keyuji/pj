import UIKit
import MapKit

/// 地図シーン用のビューコントローラ
class MapViewController: UIViewController {
    /// 住所情報受け取り用
    var address: Address = ("", "", "", "", 0, 0) {
        didSet {
            print(address)
            
            /*
             TODO: 前画面のビューコントローラから渡された値をもとに、以下のオブジェクトを作成してプロパティに代入。
             ・座標（CLLocationCoordinate2D）
             ・地図上に表示するアノテーション（MKPointAnnotation）
             ・地図上での位置（MKMapPoint） - 後の演習で利用
             */
            
            
            
            
            
            
        }
    }
    
    /// 表示する住所の座標
    var addressCoordinate: CLLocationCoordinate2D?
    
    /// 地図に付加する、住所用のアノテーション
    var addressAnnotation: MKPointAnnotation?
    
    /// 地図上での位置
    var addressMapPoint: MKMapPoint?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    /// 「ピンと現在地を表示」ボタンタップ時のコールバック
    @IBAction func showUserAndAddress(sender: UIButton) {
        // 後の演習で実装
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         TODO: 前画面から渡された地点の情報を、ラベルaddressLabelに表示する。
         */
        
        
        
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 選択された住所にアノテーションを追加
        self.putAddressAnnotation()
    }
    
    /// 地図にアノテーションを追加
    func putAddressAnnotation() {
        /*
         TODO: 前画面から渡された地点を、地図上ににアノテーションとして追加する。
         */
        
        
        
        
        
        /*
         TODO: アノテーションを追加した地点を中心として、2.5km四方が表示されるように地図の拡大率を設定する。
         */
        
        
        
        
        
    }
}
