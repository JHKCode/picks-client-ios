//
//  SavePickViewController.swift
//  Picks
//
//  Created by Jinhong Kim on 10/12/16.
//  Copyright © 2016 JHK. All rights reserved.
//

import UIKit


extension UIViewAnimationOptions {
    init(animationCurve: UIViewAnimationCurve) {
        var option: UIViewAnimationOptions
        
        switch animationCurve {
            case UIViewAnimationCurve.easeInOut:
                option = UIViewAnimationOptions.curveEaseInOut
            case UIViewAnimationCurve.easeIn:
                option = UIViewAnimationOptions.curveEaseIn
            case UIViewAnimationCurve.easeOut:
                option = UIViewAnimationOptions.curveEaseOut
            case UIViewAnimationCurve.linear:
                option = UIViewAnimationOptions.curveLinear
        }
        
        self = option
    }
}


class SavePickViewController: UIViewController {
    
    @IBOutlet weak var pickImageView: PickImageView!
    @IBOutlet weak var pickTitleLabel: UILabel!
    @IBOutlet weak var pickCreatorLabel: UILabel!
    @IBOutlet weak var pickDateLabel: UILabel!
    @IBOutlet weak var starSlider: UISlider!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var pickTextView: UITextView!
    @IBOutlet weak var pickTextViewBottomConstraint: NSLayoutConstraint!
    
