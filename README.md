# StrongTypedCSSPublishPlugin

[![Tests](https://github.com/c0dedbear/StrongTypedCSSPublishPlugin/actions/workflows/tests.yml/badge.svg)](https://github.com/c0dedbear/StrongTypedCSSPublishPlugin/actions/workflows/tests.yml)
![Swift 5.3](https://img.shields.io/badge/Swift-5.3-orange.svg)<a href="https://swift.org/package-manager">
<img src="https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
</a>![Mac](https://img.shields.io/badge/platforms-mac-brightgreen.svg?style=flat)<a href="https://github.com/JohnSundell/Publish">
<img src="https://img.shields.io/badge/Publish-Plugin-orange.svg?style=flat" alt="Publish Plugin" />
</a>

Make your stylesheets classes **strong-typed** within powerful Swift enums 💥

## Installation

Add the package to your SPM dependencies.

```swift
.package(name: "StrongTypedCSSPublishPlugin", url: "https://github.com/c0dedbear/StrongTypedCSSPublishPlugin", from: "0.1.0"),
```

## Usage

1. Put your stylesheets files (.css, .scss, .sass) at the **"Resources/css"** folder (it's default path, but you can changed it).
2. Create your own enum(or enums) with **String rawValue** cases duplicating stylesheets class names and conform it to "**StrongTypeCSS**" and "**CaseIterable**" protocols. 
```swift
import StrongTypedCSSPublishPlugin
...
enum CSS: String, CaseIterable {
	case container
	case myPost = "my-post"
  case marginLeft = "margin-left"
...
}
extension CSS: StrongTypeCSS {
	var classDescription: String { "CSS" }
}

enum CSSAnimation: String, CaseIterable {
	case fadeIn
	case fadeOut
...
}
extension CSSAnimation: StrongTypeCSS {
	var classDescription: String { "CSSAnimation" }
}
```

2. Install the plugin using publishing pipeline like this (better if you place it at a very beginning of pipeline):
```swift
import StrongTypedCSSPublishPlugin
...
try YourSite().publish(
	withTheme: .foundation,
	additionalSteps: [
		.addCustomPages(),
...
	],
	plugins: [
		.checkStrongTypeCSS(of: CSS.allCases + CSSAnimation.allCases), // this is it
		.compileSass(sassFilePath: "Resources/css/styles.scss", cssFilePath: "styles.css"),
	]
)
```
Note that if your css files not placed  in the **"Resources/css"**, you must change '**cssFilesFolderPath**' parameter of '**checkStrongTypeCSS**' method.

3.  Done! Use it in the **.class** Node context like this:
```swift
// Note that you don't need import plugin in places where you build your HTML
...
func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
	HTML(
		.lang(context.site.language),
		.head(for: page, on: context.site),
		.body(
			.header(for: context, selectedSection: nil),
			.div(
				// Strong typed CSS class node
				.class(CSS.container),
				.p(
				// When you need a few classes, just put them together separated with comma
				.class(CSS.myPost, CSS.marginLeft),
				"Sample text"
				 ),
        .button(
          .class(CSSAnimation.fadeIn),
          .text("Tap me")
        )
			)
		)
	)
}
```

### How it works?
If **rawValue** of **StrongTypeCSS-conformed** enum will not be found in stylesheet files contents - compiler will throw an error (with some description), and then interrupt execution.
Types of errors:

```swift
// Folder with css files not found (check 'cssFilesFolderPath' parameter when installing plugin)
"🔴 Folder with css files not found at '\(cssFilesFolderPath)'")
// Folder was found, but it's empty or without stylesheets files inside.
"🔴 There are no files found in '\(cssFilesFolderPath)'")
// Can't parse file
"🔴 Can't read \($0.name) as String"
// Enum case not found among your stylesheet files
"🔴 '\($0.classDescription).\($0.rawValue)' not found in files \(files.names()) contents. Please check it's name or add it in stylesheets")
```

# Author
<img src="authorlogo.png" alt="logo"/> Mikhail Medvedev | http://bearlogs.ru

