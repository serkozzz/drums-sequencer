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
    
    
    private var padsInRow: CGFloat = 8
    private var rowsNumber: CGFloat = 4
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var dataSource: UICollectionViewDiffableDataSource<Int, UUID>!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.collectionViewLayout = createLayout()
        self.collectionView.delegate = self
        
        dataSource = UICollectionViewDiffableDataSource<Int, UUID>(collectionView: collectionView!) {collectionView, indexPath, padID in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            
            var backgroundConf = cell.defaultBackgroundConfiguration()
            
            if (indexPath.section == 0) {
                let pad = GridModel.shared.pad(uuid: padID)
                backgroundConf.backgroundColor = pad.isActive ? .cyan : .lightGray
                cell.backgroundConfiguration = backgroundConf
            }
            if (indexPath.section == 1) {
                let pad = GridModel.shared.indicator(uuid: padID)
                backgroundConf.backgroundColor = pad.isActive ? .green : .lightGray
                cell.backgroundConfiguration = backgroundConf
            }
            return cell
        }
        applySnapshot()
        
        GridModel.shared.indicatorsUpdated.sink { [weak self] _ in
            guard let self = self else { return }
            updateInidcators()
        }.store(in: &cancellables)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tooglePad")
        GridModel.shared.tooglePad(index: indexPath.item)
        let id = dataSource.itemIdentifier(for: indexPath)!
        
        //applySnapshot()
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([id])
        dataSource.apply(snapshot)
    }
  
    private func updateInidcators() {
//        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<UUID>()
//        var indicators = GridModel.shared.indicators.map{$0.id}
//        sectionSnapshot.append(indicators)
//        dataSource.apply(sectionSnapshot, to: 1, animatingDifferences: true)
        var indicators = GridModel.shared.indicators.map{$0.id}
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems(indicators)
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, UUID>()
        snapshot.appendSections([0])
        snapshot.appendItems(GridModel.shared.flattenedPadsArray.map { $0.id })
        
        snapshot.appendSections([1])
        snapshot.appendItems(GridModel.shared.indicators.map({ $0.id }))
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}



//MARK: layout
extension GridViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self else { return nil }
            
            let fractionalSectionHeight = sectionIndex == 0 ? 0.8 : 0.2
            let padSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth( 1 / padsInRow), heightDimension: .fractionalHeight( 1))
            let pad = NSCollectionLayoutItem(layoutSize: padSize)
            pad.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let padGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight( fractionalSectionHeight / rowsNumber))
            let padsGroup = NSCollectionLayoutGroup.horizontal(layoutSize: padGroupSize, subitems: [pad])
            //padsGroup.interItemSpacing = .fixed(5)
            
            let section = NSCollectionLayoutSection(group: padsGroup)
            return section
        }
    }
}
