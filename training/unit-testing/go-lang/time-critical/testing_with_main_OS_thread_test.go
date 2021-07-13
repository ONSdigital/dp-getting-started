package choicetests

import (
	"os"
	"runtime"
	"testing"
)

// init is used here to ensure current goroutine exclusively tied to current OS thread
func init() {
	runtime.LockOSThread()
}

// TestMain demonstrates the use of TestMain and also attaching the tests to the main OS thread.
// This may be usedful for some Go functionality that needs to have the test thread attached to the OS thread.
func TestMain(m *testing.M) {
	go func() {
		os.Exit(m.Run())
	}()
	runOSRoutines()
}

func runOSRoutines() {
	// Run's specific functions to ensure setup for test is acheived whilst attaching on the OS thread, perhaps to ensure priority scheduling.
}
