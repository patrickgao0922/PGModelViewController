//
//  PGModelViewController.swift
//  FBSnapshotTestCase
//
//  Created by Patrick Gao on 13/2/18.
//

import UIKit

open class PGModelViewController: UIViewController {
    public enum PresentationDirection {
        case left
        case right
    }
    public enum PresentationStyle {
        case iOSNativeMail
        case sideMenu
        case notification
    }
    public var presentationStyle:PresentationStyle = .iOSNativeMail {
        didSet( newPresentationStyle ) {
            switch newPresentationStyle{
            case .notification:
                self.showDimmingView = false
            default:break
            }
        }
    }
    public var direction = PresentationDirection.left
    public var notificationFrame:CGRect?
    public var showDimmingView = true
    public var transitionDuration:TimeInterval?
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    func config() {
        self.modalPresentationStyle = .custom
    }
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        // Do any additional setup after loading the view.
    //    }
    //
    //    override func didReceiveMemoryWarning() {
    //        super.didReceiveMemoryWarning()
    //        // Dispose of any resources that can be recreated.
    //    }
    //
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
}
