package orderexecution

import (
	"fmt"
	"strconv"
	"testing"

	. "github.com/smartystreets/goconvey/convey"
)

// TestOrderOfExe shows the order of execution of Convey
//  Convey A
//      So 1
//      Convey B
//          So 2
//          Convey Q
//          	So 9
//      Convey C
//          So 3
//
// Result would be A1,B2,Q9,A1,B2,C3
func TestOrderOfExe(t *testing.T) {
	Convey("A", t, func() {
		So(1, ShouldEqual, 1)
		Convey("B", func() {
			So(2, ShouldEqual, 2)
			Convey("C", func() {
				So(3, ShouldEqual, 3)
			})
			Convey("D", func() {
				So(4, ShouldEqual, 4)
			})
		})
	})
}

var S = 0

func display(msg string) {
	fmt.Printf("S=%d msg=%s\n", S, msg)
	Println("hello")
	S++
}
func Test_Output(t *testing.T) {
	Convey("Given a loop", t, func() {
		for i := 0; i < 3; i++ {
			display("Looping")
			Convey(fmt.Sprintf("Inner Convey %d", i), func() {
				display("More looping")
			})
		}

	})
}

var count = 0

func printIt(i int) {
	fmt.Println("\nCount=", strconv.Itoa(i))
}
func TestShowsGotcha(t *testing.T) {
	Convey("Outer convey", t, func() {
		count++
		printIt(count)
		So(1, ShouldEqual, 1)
		Convey("First Inner Convey", func() {
			printIt(count)
			So(2, ShouldEqual, 2)
		})
		Convey("Second Inner Convey", func() {
			printIt(count)
			So(3, ShouldEqual, 3)
		})
		//SKIPPED
		SkipSo(count, ShouldEqual, 1)
		//SKIPPED
		SkipSo(count, ShouldEqual, 2)
		//Here the count is either 2 or 1 depending on scheduling i.e. its a Race Condition
		So(count, ShouldEqual, count)
	})
	printIt(count)
}
