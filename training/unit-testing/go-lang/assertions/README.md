## Go Convey Assertions
When you are creating tests, you normally need to compare what you expected with the actual result.  GoConvey makes this process far easier by providing you lots of different means of comparing objects - these are called assertions.  For example, result should be nil, or the result should be greater than X.
  
### Potential Pitfalls
- Comparison's of objects isn't always that simple.  Some objects are complex and can have many embedded values within the object to compare. GoConvey by default will use Go's default comparison routines, which have their limitations.  
- Also, some objects may equate in one operating system, and may not in the other OS.  For example Mac OS and Ubuntu.  This is beyond the scope of this page, and the author(!), however here is an [occasion](https://github.com/ONSdigital/dp-healthcheck/pull/24/files#diff-52fd3f5f090099f6447ed6aa7948ca76b3ab6c086bb8a7909b70f48fe7473e0bR839) of where this occurred.
- The example occasion above utilised GoCmp which seems to do a better job of comparing than Go's implementation out the box [GoCmp](https://github.com/google/go-cmp).  The `ShouldBeTrue` assertion can be used, e.g. `So(cmp.Equal(object1, object2), ShouldBeTrue)`.
- Comparing Error Types can be troublesome, and ideally useful to design out using [interface reflection](https://dave.cheney.net/2016/04/27/dont-just-check-errors-handle-them-gracefully)

### Assertion Examples
GoConvey comes with many Assertions.  Here are some examples:
- [From GoConvey's website](https://github.com/smartystreets/goconvey/wiki/Assertions)
- [Scroll half way down for more examples](https://www.programmersought.com/article/5383917628/)
- [Other uses of Assertions](https://smartystreets.com/blog/2015/08/go-testing-part-4-standalone-assertions/)

### Custom Assertions
If the Assertion that you require isn't available, you can create your own.  See [GoConvey's page](https://github.com/smartystreets/goconvey/wiki/Custom-Assertions)


