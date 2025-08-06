//
//  HeaderView.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/6/25.
//

import UIKit

final class HeaderView: BaseView {
    private let headerLabel = UILabel()
    private let actionButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        headerLabel.font = .systemFont(ofSize: Constant.headerSize, weight: .bold)
    }
    
    public func plain(_ headerText: String) {
        headerLabel.text = headerText
        
        addHeaderLabel()
    }
    
    public func withAction(_ headerText: String, _ buttonText: String, _ action: Selector) {
        headerLabel.text = headerText
        actionButton.setTitle(buttonText, for: .normal)
        actionButton.addTarget(nil, action: action, for: .touchUpInside)
        
        addHeaderLabel()
        addActionButton()
    }
    
    private func addHeaderLabel() {
        addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constant.offsetFromHorizon)
        }
    }
    
    private func addActionButton() {
        addSubview(actionButton)
        
        actionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constant.offsetFromHorizon)
        }
    }
}
