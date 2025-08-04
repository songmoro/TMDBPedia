//
//  Constant.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/1/25.
//

struct Constant {
    private init() { }
    
    // MARK: Layout
    /**
     연관된 레이블의 구분을 주기위한 정도
     */
    static let offsetFromTop = 4
    
    /**
     연관된 이미지간 구분을 주기위한 정도
     */
    static let offsetFromImage = 8
    
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
    //:-
    
    // MARK: Size
    /**
     텍스트필드의 기본 높이
     */
    static let textFieldHeight = 48
    //:-
    
    // MARK: CornerRadius
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
    //:-
    
    // MARK: Font Size
    static let placeholderSize = 13.0
    static let bodySize = 14.0
    static let titleSize = 17.0
    static let headerSize = 20.0
    static let largeTitleSize = 34.0
    //:-
}
