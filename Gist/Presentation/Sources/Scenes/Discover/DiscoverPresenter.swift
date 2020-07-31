import Foundation

protocol DiscoverPresentationLogic {
    func getDiscoveries(request: Discover.GetDiscoveries.Request)
}

protocol DiscoverDataStore {
    var gists: [GistDigest] { get set }
}

final class DiscoverPresenter: DiscoverDataStore {
    private let getPublicGists: GetPublicGistsUseCase
    var gists: [GistDigest] = []

    weak var display: DiscoverDisplayLogic?

    init(
        getPublicGists: GetPublicGistsUseCase
    ) {
        self.getPublicGists = getPublicGists
    }

    private func map(gist: GistDigest) -> GistDigestView.ViewModel {
        let fileTags = gist.fileTags(threshold: 4)

        return .init(
            avatarUrl: gist.owner.avatarUrl,
            ownerName: gist.owner.name,
            secondaryText: gist.formmatedDescription,
            fileTags: fileTags
        )
    }

    private func calculateIndexPathsToReload(from newGists: [GistDigest]) -> [IndexPath] {
        let startIndex = gists.count - newGists.count
        let endIndex = startIndex + newGists.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}

extension DiscoverPresenter: DiscoverPresentationLogic {
    func getDiscoveries(request: Discover.GetDiscoveries.Request) {
        getPublicGists.execute { [weak self] in
            guard let self = self else { return }

            switch $0 {
            case .success(let newGists):
                self.gists.append(contentsOf: newGists)
                let content = self.gists.map(self.map(gist:))

                self.display?.displayDiscoveries(viewModel:
                    .content(
                        list: content,
                        hasMoreDataAvailable: !newGists.isEmpty
                    )
                )
            case .failure(let error):
                let userError = ErrorHandler.userError(from: error)
                self.display?.displayDiscoveries(viewModel:
                    .failure(userError)
                )
            }
        }
    }
}

extension GistDigest {
    var formmatedDescription: String? {
        description?.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
            .filter{ !$0.isEmpty }
            .joined(separator: "\n")
    }

    func fileTags(threshold: Int? = nil) -> [String] {
        var fileTypes = files.map { $0.type }

        guard let threshold = threshold else {
            return fileTypes
        }

        fileTypes = Array(fileTypes.suffix(threshold))

        if files.count > threshold {
            fileTypes.append("...")
        }

        return fileTypes
    }
}
