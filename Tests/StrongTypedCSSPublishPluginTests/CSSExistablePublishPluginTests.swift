/**
*  StrongTypedCSS plugin for Publish
*  Copyright (c) Mikhail Medvedev 2021
*  MIT license, see LICENSE file for details
**/

import XCTest
@testable import Publish
@testable import Plot
@testable import Files
@testable import StrongTypedCSSPublishPlugin

final class StrongTypedCSSPublishPluginTests: XCTestCase {

	func testNoThrowWithExistingCSSClasses() {
		XCTAssertNoThrow(try publishWebsite(with: CSSExistableMock.allCases))
	}

	func testThrowWithNoExistingCSSClass() {
		XCTAssertThrowsError(try publishWebsite(with: CSSNotExistableMock.allCases))
	}

	private func publishWebsite(with cssClassMock: [StrongTypeCSS]) throws {
		let fm = FileManager()
		let cssMockURL = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("Mocks/test.css")

		let siteFolder = try Folder.createTemporary()
		let _ = try siteFolder.createCleanSubfolder(named: "Content")
		let cssFolder = try siteFolder.createCleanSubfolder(named: "Resources").createSubfolder(named: "css")

		try fm.copyItem(atPath: cssMockURL.path, toPath: cssFolder.path.appending("test.css"))

		try MockSite().publish(
			withTheme: .foundation,
			at: Path(siteFolder.path),
			additionalSteps: [.installPlugin(.checkStrongTypeCSS(of: cssClassMock))]
		)

		// deleting temporary site folder
		try siteFolder.delete()
	}

	static var allTests = [
		("testExample", testNoThrowWithExistingCSSClasses, testThrowWithNoExistingCSSClass)
	]
}

// MARK: - Stub website
private struct MockSite: Website {
	enum SectionID: String, WebsiteSectionID {
		case posts
	}

	struct ItemMetadata: WebsiteItemMetadata {}

	var url = URL(string: "https://stub.com")!
	var name = "Stub"
	var description = "description"
	var language: Language { .english }
	var imagePath: Path? { nil }
}

// MARK: - Temporary folder
extension Folder {
	static func createTemporary() throws -> Self {
		let parent = try createTestsFolder()
		return try parent.createSubfolder(named: UUID().uuidString)
	}

	func createCleanSubfolder(named: String) throws -> Folder {
		try? subfolder(named: named).delete()
		return try createSubfolder(named: named)
	}

	private static func createTestsFolder() throws -> Self {
		try Folder.temporary.createSubfolderIfNeeded(at: "VerifyResourcesExistPublishPluginTests")
	}
}
