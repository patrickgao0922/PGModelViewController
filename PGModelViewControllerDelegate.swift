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
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentedVC = presented as! PGModelViewController
        switch presentedVC.presentationStyle {
        case .sideMenu:
            return SideMenuPresentationAnimator(forPresented: presented)
        case .notification:
            return NotificationPresentationAnimator(forPresented: presented)
//        default:
//            return nil
//        }
        
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissedVC = dismissed as! PGModelViewController
        switch dismissedVC.presentationStyle {
        case .iOSNativeMail:
            return iOSNativeMailDismissAnimator(forDismissed:dismissed)
        case .sideMenu:
            return SideMenuDismissAnimator(forDismissed: dismissed)
        case .notification:
            return NotificationDismissalAnimator(forDismissed: dismissed)
//        default:
//            return nil
//        }
        
        
    }
}


