context("report data")


test_that("report.numeric", {
  r <- report(seq(0, 1, length.out = 100))
  testthat::expect_equal(as.data.frame(r)$Mean, 0.5, tol = 0)
  testthat::expect_null(as.report_table(r, summary = TRUE)$Median)

  r <- report(seq(0, 1, length.out = 100), centrality = "median", range = FALSE, dispersion = FALSE, missing_percentage = TRUE)
  testthat::expect_equal(as.data.frame(r)$Median, 0.5, tol = 0)
  testthat::expect_equal(as.data.frame(r)$percentage_Missing, 0, tol = 0)
  testthat::expect_null(summary(as.data.frame(r))$Mean)
  testthat::expect_null(summary(as.data.frame(r))$Min)
  testthat::expect_null(summary(as.data.frame(r))$MAD)
  testthat::expect_warning(report(c(0, 0, 0, 1, 1)))
})


test_that("report.character", {
  x <- c("A", "B", "C", "A", "B", "B", "D", "E", "B", "D", "A")
  r <- report(x)
  testthat::expect_equal(nrow(as.data.frame(r)), 1, tol = 0)
  testthat::expect_null(as.data.frame(r)$Median)

  r <- report(x, levels_percentage = FALSE, missing_percentage = TRUE)
  testthat::expect_equal(nrow(as.data.frame(r)), 1, tol = 0)
  testthat::expect_equal(as.data.frame(r)$percentage_Missing[1], 0, tol = 0)
})


context("report.factor")

test_that("report.factor", {
  r <- report(factor(rep(c("A", "B", "C"), 10)))
  testthat::expect_equal(nrow(as.data.frame(r)), 3, tol = 0)
  testthat::expect_null(as.data.frame(r)$Median)

  r <- report(factor(rep(c("A", "B", "C", NA), 10)), levels_percentage = FALSE)
  testthat::expect_equal(nrow(as.data.frame(r)), 4, tol = 0)
})


test_that("report.data.frame", {
  r <- report(iris)
  testthat::expect_equal(nrow(as.data.frame(r)), 7, tol = 0)
  testthat::expect_equal(mean(as.data.frame(r)$Median, na.rm = TRUE), 3.6125)

  r <- report(iris, levels_percentage = FALSE, missing_percentage = TRUE, median = TRUE, range = FALSE, dispersion = FALSE)
  testthat::expect_equal(nrow(as.data.frame(r)), 7, tol = 0)
  testthat::expect_equal(mean(as.data.frame(r)$n_Obs), 107, tol = 0.01)

  r <- report(dplyr::group_by_at(iris, "Species"))
  testthat::expect_equal(nrow(as.data.frame(r)), 12, tol = 0)
  testthat::expect_equal(mean(as.data.frame(r)$n_Obs), 50, tol = 0)
})
