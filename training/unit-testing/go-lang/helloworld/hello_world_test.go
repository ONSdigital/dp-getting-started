package helloworld

import (
	"testing"

	ass "github.com/smartystreets/assertions"
	. "github.com/smartystreets/goconvey/convey"
)

// If you are new to Go check out these useful links on reddit:
// https://www.reddit.com/r/golang/comments/n5ppx5/some_resources_that_have_helped_me_learn_golang/?utm_source=share&utm_medium=web2x&context=3
//
// Test files must end in _test
// Tests in the test test file must start with exactly "Test"
// "Convey" is defining what you're about to test, or the situation
// "So" is the actual test
// "ShouldBeGreaterThan" is the assertion, or check which is being done on the value(s)
//
// To run all tests fron the command line type (ommit -v if you just want the overall result):-
// go test hello_world_test.go -v
//
// To only run this test from command line type:-
// go test hello_world_test.go -run TestHelloWorld1
//
// To only run this test with verbose tracing add a -v
// go test hello_world_test.go -run TestHelloWorld -v
//
// This should run all tests in current directory and all of its subdirectories:
// $ go test ./...
//
// This should run all tests for given specific directories:
// $ go test ./tests/... ./unit-tests/... ./my-packages/...

// This should run all tests with import path prefixed with foo/:
// $ go test foo/...

// This should run all tests import path prefixed with foo:
// $ go test foo...

// This should run all tests in your $GOPATH:
// $ go test ...
func TestHelloWorld1(t *testing.T) {
	a := 100
	b := 20
	Convey("Given two integers", t, func() {
		//Lets check the first and last one first
		Convey("Check a is larger than b", func() {
			So(a, ShouldBeGreaterThan, b)
		})
	})
}

//You can have multiple tests (So's) for each overall Convey.
func TestHelloWorld2(t *testing.T) {
	a := []int{22, 15, 10, -1, -12}
	lastIndexOfArray := len(a) - 1

	Convey("Given a series of integers in an array, check they are decending in value starting from index 0", t, func() {
		Convey("Checking the first and last entries as an initial first check", func() {
			So(a[0], ShouldBeGreaterThan, a[lastIndexOfArray])
			Convey("Checking all the remaining entries", func() {
				So(a[0], ShouldBeGreaterThan, a[1])
				So(a[1], ShouldBeGreaterThan, a[2])
				So(a[2], ShouldBeGreaterThan, a[3])
				So(a[3], ShouldBeGreaterThan, a[4])
				// If you are wondering why we didn't put these in a loop it was because to keep things simple as things can get a little
				//complicated with loops and Convey as you can see in folder 4.orderOfExecution ;-)
			})
		})

	})
}

// TestHelloWorld3 is a half finished test where we want Convey to only test the tests that are finished.
// Focus Convey - all sub Convey's need to be FocusConvey's otherwise they are ignored.
// SkipConvey - all Convey's and tests underneath will be skipped
// SkipSo - this test is skipped
func TestHelloWorld3(t *testing.T) {
	const MaxDifference = 3
	FocusConvey("Given two numbers check x is greater than y", t, func() { //ONLY TESTS WITH FOCUS ARE RUN.
		x, y := 99, 100
		diff := y - x
		if ok, message := ass.So(x, ShouldBeGreaterThan, y); !ok {
			//Using Print instead of Println because it ensures that output is aligned with the corresponding scopes in the web UI.
			Print(message)
			FocusConvey("Given X is bigger than Y, check the difference between isn't too large", func() {
				So(diff, ShouldBeLessThanOrEqualTo, MaxDifference)
			})
		} else {
			Convey("Given Y is bigger than X, check the difference between isn't too large", func() { //THIS TEST SHOULD BE SKIPPED
				So(diff, ShouldBeLessThanOrEqualTo, MaxDifference)
			})
		}
	})
	Convey("Given two numbers check they are the same", t, func() {
		a, b := 10, 10.1
		SkipSo(a, ShouldAlmostEqual, b) //ANOTHER WAY OF GETTING TEST SKIPPED
	})
	SkipConvey("All Convey's under here will be skipped", t, func() {
		Convey("This is a test which will be skipped", func() {
			So("dog", ShouldEqual, "cat")
			Convey("This is yet another test which will be skipped", func() {
				So("dog", ass.ShouldBeGreaterThan, "cat")
			})
		})
	})
}

func TestIncludesReset(t *testing.T) {
	Convey("First-level bla bla", t, func() {
		isReset := "test"

		Convey("For isReset with value other", func() {
			isReset = "other"
			So(isReset, ShouldEqual, "other")
		})

		Convey("For a nested Reset example", func() {
			isReset = "innerTest"
			So(isReset, ShouldEqual, "innerTest")
			Convey("For this inner a different isReset is called after this inner Convey is run", func() {
				isReset = "innerInnerTest"
				So(isReset, ass.ShouldEqual, "innerInnerTest")
				//A Convey's Reset() runs at the end of each Convey() within that same scope.
				Reset(func() {
					isReset = "test"
				})
			})
		})

		Convey("For a given isReset", func() {
			So(isReset, ShouldEqual, "test")
		})

		//A Convey's Reset() runs at the end of each Convey() within that same scope.
		Reset(func() {
			isReset = "test"
		})

	})
}
