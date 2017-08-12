import UIKit
import MapKit

/// 地図シーン用ビューコントローラ
class MapViewController: UIViewController {
    /// 位置情報マネージャ
    let locationManager = CLLocationManager()
    
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
            
            // 駅の座標をもとに、地図上での駅の位置を作成
            stationMapPoint = MKMapPointForCoordinate(stationCoordinate!)
        }
    }
    
    /// 駅の座標
    var stationCoordinate: CLLocationCoordinate2D?
    
    /// 地図上で駅に付加するアノテーション
    var stationAnnotation: MKPointAnnotation?
    
    /// 地図上での駅の位置
    var stationMapPoint: MKMapPoint?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    /// 「現在地へ」ボタンがタップされた際のコールバック
    @IBAction func moveToCurrentPosition(sender: UIButton) {
        // 現在地が取得できていた場合、直近に取得した位置を中心とした1km四方の範囲オブジェクトを作成
        guard let lastLocation = locationManager.location else { return }
        let region = MKCoordinateRegionMakeWithDistance(lastLocation.coordinate, 1000, 1000)
        
        // 指定した範囲が表示されるように、地図の拡大率を指定
        mapView.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegateとして、ビューコントローラ自体を設定
        locationManager.delegate = self
        mapView.delegate = self
        
        // フォアグラウンド時のみ利用するための、利用許可を求める（利用許可が未設定の場合に呼ばれる）
        locationManager.requestWhenInUseAuthorization()

        // 位置情報の精度と、移動時の更新間隔（50m以上の移動時）を指定
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // ビューが表示されるタイミングで、位置情報の取得を開始する
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 駅の位置にアノテーションを追加
        self.putStationAnnotation()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // ビューが非表示になったタイミングで、位置情報の取得を停止する
        locationManager.stopUpdatingLocation()
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

// MARK: - CLLocationManagerDelegateを適用
extension MapViewController: CLLocationManagerDelegate {
    /// 位置情報の利用許可状態が変更された際のコールバック
    func locationManager(manager: CLLocationManager,
                         didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 「フォアグラウンド時の位置情報利用許可」が得られていた場合には、現在地アノテーションを表示
        switch status {
        case .AuthorizedWhenInUse:
            mapView.showsUserLocation = true
        default:
            mapView.showsUserLocation = false
        }
    }
    
    /// 位置情報の更新を受け取った際のコールバック
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 現在地を取得して、位置オブジェクトを作成（最新の情報は配列の末尾）
        guard let newLocation = locations.last, stationMapPoint = stationMapPoint else { return }
        let currentPoint = MKMapPointForCoordinate(newLocation.coordinate)
        
        // 駅<->現在地間の距離をメートルで計算し、キロメートルに変換
        let distanceByMeter = MKMetersBetweenMapPoints(stationMapPoint, currentPoint)
        let distanceByKm = distanceByMeter / 1000

        // ラベルに距離を表示
        distanceLabel.text = String(format: "\(station.name)駅までの距離: 約%.2fkm", distanceByKm)
    }
}

// MARK: - MKMapViewDelegateを適用
extension MapViewController: MKMapViewDelegate {
    /// アノテーションが追加される直前のコールバック
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // 表示するのが現在地（MKUserLocation）アノテーションの場合、タイトルだけ変更
        if let userLocation = annotation as? MKUserLocation {
            userLocation.title = "現在地"
            
            // nilを返すと、デフォルトのアイコンをそのまま利用
            return nil
        }
        
        // アノテーション用のビュー再利用のためのIdentifier
        let identifier = "myStationAnnotation"
        
        // 再利用できるアノテーション用のビューがあればそのまま利用、なければ作成
        if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
            return annotationView
        } else {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            // ピンの色を設定、ピンの落ちるアニメーションと吹き出しを有効化
            annotationView.pinTintColor = UIColor.orangeColor()
            annotationView.animatesDrop = true
            annotationView.canShowCallout = true
            
            return annotationView
        }
    }
    
    /// アノテーションが追加されたタイミングのコールバック
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        // 地図上のアノテーションから、現在地以外のアノテーションだけ取得
        let annotationViews = views.filter {
            (view) -> Bool in
            view.annotation is MKPointAnnotation
        }
        
        // 今回はピンのアノテーションはひとつなので、最後（最初でも同じ）の要素を選択
        // アノテーションが取得できなければ、追加されたのは現在地アノテーションなので処理を抜ける
        guard let annotation = annotationViews.last?.annotation else { return }
        
        // 駅に追加したアノテーションの吹き出しは、あらかじめ表示しておく
        mapView.selectAnnotation(annotation, animated: true)
    }
}
