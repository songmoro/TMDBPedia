//
//  Constant.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/1/25.
//

struct CGFloatConstant {
    private init() { }
    
    /**
     모서리가 조금 다듬어진 정도
     */
    static let smallRadius = 4.0
    
    /**
     모서리가 다듬어진 정도
     */
    static let defaultRadius = 8.0
    
    /**
     모서리가 조금 더 다듬어진 정도
     */
    static let largeRadius = 12.0
}

struct IntConstant {
    private init() { }
    
    /**
     스크린 너비에서 조금 떨어진 정도
     */
    static let offsetFromHorizon = 12
    
    /**
     기본 스크린 너비에서 조금 더 떨어진 정도
     */
    static let semiOffsetFromHorizon = 16
    
    /**
     관련 있는 요소와 떨어진 정도
     */
    static let offsetFromRelated = 20
    
    /**
     상단 SafeArea에서 떨어지는 정도의 기본 값
     */
    static let offsetFromVertical = 30
    
    /**
     텍스트필드의 기본 높이
     */
    static let textFieldHeight = 48
    
}
