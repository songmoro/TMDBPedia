//
//  SettingsViewModel.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/10/25.
//

import Foundation
import Combine

final class SettingsViewModel {
    private var cancellable = Set<AnyCancellable>()
    
    let list = ["자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    
    @Published private(set) var nickname: Nickname = .init(text: "")
    @Published private(set) var likeList: [Int] = []
    
    init() {
        UserDefaultsManager.shared.$nickname
            .compactMap(\.self)
            .assign(to: \.nickname, on: self)
            .store(in: &cancellable)
        
        UserDefaultsManager.shared.$likeList
            .replaceNil(with: [])
            .assign(to: \.likeList, on: self)
            .store(in: &cancellable)
    }
    
    func withdraw() {
        UserDefaultsManager.shared.likeList = nil
        UserDefaultsManager.shared.keywords = nil
        UserDefaultsManager.shared.nickname = nil
    }
}
