//
//  ViewController.swift
//  chapter8
//
//  Created by 박종훈 on 2021/05/03.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var TableViewMain: UITableView!
    
    //1. HTTP 통신 방법
    //2. JSON 데이터 형태
    //3. 테이블뷰의 데이터 매칭 <- 통보 <- 그리기
    
    var newsData: Array<Dictionary<String, Any>>?//articles에 담긴 각 뉴스 제이슨 내용을 넣음.
    
    //news-api는 500회 무료. 뉴스를 띄워주는 함수
    func getNews() {
        let task = URLSession.shared.dataTask(with: URL(string: "https://newsapi.org/v2/top-headlines?country=kr&apiKey=a076fb5348fd4845a3a5c6b34c933276")!) { data, response, error in
            if let dataJson = data {
                
                //JSON parsing
                do {
                    let json = try JSONSerialization.jsonObject(with: dataJson, options: []) as! Dictionary<String, Any>
                    let articles = json["articles"] as! Array<Dictionary<String, Any>>
                    self.newsData = articles
                    
                    DispatchQueue.main.async {
                        self.TableViewMain.reloadData()//Main에서 준비가 다 되면 출력되게
                    }
                    
/*                    for (idx, value) in articles.enumerated() {
                        if let v = value as? Dictionary<String,Any> {
                            print("\(v["title"])")
                        }
                    }
 */
                }
                catch {}
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //뉴스 개수 반환(테이블 셀을 몇개 만들 것인지에 사용)
        if let news = newsData {
            return news.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //내용
        //2가지 방법
        //첫번째 방법. 임의의 셀을 만듦 : 연습
        //let cell = UITableViewCell.init(style: .default, reuseIdentifier: "TableCellType1")
        //cell.textLabel?.text = "\(indexPath.row)" //string 사이에 값을 넣기 위해서는 \(값)
        //두번째 방법. 스토리보드 + id : 실전
        let cell = TableViewMain.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1//재사용할 수 있는 셀을 정의해서 셀뷰에 넣음. as? as!는 부모 친자확인
        
        let idx = indexPath.row
        if let news = newsData {
            let row = news[idx]
            if let r = row as? Dictionary<String, Any> {
                print("TITLE :: \(r)")
                if let title = r["title"] as? String {
                    cell.LabelText.text = title
                }
            }
            
        }
        
        
        return cell
    }
    //1. tableview delegate 클릭 리스너
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("CLICK!! \(indexPath.row)")
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "NewsDetailController") as! NewsDetailController
        
        if let news = newsData {
            let row = news[indexPath.row]
            print("row :: \(row)")
            if let r = row as? Dictionary<String, Any> {
                if let imageUrl = r["urlToImage"] as? String {
                    controller.imageUrl = imageUrl
                }
                if let desc = r["description"] as? String {
                    controller.desc = desc
                }
            }
        }
        //이동 - 수동
        //showDetailViewController(controller, sender: nil)
    }
    //2. segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "NewsDetail" == id {
            if let controller = segue.destination as? NewsDetailController {
                if let news = newsData {
                    if let indexPath = TableViewMain.indexPathForSelectedRow {
                        let row = news[indexPath.row]
                        print("row :: \(row)")
                        if let r = row as? Dictionary<String, Any> {
                            if let imageUrl = r["urlToImage"] as? String {
                                controller.imageUrl = imageUrl
                            }
                            if let desc = r["description"] as? String {
                                controller.desc = desc
                            }
                        }
                    }
                }
                
            }
        }
        //이동 - 자동
    }
    
    //1. 디테일 (상세) 화면 만들기
    //2. 값을 보내기 2가지.
        //1. tableview delegate
        //2. storyboard (segue)
    //3. 화면 이동 (이동하기 전에 미리 값은 세팅)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TableViewMain.delegate = self
        TableViewMain.dataSource = self//self = 클래스 안 범위 알아서 찾아감.
        getNews()//뉴스 보여주기 함수 호출
    }

    //tableView: 테이블로된 뷰. 여러개의 행이 모여있는 목록 뷰(화면)
    
    //1. 데이터 내용
    //2. 데이터 개수
    //3.(옵션) 데이터 행 클릭 이벤트 리스너.
}

