//
//  MovieGenre.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/2/25.
//

enum MovieGenre: Int {
    case adventure     = 12 // 모험
    case fantasy       = 14 // 판타지
    case animation     = 16 // 애니메이션
    case drama         = 18 // 드라마
    case horror        = 27 // 공포
    case action        = 28 // 액션
    case comedy        = 35 // 코미디
    case historical    = 36 // 역사
    case western       = 37 // 서부
    case thriller      = 53 // 스릴러
    case crime         = 80 // 범죄
    case documentary   = 99 // 다큐멘터리
    case sf            = 878 // SF
    case mystery       = 9648 // 미스터리
    case musical       = 10402 // 음악
    case romance       = 10749 // 로맨스
    case family        = 10751 // 가족
    case war           = 10752 // 전쟁
    case tv            = 10770 // TV 영화
    
    var text: String {
        switch self {
        case .adventure: "모험"
        case .fantasy: "판타지"
        case .animation: "애니메이션"
        case .drama: "드라마"
        case .horror: "공포"
        case .action: "액션"
        case .comedy: "코미디"
        case .historical: "역사"
        case .western: "서부"
        case .thriller: "스릴러"
        case .crime: "범죄"
        case .documentary: "다큐멘터리"
        case .sf: "SF"
        case .mystery: "미스터리"
        case .musical: "음악"
        case .romance: "로맨스"
        case .family: "가족"
        case .war: "전쟁"
        case .tv: "TV 영화"
        }
    }
}
