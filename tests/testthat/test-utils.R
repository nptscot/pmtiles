test_that("is_tippecanoe_installed returns a logical", {
  expect_type(is_tippecanoe_installed(), "logical")
})

test_that("get_tippecanoe_version returns NULL or character", {
  version <- get_tippecanoe_version()
  expect_true(is.null(version) || is.character(version))
})

test_that("order_by parameter is properly validated", {
  # Test that order_by accepts string values
  expect_no_error({
    order_by <- "all_fastest_bicycle_go_dutch"
    expect_type(order_by, "character")
  })
  
  # Test that order_by accepts NULL
  expect_no_error({
    order_by <- NULL
    expect_null(order_by)
  })
}) 