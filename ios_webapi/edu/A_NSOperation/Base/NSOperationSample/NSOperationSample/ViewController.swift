import UIKit

class ViewController: UIViewController {

    @IBAction func startCalculate(sender: UIButton) {
        // 100000個のランダムな整数を作成
        let numbers = (1...100000).map { _ -> Int in
            Int(arc4random_uniform(100000))
        }

        // 最大値を検索
        guard let max = numbers.maxElement() else { return }
        NSLog("最大:%d", max)
        
        // 最小値を検索
        guard let min = numbers.minElement() else { return }
        NSLog("最小:%d", min)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
