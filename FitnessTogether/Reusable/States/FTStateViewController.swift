
import UIKit

public class FTStateViewController: FTViewController, ScreenStateDelegate {
    
    var firstSpacingHeight: SpaceKind = .fractional(0.1)
    
    //MARK: - Pattern method
    public func goToNextState() {
        guard let state = getNextState() else {
            viewStatesDidEnd()
            return
        }
        state.delegate = self
        
        removeAllStackSubviews(direction: .left, completion: { [weak self] in
            guard let self else { return }
            addSpacing(firstSpacingHeight)
            addStackSubviews(state.viewsToPresent(), direction: .right)
        })

    }
    
    public func getNextState() -> (any ScreenState)? {
        return nil
    }
    
    public func viewStatesDidEnd() {}
    //
    
    public func screenStateGoNext(_ state: any ScreenState) {
        goToNextState()
    }
    
    public func screenState(_ state: any ScreenState, needInertView view: UIView, after afterView: UIView) {
        guard let index = stackView.arrangedSubviews.firstIndex(of: afterView) else { return }
        stackView.insertArrangedSubview(view, at: index + 1)
    }

    public func screenState(_ state: any ScreenState, needRemoveView view: UIView) {
        stackView.removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
}
