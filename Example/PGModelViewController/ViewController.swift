//
//  ViewController.swift
//  PGModelViewController
//
//  Created by patrickgao0922@gmail.com on 02/13/2018.
//  Copyright (c) 2018 patrickgao0922@gmail.com. All rights reserved.
//

import UIKit
import PGModelViewController


class ViewController: UIViewController {

    enum SegueIdentifier:String {
        case iosNativeMail = "showIOSNatvieMailStyle"
    }
    
    var pgModelViewControllerDelegate:PGModelViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pgModelViewControllerDelegate = PGModelViewControllerDelegate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let segueEnum = SegueIdentifier(rawValue: segue.identifier!)!
        switch segueEnum {
        case .iosNativeMail:
            let controller = segue.destination as! IOSNativeMailViewController
            controller.transitioningDelegate = pgModelViewControllerDelegate
        }
    }

}

