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
        // 全てのアノテーション（今回はピンと現在地の2つ）を画面内に表示する
        mapView.showAnnotations(mapView.annotations, animated: false)
        
        // 緯度と経度方向に、10%分だけ拡大率を下げる（吹き出しが画面内に収まるように）
        mapView.region.span.latitudeDelta *= 1.1
        mapView.region.span.longitudeDelta *= 1.1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegateの設定
        locationManager.delegate = self
        mapView.delegate = self
        
        // 位置情報の利用許可を要求
        locationManager.requestWhenInUseAuthorization()
        
        // 精度と再取得距離の設定
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        
        // 選択された住所をラベルに表示
        addressLabel.text = "〒\(address.postal)\n\(address.prefecture)\(address.city)\(address.town)"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 位置情報の取得開始
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 位置情報の取得停止
        locationManager.stopUpdatingLocation()
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
    
    /// 位置情報を取得した際のコールバック
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 現在地の位置オブジェクト作成
        guard let newLocation = locations.last, addressMapPoint = addressMapPoint else { return }
        let currentPoint = MKMapPointForCoordinate(newLocation.coordinate)
        
        // 2点間の距離を計算
        let distanceByMeter = MKMetersBetweenMapPoints(addressMapPoint, currentPoint)
        let distanceByKm = distanceByMeter / 1000
        
        // ラベルに表示
        distanceLabel.text = String(format: "現在地からの距離:%.2fkm", distanceByKm)
    }
}

// MARK: - MKMapViewDelegateの適用
extension MapViewController: MKMapViewDelegate {
    /// 地図上にアノテーションが追加される直前のコールバック
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // 現在地アノテーションは、タイトルを変更
        if let userLocation = annotation as? MKUserLocation {
            userLocation.title = "You are here"
            return nil
        }
        
        // アノテーションビュー再利用のidentifier
        let identifier = "addressAnnotation"
        
        // アノテーションビューを取得し、カスタマイズ
        if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
            return annotationView
        } else {
            // 通常のMKPinAnnotationViewではなくMKAnnotationViewを利用すると、画像を変えるなどのカスタマイズ可能
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.image = UIImage(named: "myPinImage")
            annotationView.canShowCallout = true
            
            return annotationView
        }
    }
    
    /// 地図上にアノテーションが追加された際のコールバック
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        // 現在地以外のアノテーションを取得
        let annotationViews = views.filter {
            (view) -> Bool in
            view.annotation is MKPointAnnotation
        }
        
        // ピン形式のアノテーションが取得できた場合は、選択しておく
        guard let annotation = annotationViews.last?.annotation else { return }
        mapView.selectAnnotation(annotation, animated: true)
    }
}