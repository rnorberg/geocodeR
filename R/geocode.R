#' Batch geocode up to 1000 addresses
#'
#' @param address_df A data.frame with columns Unique ID, Street Address, City, State, Zip Code.
#' Not necessarily with those column names, but must be in that order.
#'
#' @return A data.frame
#'
#' @export
#'
#' @examples
#' data(sample_addresses) # included in package
#' batch_geocode(sample_addresses)
batch_geocode <- function(address_df) {
  # save as file
  temporary_file <- tempfile(fileext = '.csv')
  write.table(address_df, file = temporary_file, sep = ",", qmethod = "double", row.names = F, col.names = F)

  # send data to Census Geocoding API
  req <- httr::POST(url = "http://geocoding.geo.census.gov/geocoder/geographies/addressbatch",
                    body = list(benchmark = 'Public_AR_ACS2015',
                                vintage = 'ACS2015_ACS2015',
                                addressFile = httr::upload_file(temporary_file)
                    )
  )

  # get rid of temporary file
  unlink(temporary_file)

  # check request for errors
  httr::stop_for_status(req)

  # from the census.gov documentation
  ret_names <- c('id', 'address_sent', 'any_match', 'exact_match', 'address_matched',
                 'lat_lon', 'tiger_line', 'line_side', 'state', 'county', 'tract', 'block')

  # convert result to data.frame
  read.csv(textConnection(httr::content(req, encoding = 'UTF-8')), header = F, col.names = ret_names, encoding = 'UTF-8')
}
