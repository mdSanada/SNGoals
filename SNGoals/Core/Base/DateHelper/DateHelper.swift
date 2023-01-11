//
//  DateHelper.swift
//  maximadigital
//
//  Created by Matheus D Sanada on 15/08/22.
//

import Foundation
/// Date and time format styles
///
/// ```
/// case complete // "15 de agosto de 2022 - 15:28:24".
/// case long // "15 de agosto de 2022"
/// case numeric // "15/08/2022"
/// case expanded_hours // "15-08-2022 às 16h"
/// case api // "2022-08-15"
/// case expanded_api // "2022-08-15T16:00:00"
/// case other(pattern: String) // "pattern"
/// ```

public enum DatePattern {
    /// Example "15 de agosto de 2022 - 15:28:24".
    case complete
    /// Example "15 de agosto de 2022".
    case long
    /// Example "15/08/2022".
    case numeric
    /// Example "15-08-2022 às 16h".
    case expanded_hours
    /// Example "2022-08-15".
    case api
    /// Example "2022-08-15T16:00:00".
    case expanded_api
    case other(pattern: String)
}

extension DatePattern {
    fileprivate func string() -> String {
        switch self {
        case .complete: return "dd ' de ' MMMM ' de ' yyyy ' - ' HH:mm:ss"
        case .long: return "dd 'de' MMMM 'de' yyyy"
        case .numeric: return "dd/MM/yyyy"
        case .expanded_hours: return "dd-MM-yyyy 'às' HH'h'"
        case .api: return "yyyy-MM-dd"
        case .expanded_api: return "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case let .other(pattern): return pattern
        }
    }
}
/// Timezone
///
/// ```
/// case UTC // "Timezone UTC".
/// case PT_BR // "Timezone America/Sao_Paulo"
/// ```
public enum DateTimeZone {
    /// UTC
    case UTC
    /// BRT
    case PT_BR
}

public extension DateTimeZone {
    func timezone() -> TimeZone {
        switch self {
        case .UTC:
            return TimeZone(abbreviation: "UTC") ?? .current
        case .PT_BR:
            return TimeZone(abbreviation: "BRT") ?? .current
        }
    }
    
    func locale() -> Locale {
        return Locale(identifier: "pt_BR")
    }
}

extension String {
    ///
    /// Produce a ``Date`` from a ``String``.
    ///
    /// > Warning: This function has been created to convert Local Date Time (PT_BR) retrieved from API
    ///
    /// - parameters:
    ///     - timezone: `DateTimeZone = .PT_BR` Timezone, is the TimeZone of the given Date. If you are passing an PT_BR Date, must use `DateTimeZone.PT_BR`, otherwise if the given Date is UTC, must use `DateTimeZone.UTC`
    ///         - `DateTimeZone.PT_BR`, will assume that the date is on Brazil TimeZone (-0300).
    ///         *In the conversion  **will add 3 (+3)**, to get date UTC.*
    ///         - `DateTimeZone.UTC`, will assume that the date is on UTC (+0000).
    ///         *In the conversion **will mantain exactly hour**, it is already UTC`.*
    ///
    /// > Example:
    ///  ```
    ///     "2022-08-10T00:00:00".date(timezone: DateTimeZone.PT_BR)
    ///     // Optional(2022-08-10 03:00:00 +0000)
    ///  ```
    ///
    ///  ```
    ///     "2022-08-10T00:00:00".date(timezone: DateTimeZone.UTC)
    ///     // Optional(2022-08-10 00:00:00 +0000)
    ///  ```
    ///
    /// - Returns: Generates a `UTC Date` using specified string and timezone format.
    func date(timezone: DateTimeZone = .PT_BR) -> Date? {
        let formats: [String] = ["yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                 "yyyy-MM-dd'T'HH:mm:ss.SSS",
                                 "yyyy-MM-dd'T'HH:mm:ssZZZZ",
                                 "yyyy-MM-dd'T'HH:mm:ssZ",
                                 "yyyy-MM-dd'T'HH:mm:ss",
                                 "yyyy-MM-dd'T'HH:mmZ",
                                 "yyyy-MM-dd'T'HH:mm",
                                 "yyyy-MM-ddZZZZ",
                                 "yyyy-MM-ddZ",
                                 "yyyy-MM-dd",
                                 "HH:mm:ss",
                                 "yyyyMMdd",
                                 "ddMMYYYY",
                                 "dd-MM-YYYY",
                                 "dd/MM/yyyy"];
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timezone.timezone()
        dateFormatter.locale = timezone.locale()
        for format in formats {
            dateFormatter.dateFormat = format
            let date = dateFormatter.date(from: self)
            if let safeDate = date {
                return safeDate
            }
        }
        return nil
    }
}

extension Date {
    ///
    /// Produce a formatted ``String`` from a ``Date``.
    ///
    /// > Warning: This function has been created to convert Local Date Time (PT_BR) retrieved from API
    ///
    /// > Example:
    ///
    ///  ```
    ///  Date().string(pattern: .numeric) // "15/08/2022"
    ///  ```
    /// - parameters:
    ///     - pattern: `DatePattern` Date and time format styles.
    ///     - timezone: `DateTimeZone = .PT_BR` Timezone, is the TimeZone of the given Date. If you are passing an PT_BR Date, must use `DateTimeZone.PT_BR`, otherwise if the given Date is UTC, must use `DateTimeZone.UTC`
    ///         - `DateTimeZone.PT_BR`, will assume that the date is on Brazil TimeZone (-0300).
    ///         - `DateTimeZone.UTC`, will assume that the date is on UTC (+0000).
    ///
    ///
    /// - Returns: Generates a `string` representation of a date using specified date and time format.
    public func string(pattern: DatePattern, timezone: DateTimeZone = .PT_BR) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timezone.timezone()
        formatter.locale = DateTimeZone.PT_BR.locale()
        formatter.dateFormat = pattern.string()
        let date = formatter.string(from: self)
        return date
    }
}
