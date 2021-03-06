//
//  ViewTests.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/7/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import Prototope
import XCTest
import Foundation

class ViewTests: XCTestCase {
	func testSublayers() {
		let parent1 = Layer(parent: nil)
		let child = Layer(parent: parent1)
		XCTAssertEqual(parent1.sublayers, [child])
		XCTAssertEqual(child.parent!, parent1)

		let parent2 = Layer(parent: nil)
		child.parent = parent2
		XCTAssertEqual(parent1.sublayers, [])
		XCTAssertEqual(parent2.sublayers, [child])
	}

	func testAncestorNamed() {
		let superparent = Layer(parent: nil, name: "A")
		let parent = Layer(parent: superparent, name: "B")
		let child = Layer(parent: parent, name: "C")

		XCTAssertEqual(child.ancestorNamed("A")!, superparent)
		XCTAssertNil(child.ancestorNamed("D"))

		let alternativeParent = Layer(parent: superparent, name: "A")
		child.parent = alternativeParent
		XCTAssertEqual(child.ancestorNamed("A")!, alternativeParent)
	}

	func testSublayerAtFront() {
		let parent = Layer(parent: nil)
		let child1 = Layer(parent: parent)
		let child2 = Layer(parent: parent)

		XCTAssertEqual(parent.sublayerAtFront!, child2)
		XCTAssertNil(child2.sublayerAtFront)
	}

	func testSublayerNamed() {
		let parent = Layer(parent: nil)
		let child1 = Layer(parent: parent, name: "A")
		let child2 = Layer(parent: parent, name: "B")
		XCTAssertEqual(parent.sublayerNamed("A")!, child1)
		XCTAssertEqual(parent.sublayerNamed("B")!, child2)
	}

	func testDescendentNamed() {
		let superparent = Layer(parent: nil, name: "A")
		let redHerring = Layer(parent: superparent, name: "Nope")
		let parent = Layer(parent: superparent, name: "B")
		let child = Layer(parent: parent, name: "C")

		XCTAssertEqual(superparent.descendentNamed("C")!, child)
		XCTAssertNil(superparent.descendentNamed("What?"))

		XCTAssertEqual(superparent.descendentAtPath(["B", "C"])!, child)
		XCTAssertNil(superparent.descendentAtPath(["C"]))
	}

	func testRemoveAllSublayers() {
		let parent = Layer(parent: nil)
		let child1 = Layer(parent: parent)
		let child2 = Layer(parent: parent)

		parent.removeAllSublayers()
		XCTAssertEqual(parent.sublayers, [])
		XCTAssertNil(child1.parent)
		XCTAssertNil(child2.parent)
	}

	func testContainsGlobalPoint() {
		let parent = Layer(parent: nil)
		parent.frame = Rect(x: 0, y: 0, width: 200, height: 200)
		let child1 = Layer(parent: parent)
		child1.frame = Rect(x: 30, y: 30, width: 50, height: 50)

		XCTAssertTrue(child1.containsGlobalPoint(Point(x: 30, y: 30)))
		XCTAssertFalse(child1.containsGlobalPoint(Point(x: 29, y: 30)))
		XCTAssertFalse(child1.containsGlobalPoint(Point(x: 80, y: 30)))
		XCTAssertTrue(child1.containsGlobalPoint(Point(x: 79, y: 30)))
	}
}
