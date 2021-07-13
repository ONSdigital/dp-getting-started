package helloworld

import (
	"os"
	"testing"

	. "github.com/smartystreets/goconvey/convey"
)

// TestMain should start `TestMain` otherwise you cannot use (m *testing.M)
// Which is called first, unless an init function is present, where that will be called first.
// Using this method allows you to control:
//  1) Setup.
//  3) Shutdown.
//  2) How and when to run the tests.
//  4) Exit behavior.
func TestMain(m *testing.M) {
	setup()
	code := m.Run()
	shutdown()
	// THE FOLLOWING LINE IS VERY IMPORTANT and cannot be removed for TestMain func's
	os.Exit(code)
}

func TestServiceSuccessWithConvey(t *testing.T) {
	a := 100
	b := 20
	Convey("Given two integers", t, func() {
		// Lets check the first and last one first
		Convey("Check a is larger than b", func() {
			So(a, ShouldBeGreaterThan, b)
		})
	})
}

func setup() {
	// Do stuff
}

func shutdown() {
	// Do Stuff
}
