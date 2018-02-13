//
//  PGModelViewControllerDelegate.swift
//  Pods
//
//  Created by Patrick Gao on 13/2/18.
//

import UIKit

class PGModelViewControllerDelegate: NSObject {
    var interactor = Interactor()
}

extension PGModelViewControllerDelegate:UIViewControllerTransitioningDelegate {
    
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = PageSheetPresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator(forDismissed:dismissed)
    }
}

class DismissAnimator : NSObject {
    var dismissedVC:UIViewController!
    init(forDismissed dismissed: UIViewController) {
        super.init()
        self.dismissedVC = dismissed
    }
}

extension DismissAnimator : UIViewControllerAnimatedTransitioning {
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
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
