source(file.path("..", "..", "R", "generate_data.R"))
source(file.path("..", "..", "R", "analysis.R"))

orders <- generate_orders(n = 1500, seed = 1)

test_that("generator is deterministic and valid", {
  expect_identical(generate_orders(200, seed = 9), generate_orders(200, seed = 9))
  expect_true(all(orders$revenue > 0))
  expect_true(all(orders$rating >= 1 & orders$rating <= 5))
  expect_equal(length(unique(orders$order_id)), nrow(orders))
})

test_that("category shares sum to 1 and totals reconcile", {
  c <- category_summary(orders)
  expect_equal(sum(c$share), 1)
  expect_equal(sum(c$revenue), sum(orders$revenue))
})

test_that("monthly revenue covers every month and first growth is NA", {
  m <- monthly_revenue(orders)
  expect_equal(nrow(m), 24)
  expect_true(is.na(m$mom_growth[1]))
  expect_equal(sum(m$revenue), sum(orders$revenue))
})
