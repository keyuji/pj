import UIKit
import MapKit

/// 地図シーン用のビューコントローラ
class MapViewController: UIViewController {
    /// 位置情報マネージャ
    let locationManager = CLLocationManager()
    
    /// 住所情報受け取り用
    var address: Address = ("", "", "", "", 0, 0) {
        didSet {
            print(address)
            
            // 座標を作成
            addressCoordinate = CLLocationCoordinate2DMake(address.latitude, address.longitude)
            
            // アノテーションを作成（アノテーションにはサブタイトルも付加できる）
            addressAnnotation = MKPointAnnotation()
            addressAnnotation?.coordinate = addressCoordinate!
            addressAnnotation?.title = "\(address.town)"
            addressAnnotation?.subtitle = "\(address.city)"
            
            // 位置を作成
            addressMapPoint = MKMapPointForCoordinate(addressCoordinate!)
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
        
        // delegateの設定
        locationManager.delegate = self
        
        /*
         TODO: MKMapViewに対するdelegateとして、ビューコントローラ自身を設定
         */
        
        
        
        
        
        
        // 位置情報の利用許可を要求
        locationManager.requestWhenInUseAuthorization()
        
        // 選択された住所をラベルに表示
        addressLabel.text = "〒\(address.postal)\n\(address.prefecture)\(address.city)\(address.town)"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 選択された住所にアノテーションを追加
        self.putAddressAnnotation()
    }
    
    /// 地図にアノテーションを追加
    func putAddressAnnotation() {
        guard let coordinate = addressCoordinate, annotation = addressAnnotation else { return }
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 2500, 2500)
        mapView.setRegion(region, animated: false)
    }
}

// MARK: - CLLocationManagerDelegateを適用
extension MapViewController: CLLocationManagerDelegate {
    /// 位置情報の利用許可状態が変更された際のコールバック
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedWhenInUse:
            mapView.showsUserLocation = true
        default:
            mapView.showsUserLocation = false
        }
    }
}

// MARK: - MKMapViewDelegateの適用

/*
 TODO: ビューコントローラにMKMapViewDelegateを適用し、2つのdelegateメソッドを実装する。
       ・地図上にアノテーションが追加される直前のコールバックで、アノテーションをカスタマイズする。
       ・地図上にアノテーションが追加された際のコールバックで、アノテーションをあらかじめ選択状態にする。
 
 */





