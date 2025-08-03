//
//  MovieDetailViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/3/25.
//

import UIKit
import Alamofire
import SnapKit
import Kingfisher
import Then


// MARK: -BackdropsResponse-
struct BackdropsResponse: Decodable {
    let backdrops: [BackdropsItem]
}

struct BackdropsItem: Decodable {
    let file_path: String
}
// MARK: -

// MARK: -BackdropsCell-
final class BackdropsCell: UITableViewCell, IsIdentifiable {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    let informationLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: -Configure-
private extension BackdropsCell {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
        configureCollectionView()
    }
    
    private func configureSubview() {
        contentView.addSubviews(collectionView, informationLabel)
    }
    
    private func configureLayout() {
        print("1")
        collectionView.snp.makeConstraints {
            $0.width.equalToSuperview().priority(1000)
            $0.height.equalTo(collectionView.snp.width).multipliedBy(0.8).priority(999)
            $0.top.horizontalEdges.equalToSuperview().inset(Constant.offsetFromHorizon).priority(998)
        }
        
        informationLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(Constant.offsetFromHorizon)
            $0.horizontalEdges.bottom.equalToSuperview().inset(Constant.offsetFromHorizon)
        }
    }
    
    private func configureView() {
        informationLabel.do {
            $0.textAlignment = .center
            $0.text = "abcdefg"
        }
    }
}
// MARK: -CollectionView-
extension BackdropsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    private func configureCollectionView() {
        collectionView.do {
            $0.isPagingEnabled = true
            $0.delegate = self
            $0.dataSource = self
            $0.register(BackdropCell.self)
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        updateCollectionViewLayout()
    }
    
    private func updateCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout().then {
            let cellBounds = self.bounds
            
            $0.itemSize = cellBounds.size
            $0.minimumInteritemSpacing = 0
            $0.minimumLineSpacing = 0
            $0.scrollDirection = .horizontal
        }
        
        collectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        cell = collectionView.dequeueReusableCell(BackdropCell.self, for: indexPath)
        
        return cell
    }
}
// MARK: -

// MARK: -BackdropCell-
final class BackdropCell: UICollectionViewCell, IsIdentifiable {
    private let backdropImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    private func configureSubview() {
        contentView.addSubview(backdropImageView)
    }
    
    private func configureLayout() {
        backdropImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureView() {
        backdropImageView.do {
            let systemColors: [UIColor] = [.systemBlue, .systemRed, .systemPink, .systemOrange, .systemMint, .systemTeal, .systemGreen, .systemCyan, .systemBrown]
            $0.backgroundColor = systemColors.randomElement()!
            $0.kf.indicatorType = .activity
        }
    }
}
// MARK: -

// MARK: -MovieDetailViewController-
final class MovieDetailViewController: UIViewController {
    private var tableView = UITableView()
    private var id: Int?
    private var synopsis: String?
    private var creditsInfo = CreditsResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
        configreTableView()
    }
    
    private func configureSubview() {
        view.addSubview(tableView)
    }
    
    private func configureLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview(\.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        
    }
}
// MARK: -Open-
extension MovieDetailViewController {
    public func input(_ item: SearchMovieItem) {
        handleInput(item)
    }
    
    private func handleInput(_ item: SearchMovieItem) {
        self.id = item.id
        self.synopsis = item.overview
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        callCreditsAPI(item.id)
    }
    
    private func callCreditsAPI(_ id: Int) {
        let url = URL(string: APIURL.creditsAPI(id))!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "ko-KR")
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer \(APIKey.tmdbToken)"
        ]

        AF.request(request)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CreditsResponse.self) {
                switch $0.result {
                case .success(let creditsResponse):
                    self.creditsInfo = creditsResponse
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
}
// MARK: -TableView-
extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    private func configreTableView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(BackdropsCell.self)
            $0.register(SynopsisCell.self)
            $0.register(CastCell.self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 1
        }
        else {
            return creditsInfo.cast.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(BackdropsCell.self, for: indexPath)
        }
        else if indexPath.section == 1 {
            let item = synopsis ?? ""
            cell = tableView.dequeueReusableCell(SynopsisCell.self, for: indexPath).then {
                $0.input(item: item)
            }
        }
        else {
            let item = creditsInfo.cast[indexPath.row]
            cell = tableView.dequeueReusableCell(CastCell.self, for: indexPath).then {
                $0.input(item)
            }
        }
        
        return cell
    }
}
// MARK: -
