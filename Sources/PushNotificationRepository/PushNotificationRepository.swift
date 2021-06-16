import UIKit
import UserNotifications

public enum PushNotificationError: LocalizedError {
    
    case notAuthorizated
}

open class PushNotificationRepository: NSObject {

    public var userDidSelect: ((UNNotificationContent) -> Void)?

    public var authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    public var presantationsOptions: UNNotificationPresentationOptions = [.alert, .badge, .sound]
    
    private let notificationCenter: UNUserNotificationCenter
     
    public init(_ notificationCenter: UNUserNotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    public func isAuthorizated(completionHandler: @escaping (Result<Void, PushNotificationError>) -> Void) {
        notificationCenter.getNotificationSettings { (settings) in
            guard settings.authorizationStatus != .notDetermined else {
                return
            }
            
            if settings.authorizationStatus == .authorized {
                completionHandler(.success(()))
            } else {
                completionHandler(.failure(.notAuthorizated))
            }
        }
    }
    
    public func getPermission(completionHandler: @escaping (Result<Void, PushNotificationError>) -> Void) {
        notificationCenter.requestAuthorization(options: authOptions) { status, _ in
            DispatchQueue.main.async {
                if status == true {
                    self.setup()
                    completionHandler(.success(()))
                } else {
                    self.unregister()
                    completionHandler(.failure(.notAuthorizated))
                }
            }
        }
    }

    public func setup() {
        UIApplication.shared.registerForRemoteNotifications()
        notificationCenter.delegate = self
    }

    public func unregister() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
}

extension PushNotificationRepository: UNUserNotificationCenterDelegate {

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler(presantationsOptions)
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void)
    {
        self.userDidSelect?(response.notification.request.content)
        completionHandler()
    }
}
