import UIKit
import Combine

final class DetailsView: UIViewController {
    
    var viewModel: DetailsViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