    var item: PickItem?
    var orgTextViewBottomConstraint: CGFloat = 0
    
    
    deinit {
        print("deinit at SavePickViewController")
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        setupNavigationBar()
        
        
        starSlider.value = 3
        handleStarSlider(starSlider)
        
        
        if let pickItem = item {
            pickTitleLabel.text = pickItem.title
            pickCreatorLabel.text = pickItem.creator

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "ko_KR")

            pickDateLabel.text = dateFormatter.string(from: pickItem.date)
            
            if let url = URL(string: pickItem.imageURI) {
                pickImageView.load(imageURL: url)
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        registerKeyboardObserver()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unregisterKeyboardObserver()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func handleStarSlider(_ sender: AnyObject) {
        let orgValue = starSlider.value
        let intValue = Int(orgValue)
        var starText = "Star " + String(intValue)
        
        if (orgValue - Float(intValue)) >= 0.5 {
            starText += ".5"
        }
        
        starLabel.text = starText
    }
    
    
    func savePick() {
        pickTextView.resignFirstResponder()
    }
    
    
    // Keyboard Notificaiton
    
    
    func handleKeyboardWillShow(_ notification: Notification) {
        orgTextViewBottomConstraint = pickTextViewBottomConstraint.constant

        let animation = keyboardAnimation(notification.userInfo)
        
        if animation.frame.origin.y > 0 {
            let constant = view.bounds.height - animation.frame.origin.y + orgTextViewBottomConstraint
            
            UIView.animate(withDuration: animation.duration,
                           delay: 0,
                           options: animation.option,
                           animations: {
                                self.pickTextViewBottomConstraint.constant = constant
                                self.view.layoutIfNeeded()
                            },
                           completion: nil)
        }
        
        
        /*
            name = UIKeyboardWillShowNotification,
            object = nil, 
            userInfo = Optional([
                    AnyHashable("UIKeyboardCenterBeginUserInfoKey"): NSPoint: {160, 676},
                    AnyHashable("UIKeyboardIsLocalUserInfoKey"): 1, 
                    AnyHashable("UIKeyboardCenterEndUserInfoKey"): NSPoint: {160, 460}, 
                    AnyHashable("UIKeyboardBoundsUserInfoKey"): NSRect: {{0, 0}, {320, 216}}, 
                    AnyHashable("UIKeyboardFrameEndUserInfoKey"): NSRect: {{0, 352}, {320, 216}}, 
                    AnyHashable("UIKeyboardAnimationCurveUserInfoKey"): 7, 
                    AnyHashable("UIKeyboardFrameBeginUserInfoKey"): NSRect: {{0, 568}, {320, 216}}, 
                    AnyHashable("UIKeyboardAnimationDurationUserInfoKey"): 0.25])
         */
    }
    
    
    func handleKeyboardDidShow(_ notification: Notification) {
        /*
            name = UIKeyboardDidShowNotification, 
            object = nil, 
            userInfo = Optional([
                    AnyHashable("UIKeyboardCenterBeginUserInfoKey"): NSPoint: {160, 676},
                    AnyHashable("UIKeyboardIsLocalUserInfoKey"): 1, 
                    AnyHashable("UIKeyboardCenterEndUserInfoKey"): NSPoint: {160, 460}, 
                    AnyHashable("UIKeyboardBoundsUserInfoKey"): NSRect: {{0, 0}, {320, 216}}, 
                    AnyHashable("UIKeyboardFrameEndUserInfoKey"): NSRect: {{0, 352}, {320, 216}}, 
                    AnyHashable("UIKeyboardAnimationCurveUserInfoKey"): 7, 
                    AnyHashable("UIKeyboardFrameBeginUserInfoKey"): NSRect: {{0, 568}, {320, 216}}, 
                    AnyHashable("UIKeyboardAnimationDurationUserInfoKey"): 0.25])
         */
        
    }

    
    func handleKeyboardWillHide(_ notification: Notification) {
        let animation = keyboardAnimation(notification.userInfo)
        let constant = orgTextViewBottomConstraint
        
        UIView.animate(withDuration: animation.duration,
                       delay: 0,
                       options: animation.option,
                       animations: {
                            self.pickTextViewBottomConstraint.constant = constant
                            self.view.layoutIfNeeded()
                        },
                       completion: nil)

        /*
            name = UIKeyboardWillHideNotification,
            object = nil, 
            userInfo = Optional([
                    AnyHashable("UIKeyboardCenterBeginUserInfoKey"): NSPoint: {160, 460},
                    AnyHashable("UIKeyboardIsLocalUserInfoKey"): 1, 
                    AnyHashable("UIKeyboardCenterEndUserInfoKey"): NSPoint: {160, 676}, 
                    AnyHashable("UIKeyboardBoundsUserInfoKey"): NSRect: {{0, 0}, {320, 216}}, 
                    AnyHashable("UIKeyboardFrameEndUserInfoKey"): NSRect: {{0, 568}, {320, 216}}, 
                    AnyHashable("UIKeyboardAnimationCurveUserInfoKey"): 7, 
                    AnyHashable("UIKeyboardFrameBeginUserInfoKey"): NSRect: {{0, 352}, {320, 216}}, 
                    AnyHashable("UIKeyboardAnimationDurationUserInfoKey"): 0.25])
         */
    }

    
    func handleKeyboardDidHide(_ notification: Notification) {
        /*
            name = UIKeyboardDidHideNotification, 
            object = nil,
            userInfo = Optional([
                    AnyHashable("UIKeyboardCenterBeginUserInfoKey"): NSPoint: {160, 460},
                    AnyHashable("UIKeyboardIsLocalUserInfoKey"): 1, 
                    AnyHashable("UIKeyboardCenterEndUserInfoKey"): NSPoint: {160, 676}, 
                    AnyHashable("UIKeyboardBoundsUserInfoKey"): NSRect: {{0, 0}, {320, 216}}, 
                    AnyHashable("UIKeyboardFrameEndUserInfoKey"): NSRect: {{0, 568}, {320, 216}}, 
                    AnyHashable("UIKeyboardAnimationCurveUserInfoKey"): 7, 
                    AnyHashable("UIKeyboardFrameBeginUserInfoKey"): NSRect: {{0, 352}, {320, 216}}, 
                    AnyHashable("UIKeyboardAnimationDurationUserInfoKey"): 0.25])
         */
    }

    
    func handleKeyboardWillChangeFrame(_ notification: Notification) {
        /*
             name = UIKeyboardWillChangeFrameNotification,
             object = nil, 
             userInfo = Optional([
                    AnyHashable("UIKeyboardCenterBeginUserInfoKey"): NSPoint: {160, 676},
                    AnyHashable("UIKeyboardIsLocalUserInfoKey"): 1, 
                    AnyHashable("UIKeyboardCenterEndUserInfoKey"): NSPoint: {160, 460}, 
                    AnyHashable("UIKeyboardBoundsUserInfoKey"): NSRect: {{0, 0}, {320, 216}}, 
                    AnyHashable("UIKeyboardFrameEndUserInfoKey"): NSRect: {{0, 352}, {320, 216}}, 
                    AnyHashable("UIKeyboardAnimationCurveUserInfoKey"): 7, 
                    AnyHashable("UIKeyboardFrameBeginUserInfoKey"): NSRect: {{0, 568}, {320, 216}}, 
                    AnyHashable("UIKeyboardAnimationDurationUserInfoKey"): 0.25])
        */
    }

    
    func handleKeyboardDidChangeFrame(_ notification: Notification) {
        /*
            name = UIKeyboardDidChangeFrameNotification, 
            object = nil, 
            userInfo = Optional([
                    AnyHashable("UIKeyboardCenterBeginUserInfoKey"): NSPoint: {160, 676},
                    AnyHashable("UIKeyboardIsLocalUserInfoKey"): 1, 
                    AnyHashable("UIKeyboardCenterEndUserInfoKey"): NSPoint: {160, 460}, 
                    AnyHashable("UIKeyboardBoundsUserInfoKey"): NSRect: {{0, 0}, {320, 216}}, 
                    AnyHashable("UIKeyboardFrameEndUserInfoKey"): NSRect: {{0, 352}, {320, 216}}, 
                    AnyHashable("UIKeyboardAnimationCurveUserInfoKey"): 7, 
                    AnyHashable("UIKeyboardFrameBeginUserInfoKey"): NSRect: {{0, 568}, {320, 216}}, 
                    AnyHashable("UIKeyboardAnimationDurationUserInfoKey"): 0.25])
         */
    }

    
    private func setupNavigationBar() {
        self.title = "Save Pick"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePick))
    }
    
    
    private func registerKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow(_:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidHide(_:)), name: Notification.Name.UIKeyboardDidHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChangeFrame(_:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidChangeFrame(_:)), name: Notification.Name.UIKeyboardDidChangeFrame, object: nil)
    }
    
    
    private func unregisterKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name:  Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:  Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:  Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name:  Notification.Name.UIKeyboardDidHide, object: nil)
        NotificationCenter.default.removeObserver(self, name:  Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name:  Notification.Name.UIKeyboardDidChangeFrame, object: nil)
    }
    
    
    private func keyboardAnimation(_ userInfo: Dictionary<AnyHashable, Any>?) -> (duration: TimeInterval, option: UIViewAnimationOptions, frame: CGRect) {
        var duration: TimeInterval
        var option: UIViewAnimationOptions = UIViewAnimationOptions.curveEaseInOut
        var frame: CGRect = CGRect.zero
        
        
        // duration
        duration = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        
        
        // option
        if let curveNumber = userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
            if let curve = UIViewAnimationCurve(rawValue: curveNumber.intValue) {
                option = UIViewAnimationOptions(animationCurve: curve)
            }
        }
        
        
        // frame
        if let rectValue = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            frame = rectValue.cgRectValue
        }

        
        return (duration: duration, option: option, frame: frame)
    }
}
