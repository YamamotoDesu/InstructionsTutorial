//
//  ViewController.swift
//  InstructionsTutorial
//
//  Created by 山本響 on 2021/12/26.
//

import UIKit
import Instructions

class ViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var controlButton: UIButton!
    
    
    let coachMarksController = CoachMarksController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", for: .normal)
        
        self.coachMarksController.overlay.blurEffectStyle = .dark
        self.coachMarksController.overlay.isUserInteractionEnabled = true
        self.coachMarksController.skipView = skipView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if !AppManager.getUserSeenAppInstruction() {
//            self.coachMarksController.start(in: .viewController(self))
//        }
        
        self.coachMarksController.start(in: .viewController(self))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.coachMarksController.stop(immediately: true)
    }

}

extension ViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    
    func coachMarksController(_ coachMarksController: CoachMarksController, didEndShowingBySkipping skipped: Bool) {
        AppManager.setUserSeenAppInstruction()
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 4
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch index {
        case 0: return coachMarksController.helper.makeCoachMark(for: segmentControl)
        case 1: return coachMarksController.helper.makeCoachMark(for: searchTextField)
        case 2: return coachMarksController.helper.makeCoachMark(for: textLabel)
        case 3: return coachMarksController.helper.makeCoachMark(for: controlButton)
        default: return coachMarksController.helper.makeCoachMark()
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        let coachMarkBodyView = CustomCoachMarkBodyView()
        coachMarkBodyView.backgroundColor = .systemBlue
        coachMarkBodyView.layer.cornerRadius = 20
        coachMarkBodyView.hintLabel.textColor = .white
        coachMarkBodyView.clipsToBounds = true
        
        coachViews.arrowView?.background.innerColor = .systemBlue
        coachViews.arrowView?.background.borderColor = .systemBlue
        coachViews.arrowView?.background.highlightedInnerColor = .systemBlue
        coachViews.arrowView?.background.highlightedBorderColor = .systemBlue
        
        var width: CGFloat = 0.0
        
        switch index {
        case 0:
            let hintLabel = "Toggle dark and light mode here!"
            configure(view0: coachMarkBodyView, andUpdateWidth: &width, hintLabel: hintLabel)
        case 1:
            let hintLabel = "Search for your favourite texts here."
            configure(view0: coachMarkBodyView, andUpdateWidth: &width, hintLabel: hintLabel)
        case 2:
            let hintLabel = "Search texxt will appear here when you hit enter"
            configure(view0: coachMarkBodyView, andUpdateWidth: &width, hintLabel: hintLabel)
        case 3:
            let hintLabel = "Hit the control button"
            configure(view0: coachMarkBodyView, andUpdateWidth: &width, hintLabel: hintLabel)
        default: break
        }
        
        return (bodyView: coachMarkBodyView, arrowView: coachViews.arrowView)
    }
    
    // MARK: - Private Helpers
    private func configure(view0 view: CustomCoachMarkBodyView,
                           andUpdateWidth width: inout CGFloat,
                           hintLabel: String) {
        view.hintLabel.text = hintLabel
        view.nextButton.setTitle("OK", for: .normal)
    }

}
