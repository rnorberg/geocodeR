context('Census API Batch Geocoding')

test_that("batch_geocode() works as expected", {
  expect_silent({r <- batch_geocode(sample_addresses)})
  expect_is(r, 'data.frame')
})
