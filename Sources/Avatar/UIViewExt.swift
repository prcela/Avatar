//
//  File.swift
//  
//
//  Created by Kresimir Prcela on 22.10.2022..
//

import Foundation
import UIKit

extension UIView {
    func embedSubview(_ view: UIView, edgeInsets: UIEdgeInsets = .zero) {
        view.frame = bounds
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let views:[String:Any] = ["intoView":self, "view":view]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(edgeInsets.left)-[view]-\(edgeInsets.right)-|",
                                                         options:[],
                                                         metrics:nil,
                                                         views:views)
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(edgeInsets.top)-[view]-\(edgeInsets.bottom)-|",
                                                      options:[],
                                                      metrics:nil,
                                                      views:views)
        
        addConstraints(constraints)
        layoutIfNeeded()
    }
    
    func image() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
}
