//: # JSONの解析
//: [サンプルへ](sample)
import UIKit

// 解析対象のJSON
let originalJSON: String
    = "{ \"name\" : \"山田二郎\", \"scores\": [ { \"score\": 65.2 }, { \"score\": 23.8 } ] }"
let data = originalJSON.dataUsingEncoding(NSUTF8StringEncoding)

// JSONを解析する関数を定義
func parseJSON(data: NSData) {
    // TODO: 引数として受け取ったNSDataを、JSONとして解析する処理を実装
    guard let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments))
        as? Dictionary<String, AnyObject>
        else{ print("失敗"); return}

    guard let name = json["name"] as? String else { print("失敗"); return}
    print("名前：　\(name)")

    guard let scores = json["scores"] as? [AnyObject] else { print("失敗"); return}

    for element in scores{
        guard let score = element["score"] as? Double else { print("失敗"); return}
        print("特典：　\(score)")
    }
    
}

// JSONを解析するメソッドを実行
parseJSON(data!)
