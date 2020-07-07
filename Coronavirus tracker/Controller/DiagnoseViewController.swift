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
    
    var diagnoseViewModel = DiagnoseViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }

    func updateUI() {
        if !diagnoseViewModel.startedDiagnose {
            preventionInfoView.isHidden = false
            questionStackView.isHidden = true
            startButton.isHidden = false
        } else {
            preventionInfoView.isHidden = true
            questionStackView.isHidden = false
            startButton.isHidden = true
            questionLabel.text = diagnoseViewModel.currentQuestionText
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.diagnoseSegue {
            if let destinationVC = segue.destination as? ScoreViewController {
                destinationVC.score = diagnoseViewModel.diagnoseScore
            }
        }
    }
    
    @IBAction func answer(_ sender: RoundedButton) {
        if  sender.tag == 1 {
            diagnoseViewModel.updateScore(by: diagnoseViewModel.currentQuestionPercent)
        }
        if diagnoseViewModel.nextQuestion() != nil {
            performSegue(withIdentifier: K.diagnoseSegue, sender: nil)
        }
        updateUI()
    }
    
    @IBAction func startButtonPressed(_ sender: RoundedButton) {
        diagnoseViewModel.startDiagnose(true)
        updateUI()
    }
    
}
