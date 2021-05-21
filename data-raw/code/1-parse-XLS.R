################################################################################
# Joshua C. Fjelstul, Ph.D.
# eutr R package
################################################################################

# this script requires raw data that is not available in the GitHub repo

##################################################
# read in data
##################################################

# files
files <- stringr::str_c("data-raw/XLS-files/", list.files("data-raw/XLS-files/"))

# read in files
raw <- list()
for(i in 1:length(files)) {
  raw[[i]] <- readxl::read_excel(files[i])
  names(raw[[i]]) <- c("member_state", "notification_number", "title", "reception_date", "end_standstill")
}

# stack data frames
notifications_raw <- dplyr::bind_rows(raw)

# drop header rows
notifications_raw <- dplyr::filter(notifications_raw, stringr::str_detect(notification_number, "[0-9]+/[0-9]+/[A-Z]+"))

##################################################
# dates
##################################################

# start date
notifications_raw$start_date <- lubridate::ymd(notifications_raw$reception_date)

# end date
notifications_raw$end_date <- suppressWarnings(lubridate::ymd(notifications_raw$end_standstill))

# start year
notifications_raw$start_year <- lubridate::year(notifications_raw$start_date)

# start month
notifications_raw$start_month <- lubridate::month(notifications_raw$start_date)

# start day
notifications_raw$start_day <- lubridate::day(notifications_raw$start_date)

# end year
notifications_raw$end_year <- lubridate::year(notifications_raw$end_date)

# end month
notifications_raw$end_month <- lubridate::month(notifications_raw$end_date)

# end day
notifications_raw$end_day <- lubridate::day(notifications_raw$end_date)

# duration
notifications_raw$duration <- as.numeric(notifications_raw$end_date - notifications_raw$start_date)

# clean end day
notifications_raw$end_day[notifications_raw$duration < 0] <- NA

##################################################
# organize
##################################################

# sort by date, then by notification number
notifications_raw <- dplyr::arrange(notifications_raw, start_date, notification_number)

# key ID
notifications_raw$key_id <- 1:nrow(notifications_raw)

# select variables
notifications_raw <- dplyr::select(
  notifications_raw, 
  key_id, member_state, notification_number, 
  start_date, start_year, start_month, start_day, 
  end_date, end_year, end_month, end_day
)

# save
save(notifications_raw, file = "data-raw/notifications_raw.RData")

################################################################################
# end R script
################################################################################
