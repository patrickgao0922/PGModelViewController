//
//  Animators.swift
//  PGModelViewController
//
//  Created by Patrick Gao on 14/2/18.
//

import Foundation

class DismissedViewControllerAnimator : NSObject {
    var dismissedVC:UIViewController!
    var transitionDuration:TimeInterval!
    init(forDismissed dismissed: UIViewController) {
        super.init()
        self.dismissedVC = dismissed
        self.transitionDuration = 0.6
    }
}
/// iOS Native Mail Animation
class iOSNativeMailDismissAnimator : DismissedViewControllerAnimator {}

extension iOSNativeMailDismissAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Retrieving VC and Views
        guard let fromView = transitionContext.view(forKey: .from) // from view
            else {
                return
        }
        let containerView = transitionContext.containerView // Container View
        
        // Set up frames for animations
        let containerFrame = containerView.frame
        let fromViewFinalFrame = CGRect(x: 0, y: containerFrame.size.height, width: fromView.frame.size.width, height: fromView.frame.size.height)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                self.dismissedVC.view.frame = fromViewFinalFrame
        },
            completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        )
    }
}

/// Side Menu Dismiss Animation
class SideMenuDismissAnimator : DismissedViewControllerAnimator {}

extension SideMenuDismissAnimator:UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    }
}
