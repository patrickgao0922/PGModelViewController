//
//  PGModelViewControllerDelegate.swift
//  Pods
//
//  Created by Patrick Gao on 13/2/18.
//

import UIKit

public class PGModelViewControllerDelegate: NSObject {
    var interactor = Interactor()
}

extension PGModelViewControllerDelegate:UIViewControllerTransitioningDelegate {
    
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = PGPresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissedVC = dismissed as! PGModelViewController
        switch dismissedVC.presentationStyle {
        case .iOSNativeMail:
            return iOSNativeMailDismissAnimator(forDismissed:dismissed)
        case .sideMenu:
            return SideMenuDismissAnimator(forDismissed: dismissed)
        }
        
    }
}


