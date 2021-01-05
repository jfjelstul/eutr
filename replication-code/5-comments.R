###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R package
###########################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# load data
load("data/notifications.RData")

##################################################
# make comments data
##################################################

# select variables
comments <- dplyr::select(
  notifications,
  notification_ID, 
  notification_by_ID, notification_by, notification_by_code, 
  start_date, end_date, comments
)

# drop notifications with no comments
comments <- dplyr::filter(comments, !is.na(comments))

# one row per comment
comments <- tidyr::separate_rows(comments, comments, sep = ",")

# rename variable
comments <- dplyr::rename(comments, comment_by = comments)

# clean member state names
comments$comment_by <- stringr::str_squish(comments$comment_by)

# merge in codes
codes <- read.csv("data-raw/entity-codes.csv", stringsAsFactors = FALSE)
comments <- dplyr::left_join(comments, codes, by = c("comment_by" = "entity"))

# rename variables
comments <- dplyr::rename(
  comments,
  comment_by_ID = entity_ID, 
  comment_by_code = entity_code
)

# year
comments$start_year <- lubridate::year(comments$start_date)
comments$end_year <- lubridate::year(comments$end_date)

# comment ID
comments$comment_ID <- stringr::str_c(comments$notification_ID, comments$comment_by_code, sep = ":")
comments$comment_ID <- stringr::str_replace(comments$comment_ID, ":N:", ":C:")

# arrange
comments <- dplyr::arrange(comments, start_date, notification_ID, comment_ID)

# key ID
comments$key_ID <- 1:nrow(comments)

# select variables
comments <- dplyr::select(
  comments,
  key_ID, 
  notification_ID, notification_by_ID, notification_by, notification_by_code,
  start_date, start_year, end_date, end_year,
  comment_ID, comment_by_ID, comment_by, comment_by_code
)

# save
save(comments, file = "data/comments.RData")

###########################################################################
# end R script
###########################################################################
