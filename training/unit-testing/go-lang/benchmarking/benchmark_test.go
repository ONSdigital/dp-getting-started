package benchmarking

import (
	"fmt"
	"runtime"
	"testing"

	// ass "github.com/smartystreets/assertions"
	. "github.com/smartystreets/goconvey/convey"
)

//init is used here to ensure current goroutine exclusively tied to current OS thread
func init() {
	runtime.LockOSThread()
}

// TestMain demonstrates the use of TestMain and also attaching the tests to the main OS thread.
// Can be run with the following command `go test -run=XXX -bench=.`This may be usedful for some Go functionality that needs to have the test thread attached to the OS thread.
// XXX is a regular expression which is to match any functions that need to be also run as part of the Benchmarking
// The dot after `bench=` is a regular expression to match which Benchmark tests to run.
//
// Go Testing decides how many iterations are required to create an accurate timed figure, and this is why b.N is used.
func BenchmarkTest1(b *testing.B) {
	Convey("Given a benchmark test to display a dot", b, func() {
		for i := 0; i < b.N; i++ {
			fmt.Print(".")
		}
	})
}
