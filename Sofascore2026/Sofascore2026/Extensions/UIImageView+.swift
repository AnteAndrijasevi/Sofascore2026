import UIKit

extension UIImageView {
    convenience init(named imageName: String, contentMode: UIView.ContentMode = .scaleAspectFit) {
        self.init()
        self.image = UIImage(named: imageName)
        self.contentMode = contentMode
    }
}
