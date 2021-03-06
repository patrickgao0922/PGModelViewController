//
//  Animators.swift
//  PGModelViewController
//
//  Created by Patrick Gao on 14/2/18.
//

import UIKit

/// Presentation
class PresentedViewControllerAnimator : NSObject {
    var presentedVC:PGModelViewController!
    var transitionDuration:TimeInterval{
            if let duration = presentedVC.transitionDuration {
                return duration
            }
        return 0.3
            
        
    }
    
    init(forPresented presented:UIViewController) {
        self.presentedVC = presented as! PGModelViewController
        
    }
}

/// Side menu presentation animator
class SideMenuPresentationAnimator:PresentedViewControllerAnimator {
}

extension SideMenuPresentationAnimator:UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView // Container View
        
        // Set up frames for animations
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

/// Notification Presentation Animator
class NotificationPresentationAnimator:PresentedViewControllerAnimator {}
extension NotificationPresentationAnimator:UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        var presentedViewStartFrame:CGRect = .zero
        var presentedViewFinalFrame:CGRect = .zero
        switch presentedVC.traitCollection.horizontalSizeClass {
        case .regular:
            presentedViewStartFrame = CGRect(x: containerView.frame.size.width / 2 - 100, y: 40, width: 0, height: 0)
            presentedViewFinalFrame = CGRect(x: containerView.frame.size.width / 2 - 100, y: 40, width: 200, height: 70)
        default:
            presentedViewStartFrame = CGRect(x: 10, y: 40, width: 0, height: 0)
            presentedViewFinalFrame = CGRect(x: 10, y: 40, width: containerView.frame.size.width - 20, height: 70)
        }
        presentedVC.view.frame = presentedViewStartFrame
        containerView.addSubview(presentedVC.view)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            self.presentedVC.view.frame = presentedViewFinalFrame
        }
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
        var presentedViewFinalFrame = CGRect(x: 0, y: -containerView.frame.size.width / 2, width: containerView.frame.size.width / 2, height: containerView.frame.size.height)
        let presentedViewStartFrame = self.presentedVC.view.frame
        print(presentedViewStartFrame)
        switch presentedVC.direction {
        case .left:
            presentedViewFinalFrame = CGRect(x: -presentedViewStartFrame.size.width, y:0 , width: presentedViewStartFrame.size.width, height: presentedViewStartFrame.size.height)
        case .right:
            presentedViewFinalFrame = CGRect(x: containerView.frame.size.width, y: 0, width: presentedViewStartFrame.size.width, height: presentedViewStartFrame.size.height)
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

/// Notification dismiss animation
class NotificationDismissalAnimator:DismissedViewControllerAnimator {}

extension NotificationDismissalAnimator:UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            self.presentedVC.view.alpha = 0
        }
    }
}
