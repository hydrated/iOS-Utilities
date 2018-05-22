//
//  FanShapeButton.swift
//  Barracuda-remote
//
//  Created by hydra on 2018/5/21.
//  Copyright © 2018年 hydra. All rights reserved.
//

import UIKit

class FanShapeButton: UIButton {
    
    var path: UIBezierPath
    var fillColor: UIColor = UIColor.white

    required init(path: UIBezierPath) {
        self.path = path
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.path = UIBezierPath()
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        self.path = UIBezierPath()
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        fillColor.setFill()
        self.path.fill()
        UIColor(argb: 0xFFf2f4f7).setStroke()
        self.path.lineWidth = 2
        self.path.stroke()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if (self.path.contains(point)) {
            return self;
        } else {
            return nil;
        }
    }
    
    public func setPath(path: UIBezierPath) {
        self.path = path
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch? = touches.first
        let location: CGPoint? = touch?.location(in: self)
        
        if let local = location, self.hitTest(local, with: nil) != nil {
            fillColor = UIColor(argb: 0xFFf2f4f7)
            setNeedsDisplay()
        } else {
            fillColor = UIColor.white
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        fillColor = UIColor.white
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        fillColor = UIColor.white
        setNeedsDisplay()
    }
}
