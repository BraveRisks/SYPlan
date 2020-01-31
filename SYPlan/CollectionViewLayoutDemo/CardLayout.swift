//
//  CardLayout.swift
//  SYPlan
//
//  Created by Ray on 2018/10/31.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

class CardLayout: UICollectionViewLayout {
    
    /// 卡片Item的大小
    public var itemSize: CGSize = CGSize(width: 280.0, height: 240.0) {
        didSet {
            if collectionView != nil { invalidateLayout() }
        }
    }
    
    /// 間距大小
    public var spacing: CGFloat = 15.0 {
        didSet {
            if collectionView != nil { invalidateLayout() }
        }
    }
    
    /// 最多可見的數量
    public var maximumVisibleItems: Int = 3 {
        didSet {
            if collectionView != nil { invalidateLayout() }
        }
    }
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }
        let items = collectionView.numberOfItems(inSection: 0)
        return CGSize(width: collectionView.bounds.width * CGFloat(items), height: collectionView.bounds.height)
    }
    
    override func prepare() {
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    // 滑動時會觸發該方法，此時可改變每個item的屬性
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        
        let offsetX = collectionView.contentOffset.x
        let width = collectionView.bounds.width
        
        let totalItemsCount = collectionView.numberOfItems(inSection: 0)
        
        // 取得目前最上方顯示的index
        let minVisibleIndex = max(0, Int(offsetX) / Int(width))
        
        // 取得目前的index
        // e.g. --> 0 1 2, 1 2 3, 2 3 4
        let maxVisibleIndex = min(totalItemsCount, minVisibleIndex + maximumVisibleItems)
        
        // 取得目前的中心點
        let contentCenterX = offsetX + width / 2
        
        // 取得x軸偏移量
        let deltaOffset = offsetX.truncatingRemainder(dividingBy: width)
        
        // 取得百分比x軸偏移量
        let percentageDeltaOffset = CGFloat(deltaOffset) / width
        //print("min --> \(minVisibleIndex) max --> \(maxVisibleIndex) content --> \(contentCenterX) delta --> \(deltaOffset)")
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for i in minVisibleIndex ..< maxVisibleIndex {
            let indexPath = IndexPath(item: i, section: 0)
            
            // 取得item屬性
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let cardIndex = indexPath.row - minVisibleIndex
            attributes.center = CGPoint(x: contentCenterX,
                                        y: collectionView.bounds.midY + spacing * CGFloat(cardIndex))
            attributes.zIndex = maximumVisibleItems - cardIndex
            
            switch cardIndex {
            case 0:
                attributes.size = itemSize
                attributes.center.x -= CGFloat(deltaOffset)
            case 1 ..< maximumVisibleItems:
                attributes.size = CGSize(width: itemSize.width - (CGFloat(cardIndex) * spacing),
                                         height: itemSize.height - (CGFloat(cardIndex) * spacing))
                attributes.center.y -= spacing * percentageDeltaOffset
            default: break
            }
            visibleLayoutAttributes.append(attributes)
            cache.append(attributes)
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
