//
//  SequencerViewController.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 18.02.2025.
//

import UIKit

class SequencerViewController: UIViewController {
    
    var gridViewController: GridViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridViewController = children.first(where: {$0 as? GridViewController != nil }) as? GridViewController
    }
}
