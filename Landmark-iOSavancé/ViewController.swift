//
//  ViewController.swift
//  Landmark-iOSavancé
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {
    enum Section: CaseIterable {
        case main
        case lakes
        case mountains
        case rivers
    }
    
    enum Item: Hashable {
        case favorite(Landmark, UUID = UUID())
        case category(Landmark, UUID = UUID())
    }
    
    var landmarks: [Landmark] = []
    var landmarkSelected: Landmark?
    var diffableDataSource : UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "HeaderCollectionReusableView")
        
        let nibCategoryLandmarkCell = UINib(nibName: "CellCategory", bundle: nil)
            collectionView.register(nibCategoryLandmarkCell, forCellWithReuseIdentifier: "CellCategory")
        
        configureDataSource()
        collectionView.collectionViewLayout = createLayout()
        // Do any additional setup after loading the view.
        if let jsonData = readLocalJSONFile() {
            do {
                landmarks = try JSONDecoder().decode([Landmark].self, from: jsonData)
            } catch {
                print("error: \(error)")
            }
        }
        
        let snapshot = createSnapshot()
        diffableDataSource.apply(snapshot)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = diffableDataSource.itemIdentifier(for: indexPath), let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        switch item {
        case .category:
            performSegue(withIdentifier: "detail", sender: cell)
        case .favorite:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" , let destinationViewController = segue.destination as? DetailViewController {
            guard let cell = sender as? UICollectionViewCell,
                  let indexPath = collectionView.indexPath(for: cell),
                  let item = diffableDataSource.itemIdentifier(for: indexPath)
            else {
                return
            }
            switch item {
            case .category(let landmark, _),
                    .favorite(let landmark, _):
            destinationViewController.landmark = landmark
            }
        }
    }
    
    private func configureDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .favorite(let landmark, _):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
                cell.configure(landmark: landmark )
                //cell.contentView.backgroundColor = UIColor.gray

                return cell
            case .category(let landmark, _):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCategory", for: indexPath) as! CellCategory
                cell.configure(landmark: landmark )
                
                return cell
            }
        })
        
        diffableDataSource.supplementaryViewProvider = { [weak self] collectionView, elementKind, indexPath in
            switch elementKind {
            case UICollectionView.elementKindSectionHeader:
                guard let section = self?.diffableDataSource.sectionIdentifier(for: indexPath.section),
                 let header = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as? HeaderCollectionReusableView else {
                return nil
              }
                
                switch section {
                case .main:
                    return nil
                case .rivers:
                    header.configureHeader(title: "Rivers")
                case .lakes:
                    header.configureHeader(title: "Lakes")
                case .mountains:
                    header.configureHeader(title: "Mountains")
                }
              return header
            default:
              return nil
            }
        }
    }
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        for section in Section.allCases {
            switch section {
            case .main:
                snapshot.appendSections([Section.main])
                let items = landmarks.filter { landmark in
                    return landmark.isFavorite == true
                }.map { landmark in
                    return Item.favorite(landmark)
                }
                snapshot.appendItems(items, toSection: .main)
            case .lakes:
                snapshot.appendSections([Section.lakes])
                let items = landmarks.filter { landmark in
                    switch landmark.category {
                    case .lakes:
                        return true
                    default:
                        return false
                    }
                }.map { landmark in
                    return Item.category(landmark)
                }
                snapshot.appendItems(items, toSection: .lakes)
            case .mountains:
                snapshot.appendSections([Section.mountains])
                let items = landmarks.filter { landmark in
                    switch landmark.category {
                    case .mountains:
                        return true
                    default:
                        return false
                    }
                }.map { landmark in
                    return Item.category(landmark)
                }
                snapshot.appendItems(items, toSection: .mountains)
            case .rivers:
                snapshot.appendSections([Section.rivers])
                let items = landmarks.filter { landmark in
                    switch landmark.category {
                    case .rivers:
                        return true
                    default:
                        return false
                    }
                }.map { landmark in
                    return Item.category(landmark)
                }
                snapshot.appendItems(items, toSection: .rivers)
            }
        }
        
        return snapshot
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, collectionLayoutEnvironment in
            guard let section = self?.diffableDataSource.sectionIdentifier(for: sectionIndex) else {
                return nil
            }
            switch section {
            case .main:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .fractionalHeight(0.5))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitem: item,
                                                               count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0
                section.orthogonalScrollingBehavior = . continuous
                
                return section
                
            case .lakes:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                       heightDimension: .fractionalWidth(0.5))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitem: item,
                                                               count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 2
                section.orthogonalScrollingBehavior = .continuous
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .absolute(50))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [headerItem]
                //section.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10)
                return section
                
            case .mountains:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 2
                section.orthogonalScrollingBehavior = . continuous
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [headerItem]
                
                return section
                
            case .rivers:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 2
                section.orthogonalScrollingBehavior = . continuous
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [headerItem]
                
                return section
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 50
        layout.configuration = config
        
        return layout
    }
    
    func readLocalJSONFile() -> Data? {
        do {
            if let file = (Bundle.main.url(forResource: "landmarkData", withExtension: "json")) {
                
                let data = try Data(contentsOf: file)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
}

