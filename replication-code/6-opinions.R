###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R package
###########################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# load data
load("data/notifications.RData")

##################################################
# make opinions data
##################################################

# select variables
opinions <- dplyr::select(
  notifications,
  notification_ID, 
  notification_by_ID, notification_by, notification_by_code, 
  start_date, end_date, opinions
)

# drop notifications with no opinions
opinions <- dplyr::filter(opinions, !is.na(opinions))

# one row per comment
opinions <- tidyr::separate_rows(opinions, opinions, sep = ",")

# rename variable
opinions <- dplyr::rename(opinions, opinion_by = opinions)

# clean member state names
opinions$opinion_by <- stringr::str_squish(opinions$opinion_by)

# merge in codes
codes <- read.csv("data-raw/entity-codes.csv", stringsAsFactors = FALSE)
opinions <- dplyr::left_join(opinions, codes, by = c("opinion_by" = "entity"))

# rename variables
opinions <- dplyr::rename(
  opinions,
  opinion_by_ID = entity_ID, 
  opinion_by_code = entity_code
)

# year
opinions$start_year <- lubridate::year(opinions$start_date)
opinions$end_year <- lubridate::year(opinions$end_date)

# opinion ID
opinions$opinion_ID <- stringr::str_c(opinions$notification_ID, opinions$opinion_by_code, sep = ":")
opinions$opinion_ID <- stringr::str_replace(opinions$opinion_ID, ":N:", ":O:")

# arrange
opinions <- dplyr::arrange(opinions, start_date, notification_ID, opinion_ID)

# key ID
opinions$key_ID <- 1:nrow(opinions)

# select variables
opinions <- dplyr::select(
  opinions,
  key_ID, 
  notification_ID, notification_by_ID, notification_by, notification_by_code,
  start_date, start_year, end_date, end_year,
  opinion_ID, opinion_by_ID, opinion_by, opinion_by_code
)

# save
save(opinions, file = "data/opinions.RData")

###########################################################################
# end R script
###########################################################################
