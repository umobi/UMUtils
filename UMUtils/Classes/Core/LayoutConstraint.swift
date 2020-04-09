import UIKit

@IBDesignable
public class LayoutConstraint: NSLayoutConstraint {

    @IBInspectable
    public var constant35: CGFloat = 0 {
        didSet {
            if UIScreen.main.bounds.maxY == 480 {
                constant = constant35
            }
        }
    }

    @IBInspectable
    public var constant40: CGFloat = 0 {
        didSet {
            print(constant40)
            if UIScreen.main.bounds.maxY == 568 {
                constant = constant40
            }
        }
    }

    @IBInspectable
    public var constant47: CGFloat = 0 {
        didSet {
            if UIScreen.main.bounds.maxY == 667 {
                constant = constant47
            }
        }
    }

    @IBInspectable
    public var constant55: CGFloat = 0 {
        didSet {
            if UIScreen.main.bounds.maxY == 736 {
                constant = constant55
            }
        }
    }
}
