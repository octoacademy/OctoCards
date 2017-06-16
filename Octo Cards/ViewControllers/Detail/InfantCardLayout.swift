//
//  InfantCardLayout.swift
//  Octo Cards
//
//  Created by Macbook on 6/15/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//


import UIKit

class InfantCardLayout: UICollectionViewFlowLayout {
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let collectionViewSize = self.collectionView!.bounds.size
        
        let proposedRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionViewSize.width, height: collectionViewSize.height)
        
        var lastInRectWidth : CGFloat = 0
         var candidateAttributes: UICollectionViewLayoutAttributes?
        for attributes in self.layoutAttributesForElements(in: proposedRect)! {
            // We can skip header and footer. We only care about cell
            if attributes.representedElementCategory != .cell {
                continue
            }
            
            // Get collectionView current scroll position
            let currentOffset = self.collectionView!.contentOffset
            
            // Don't even bother with items on opposite direction
            if (attributes.center.x <= (currentOffset.x + collectionViewSize.width * 0.5) && velocity.x > 0) || (attributes.center.x >= (currentOffset.x + collectionViewSize.width * 0.5) && velocity.x < 0) {
                  continue
            }
            
            //Find out which is the biggest rect on the screen and show in the middle
            var inRectWidth : CGFloat = 0
            
            if attributes.frame.origin.x < proposedRect.origin.x
            {
                inRectWidth = (attributes.frame.origin.x + attributes.frame.width) - proposedRect.origin.x
            }
            else if attributes.frame.size.width + attributes.frame.origin.x < proposedRect.origin.x + proposedRect.size.width
            {
                inRectWidth = attributes.frame.size.width
            }
            else
            {
                inRectWidth = (proposedRect.origin.x + proposedRect.size.width) - attributes.frame.origin.x
            }
            
            if lastInRectWidth == 0 || inRectWidth >= lastInRectWidth
            {
                lastInRectWidth = inRectWidth
                candidateAttributes = attributes
            }
        }
        
        if candidateAttributes != nil {
            // Great, we have a candidate
            return CGPoint(x: candidateAttributes!.center.x - collectionViewSize.width * 0.5, y: proposedContentOffset.y)
            
        } else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        
    }
}
