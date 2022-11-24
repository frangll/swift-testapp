import UIKit

class CustomImage: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.masksToBounds = false
            layer.cornerRadius = frame.height/2
            clipsToBounds = true
        }
    }
}
