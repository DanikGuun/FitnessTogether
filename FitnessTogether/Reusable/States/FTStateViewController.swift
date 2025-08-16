
import UIKit

public class FTStateViewController: FTViewController, ScreenStateDelegate, UINavigationControllerDelegate {
    
    var firstSpacingHeight: SpaceKind = .fractional(0.1)
    
    //MARK: - Pattern method
    public func goToNextState() {
        guard let state = getNextState() else {
            viewStatesDidEnd()
            return
        }

        goToState(state, isNext: true)
    }
    
    public func getNextState() -> (any ScreenState)? {
        return nil
    }
    
    public func goToPreviousState() {
        guard let state = getPreviousState() else {
            return
        }
        
        goToState(state, isNext: false)
    }
    
    public func getPreviousState() -> (any ScreenState)?  {
        return nil
    }
    
    public func goToState(_ state: any ScreenState, isNext: Bool = true) {
        state.delegate = self
        
        removeAllStackSubviews(direction: isNext ? .left : .right, completion: { [weak self] in
            guard let self else { return }
            addSpacing(firstSpacingHeight)
            addStackSubviews(state.viewsToPresent(), direction: isNext ? .right : .left)
        })
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
    
    //Шаблонный метод для сброса состояний
    public override func popViewController() {
        if isFirstState() {
            navigationController?.popViewController(animated: true)
        }
        else {
            goToPreviousState()
        }
    }
    
    public func isFirstState() -> Bool {
        return true
    }
    
}
