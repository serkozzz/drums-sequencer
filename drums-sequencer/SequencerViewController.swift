//
//  SequencerViewController.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 18.02.2025.
//

import UIKit

class SequencerViewController: UIViewController, PlayerViewDelegate {
    
    @IBOutlet weak var playerView: PlayerView!
    var gridViewController: GridViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.delegate = self
        gridViewController = children.first(where: {$0 as? GridViewController != nil }) as? GridViewController
        
        NotificationCenter.default.addObserver(self, selector: #selector(tick(_:)), name: .sequencerTimer, object: nil)
        
    }
    
    func play(sender: PlayerView) {
        SequencerTimer.shared.start()
        
    }
    
    func stop(sender: PlayerView) {
        
    }
    
    @objc func tick(_ notification: Notification) {
        if let noteNumber = notification.userInfo?["noteNumber"] as? Int {
            print("noteNumber \(noteNumber)")
            GridModel.shared.lightIndicator(noteNumber: noteNumber)
        }
    }
}
