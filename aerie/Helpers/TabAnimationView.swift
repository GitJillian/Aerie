//
//  TabAnimationView.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/1.
//  Copyright © Yejing Li. All rights reserved.
//  Used for tab items switching between tab bar with animated visualization

import Foundation
import UIKit

class TabAnimationView : NSObject, UIViewControllerAnimatedTransitioning {
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destinationView = transitionContext.view(forKey: .to) else{ return }
        
        destinationView.transform = CGAffineTransform(translationX: 0, y: destinationView.frame.height)
        transitionContext.containerView.addSubview(destinationView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            destinationView.transform = .identity
        }, completion: {transitionContext.completeTransition($0)})
    }
}
