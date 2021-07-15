//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.color` struct is generated, and contains static references to 1 colors.
  struct color {
    /// Color `AccentColor`.
    static let accentColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "AccentColor")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func accentColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.accentColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func accentColor(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.accentColor.name)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 1 images.
  struct image {
    /// Image `launch`.
    static let launch = Rswift.ImageResource(bundle: R.hostingBundle, name: "launch")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "launch", bundle: ..., traitCollection: ...)`
    static func launch(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.launch, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.nib` struct is generated, and contains static references to 3 nibs.
  struct nib {
    /// Nib `QHIndexViewCell`.
    static let qhIndexViewCell = _R.nib._QHIndexViewCell()
    /// Nib `QHStockTableHeaderViewCell`.
    static let qhStockTableHeaderViewCell = _R.nib._QHStockTableHeaderViewCell()
    /// Nib `QHStockViewCell`.
    static let qhStockViewCell = _R.nib._QHStockViewCell()

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "QHIndexViewCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.qhIndexViewCell) instead")
    static func qhIndexViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.qhIndexViewCell)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "QHStockTableHeaderViewCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.qhStockTableHeaderViewCell) instead")
    static func qhStockTableHeaderViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.qhStockTableHeaderViewCell)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "QHStockViewCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.qhStockViewCell) instead")
    static func qhStockViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.qhStockViewCell)
    }
    #endif

    static func qhIndexViewCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> QHIndexViewCell? {
      return R.nib.qhIndexViewCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? QHIndexViewCell
    }

    static func qhStockTableHeaderViewCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> QHStockTableHeaderViewCell? {
      return R.nib.qhStockTableHeaderViewCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? QHStockTableHeaderViewCell
    }

    static func qhStockViewCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> QHStockViewCell? {
      return R.nib.qhStockViewCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? QHStockViewCell
    }

    fileprivate init() {}
  }

  /// This `R.reuseIdentifier` struct is generated, and contains static references to 3 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `QHIndexViewCell`.
    static let qhIndexViewCell: Rswift.ReuseIdentifier<QHIndexViewCell> = Rswift.ReuseIdentifier(identifier: "QHIndexViewCell")
    /// Reuse identifier `QHStockTableHeaderViewCell`.
    static let qhStockTableHeaderViewCell: Rswift.ReuseIdentifier<QHStockTableHeaderViewCell> = Rswift.ReuseIdentifier(identifier: "QHStockTableHeaderViewCell")
    /// Reuse identifier `QHStockViewCell`.
    static let qhStockViewCell: Rswift.ReuseIdentifier<QHStockViewCell> = Rswift.ReuseIdentifier(identifier: "QHStockViewCell")

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct nib {
    struct _QHIndexViewCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = QHIndexViewCell

      let bundle = R.hostingBundle
      let identifier = "QHIndexViewCell"
      let name = "QHIndexViewCell"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> QHIndexViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? QHIndexViewCell
      }

      fileprivate init() {}
    }

    struct _QHStockTableHeaderViewCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = QHStockTableHeaderViewCell

      let bundle = R.hostingBundle
      let identifier = "QHStockTableHeaderViewCell"
      let name = "QHStockTableHeaderViewCell"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> QHStockTableHeaderViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? QHStockTableHeaderViewCell
      }

      fileprivate init() {}
    }

    struct _QHStockViewCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = QHStockViewCell

      let bundle = R.hostingBundle
      let identifier = "QHStockViewCell"
      let name = "QHStockViewCell"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> QHStockViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? QHStockViewCell
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }
  #endif

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
      #if os(iOS) || os(tvOS)
      try main.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }
    #endif

    #if os(iOS) || os(tvOS)
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UITabBarController

      let bundle = R.hostingBundle
      let name = "Main"
      let qhDetailViewController = StoryboardViewControllerResource<QHDetailViewController>(identifier: "QHDetailViewController")

      func qhDetailViewController(_: Void = ()) -> QHDetailViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: qhDetailViewController)
      }

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
        if _R.storyboard.main().qhDetailViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'qhDetailViewController' could not be loaded from storyboard 'Main' as 'QHDetailViewController'.") }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
