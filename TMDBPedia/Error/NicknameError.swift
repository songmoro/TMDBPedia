//
//  NicknameError.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

struct NicknameError: Error {
    enum Kind: CustomStringConvertible {
        case textIsNil
        case invalidRange
        case containsNumber
        case containsSpecialSymbol
        
        var description: String {
            switch self {
            case .textIsNil:
                "닉네임을 입력해주세요"
            case .invalidRange:
                "2글자 이상 10글자 미만으로 설정해주세요"
            case .containsNumber:
                "닉네임에 숫자는 포함할 수 없어요"
            case .containsSpecialSymbol:
                "닉네임에 @, #, $, % 는 포함할 수 없어요"
            }
        }
    }
    
    let text: String?
    let kind: Kind
    
    init(text: String?, kind: Kind) {
        self.text = text
        self.kind = kind
    }
}
