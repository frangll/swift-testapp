import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardColor: UIView!
    @IBOutlet weak var cardLabel: UILabel!
    override public func layoutSubviews() {
        super.layoutSubviews()
        super.layoutIfNeeded()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
    }
}
