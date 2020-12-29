###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R package
###########################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# load data
load("data/notifications.RData")
load("data/comments.RData")
load("data/opinions.Rdata")

# read in codes
codes <- read.csv("data-raw/entity-codes.csv")

##################################################
# template
##################################################

# template
template_EY <- expand.grid(codes$entity, 1988:2020, stringsAsFactors = FALSE)
names(template_EY) <- c("entity", "year")

# drop invalid entity-years
template_EY$drop <- FALSE
template_EY$drop[template_EY$entity == "Turkey" & template_EY$year < 1995] <- TRUE
template_EY$drop[template_EY$entity == "Liechtenstein" & template_EY$year < 1991] <- TRUE
template_EY$drop[template_EY$entity %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & template_EY$year < 2004] <- TRUE
template_EY$drop[template_EY$entity %in% c("Bulgaria", "Romania") & template_EY$year < 2007] <- TRUE
template_EY$drop[template_EY$entity == "Croatia" & template_EY$year < 2013] <- TRUE
template_EY <- dplyr::filter(template_EY, !drop)

##################################################
# notifications
##################################################

# collapse by member state and by year
notifications_EY <- notifications %>%
  dplyr::group_by(notification_by, start_year) %>%
  dplyr::summarize(
    count_notifications = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
notifications_EY <- dplyr::rename(notifications_EY, year = start_year)

# merge
notifications_EY <- dplyr::left_join(template_EY, notifications_EY, by = c("entity" = "notification_by", "year"))

# rename variable
notifications_EY <- dplyr::rename(notifications_EY, notification_by = entity)

# convert to a tibble
notifications_EY <- dplyr::as_tibble(notifications_EY)

# code zeros
notifications_EY$count_notifications[is.na(notifications_EY$count_notifications)] <- 0

# arrange
notifications_EY <- dplyr::arrange(notifications_EY, year, notification_by)

# key ID
notifications_EY$key_ID <- 1:nrow(notifications_EY)

# select variables
notifications_EY <- dplyr::select(
  notifications_EY,
  key_ID, year, notification_by, count_notifications
)

# save
save(notifications_EY, file = "data/notifications_EY.RData")

##################################################
# comments
##################################################

# collapse by member state and by year
comments_EY <- comments %>%
  dplyr::group_by(comment_by, start_year) %>%
  dplyr::summarize(
    count_comments = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
comments_EY <- dplyr::rename(comments_EY, year = start_year)

# merge
comments_EY <- dplyr::left_join(template_EY, comments_EY, by = c("entity" = "comment_by", "year"))

# rename variable
comments_EY <- dplyr::rename(comments_EY, comment_by = entity)

# convert to a tibble
comments_EY <- dplyr::as_tibble(comments_EY)

# code zeros
comments_EY$count_comments[is.na(comments_EY$count_comments)] <- 0

# arrange
comments_EY <- dplyr::arrange(comments_EY, year, comment_by)

# key ID
comments_EY$key_ID <- 1:nrow(comments_EY)

# select variables
comments_EY <- dplyr::select(
  comments_EY,
  key_ID, year, comment_by, count_comments
)

# save
save(comments_EY, file = "data/comments_EY.RData")

##################################################
# opinions
##################################################

# collapse by member state and by year
opinions_EY <- opinions %>%
  dplyr::group_by(opinion_by, start_year) %>%
  dplyr::summarize(
    count_opinions = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
opinions_EY <- dplyr::rename(opinions_EY, year = start_year)

# merge
opinions_EY <- dplyr::left_join(template_EY, opinions_EY, by = c("entity" = "opinion_by", "year"))

# rename variable
opinions_EY <- dplyr::rename(opinions_EY, opinion_by = entity)

# convert to a tibble
opinions_EY <- dplyr::as_tibble(opinions_EY)

# code zeros
opinions_EY$count_opinions[is.na(opinions_EY$count_opinions)] <- 0

# arrange
opinions_EY <- dplyr::arrange(opinions_EY, year, opinion_by)

# key ID
opinions_EY$key_ID <- 1:nrow(opinions_EY)

# select variables
opinions_EY <- dplyr::select(
  opinions_EY,
  key_ID, year, opinion_by, count_opinions
)

# save
save(opinions_EY, file = "data/opinions_EY.RData")

##################################################
# responses
##################################################

# duplicate tibbles
a <- comments_EY
b <- opinions_EY

# rename variables
a <- dplyr::rename(a, response_by = comment_by)
b <- dplyr::rename(b, response_by = opinion_by)

# select variables
a <- dplyr::select(a, -key_ID)
b <- dplyr::select(b, -key_ID)

# merge
responses_EY <- dplyr::left_join(a, b, by = c("year", "response_by"))

# arrange
responses_EY <- dplyr::arrange(responses_EY, year, response_by)

# key ID
responses_EY$key_ID <- 1:nrow(responses_EY)

# select variables
responses_EY <- dplyr::select(
  responses_EY,
  key_ID, year, response_by, count_comments, count_opinions
)

# save
save(responses_EY, file = "data/responses_EY.RData")

##################################################
# responses (tidy)
##################################################

# duplicate tibbles
a <- comments_EY
b <- opinions_EY

# rename variables
a <- dplyr::rename(a, response_by = comment_by, count = count_comments)
b <- dplyr::rename(b, response_by = opinion_by, count = count_opinions)

# select variables
a <- dplyr::select(a, -key_ID)
b <- dplyr::select(b, -key_ID)

# add type variables
a$response_type <- "comment"
b$response_type <- "opinion"

# stack tibbles
responses_EY_tidy <- dplyr::bind_rows(a, b)

# arrange
responses_EY_tidy <- dplyr::arrange(responses_EY_tidy, year, response_by, response_type)

# key ID
responses_EY_tidy$key_ID <- 1:nrow(responses_EY_tidy)

# select variables
responses_EY_tidy <- dplyr::select(
  responses_EY_tidy,
  key_ID, year, response_by, response_type, count
)

# save
save(responses_EY_tidy, file = "data/responses_EY_tidy.RData")

###########################################################################
# end R script
###########################################################################
