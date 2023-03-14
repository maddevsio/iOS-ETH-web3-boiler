import UIKit

private typealias Module = Debugging.ViewManager

extension Module {
    class DebuggingViewManagerCell: BaseTableViewCell {
        
        private(set) lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            label.textColor = UIColor.black
            label.numberOfLines = 1
            label.backgroundColor = .clear
            return label
        }()
        
        override func resolveSubviews() {
            super.resolveSubviews()
            setupUI()
            setupConstraints()
        }
        
        fileprivate func setupUI() {
            accessoryType = .disclosureIndicator
            selectionStyle = .default
        }
        
        fileprivate func setupConstraints() {
            contentView.addSubview(titleLabel)
            
            titleLabel.snp.makeConstraints {
                $0.edges.equalTo(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
            }
        }
        
        public func setup(_ title: String) {
            titleLabel.text = title
        }
    }
}
