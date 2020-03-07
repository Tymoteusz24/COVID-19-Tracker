//
//  DiagnoseViewController.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 01/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import UIKit

class DiagnoseViewController: UIViewController {
    @IBOutlet weak var startButton: RoundedButton!
    
    @IBOutlet weak var questionStackView: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var preventionInfoView: UIView!
    
    var diagnoseBrain = DiagnoseBrain()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        if !diagnoseBrain.startedDiagnose {
            preventionInfoView.isHidden = false
            questionStackView.isHidden = true
            startButton.isHidden = false
        } else {
            preventionInfoView.isHidden = true
            questionStackView.isHidden = false
            startButton.isHidden = true
            questionLabel.text = diagnoseBrain.currentQuestionText
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.diagnoseSegue {
            if let destinationVC = segue.destination as? ScoreViewController {
                destinationVC.score = diagnoseBrain.diagnoseScore
            }
        }
    }
    
    @IBAction func answer(_ sender: RoundedButton) {
        if  sender.tag == 1 {
            diagnoseBrain.updateScore(by: diagnoseBrain.currentQuestionPercent)
        }
        if diagnoseBrain.nextQuestion() != nil {
            performSegue(withIdentifier: K.diagnoseSegue, sender: nil)
        }
        updateUI()
    }
    
    @IBAction func startButtonPressed(_ sender: RoundedButton) {
        diagnoseBrain.startDiagnose(true)
        updateUI()
    }
    
}
