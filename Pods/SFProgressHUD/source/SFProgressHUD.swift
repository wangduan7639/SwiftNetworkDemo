//
//  SFProgressHUD.swift
//  SFProgressHUD
//
//  Created by Edmond on 8/22/15.
//  Copyright © 2015 XueQiu. All rights reserved.
//

import UIKit

public class SFRoundProgressView : UIView {
    var annular = false {
        didSet {
            setNeedsDisplay()
        }
    }
    var progress : CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var progressTintColor = UIColor(white:0.5, alpha:1.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    var backgroundTintColor = UIColor(white:1.0, alpha:1.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:CGRectMake(0, 0, 37, 37))
        backgroundColor = UIColor.clearColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func drawRect(rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            let circleRect = CGRectInset(bounds, 2.0, 2.0)
            let pi = CGFloat(M_PI)
            let startAngle = -pi / 2.0 // 90 degrees
            let lineW : CGFloat = 2.0
            let center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
            if annular {
                // Draw background
                var endAngle = 2.0 * pi + startAngle
                let radius = (CGRectGetWidth(bounds) - lineW)/2
                let processBackgroundPath = UIBezierPath()
                processBackgroundPath.lineWidth = lineW
                processBackgroundPath.lineCapStyle = .Butt
                processBackgroundPath.addArcWithCenter(center, radius:radius, startAngle:startAngle, endAngle:endAngle, clockwise:true)
                backgroundTintColor.set()
                processBackgroundPath.stroke()
                
                // Draw progress
                let processPath = UIBezierPath()
                processPath.lineCapStyle = .Square
                processPath.lineWidth = lineW
                endAngle = progress * 2 * pi + startAngle
                processPath.addArcWithCenter(center, radius:radius, startAngle:startAngle, endAngle:endAngle, clockwise:true)
                progressTintColor.set()
                processPath.stroke()
            } else {
                // Draw background
                progressTintColor.setStroke()
                backgroundTintColor.setFill()
                CGContextSetLineWidth(context, 2.0)
                CGContextFillEllipseInRect(context, circleRect)
                CGContextStrokeEllipseInRect(context, circleRect)
                // Draw progress
                let radius = (CGRectGetWidth(bounds) - 4) / 2
                let endAngle = progress * 2 * pi + startAngle
                progressTintColor.setFill()
                CGContextMoveToPoint(context, center.x, center.y)
                CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0)
                CGContextClosePath(context)
                CGContextFillPath(context)
            }
        }
        super.drawRect(rect)
    }
}


/// Provides the general look and feel of the APPLE HUD,
/// into which the eventual content is inserted.
public class SFEffectView : UIVisualEffectView {
    private var _content = UIView()
    private var content: UIView {
        get {
            return _content
        }
        set {
            _content.removeFromSuperview()
            _content = newValue
            _content.alpha = 0.85
            _content.clipsToBounds = true
            _content.contentMode = .Center
            frame.size = _content.bounds.size
            addSubview(_content)
        }
    }
    
    init() {
        super.init(effect: UIBlurEffect(style: .Light))
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor(white: 0.8, alpha: 0.36)
        layer.cornerRadius = 9.0
        layer.masksToBounds = true
        contentView.addSubview(content)
        
        let offset = 20.0
        let motionEffectsX = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        motionEffectsX.maximumRelativeValue = offset
        motionEffectsX.minimumRelativeValue = -offset
        
        let motionEffectsY = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        motionEffectsY.maximumRelativeValue = offset
        motionEffectsY.minimumRelativeValue = -offset
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [motionEffectsX, motionEffectsY]
        addMotionEffect(group)
    }
}



/**
* Displays a simple HUD window containing a progress indicator and two optional labels for short messages.
*
* This is a simple drop-in class for displaying a progress HUD view similar to Apple's private UIProgressHUD class.
* The ProgressHUD window spans over the entire space given to it by the initWithFrame constructor and catches all
* user input on this region, thereby preventing the user operations on components below the view. The HUD itself is
* drawn centered as a rounded semi-transparent view which resizes depending on the user specified content.
*
* This view supports four modes of operation:
*  - ProgressHUDModeIndeterminate - shows a UIActivityIndicatorView
*  - ProgressHUDModeDeterminate - shows a custom round progress indicator
*  - ProgressHUDModeAnnularDeterminate - shows a custom annular progress indicator
*  - ProgressHUDModeCustomView - shows an arbitrary, user specified view (see `customView`)
*
* All three modes can have optional labels assigned:
*  - If the labelText property is set and non-empty then a label containing the provided content is placed below the
*    indicator view.
*  - If also the detailsLabelText property is set then another label is placed below the first label.
*/

