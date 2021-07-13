package helloworld

import (
	"testing"

	. "github.com/smartystreets/goconvey/convey"
)

// TestHelloWorldX calls other tests.  You could use this way of splitting your tests up if they are too large.
// Note t doesn't need to be passed.
func TestHelloWorldX(t *testing.T) {
	a := 100
	b := 20
	Convey("Given two integers", t, func() {
		//Lets check the first and last one first
		Convey("Check a is larger than b", func() {
			aTestA()
			aTestB()
			So(a, ShouldBeGreaterThan, b)
		})
	})
}

func aTestA() {
	Println("testA.  Print is Convey's equivalent to fmt.Println")
	Convey("Scenario: one", func() {
		Convey("Given ", func() {
			So(1, ShouldBeGreaterThan, 0)
			Convey("When ", func() {
				So(1, ShouldBeGreaterThan, -1)
				Convey("Then ", func() {
				})
			})
		})
	})
}

func aTestB() {
	Println("testB.  Print is Convey's equivalent to fmt.Println")
	Convey("Scenario: two ", func() {
		Convey("Given ", func() {
			So(2, ShouldBeGreaterThan, 0)
			Convey("When ", func() {
				So(2, ShouldBeGreaterThan, 1)
				Convey("Then ", func() {
				})
			})
		})
	})
}
