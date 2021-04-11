//
//  TextMessageContent.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation

public class TextMessageContent: DefaultMessageContent {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.addSubview(label)
        label.keepInsets.equal = 8
        return view
    }()
    
    override public func view() -> UIView {
        return containerView
    }
    
    override public func bind(message: Message) {
        label.text = message.messageText()
    }
        
}
