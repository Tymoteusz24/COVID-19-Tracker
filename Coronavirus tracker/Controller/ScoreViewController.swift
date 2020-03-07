//
//  ScoreViewController.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 01/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let safeScore = score {
            scoreLabel.text = "\(safeScore)%"
        }
        // Do any additional setup after loading the view.
    }
    
   
    
    @IBAction func shareButtonPressed(_ sender: RoundedButton) {
        createScreenShot()
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createScreenShot(){
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var imagesToShare = [AnyObject]()
        imagesToShare.append(image!)

        let activityViewController = UIActivityViewController(activityItems: imagesToShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
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
