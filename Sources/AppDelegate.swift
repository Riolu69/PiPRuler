import UIKit
import AVKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var pipController: AVPictureInPictureController?
    var pipVideoCallViewController: AVPictureInPictureVideoCallViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        
        let startBtn = UIButton(type: .system)
        startBtn.frame = CGRect(x: 50, y: 200, width: UIScreen.main.bounds.width - 100, height: 50)
        startBtn.setTitle("Запустить линейку в PiP", for: .normal)
        startBtn.backgroundColor = .systemBlue
        startBtn.setTitleColor(.white, for: .normal)
        startBtn.layer.cornerRadius = 10
        startBtn.addTarget(self, action: #selector(startPiP), for: .touchUpInside)
        
        vc.view.addSubview(startBtn)
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        setupAudioSession()
        setupPiP()
        
        return true
    }
    
    func setupAudioSession() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func setupPiP() {
        guard AVPictureInPictureController.isPictureInPictureSupported() else { return }
        
        let rulerVC = UIViewController()
        rulerVC.view.backgroundColor = .clear
        
        // Здесь мы генерируем простую полупрозрачную красную полосу для теста. 
        // Позже вы сможете загрузить в папку Sources картинку ruler.png и заменить этот блок на UIImageView
        let rulerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 400))
        rulerView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        rulerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        rulerVC.view.addSubview(rulerView)
        
        pipVideoCallViewController = AVPictureInPictureVideoCallViewController()
        pipVideoCallViewController?.preferredContentSize = CGSize(width: 100, height: 400)
        pipVideoCallViewController?.view.addSubview(rulerVC.view)
        
        let source = AVPictureInPictureController.ContentSource(
            activeVideoCallSourceView: window!.rootViewController!.view,
            contentViewController: pipVideoCallViewController!
        )
        
        pipController = AVPictureInPictureController(contentSource: source)
        pipController?.canStartPictureInPictureAutomaticallyFromInline = true
    }
    
    @objc func startPiP() {
        pipController?.startPictureInPicture()
    }
}
