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
        /*
         TODO: 全てのアノテーション（今回はピンと現在地の2つ）を画面内に表示する。
               MKMapViewのshowAnnotationsメソッドを利用すると、指定した全アノテーションが
               画面内に収まるように自動的に拡大率が調整される。
         */
        
        
        
        
        
        
        
        /*
         TODO: 緯度と経度方向に、10%分だけ拡大率を下げる（吹き出しが画面内に収まるように）。
               showAnnotationsでは、アノテーションが画面の端ギリギリに表示されるため、
               余裕を持たせるために少しだけ拡大率を下げる。
         */
        
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegateの設定
        locationManager.delegate = self
        mapView.delegate = self
        
        // 位置情報の利用許可を要求
        locationManager.requestWhenInUseAuthorization()
        
        /*
         TODO: 位置情報取得時の精度と再取得距離を設定
         */
        
        
        
        
        
        
        // 選択された住所をラベルに表示
        addressLabel.text = "〒\(address.postal)\n\(address.prefecture)\(address.city)\(address.town)"
    }
    
    /*
     TODO: UIViewControllerのライフサイクルメソッドをオーバーライドする（ビューが表示される直前のコールバック）。
     位置情報の取得開始処理を行う。
     */
    
    
    
    
    
    

    /*
     TODO: UIViewControllerのライフサイクルメソッドをオーバーライドする（ビューが非表示となった直後のコールバック）。
           位置情報の取得停止処理を行う。
     */
    
    
    
    
    
    
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
    
    /*
     TODO: CLLocationManagerDelegateのコールバックを実装（位置情報を取得した際のコールバック）。
           ピンの地点と、現在地との距離を計算してラベルに表示する。
     
     */
    
    
    
    
    
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