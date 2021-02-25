/**
*  StrongTypedCSS plugin for Publish
*  Copyright (c) Mikhail Medvedev 2021
*  MIT license, see LICENSE file for details
**/

import Publish
import Plot

public protocol StrongTypeCSS {
	var classDescription: String { get }
	var rawValue: String { get }

	func isExisting(in contents: String) -> Bool
}

public extension StrongTypeCSS {
	func isExisting(in contents: String) -> Bool {
		let lines = contents.components(separatedBy: "\n")

		let filteredCommentLines = lines.filter { !$0.contains("/*") || !$0.contains("*/") }

		for line in filteredCommentLines {
			if line.contains("." + self.rawValue) {
				return true
			}
		}
		return false
	}
}

public extension Node where Context: HTMLContext {
	static func `class`(_ existingCssClass: StrongTypeCSS...) -> Node {
		let separator = " "
		let cssClassString = existingCssClass.map { $0.rawValue }.joined(separator: separator)

		return .attribute(named: "class", value: cssClassString)
	}
}
