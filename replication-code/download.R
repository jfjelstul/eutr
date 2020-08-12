###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R Package
###########################################################################

# this script requires raw data that is not available in the GitHub repo
# this script is for replication purposes only
# do not attempt run this script

# load notification data
load("data/notifications.RData")

# year
notifications$year <- stringr::str_extract(notifications$notification_number, "^[0-9]{4}")

# number
notifications$number <- stringr::str_extract(notifications$notification_number, "/[0-9]+")
notifications$number <- stringr::str_extract(notifications$number, "[0-9]+")

# sorted by date in descending order
notifications <- dplyr::arrange(notifications, desc(start_date))

# select variables
notifications <- dplyr::select(notifications, notification_number, year, number)

# file
notifications$file <- stringr::str_c("notification_", notifications$year, "_", notifications$number, ".html")

# create the link
notifications$query <- stringr::str_c("https://ec.europa.eu/growth/tools-databases/tris/en/search/?trisaction=search.detail&year=", notifications$year, "&num=", notifications$number)

##################################################
# identify pages to download
##################################################

# downloaded pages
downloaded <- list.files("data-raw/HTML-pages")

# code missing pages
notifications$downloaded <- as.numeric(notifications$file %in% downloaded)

# keep only pages that need to be downloaded
notifications <- dplyr::filter(notifications, downloaded == 0)

##################################################
# download pages
##################################################

# set up progress bar
pb <- txtProgressBar(min = 0, max = nrow(notifications), style = 3)

# download judgment results
for(i in 1:nrow(notifications)) {

  # download the HTML page
  download.file(notifications$query[i], stringr::str_c("data-raw/HTML-pages/", notifications$file[i]), quiet = TRUE)

  # random pause
  Sys.sleep(runif(1, 0, 0.1))

  # update progress bar
  setTxtProgressBar(pb, i)
}

# close progress bar
close(pb)

###########################################################################
# end R script
###########################################################################
