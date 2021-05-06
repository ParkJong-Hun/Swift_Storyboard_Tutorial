//
//  NewsDetailController.swift
//  chapter8
//
//  Created by 박종훈 on 2021/05/06.
//

import UIKit

class NewsDetailController : UIViewController {
    
    @IBOutlet weak var ImageMain: UIImageView!
    @IBOutlet weak var LabelMain: UILabel!
    
    //1. Image URL
    //2. Description
    
    var imageUrl: String?
    var desc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ok
        if let img = imageUrl {
            //이미지 뿌림
            //Data
            if let data = try? Data(contentsOf: URL(string: img)!) {
                //Main Thread
                DispatchQueue.main.async {
                    self.ImageMain.image = UIImage(data: data)
                }
                
            }
        }
        
        if let d = desc {
            //본문 보여줌
            self.LabelMain.text = d
        }
    }
}
