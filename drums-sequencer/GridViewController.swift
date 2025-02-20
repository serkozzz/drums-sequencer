//
//  GridViewController.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 17.02.2025.
//

import UIKit
import Combine

private let reuseIdentifier = "Cell"

class GridViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var gridModel = SequencerModel.shared.grid
    
    var dataSource: UICollectionViewDiffableDataSource<Int, UUID>!
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var gridBackgroundView: GridBackgroundView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.collectionViewLayout = createLayout()
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor(_colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)
        
        dataSource = UICollectionViewDiffableDataSource<Int, UUID>(collectionView: collectionView!) {[weak self] collectionView, indexPath, padID in
            
            guard let self else { return nil }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            
            var backgroundConf = cell.defaultBackgroundConfiguration()
            
            if (indexPath.section == 0) {
                let pad = gridModel.pad(uuid: padID)
                backgroundConf.backgroundColor = pad.isActive ? .cyan : .lightGray
                cell.backgroundConfiguration = backgroundConf
            }
            if (indexPath.section == 1) {
                let pad = gridModel.indicator(uuid: padID)
                backgroundConf.backgroundColor = pad.isActive ? .green : .lightGray
                cell.backgroundConfiguration = backgroundConf
            }
            return cell
        }
        
        applySnapshot()
        gridBackgroundView.setColumns(columns: gridModel.columns)
        
        gridModel.indicatorsUpdated.sink { [weak self] _ in
            guard let self = self else { return }
            updateInidcators()
        }.store(in: &cancellables)
        
        
        gridModel.columnsChanged.sink { [weak self] _ in
            guard let self = self else { return }
            applySnapshot()
            gridBackgroundView.setColumns(columns: gridModel.columns)
        }.store(in: &cancellables)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tooglePad")
        gridModel.tooglePad(index: indexPath.item)
        let id = dataSource.itemIdentifier(for: indexPath)!
        
        //applySnapshot()
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([id])
        dataSource.apply(snapshot)
    }
  
    private func updateInidcators() {
        let indicators = gridModel.indicators.map{$0.id}
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems(indicators)
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
    
    private func applySnapshot() {
        print("applySnapshot")
        var snapshot = NSDiffableDataSourceSnapshot<Int, UUID>()
        snapshot.appendSections([0])
        snapshot.appendItems(gridModel.flattenedPadsArray.map { $0.id })
        
        snapshot.appendSections([1])
        snapshot.appendItems(gridModel.indicators.map({ $0.id }))
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}



//MARK: layout
extension GridViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self else { return nil }
            print("createLayout")
            
            let rows = CGFloat(SequencerModel.shared.grid.rows)
            let columns = CGFloat(SequencerModel.shared.grid.columns)
            
            let fractionalGroupHeight = sectionIndex == 0 ? 0.95 / rows : 0.05
    
            let padWidth = collectionView.frame.width / columns

            let horizontalInsets = layoutEnvironment.container.effectiveContentSize.width / columns / 20
            
            let padSize = NSCollectionLayoutSize(widthDimension: .absolute(padWidth), heightDimension: .fractionalHeight( 1))
            let pad = NSCollectionLayoutItem(layoutSize: padSize)
            pad.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: horizontalInsets, bottom: 5, trailing: horizontalInsets)
            
            let padGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight( fractionalGroupHeight))
            let padsGroup = NSCollectionLayoutGroup.horizontal(layoutSize: padGroupSize, subitems: [pad])
            
            let section = NSCollectionLayoutSection(group: padsGroup)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            return section
        }
    }
}
