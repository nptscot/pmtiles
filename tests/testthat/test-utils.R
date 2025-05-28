test_that("is_tippecanoe_installed returns a logical", {
  expect_type(is_tippecanoe_installed(), "logical")
})

test_that("get_tippecanoe_version returns NULL or character", {
  version <- get_tippecanoe_version()
  expect_true(is.null(version) || is.character(version))
}) 