let kPadding: CGFloat = 4.0

public class SFProgressHUD : UIView {
    
    var mode: SFProgressHUDMode = .Indeterminate
    var customView : UIView? = nil {
        didSet {
            if let indicator = indicator {
                indicator.removeFromSuperview()
            }
            addSubview(customView!)
        }
    }
    var indicator : UIView? = nil
    var effectView = SFEffectView()
    
    var progress : Float = 0.0
    
    var opacity: CGFloat = 0.9
    var xOffset: CGFloat = 0.0
    var yOffset: CGFloat = 0.0
    var margin: CGFloat = 20.0
    var cornerRadius: CGFloat = 10.0
    var graceTime: Float = 0.0
    var minShowTime: NSTimeInterval = 0.0
    var minSize = CGSizeZero
    var size = CGSizeZero
    var square = false
    var dimBackground = false
    
    private var isFinished = false
    private var taskInProgress = false
    private var rotationTransform = CGAffineTransformIdentity
    private var showStarted: NSDate? = nil
    private var graceTimer: NSTimer? = nil
    private var minShowTimer: NSTimer? = nil
    
    
    /// MARK: class Method
    public class func showHUD(onView: UIView) -> SFProgressHUD {
        let hud = SFProgressHUD(onView:onView)
        hud.show()
        return hud
    }
    
    public class func hideHUD(onView: UIView) -> Bool {
        if let hud = SFProgressHUD.getHUD(onView) {
            hud.hide()
            return true
        } else {
            return false
        }
    }
    
    public class func hideAllHUD(onView: UIView) -> Bool {
        var result = false
        if let huds = SFProgressHUD.getAllHUD(onView) {
            for hud in huds {
                hud.hide()
            }
            result = true
        }
        return result
    }
    
    public class func getHUD(onView: UIView) -> SFProgressHUD? {
        for case let hud as SFProgressHUD in onView.subviews {
            return hud
        }
        return nil
    }
    
    public class func getAllHUD(onView: UIView) -> [SFProgressHUD]? {
        var huds = [SFProgressHUD]()
        for case let hud as SFProgressHUD in onView.subviews {
            huds.append(hud)
        }
        return huds.count > 0 ? huds : nil
    }
    
    
    /// show && hide
    
    public func show() {
        assert(NSThread.isMainThread(), "ProgressHUD needs to be accessed on the main thread.")
        if graceTime > 0.0 {
            let timer = NSTimer(timeInterval:1.0, target:self, selector:"handleGraceTimer:",
                userInfo:nil, repeats:false)
            NSRunLoop.currentRunLoop().addTimer(timer, forMode:NSRunLoopCommonModes)
        } else {
            showUsingAnimation()
        }
    }
    
    public func hide() {
        assert(NSThread.isMainThread(), "ProgressHUD needs to be accessed on the main thread.")
        
        // If the minShow time is set, calculate how long the hud was shown,
        // and pospone the hiding operation if necessary
        if let showStarted = showStarted where minShowTime > 0.0 {
            let interv = NSDate().timeIntervalSinceDate(showStarted)
            if interv < minShowTime {
                minShowTimer = NSTimer.scheduledTimerWithTimeInterval(minShowTime - interv, target:self, selector:"hideUseAnimation", userInfo:nil, repeats:false)
                return
            }
        }
        // ... otherwise hide the HUD immediately
        hideUseAnimation()
    }
    
    public func hide(animated: Bool, afterDelay: UInt64) {
        dispatch_after(dispatch_time(DISPATCH_TIME_FOREVER, Int64(afterDelay * NSEC_PER_SEC)),dispatch_get_main_queue()) { () -> Void in
            self.hide()
        }
    }
    
