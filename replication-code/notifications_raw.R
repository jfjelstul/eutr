###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R package
###########################################################################

##################################################
# read in data
##################################################

# files
files <- stringr::str_c("data-raw/", list.files("data-raw"))

# read in files
raw <- list()
for(i in 1:length(files)) {
  raw[[i]] <- readxl::read_excel(files[i])
  names(raw[[i]]) <- c("member_state", "notification_number", "title", "reception_date", "end_standstill")
}

# stack data frames
notifications <- dplyr::bind_rows(raw)

# drop header rows
notifications <- dplyr::filter(notifications, stringr::str_detect(notification_number, "[0-9]+/[0-9]+/[A-Z]+"))

##################################################
# dates
##################################################

# start date
notifications$start_date <- lubridate::ymd(notifications$reception_date)

# end date
notifications$end_date <- suppressWarnings(lubridate::ymd(notifications$end_standstill))

# start year
notifications$start_year <- lubridate::year(notifications$start_date)

# start month
notifications$start_month <- lubridate::month(notifications$start_date)

# start day
notifications$start_day <- lubridate::day(notifications$start_date)

# end year
notifications$end_year <- lubridate::year(notifications$end_date)

# end month
notifications$end_month <- lubridate::month(notifications$end_date)

# end day
notifications$end_day <- lubridate::day(notifications$end_date)

# duration
notifications$duration <- as.numeric(notifications$end_date - notifications$start_date)

# clean end day
notifications$end_day[notifications$duration < 0] <- NA

##################################################
# organize
##################################################

# sort by date, then by notification number
notifications <- dplyr::arrange(notifications, start_date, notification_number)

# key ID
notifications$key_id <- 1:nrow(notifications)

# select variables
notifications <- dplyr::select(notifications, key_id, member_state, notification_number, start_date, start_year, start_month, start_day, end_date, end_year, end_month, end_day)

# save
save(notifications, file = "data/notifications.RData")

###########################################################################
# end R script
###########################################################################
