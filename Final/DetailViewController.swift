//
//  DetailViewController.swift
//  Final
//
//  Created by DKS_mac on 2019/12/23.
//  Copyright © 2019 dks. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    // 网址
    var link: String?
    
    //var action: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let link = link else {
            fatalError("Target link not set!")
        }
        print("Link: \(link)")
        let url = URL(string: link)!
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
