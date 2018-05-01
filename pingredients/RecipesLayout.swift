//
//  RecipesLayout.swift
//  pingredients
//
//  Created by Catherine Bostian on 1/24/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import UIKit

protocol RecipesLayoutDelegate: class {
    func heightForPhoto(at indexPath: IndexPath, width: CGFloat) -> CGFloat

    func heightForCaption(at indexPath:IndexPath, width: CGFloat) -> CGFloat
}

struct AppUtility {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {

        self.lockOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}

class RecipesLayout: UICollectionViewLayout {
    var delegate: RecipesLayoutDelegate?

    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return (collectionView!.bounds.width - (insets.left + insets.right))
    }

    var attributesCache = [RecipesLayoutAttributes]()

    override func prepare() {
        if attributesCache.isEmpty {
            let columnWidth = contentWidth / CGFloat(Constants.columns)
            let cellWidth = columnWidth

            var yOffsets = [CGFloat](repeating: 0, count: Constants.columns)

            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                //place the item in the shortest column to keep columns balanced
                var column = 0
                for (offsetIndex, offset) in yOffsets.enumerated() {
                    if offset < yOffsets[column] {
                        column = offsetIndex
                    }
                }
                let indexPath = IndexPath(item: item, section: 0)

                // calculate the frame
                let photoHeight: CGFloat = (delegate?.heightForPhoto(at: indexPath, width: cellWidth))!
                let captionHeight: CGFloat = (delegate?.heightForCaption(at: indexPath, width: cellWidth))!

                let cellHeight: CGFloat = photoHeight + captionHeight
                let frame = CGRect(x: CGFloat(column) * columnWidth, y: yOffsets[column], width: columnWidth, height: cellHeight)
                let insetFrame = frame.insetBy(dx: Constants.cellPadding, dy: Constants.cellPadding)

                // create layout attributes
                let attributes = RecipesLayoutAttributes(forCellWith: indexPath)
                attributes.photoHeight = photoHeight
                attributes.frame = insetFrame
                attributesCache.append(attributes)

                // update column, yOffset
                contentHeight = max(contentHeight, frame.maxY)
                yOffsets[column] = yOffsets[column] + cellHeight
            }
        }
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in attributesCache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }

        return layoutAttributes
    }
}

class RecipesLayoutAttributes: UICollectionViewLayoutAttributes
{
    var photoHeight: CGFloat = 0.0

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! RecipesLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? RecipesLayoutAttributes {
            if attributes.photoHeight == photoHeight {
                return super.isEqual(object)
            }
        }

        return false
    }
}
