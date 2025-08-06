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
    
    public func plain(_ headerText: String) {
        addHeaderLabel(headerText)
    }
    
    public func withAction(_ headerText: String, _ buttonText: String, _ action: Selector) {
        addHeaderLabel(headerText)
        addActionButton(buttonText, action)
    }
    
    private func addHeaderLabel(_ text: String) {
        headerLabel.text = text
        headerLabel.font = .systemFont(ofSize: Constant.headerSize, weight: .bold)
        
        addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constant.offsetFromHorizon)
        }
    }
    
    private func addActionButton(_ text: String, _ action: Selector) {
        actionButton.do {
            var attributedText = AttributedString(text)
            attributedText.foregroundColor = UIColor.Tint
            attributedText.font = .systemFont(ofSize: Constant.titleSize, weight: .bold)
            
            var configuration = UIButton.Configuration.plain()
            configuration.attributedTitle = attributedText
            configuration.baseForegroundColor = .Tint
            
            $0.configuration = configuration
            $0.addTarget(nil, action: action, for: .touchUpInside)
        }
        
        addSubview(actionButton)
        
        actionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constant.offsetFromHorizon)
        }
    }
}
