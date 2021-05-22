################################################################################
# Joshua C. Fjelstul, Ph.D.
# eutr R package
################################################################################

# this script requires raw data that is not available in the GitHub repo

##################################################
# create API queries
##################################################

# load notification data
load("data-raw/notifications_raw.RData")

# year
notifications_raw$year <- stringr::str_extract(notifications_raw$notification_number, "^[0-9]{4}")

# number
notifications_raw$number <- stringr::str_extract(notifications_raw$notification_number, "/[0-9]+")
notifications_raw$number <- stringr::str_extract(notifications_raw$number, "[0-9]+")

# sorted by date in descending order
notifications_raw <- dplyr::arrange(notifications_raw, desc(start_date))

# select variables
notifications_raw <- dplyr::select(notifications_raw, notification_number, year, number)

# file
notifications_raw$file <- stringr::str_c("notification_", notifications_raw$year, "_", notifications_raw$number, ".html")

# create the link
notifications_raw$query <- stringr::str_c("https://ec.europa.eu/growth/tools-databases/tris/en/search/?trisaction=search.detail&year=", notifications_raw$year, "&num=", notifications_raw$number)

##################################################
# identify pages to download
##################################################

# downloaded pages
downloaded <- list.files("data-raw/HTML-pages/")

# code missing pages
notifications_raw$downloaded <- as.numeric(notifications_raw$file %in% downloaded)

# keep only pages that need to be downloaded
notifications_raw <- dplyr::filter(notifications_raw, downloaded == 0)

##################################################
# download pages
##################################################

# download any new notifications
if (nrow(notifications_raw > 0)) {

  # set up progress bar
  pb <- txtProgressBar(min = 0, max = nrow(notifications_raw), style = 3)

  # download judgment results
  for (i in 1:nrow(notifications_raw)) {

    # download the HTML page
    download.file(notifications_raw$query[i], stringr::str_c("data-raw/HTML-pages/", notifications_raw$file[i]), quiet = TRUE)

    # random pause
    Sys.sleep(runif(1, 0, 0.1))

    # update progress bar
    setTxtProgressBar(pb, i)
  }

  # close progress bar
  close(pb)
}

################################################################################
# end R script
################################################################################
