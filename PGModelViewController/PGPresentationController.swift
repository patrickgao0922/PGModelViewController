//
//  PGPresentationController.swift
//  Pods
//
//  Created by Patrick Gao on 13/2/18.
//

import UIKit


public class PGPresentationController: UIPresentationController {
    
    fileprivate var dimmingView:UIView?
    fileprivate var handleView:UIView!
    fileprivate var interactor:Interactor!
    fileprivate weak var dismissalTimer:Timer?
    
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
    }
    
    /// When the transition will begin
    override public func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        let presentedVC = presentedViewController as! PGModelViewController
        if presentedVC.showDimmingView {
            setupDimmingView()
        }
        let pgPresentedVC = self.presentedViewController as! PGModelViewController
        switch pgPresentedVC.presentationStyle {
        case .iOSNativeMail:
            iOSNativeMailPresentationTransitionWillBegin()
        case .sideMenu:
            sideMenuPresentationTransitionWillBegin()
        case .notification:
            notificationPresentationTransitionWillBegin()
            //        default:break
        }
    }
    
    
    override public func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        let pgPresentedVC = self.presentedViewController as! PGModelViewController
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            switch pgPresentedVC.presentationStyle {
            case .iOSNativeMail:
                iOSNativeMailDismissalTransitionWillBegin()
            case .sideMenu:
                sideMenuDismissalTransitionWillBegin()
            default:break
            }
            
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView!.alpha = 0
            self.presentedView?.layer.cornerRadius = 0
            //            self.handleView.frame.origin.y = self.containerView!.frame.size.height
            self.presentingViewController.view!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        }, completion: nil)
    }
    
    override public func presentationTransitionDidEnd(_ completed: Bool) {
        if (!completed) {
            //            if dimmingView
            self.dimmingView?.removeFromSuperview()
        }
        let presentedVC = self.presentedViewController as! PGModelViewController
        if presentedVC.presentationStyle == .notification {
            self.NotificationPresentationTransitionDidEnd()
        }
    }
    
    override public func containerViewDidLayoutSubviews() {
        presentedView?.frame = self.frameOfPresentedViewInContainerView
    }
    
    override public var frameOfPresentedViewInContainerView: CGRect {
        let presentedVC = self.presentedViewController as! PGModelViewController
        switch presentedVC.presentationStyle
        {
        case .sideMenu:
            return sideMenuFrame
        case .notification:
            return notificationFrame
        default:
            
            return iOSNativeMailFrame
        }
        
    }
}

fileprivate extension PGPresentationController {
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView!.translatesAutoresizingMaskIntoConstraints = false
        dimmingView!.backgroundColor = UIColor(white: 0, alpha: 0.5)
        dimmingView!.alpha = 0
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimmingView!.addGestureRecognizer(recognizer)
        
        
        dimmingView!.frame = self.containerView!.frame
        self.containerView?.insertSubview(dimmingView!, at: 0)
        self.dimmingView!.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
        self.dimmingView!.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        self.dimmingView!.topAnchor.constraint(equalTo: containerView!.topAnchor).isActive = true
        self.dimmingView!.bottomAnchor.constraint(equalTo: containerView!.bottomAnchor).isActive = true
        
    }
    
    
    func drawTopCornerRadius() {
        let maskPath = UIBezierPath.init(roundedRect: self.presentedView!.bounds, byRoundingCorners:[.topLeft, .topRight], cornerRadii: CGSize.init(width: 10.0, height: 10.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.presentedView!.bounds
        maskLayer.path = maskPath.cgPath
        self.presentedView!.layer.mask = maskLayer
    }
    
    @objc
    dynamic func handleTap(recognizer:UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true)
    }
    
    func commonPresentationBegin() {
        if self.dimmingView != nil {
            self.dimmingView!.alpha = 1
        }
        
        self.presentingViewController.view!.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func commonDismissalBegin() {
        if self.dimmingView != nil {
            dimmingView!.alpha = 0
        }
        
    }
    
}
class Interactor:UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}

