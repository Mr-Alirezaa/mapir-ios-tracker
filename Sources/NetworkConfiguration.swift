//
//  NetworkUtilities.swift
//  MapirLiveTracker-iOS
//
//  Created by Alireza Asadi on 13/5/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import Foundation
import CocoaMQTT
import UIKit

/// An object that represents a network configuration for the service.
public class NetworkConfiguration {

    /// API base URL.
    ///
    /// This url is used to fetch topics for tracking identifier.
    public let authenticationServiceURL: URL

    /// Maximum network retries.
    public let maximumNetworkRetries: Int

    /// MQTT Broker address.
    public let brokerAddress: String

    /// MQTT Broker port.
    public let brokerPort: UInt16

    /// Quality of Service for MQTT packets.
    public let qos: CocoaMQTTQOS

    /// Indicates that the configuration uses SSL or not.
    public let usesSSL: Bool

    /// Shared `URLSession` instance for the service.
    public let session: URLSession

    /// Default Map.ir service configuration.
    ///
    /// - Attention: If you are using live tracking service with Map.ir infrastructre, you have to use this default configurations.
    public static let mapirDefault = NetworkConfiguration(authenticationServiceURL: URL(string: "https://tracking-dev.map.ir/")!,
                                                          maximumRetries: 3,
                                                          brokerAddress: "dev.map.ir",
                                                          port: 1883,
                                                          qos: .qos0,
                                                          usesSSL: false,
                                                          session: .shared)

    /// Creates a customized network configuration.
    ///
    /// - Parameter authenticationServiceURL: URL to fetch topics for tracking identifier.
    /// - Parameter maximumRetries: Maximum network retries.
    /// - Parameter brokerAddress: MQTT Broker address.
    /// - Parameter port: MQTT Broker port.
    /// - Parameter qos: Quality of Service for MQTT packets.
    /// - Parameter usesSSL: Indicates that the configuration uses SSL or not.
    /// - Parameter session: Shared `URLSession` instance for the service.
    ///
    /// If you use Map.ir Live Tracking Service on your own infrastructure,
    /// you can create a custom configuration using this initializer.
    public init(authenticationServiceURL: URL, maximumRetries: Int, brokerAddress: String, port: UInt16, qos: CocoaMQTTQOS, usesSSL: Bool, session: URLSession) {
        self.authenticationServiceURL = authenticationServiceURL
        self.brokerAddress = brokerAddress
        self.brokerPort = port
        self.maximumNetworkRetries = 3
        self.qos = qos
        self.usesSSL = usesSSL
        self.session = session
    }

    static let userAgent: String = {
        var components: [String] = []

        if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? Bundle.main.infoDictionary?["CFBundleIdentifier"] as?String {
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            components.append("\(appName)/\(version)")
        }

        // Replace Your bundle name
        let libraryBundle: Bundle? = Bundle(for: NetworkConfiguration.self)

        if let libraryName = libraryBundle?.infoDictionary?["CFBundleName"] as? String, let version = libraryBundle?.infoDictionary?["CFBundleShortVersionString"] as? String {
            components.append("\(libraryName)/\(version)")
        }

        let system: String
        #if os(OSX)
            system = "macOS"
        #elseif os(iOS)
            system = "iOS"
        #elseif os(watchOS)
            system = "watchOS"
        #elseif os(tvOS)
            system = "tvOS"
        #endif
        let systemVersion = ProcessInfo().operatingSystemVersion
        components.append("\(system)/\(systemVersion.majorVersion).\(systemVersion.minorVersion).\(systemVersion.patchVersion)")

        let chip: String
        #if arch(x86_64)
            chip = "x86_64"
        #elseif arch(arm)
            chip = "arm"
        #elseif arch(arm64)
            chip = "arm64"
        #elseif arch(i386)
            chip = "i386"
        #endif
        components.append("(\(chip))")

        return components.joined(separator: " ")
    }()

    static let deviceIdentifier: UUID = {
        #if os(iOS) || os(watchOS) || os(tvOS)
        if let uuid = UIDevice.current.identifierForVendor {
            return uuid
        }
        #endif
        return UUID()
    }()
}
