//
//  SplitViewController.swift
//  GoogleMap
//
//  Created by loctv on 5/11/18.
//  Copyright © 2018 loctv. All rights reserved.
//

import UIKit

class SplitViewController: UIViewController {
    @IBOutlet weak var masterPane: UIView!
    @IBOutlet weak var detailPane: UIView!
    @IBOutlet weak var masterWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var closeButtonHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.masterWidthConstraint.constant = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateCloseIcon(height: CGFloat) {
        self.closeButtonHeight.constant = height
    }
    
    @IBAction func hideUnhideMaster(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            if self.masterWidthConstraint.constant < 216 {
                self.masterWidthConstraint.constant = 216
            } else {
                self.masterWidthConstraint.constant = 0
            }
            self.view.layoutIfNeeded()
        })
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
