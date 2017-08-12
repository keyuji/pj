//: # JSONの解析
//: [練習へ](practice)
import UIKit

// 解析対象のJSON
let originalJSON: String
    = "{ \"name\" : \"山田二郎\", \"scores\": [ { \"score\": 65.2 }, { \"score\": 23.8 } ] }"
let data = originalJSON.dataUsingEncoding(NSUTF8StringEncoding)

// JSONを解析する関数を定義
func parseJSON(data: NSData) {
    
    // JSONとして解析できなければ、以降は処理しない（try?はエラーが発生するとnilを返す）
    // （トップレベルの要素はNSDictionaryなので、as?でDictinaryにキャストを試みている）
    guard let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments))
        as? Dictionary<String, AnyObject>
    else { print("解析失敗"); return }
    
    // JSONを解析
    // "name" をキーとして "山田二郎" を取得（Stringへキャスト）
    guard let name = json["name"] as? String else { print("nameが取得できない"); return }
    print("名前: \(name)")
    
    // "scores" をキーとして "score" の配列を取得（Stringの配列へキャスト）
    guard let scores = json["scores"] as? [AnyObject] else { print("scoresが取得できない"); return }
    
    // 配列を繰り返し処理
    for element in scores {
        // 配列の各要素は、キー "score" を持ったNSDictionary
        // キー "score" に対応する値はNSNumber（Doubleへキャスト）
        guard let score = element["score"] as? Double else { print("scoreが取得できない"); return }
        print("得点: \(score)")
    }
}

// JSONを解析するメソッドを実行
parseJSON(data!)
