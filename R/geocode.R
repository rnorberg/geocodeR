batch_geocode <- function(address_df) {
  # save as file
  temporary_file <- tempfile(fileext = '.csv')
  write.table(address_df, file = temporary_file, sep = ",", qmethod = "double", row.names = F, col.names = F)

  # send data to Census Geocoding API
  req <- httr::POST(url = "http://geocoding.geo.census.gov/geocoder/geographies/addressbatch",
                    body = list(benchmark = 'Public_AR_ACS2015',
                                vintage = 'ACS2015_ACS2015',
                                addressFile = upload_file(temporary_file)
                    )
  )

  # get rid of temporary file
  unlink(temporary_file)

  # check request for errors
  httr::stop_for_status(req)

  # convert result to data.frame
  read.csv(textConnection(content(req)), header = F)
}
