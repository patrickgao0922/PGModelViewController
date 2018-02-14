//
//  Animators.swift
//  PGModelViewController
//
//  Created by Patrick Gao on 14/2/18.
//

import Foundation

/// Presentation
class PresentedViewControllerAnimator : NSObject {
    var presentedVC:PGModelViewController!
    var transitionDuration:TimeInterval!
    
    init(forPresented presented:UIViewController) {
        self.presentedVC = presented as! PGModelViewController
        self.transitionDuration = 0.3
    }
}

class SideMenuPresentationAnimator:PresentedViewControllerAnimator {
}

extension SideMenuPresentationAnimator:UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let fromView = transitionContext.view(forKey: .from) // from view
//            else {
//                return
//        }
        let containerView = transitionContext.containerView // Container View
        
        // Set up frames for animations
//        let containerFrame = containerView.frame
        var presentedViewStartFrame = CGRect(x: 0, y: -containerView.frame.size.width / 2, width: containerView.frame.size.width / 2, height: containerView.frame.size.height)
        var presentedViewFinalFrame = CGRect(x: 0, y: 0, width: containerView.frame.size.width / 2, height: containerView.frame.size.height)
        switch presentedVC.direction {
        case .left:
            presentedViewStartFrame = CGRect(x: -containerView.frame.size.width / 2, y:0 , width: containerView.frame.size.width / 2, height: containerView.frame.size.height)
            presentedViewFinalFrame = CGRect(x: 0, y: 0, width: containerView.frame.size.width / 2, height: containerView.frame.size.height)
        case .right:
            presentedViewStartFrame = CGRect(x: containerView.frame.size.width, y: 0, width: containerView.frame.size.width / 2, height: containerView.frame.size.height)
            presentedViewFinalFrame = CGRect(x: 0, y: 0, width: containerView.frame.size.width / 2, height: containerView.frame.size.height)
        }
        presentedVC.view.frame = presentedViewStartFrame
        containerView.addSubview(self.presentedVC.view)
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                self.presentedVC.view.frame = presentedViewFinalFrame
        },
            completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        )
    }
}


/// Dismissal
class DismissedViewControllerAnimator : NSObject {
    var presentedVC:PGModelViewController!
    var transitionDuration:TimeInterval!
    init(forDismissed dismissed: UIViewController) {
        super.init()
        self.presentedVC = dismissed as! PGModelViewController
        self.transitionDuration = 0.3
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
                self.presentedVC.view.frame = fromViewFinalFrame
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
        let containerView = transitionContext.containerView // Container View
        
        // Set up frames for animations
        //        let containerFrame = containerView.frame
        var presentedViewFinalFrame = CGRect(x: 0, y: -containerView.frame.size.width / 2, width: containerView.frame.size.width / 2, height: containerView.frame.size.height)
        var presentedViewStartFrame = CGRect(x: 0, y: 0, width: containerView.frame.size.width / 2, height: containerView.frame.size.height)
        switch presentedVC.direction {
        case .left:
            presentedViewFinalFrame = CGRect(x: -containerView.frame.size.width / 2, y:0 , width: containerView.frame.size.width / 2, height: containerView.frame.size.height)
            presentedViewStartFrame = CGRect(x: 0, y: 0, width: containerView.frame.size.width / 2, height: containerView.frame.size.height)
        case .right:
            presentedViewFinalFrame = CGRect(x: containerView.frame.size.width, y: 0, width: containerView.frame.size.width / 2, height: containerView.frame.size.height)
            presentedViewStartFrame = CGRect(x: containerView.frame.size.width / 2, y: 0, width: containerView.frame.size.width / 2, height: containerView.frame.size.height)
        }
        presentedVC.view.frame = presentedViewStartFrame
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                self.presentedVC.view.frame = presentedViewFinalFrame
        },
            completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        )
    }
}
