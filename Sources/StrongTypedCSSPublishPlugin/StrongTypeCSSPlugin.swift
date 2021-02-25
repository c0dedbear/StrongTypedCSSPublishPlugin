/**
*  StrongTypedCSS plugin for Publish
*  Copyright (c) Mikhail Medvedev 2021
*  MIT license, see LICENSE file for details
**/

import Publish

public extension Plugin {
	static func checkStrongTypeCSS(of cssClasses: [StrongTypeCSS],
								   cssFilesFolderPath: Path = "Resources/css") throws -> Self {
		Plugin(name: "StrongTypeCSS") { context in
				guard let files = try? context.folder(at: cssFilesFolderPath).files else {
					 throw PublishingError(stepName: "Search for css files folder",
										   infoMessage: "🔴 Folder with css files not found at '\(cssFilesFolderPath.string)'")
				}

				guard files.count() > 0 else {
					throw PublishingError(stepName: "Search for css files folder",
										  infoMessage: "🔴 There are no files found in '\(cssFilesFolderPath.string)'")
				}

				var cssFilesContents = [String]()

				try files.forEach {
					guard let fileContentString = try? $0.readAsString() else {
						throw PublishingError(stepName: "Reading css file's content",
											  infoMessage: "🔴 Can't read \($0.name) as String")
					}
					cssFilesContents.append(fileContentString)
				}

				try cssClasses.forEach {
					guard $0.isExisting(in: cssFilesContents.joined(separator: " ")) else {
						throw PublishingError(stepName: "Checking StrongTypeCSS class existance inside css",
											  infoMessage: "🔴 '\($0.classDescription).\($0.rawValue)' not found in files \(files.names()) contents. Please check it's name or add it in stylesheets")
					}
				}
		}
	}
}
