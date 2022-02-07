//
//  QHHomeTableHeaderView.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/9.
//

import UIKit

@objc protocol QHHomeTableHeaderViewDelegate {
    func add(_ tableHeaderView: QHHomeTableHeaderView)
    
    func move(_ tableHeaderView: QHHomeTableHeaderView)
    
    func selectItem(_ tableHeaderView: QHHomeTableHeaderView, indexPath: IndexPath)
}

class QHHomeTableHeaderView: UIView {

    public var home: QHHomeModel = QHHomeModel()
    
    convenience init(_ home: QHHomeModel) {
        self.init()
        self.home = home
    }
    
    public weak var delegate: QHHomeTableHeaderViewDelegate?
    
    fileprivate(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 100, height: 40)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = UIColor.clear
        view.dataSource = self
        view.delegate = self
        view.register(R.nib.qhStockTableHeaderViewCell)
        return view
    }()
    
    fileprivate(set) lazy var addView: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(R.image.add(), for: .normal)
        view.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.delegate?.add(self)
        }).disposed(by: rx.disposeBag)
        return view
    }()
    
    fileprivate(set) lazy var moveView: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(R.image.move(), for: .normal)
        view.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.delegate?.move(self)
        }).disposed(by: rx.disposeBag)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        structureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        structureUI()
    }
}

// MARK: Private
extension QHHomeTableHeaderView {
    /** UI */
    fileprivate func structureUI() {
        addSubview(collectionView)
        addSubview(moveView)
        addSubview(addView)
        
        moveView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        addView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.right.equalTo(moveView.snp.left)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(addView.snp.left)
        }
    }
}

// MARK: UICollectionViewDataSource
extension QHHomeTableHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return home.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.qhStockTableHeaderViewCell, for: indexPath) else { return UICollectionViewCell() }
        cell.category = home.categories[indexPath.item]
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension QHHomeTableHeaderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categories = home.categories
        for item in categories.enumerated() { item.element.isSelected = indexPath.item == item.offset }
        home.categories = categories
        collectionView.reloadData()
        delegate?.selectItem(self, indexPath: indexPath)
    }
}