    // Timer CallBack
    private func handleGraceTimer(timer: NSTimer) {
        if taskInProgress {
            showUsingAnimation()
        }
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        _sf_updateForCurrentOrientationAnimated(false)
    }
    
    
    private func showUsingAnimation() {
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
        setNeedsDisplay()
        showStarted = NSDate()
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.alpha = 1.0
        })
    }
    
    private func hideUseAnimation() {
        if let _ = showStarted {
            UIView.animateWithDuration(0.3,
                animations: { () -> Void in
                    self.alpha = 0.02
                }, completion: { (finished) -> Void in
                    self.done()
                    self.showStarted = nil
            })
        }
    }
    
    private func done() {
        isFinished = true
        alpha = 0.0
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
        removeFromSuperview()
    }
    
    init(onView: UIView) {
        super.init(frame:onView.bounds)
        alpha = 0.0
        opaque = false
        backgroundColor = UIColor.clearColor()
        contentMode = .Center
        taskInProgress = false
        rotationTransform = CGAffineTransformIdentity
        
        addSubview(effectView)
        addSubview(label)
        addSubview(detailsLabel)
        
        _sf_updateIndicator()
        
        onView.addSubview(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        // Entirely cover the parent view
        if let parent = superview {
            frame = parent.bounds
        }
        
        // Determine the total widt and height needed
        let maxWidth = bounds.size.width - 4 * margin
        var totalSize = CGSizeZero
        
        var indicatorF = CGRectZero
        if let indicator = indicator {
            indicatorF = indicator.bounds
            indicatorF.size.width = min(indicatorF.size.width, maxWidth)
            totalSize.width = max(totalSize.width, indicatorF.size.width)
            totalSize.height += indicatorF.size.height
        }
        
        var labelSize = _sf_textSize(label.text, font:label.font)
        labelSize.width = min(labelSize.width, maxWidth)
        totalSize.width = max(totalSize.width, labelSize.width)
        totalSize.height += labelSize.height
        if (labelSize.height > 0.0 && indicatorF.size.height > 0.0) {
            totalSize.height += kPadding
        }
        
        let remainingHeight = bounds.size.height - totalSize.height - kPadding - 4 * margin
        let maxSize = CGSizeMake(maxWidth, remainingHeight)
        let detailsLabelSize = _sf_mutilLineTextSize(detailsLabel.text, font:detailsLabel.font, maxSize:maxSize)
        totalSize.width = max(totalSize.width, detailsLabelSize.width)
        totalSize.height += detailsLabelSize.height
        if (detailsLabelSize.height > 0.0 && (indicatorF.size.height > 0.0 || labelSize.height > 0.0)) {
            totalSize.height += kPadding
        }
        
        totalSize.width += 2 * margin
        totalSize.height += 2 * margin
        
        // Position elements
        var yPos = round(((bounds.size.height - totalSize.height) / 2)) + margin + yOffset
        let xPos = xOffset
        indicatorF.origin.y = yPos
        indicatorF.origin.x = round((bounds.size.width - indicatorF.size.width) / 2) + xPos
        if let indicator = indicator {
            indicator.frame = indicatorF
        }
        yPos += indicatorF.size.height
        
        if (labelSize.height > 0.0 && indicatorF.size.height > 0.0) {
            yPos += kPadding
        }
        var labelF = CGRectZero
        labelF.origin.y = yPos
        labelF.origin.x = round((bounds.size.width - labelSize.width) / 2) + xPos
        labelF.size = labelSize
        label.frame = labelF
        yPos += labelF.size.height
        
        if (detailsLabelSize.height > 0.0 && (indicatorF.size.height > 0.0 || labelSize.height > 0.0)) {
            yPos += kPadding
        }
        var detailsLabelF = CGRectZero
        detailsLabelF.origin.y = yPos
        detailsLabelF.origin.x = round((bounds.size.width - detailsLabelSize.width) / 2) + xPos
        detailsLabelF.size = detailsLabelSize
        detailsLabel.frame = detailsLabelF
        
        // Enforce minsize and quare rules
        if (square) {
            let maxValue = max(totalSize.width, totalSize.height)
            if (maxValue <= bounds.size.width - 2 * margin) {
                totalSize.width = maxValue
            }
            if (maxValue <= bounds.size.height - 2 * margin) {
                totalSize.height = maxValue
            }
        }
        if (totalSize.width < minSize.width) {
            totalSize.width = minSize.width
        }
        if (totalSize.height < minSize.height) {
            totalSize.height = minSize.height
        }
        
        size = totalSize
    }
    
    public override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        UIGraphicsPushContext(context!)
        
        if dimBackground {
            //Gradient colours
            let gradLocationsNum: size_t = 2
            let gradLocations: [CGFloat] = [0.0, 1.0]
            let gradColors: [CGFloat] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.75]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
            
            //Gradient center
            let gradCenter = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
            //Gradient radius
            let gradRadius = min(CGRectGetWidth(bounds), CGRectGetHeight(bounds))
            //Gradient draw
            CGContextDrawRadialGradient(context, gradient, gradCenter, 0, gradCenter, gradRadius, .DrawsAfterEndLocation)
        }
        
        // Set background rect color
        //        if let color = color {
        //            CGContextSetFillColorWithColor(context, color.CGColor)
        //        } else {
        CGContextSetGrayFillColor(context, 0.0, opacity)
        //        }
        
        
        // Draw rounded HUD backgroud rect
        var boxRect = CGRectMake(round((CGRectGetWidth(bounds) - size.width) / 2) + xOffset,
            round((CGRectGetHeight(bounds) - size.height) / 2) + yOffset, size.width, size.height)
        boxRect = CGRectIntegral(boxRect)
        let radius = cornerRadius
        
        effectView.bounds = boxRect
        effectView.center = self.center
        effectView.layer.cornerRadius = radius
        
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect))
        CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, CGFloat(3 * M_PI / 2), 0, 0)
        CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, CGFloat(M_PI / 2), 0)
        CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, CGFloat(M_PI / 2), CGFloat(M_PI), 0)
        CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, CGFloat(M_PI),
            CGFloat(3 * M_PI / 2), 0)
        CGContextClosePath(context)
        CGContextFillPath(context)
        
        UIGraphicsPopContext()
    }
    
    // MARK: Notifications
    
    func _sf_registeNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"statusBarOrientationDidChange:", name:UIApplicationDidChangeStatusBarOrientationNotification, object:nil)
    }
    
    func _sf_unregisteNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIApplicationDidChangeStatusBarOrientationNotification, object:nil)
    }
    
    func statusBarOrientationDidChange(notification: NSNotification) {
        if let _ = superview {
            _sf_updateForCurrentOrientationAnimated(true)
        }
    }
    
    func _sf_updateForCurrentOrientationAnimated(animated: Bool) {
        // Stay in sync with the superview in any case
        if let superview = superview {
            bounds = superview.bounds
            setNeedsDisplay()
        }
    }
    
    func _sf_updateIndicator() {
        if mode == .Indeterminate {
            let view = UIActivityIndicatorView(activityIndicatorStyle:.WhiteLarge)
            view.startAnimating()
            addSubview(view)
            indicator = view
        } else if (mode == .Determinate || mode == .AnnularDeterminate) {
            let view = SFRoundProgressView()
            view.annular = mode == .AnnularDeterminate
            addSubview(view)
            indicator = view
        }
    }
    
    func _sf_textSize(text: String?, font: UIFont) -> CGSize {
        if let text = text where text.characters.count > 0 {
            return text.sizeWithAttributes([NSFontAttributeName : font])
        } else {
            return CGSizeZero
        }
    }
    
    func _sf_mutilLineTextSize(text: String?, font: UIFont, maxSize: CGSize) -> CGSize {
        if let text = text where text.characters.count > 0 {
            return text.boundingRectWithSize(maxSize, options:.UsesLineFragmentOrigin, attributes:[NSFontAttributeName : font], context:nil).size
        } else {
            return CGSizeZero
        }
    }
    
    lazy public var label : UILabel = {
        let label = UILabel(frame: self.bounds)
        label.adjustsFontSizeToFitWidth = false
        label.textAlignment = .Center
        label.opaque = false
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont.boldSystemFontOfSize(16)
        label.textColor = UIColor.whiteColor()
        return label
        }()
    
    lazy public var detailsLabel : UILabel = {
        let detailsLabel = UILabel(frame: self.bounds)
        detailsLabel.adjustsFontSizeToFitWidth = false
        detailsLabel.textAlignment = .Center
        detailsLabel.opaque = false
        detailsLabel.backgroundColor = UIColor.clearColor()
        detailsLabel.font = UIFont.boldSystemFontOfSize(12)
        detailsLabel.textColor = UIColor.whiteColor()
        return detailsLabel
        }()
    
    @objc public enum SFProgressHUDMode : NSInteger {
        /** Progress is shown using an UIActivityIndicatorView. This is the default. */
        case Indeterminate
        /** Progress is shown using a round, pie-chart like, progress view. */
        case Determinate
        /** Progress is shown using a ring-shaped progress view. */
        case AnnularDeterminate
        /** Shows a custom view */
        case CustomView
        /** Shows only labels */
        case Text
    }
}
