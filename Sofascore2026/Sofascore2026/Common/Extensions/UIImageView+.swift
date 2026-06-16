import UIKit

extension UIImageView {
    convenience init(named name: String, contentMode: UIView.ContentMode = .scaleAspectFit) {
        self.init(frame: .zero)
        image = UIImage(named: name)
        self.contentMode = contentMode
    }

    convenience init(contentMode: UIView.ContentMode) {
        self.init(frame: .zero)
        self.contentMode = contentMode
    }
}
