import Foundation
import XCTest

@testable import Gist

final class GistDigestTests: XCTestCase {

    func test_fileInit_shouldAssignTheProperValues() {
        let expectedName = String.anyValue
        let expectedType = String.anyValue

        let sut = GistDigest.File(name: expectedName, type: expectedType)

        XCTAssertEqual(sut.name, expectedName)
        XCTAssertEqual(sut.type, expectedType)
    }

    func test_ownerInit_shouldAssignTheProperValues() {
        let expectedName = String.anyValue
        let expectedUrl = Optional<URL>.anyValue

        let sut = GistDigest.Owner(name: expectedName, avatarUrl: expectedUrl)

        XCTAssertEqual(sut.name, expectedName)
        XCTAssertEqual(sut.avatarUrl, expectedUrl)
    }

    func test_gistDigestInit_shouldAssignTheProperValues() {
        let expectedFileName = String.anyValue
        let expectedFileType = String.anyValue
        let expectedOwnerName = String.anyValue
        let expectedOwnerUrl = Optional<URL>.anyValue
        let expectedDescription = String.anyValue
        let expectedFiles = [GistDigest.File(name: expectedFileName, type: expectedFileType)]
        let owner = GistDigest.Owner(name: expectedOwnerName, avatarUrl: expectedOwnerUrl)

        let sut = GistDigest(description: expectedDescription, owner: owner, files: expectedFiles)

        XCTAssertNotNil(sut.files.first)
        XCTAssertEqual(sut.files.count, expectedFiles.count)
        XCTAssertEqual(sut.files.first?.name, expectedFileName)
        XCTAssertEqual(sut.files.first?.type, expectedFileType)
        XCTAssertEqual(sut.owner.name, expectedOwnerName)
        XCTAssertEqual(sut.owner.avatarUrl, expectedOwnerUrl)
        XCTAssertEqual(sut.description, expectedDescription)
    }
}