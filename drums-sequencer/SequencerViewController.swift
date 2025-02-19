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
    }
    
    func play(sender: PlayerView) {
        SequencerManager.shared.play()
    }
    
    func stop(sender: PlayerView) {
        SequencerManager.shared.stop()
    }
    
    @IBAction func columnsPlus(_ sender: Any) {
        SequencerModel.shared.grid.doubleColumns()
    }
    
    @IBAction func columnsMinus(_ sender: Any) {
        SequencerModel.shared.grid.reduceColumnsByHalf()
    }
}
