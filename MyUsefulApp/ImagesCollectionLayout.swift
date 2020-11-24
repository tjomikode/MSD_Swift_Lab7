//
//  ImagesCollectionLayout.swift
//  MyUsefulApp
//
//  Created by amooyts on 22.11.2020.
//

import Foundation
import UIKit

class ImagesCollectionLayout: UICollectionViewLayout {
    private let numberOfColumns = 4
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
        cache.removeAll()
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = [CGFloat](repeating: 0, count: numberOfColumns)
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            
            var width: CGFloat
            
            if [1, 5].contains(item % 10) {
                width = 2.0 * columnWidth
            } else {
                width = 1.0 * columnWidth
            }
            
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: width, height: width)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: item, section: 0))
            attributes.frame = frame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            if item % 10 == 5 {
                yOffset[2] = yOffset[2] + width
            }
            if item % 10 == 9 {
                yOffset[1] = yOffset[1] + 2 * width
            }
            yOffset[column] = yOffset[column] + width
            
            if item % 10 == 0 {
                column = 1
            }
            
            else if [2, 4, 9].contains(item % 10) {
                column = 0
            }
            
            else if [1, 3, 6, 8].contains(item % 10) {
                column = 3
            }
            
            else if [5, 7].contains(item % 10) {
                column = 2
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
