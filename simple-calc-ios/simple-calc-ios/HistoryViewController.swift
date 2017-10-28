//
//  HistoryViewController.swift
//  simple-calc-ios
//
//  Created by Kiwon Jeong on 2017. 10. 25..
//  Copyright © 2017년 Kiwon Jeong. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    public var calcHistory = [String]()
    private var LABEL_HEIGHT = 35
    private var L_R_MARGIN = CGFloat(UIScreen.main.bounds.width - 16)
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let totalHeight = CGFloat(calcHistory.count * LABEL_HEIGHT)
        scrollView.contentSize = CGSize(width: L_R_MARGIN, height: totalHeight)
        
        var margin = 0
        for each in calcHistory {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: Int(L_R_MARGIN), height: LABEL_HEIGHT))
            label.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
            label.text = each
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = NSTextAlignment.center
            let screen = UIScreen.main.bounds.width - 16
            label.center = CGPoint(x: Int(screen/2), y: LABEL_HEIGHT/2 + margin)
            scrollView.addSubview(label)
        
            
            margin = margin + LABEL_HEIGHT + 8
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func closePressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
