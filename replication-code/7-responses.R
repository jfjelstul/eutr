###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R package
###########################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# load data
load("data/comments.RData")
load("data/opinions.RData")

##################################################
# make responses data
##################################################

# rename variables
comments <- dplyr::rename(comments, response_by = comment_by, response_ID = comment_ID)
opinions <- dplyr::rename(opinions, response_by = opinion_by, response_ID = opinion_ID)

# add response type variable
comments$response_type <- "comment"
opinions$response_type <- "opinion"

# stack data
responses <- dplyr::bind_rows(comments, opinions)

# arrange
responses <- dplyr::arrange(responses, start_date, notification_ID, response_ID, response_type)

# key ID
responses$key_ID <- 1:nrow(responses)

# select variables
responses <- dplyr::select(
  responses,
  key_ID, notification_ID, notification_by,
  start_date, start_year, end_date, end_year,
  response_ID, response_type, response_by
)

# save
save(responses, file = "data/responses.RData")

###########################################################################
# end R script
###########################################################################