// MARK: - iOS Native Mail
extension PGPresentationController {
    var iOSNativeMailFrame:CGRect {
        var frame:CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
        frame.size.height -= 40
        frame.origin.y = UIApplication.shared.statusBarFrame.height + 20
        return frame
    }
    func iOSNativeMailPresentationTransitionWillBegin() {
        self.interactor = (self.presentedViewController.transitioningDelegate as! PGModelViewControllerDelegate).interactor
        let presentedViewController = self.presentedViewController
        /// Config dimming view
        setupHandleView()
        // Constraints
        // Layout handleView
        if #available(iOS 11.0, *) {
            self.presentedView?.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
            //            drawTopCornerRadius()
        }
        guard let coordinator = presentedViewController.transitionCoordinator else {
            commonPresentationBegin()
            self.presentedView?.layer.cornerRadius = 10
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.commonPresentationBegin()
            self.presentedView?.layer.cornerRadius = 10
        })
    }
    
    func iOSNativeMailDismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            commonDismissalBegin()
            self.presentedView?.layer.cornerRadius = 0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.commonDismissalBegin()
            self.presentedView?.layer.cornerRadius = 0
        })
    }
    
    func setupHandleView() {
        handleView = UIView()
        handleView.frame = CGRect(x: 0, y: 0, width: self.presentedView!.frame.size.width, height: 20)
        handleView.backgroundColor = .clear
        let lineLayer = drawHandle()
        lineLayer.position = CGPoint(x: self.handleView.bounds.width / 2, y: self.handleView.bounds.height / 2)
        handleView.layer.addSublayer(lineLayer)
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(sender:)))
        self.handleView.addGestureRecognizer(panRecognizer)
        self.presentedView!.addSubview(handleView)
    }
    
    func drawHandle() -> CAShapeLayer{
        let handleShape = CAShapeLayer()
        handleShape.lineCap = kCALineCapRound
        handleShape.lineWidth = 5
        handleShape.strokeColor = UIColor(white: 1, alpha: 0.5).cgColor
        
        handleShape.frame = CGRect(x: 0, y: 0, width: 50, height: 5)
        handleShape.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        let linePath = UIBezierPath()
        linePath.move(to: .zero)
        linePath.addLine(to: CGPoint(x: 50, y: 0))
        
        handleShape.path = linePath.cgPath
        
        return handleShape
    }
    
    @objc
    dynamic func handleDrag(sender:UIPanGestureRecognizer) {
        
        let percentThreshold:CGFloat = 0.5
        let translation = sender.translation(in: self.presentedView)
        print(translation)
        let verticalMovement = translation.y / self.presentedView!.bounds.height
        
        
        /// Why??
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        
        let progress = CGFloat(downwardMovementPercent)
        guard let interactor = interactor else {return}
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            //            dismiss
            self.presentedViewController.dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish ? interactor.finish():interactor.cancel()
        default:
            break
        }
    }
}

// MARK: - Side Menu
extension PGPresentationController {
    var sideMenuFrame:CGRect {
        let presentedVC = self.presentedViewController as! PGModelViewController
        var frame:CGRect = .zero
        switch traitCollection.horizontalSizeClass {
        case .regular:
            frame.size = CGSize(width:containerView!.frame.size.width / 3,height:containerView!.frame.size.height)
        default:
            frame.size = CGSize(width:containerView!.frame.size.width / 2,height:containerView!.frame.size.height)
        }
        
        switch presentedVC.direction {
        case .left:
            frame.origin = CGPoint(x: 0,y: 0)
        case .right:
            frame.origin = CGPoint(x: containerView!.frame.size.width - frame.width, y: 0)
        }
        return frame
    }
    func sideMenuPresentationTransitionWillBegin() {
        
        let presentedViewController = self.presentedViewController
        guard let coordinator = presentedViewController.transitionCoordinator else {
            commonPresentationBegin()
            
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.commonPresentationBegin()
        })
    }
    
    func sideMenuDismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            commonDismissalBegin()
            
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.commonDismissalBegin()
        })
    }
}

// MARK: - Notification
extension PGPresentationController {
    
    var notificationContainerFrame:CGRect{
        let presentedVC = self.presentedViewController as! PGModelViewController
        if let frame = presentedVC.notificationFrame {
            return frame
        }
        var frame = CGRect(x: 10, y: UIApplication.shared.statusBarFrame.size.height, width: containerView!.frame.size.width - 20, height: 70)
        if traitCollection.horizontalSizeClass == .regular {
            frame = CGRect(x: containerView!.frame.size.width / 2 - 100, y: UIApplication.shared.statusBarFrame.size.height, width: 200, height: 70)
        }
        return frame
    }
    
    var notificationFrame:CGRect {
        let presentedVC = self.presentedViewController as! PGModelViewController
        if let frame = presentedVC.notificationFrame {
            return CGRect(origin: .zero, size: frame.size)
        }
        var frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 20, height: 70)
        if traitCollection.horizontalSizeClass == .regular {
            frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        }
        return frame
    }
    func notificationPresentationTransitionWillBegin() {
        
        let presentedViewController = self.presentedViewController as! PGModelViewController
        self.containerView!.frame = self.notificationContainerFrame
        guard let coordinator = presentedViewController.transitionCoordinator else {
            commonPresentationBegin()
            
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.commonPresentationBegin()
        })
    }
    func NotificationPresentationTransitionDidEnd () {
        if #available(iOS 10.0, *) {
            dismissalTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { (timer) in
                self.presentedViewController.dismiss(animated: true, completion: nil)
            })
        } else {
            // Fallback on earlier versions
            
            dismissalTimer = Timer(timeInterval: 5.0, target: self, selector: #selector(self.dismissAction), userInfo: nil, repeats: false)
            
        }
    }
    @objc func dismissAction() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}
