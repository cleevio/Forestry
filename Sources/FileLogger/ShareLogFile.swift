//
//  ShareLogFile.swift
//  
//
//  Created by Lukáš Valenta on 30.12.2022.
//

#if os(iOS)
import UIKit

public extension FileLogger {
    func shareLogFile(on viewController: UIViewController) {
        guard let file = configuration.logFileURL else { return }
        let fileToShare: [Any] = [file]
        let activityViewController = UIActivityViewController(activityItems: fileToShare, applicationActivities: nil)
        viewController.present(activityViewController, animated: true, completion: nil)
    }
}
#endif
