###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R package
###########################################################################

# this script requires raw data that is not available in the GitHub repo
# this script is for replication purposes only

# define pipe function
`%>%` <- magrittr::`%>%`

##################################################
# functions to extract data
##################################################

extract_metadata <- function(file) {
  html <- xml2::read_html(file)
  div <- html %>% rvest::html_nodes("div")
  class <- div %>% rvest::html_attr("class")
  div <- div[!is.na(class)]
  class <- class[!is.na(class)]
  div <- div[class == "row trisDetails"]
  text <- div %>% rvest::html_text()
  text <- stringr::str_squish(text)
  text <- stringr::str_replace(text, "var notifYear.*", "")
  return(text)
}

##################################################
# read in TRIS data
##################################################

# load notification data
load("data-raw/notifications_raw.RData")

# year
notifications_raw$year <- stringr::str_extract(notifications_raw$notification_number, "^[0-9]{4}")

# number
notifications_raw$number <- stringr::str_extract(notifications_raw$notification_number, "/[0-9]+")
notifications_raw$number <- stringr::str_extract(notifications_raw$number, "[0-9]+")

# file
notifications_raw$file <- stringr::str_c("data-raw/HTML-pages/notification_", notifications_raw$year, "_", notifications_raw$number, ".html")

# drop HTML file with an error
notifications_raw <- dplyr::filter(notifications_raw, !stringr::str_detect(file, "notification_2019_133.html"))

# extract metadata
metadata <- plyr::alply(.data = notifications_raw$file, .margin = 1, .fun = extract_metadata, .progress = "text", .inform = TRUE)
metadata <- as.character(metadata)
metadata[metadata == "character(0)"] <- NA

# add to notifications data
notifications_raw_metadata <- notifications_raw
notifications_raw_metadata$metadata <- metadata

# save
save(notifications_raw_metadata, file = "data-raw/notifications_raw_metadata.Rdata")

###########################################################################
# end R script
###########################################################################
