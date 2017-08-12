import UIKit
import MapKit

/// 地図シーン用ビューコントローラ
class MapViewController: UIViewController {
    /// 駅情報受け取り用（StationInfoは、StationViewControllerで定義したエイリアス）
    var station: StationInfo = ("", 0, 0) {
        // 前画面からの値を受け取った際に関連するオブジェクトを作成するため、値を変更監視
        didSet {
            // 駅情報をもとに、駅の座標を作成
            stationCoordinate = CLLocationCoordinate2DMake(station.latitude, station.longitude)
            
            // 駅の座標オブジェクトをもとに、駅に付加するアノテーションを作成
            stationAnnotation = MKPointAnnotation()
            stationAnnotation?.coordinate = stationCoordinate!
            stationAnnotation?.title = "\(station.name)駅"
        }
    }
    
    /// 駅の座標
    var stationCoordinate: CLLocationCoordinate2D?
    
    /// 地図上で駅に付加するアノテーション
    var stationAnnotation: MKPointAnnotation?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    /// 「現在地へ」ボタンがタップされた際のコールバック
    @IBAction func moveToCurrentPosition(sender: UIButton) {
        // TODO: 後のサンプルで実装
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 駅の位置にアノテーションを追加
        self.putStationAnnotation()
    }
    
    /// 地図上で、駅の座標にアノテーションを追加する
    func putStationAnnotation() {
        // 座標とアノテーションが設定されている場合のみ、処理を続行
        guard let coordinate = stationCoordinate, annotation = stationAnnotation else { return }
        
        // アノテーションを追加する
        mapView.addAnnotation(annotation)
        
        // 駅を中心とした5km四方の範囲オブジェクトを作成し、指定した範囲が表示されるように拡大率を指定
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 5000, 5000)
        mapView.setRegion(region, animated: true)
    }
}
