import UIKit
import RxSwift
import RxCocoa
import Foundation
import Crashlytics

class TopBarViewController : UIViewController
{
    // MARK: Fields
    private var presenter : TopBarPresenter!
    private var viewModel : TopBarViewModel!
    private var viewModelLocator : ViewModelLocator!
    
    private let disposeBag = DisposeBag()
    
    private var pagerViewController : PagerViewController!
    private var calendarViewController : CalendarViewController!
    
    @IBOutlet private weak var titleLabel : UILabel!
    @IBOutlet private weak var calendarButton : UIButton!
    @IBOutlet private weak var feedbackButton : UIButton!
    @IBOutlet private weak var chartsButton : UIButton!
    @IBOutlet private weak var logo: UIImageView!
    
    func inject(viewModel: TopBarViewModel,
                pagerViewController: PagerViewController,
                calendarViewController: CalendarViewController,
                viewModelLocator: ViewModelLocator)
    {
        self.viewModel = viewModel
        self.pagerViewController = pagerViewController
        self.calendarViewController = calendarViewController
        self.viewModelLocator = viewModelLocator
        
        self.createBindings()
    }
    
    // MARK: UIViewController lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This won't be created here when done for the whole app. It'll be the other way around, the Presenter will create this VC
        presenter = TopBarPresenter()
        presenter.viewController = self
    
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(TopBarViewController.crash(recognizer:)))
        recognizer.numberOfTapsRequired = 10
        logo.addGestureRecognizer(recognizer)
    }
    
    func crash(recognizer:UITapGestureRecognizer)
    {
        let alert = UIAlertController(title: "Crash and catch fire!", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Crash 💥", style: .default, handler: { _ in
            Crashlytics.sharedInstance().crash()
        }))
        alert.addAction(UIAlertAction(title: "Error ⚠️", style: .default, handler: { _ in
            Crashlytics.sharedInstance().recordError(NSError(domain: "TestErrorDomain", code: 0, userInfo: nil))
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: Methods
    private func createBindings()
    {
        self.viewModel.dateObservable
            .subscribe(onNext: self.onDateChanged)
            .addDisposableTo(self.disposeBag)
        
        self.calendarButton.rx.tap
            .subscribe(onNext: self.onCalendarButtonClick)
            .addDisposableTo(self.disposeBag)
        
        self.feedbackButton.rx.tap
            .subscribe(onNext: self.onFeedbackButtonClick)
            .addDisposableTo(self.disposeBag)
        
        self.chartsButton.rx.tap
            .subscribe(onNext: self.onChartsButtonClick)
            .addDisposableTo(self.disposeBag)
        
        self.viewModel.calendarDay
            .bindTo(self.calendarButton.rx.title(for: .normal))
            .addDisposableTo(self.disposeBag)
    }
    
    private func onCalendarButtonClick()
    {
        if self.calendarViewController.isVisible
        {
            self.calendarViewController.hide()
        }
        else
        {
            self.calendarViewController.show()
        }
    }
    
    private func onFeedbackButtonClick()
    {
        self.viewModel.composeFeedback()
    }
    
    private func onChartsButtonClick ()
    {
        self.presenter.showSummary(fromRect: view.convert(self.chartsButton.frame, to: nil), viewModelLocator: viewModelLocator)
    }
    
    private func onDateChanged(date: Date)
    {
        self.titleLabel.text = viewModel.title
    }
}