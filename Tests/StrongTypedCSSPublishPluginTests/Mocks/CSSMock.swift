/**
*  StrongTypedCSS plugin for Publish
*  Copyright (c) Mikhail Medvedev 2021
*  MIT license, see LICENSE file for details
**/

import StrongTypedCSSPublishPlugin

enum CSSExistableMock: String, CaseIterable {
	case testButton
	case testImage
}

extension CSSExistableMock: StrongTypeCSS {

	var classDescription: String { "CSSExistableMock" }
}

enum CSSNotExistableMock: String, CaseIterable {
	case testFlight
}

extension CSSNotExistableMock: StrongTypeCSS {

	var classDescription: String { "CSSNotExistableMock" }
}
