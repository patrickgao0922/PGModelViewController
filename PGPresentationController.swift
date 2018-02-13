//
//  PGPresentationController.swift
//  Pods
//
//  Created by Patrick Gao on 13/2/18.
//

import UIKit


class PGPresentationController: UIPresentationController {
    
    fileprivate var dimmingView:UIView!
    fileprivate var handleView:UIView!
    fileprivate var interactor:Interactor!
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        setupDimmingView()
        
    }
    
    /// When the transition will begin
    override func presentationTransitionWillBegin() {
        //        let containerView = self.containerView
        //        super.presentationTransitionWillBegin()
        self.interactor = (self.presentedViewController.transitioningDelegate as! PGModelViewControllerDelegate).interactor
        dimmingView.frame = self.containerView!.frame
        self.containerView?.insertSubview(dimmingView, at: 0)
        let presentedViewController = self.presentedViewController
        /// Config dimming view
        setupHandleView()
        // Constraints
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[dimmingView]", options: [], metrics: nil, views: ["dimmingView":dimmingView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[dimmingView]", options: [], metrics: nil, views: ["dimmingView":dimmingView]))
        // Layout handleView
        if #available(iOS 11.0, *) {
            self.presentedView?.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
            //            drawTopCornerRadius()
        }
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1
            self.presentedView?.layer.cornerRadius = 10
            
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
            self.presentedView?.layer.cornerRadius = 10
            self.presentingViewController.view!.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
        
        
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0
            self.presentedView?.layer.cornerRadius = 0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
            self.presentedView?.layer.cornerRadius = 0
            //            self.handleView.frame.origin.y = self.containerView!.frame.size.height
            self.presentingViewController.view!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if (!completed) {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override func containerViewDidLayoutSubviews() {
        presentedView?.frame = self.frameOfPresentedViewInContainerView
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame:CGRect = .zero
        
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
        frame.size.height -= 40
        
        frame.origin.y = UIApplication.shared.statusBarFrame.height + 20
        return frame
    }
}

fileprivate extension PGPresentationController {
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        dimmingView.alpha = 0
        
        
    }
    
    func setupHandleView() {
        handleView = UIView()
        //        handleView.frame = CGRect(x: 0, y: self.containerView!.frame.size.height, width: frameOfPresentedViewInContainerView.size.width, height: 20)
        handleView.frame = CGRect(x: 0, y: 0, width: self.presentedView!.frame.size.width, height: 20)
        handleView.backgroundColor = .clear
        let lineLayer = drawHandle()
        lineLayer.position = CGPoint(x: self.handleView.bounds.width / 2, y: self.handleView.bounds.height / 2)
        handleView.layer.addSublayer(lineLayer)
        //        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        //        handleView.addGestureRecognizer(recognizer)
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
        let translation = sender.translation(in: self.containerView)
        let verticalMovement = translation.y / self.containerView!.bounds.height
        
        
        /// Why??
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        
        let progress = CGFloat(downwardMovementPercent)
        guard let interactor = interactor else {return}
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            //            dismiss
            print("Guster started")
            self.presentedViewController.dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            print(progress)
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
    
    
    func drawTopCornerRadius() {
        let maskPath = UIBezierPath.init(roundedRect: self.presentedView!.bounds, byRoundingCorners:[.topLeft, .topRight], cornerRadii: CGSize.init(width: 10.0, height: 10.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.presentedView!.bounds
        maskLayer.path = maskPath.cgPath
        self.presentedView!.layer.mask = maskLayer
    }
    
    @objc
    dynamic func handleTap(recognizer:UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
    
    
}
class Interactor:UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}
