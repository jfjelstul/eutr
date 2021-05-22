################################################################################
# Joshua C. Fjelstul, Ph.D.
# eutr R package
################################################################################

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
  notification_id,
  notification_by_id, notification_by, notification_by_code,
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
codes <- read.csv("data-raw/entity_codes.csv", stringsAsFactors = FALSE)
opinions <- dplyr::left_join(opinions, codes, by = c("opinion_by" = "entity"))

# rename variables
opinions <- dplyr::rename(
  opinions,
  opinion_by_id = entity_id,
  opinion_by_code = entity_code
)

# year
opinions$start_year <- lubridate::year(opinions$start_date)
opinions$end_year <- lubridate::year(opinions$end_date)

# opinion ID
opinions$opinion_id <- stringr::str_c(opinions$notification_id, opinions$opinion_by_code, sep = ":")
opinions$opinion_id <- stringr::str_replace(opinions$opinion_id, ":N:", ":O:")

# arrange
opinions <- dplyr::arrange(opinions, start_date, notification_id, opinion_id)

# key ID
opinions$key_id <- 1:nrow(opinions)

# select variables
opinions <- dplyr::select(
  opinions,
  key_id,
  notification_id, notification_by_id, notification_by, notification_by_code,
  start_date, start_year, end_date, end_year,
  opinion_id, opinion_by_id, opinion_by, opinion_by_code
)

# save
save(opinions, file = "data/opinions.RData")

################################################################################
# end R script
################################################################################
