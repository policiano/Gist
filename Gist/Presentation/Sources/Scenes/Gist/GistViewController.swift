import UIKit

public final class GistViewController: BaseViewController, CustomViewController {
    typealias View = GistView

    public override func loadView() {
        view = GistView()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = GistView.ViewModel(
            avatarUrl: URL(string: "https://avatars2.githubusercontent.com/u/50024899?v=4"),
            ownerName: "emanuel-jose",
            creationDate: "Created 18 minutes ago"
        )

        customView.display(with: viewModel)
    }
}
