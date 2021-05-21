################################################################################
# Joshua C. Fjelstul, Ph.D.
# eutr R package
################################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# load data
load("data/comments.RData")
load("data/opinions.Rdata")

# read in codes
codes <- read.csv("data-raw/entity-codes.csv")

##################################################
# template
##################################################

# template
template_ddy <- expand.grid(codes$entity[1:33], codes$entity, 1988:2020, stringsAsFactors = FALSE)
names(template_ddy) <- c("notifier", "responder", "year")

# drop invalid entity-years
template_ddy$drop <- FALSE
template_ddy$drop[template_ddy$notifier == "Turkey" & template_ddy$year < 1995] <- TRUE
template_ddy$drop[template_ddy$notifier == "Liechtenstein" & template_ddy$year < 1991] <- TRUE
template_ddy$drop[template_ddy$notifier %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & template_ddy$year < 2004] <- TRUE
template_ddy$drop[template_ddy$notifier %in% c("Bulgaria", "Romania") & template_ddy$year < 2007] <- TRUE
template_ddy$drop[template_ddy$notifier == "Croatia" & template_ddy$year < 2013] <- TRUE
template_ddy <- dplyr::filter(template_ddy, !drop)
template_ddy$drop <- FALSE
template_ddy$drop[template_ddy$responder == "Turkey" & template_ddy$year < 1995] <- TRUE
template_ddy$drop[template_ddy$responder == "Liechtenstein" & template_ddy$year < 1991] <- TRUE
template_ddy$drop[template_ddy$responder %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & template_ddy$year < 2004] <- TRUE
template_ddy$drop[template_ddy$responder %in% c("Bulgaria", "Romania") & template_ddy$year < 2007] <- TRUE
template_ddy$drop[template_ddy$responder == "Croatia" & template_ddy$year < 2013] <- TRUE
template_ddy$drop[template_ddy$notifier == template_ddy$responder] <- TRUE
template_ddy <- dplyr::filter(template_ddy, !drop)
template_ddy <- dplyr::select(template_ddy, -drop)

##################################################
# comments
##################################################

# collapse by member state and by year
comments_ddy <- comments %>%
  dplyr::group_by(notification_by, comment_by, start_year) %>%
  dplyr::summarize(
    count_comments = dplyr::n()
  ) %>%
  dplyr::ungroup()

# rename variable
comments_ddy <- dplyr::rename(comments_ddy, year = start_year)

# merge
comments_ddy <- dplyr::left_join(template_ddy, comments_ddy, by = c("notifier" = "notification_by", "responder" = "comment_by", "year"))

# convert to a tibble
comments_ddy <- dplyr::as_tibble(comments_ddy)

# code zeros
comments_ddy$count_comments[is.na(comments_ddy$count_comments)] <- 0

# merge in entity data
comments_ddy <- dplyr::left_join(comments_ddy, codes, by = c("notifier" = "entity"))

# rename variables
comments_ddy <- dplyr::rename(
  comments_ddy,
  notification_by = notifier,
  notification_by_id = entity_id,
  notification_by_code = entity_code
)

# merge in entity data
comments_ddy <- dplyr::left_join(comments_ddy, codes, by = c("responder" = "entity"))

# rename variables
comments_ddy <- dplyr::rename(
  comments_ddy,
  comment_by = responder,
  comment_by_id = entity_id,
  comment_by_code = entity_code
)

# arrange
comments_ddy <- dplyr::arrange(comments_ddy, year, comment_by_id, notification_by_id)

# key ID
comments_ddy$key_id <- 1:nrow(comments_ddy)

# select variables
comments_ddy <- dplyr::select(
  comments_ddy,
  key_id, year,
  comment_by_id, comment_by, comment_by_code,
  notification_by_id, notification_by, notification_by_code,
  count_comments
)

# save
save(comments_ddy, file = "data/comments_ddy.RData")

##################################################
# opinions
##################################################

# collapse by member state and by year
opinions_ddy <- opinions %>%
  dplyr::group_by(notification_by, opinion_by, start_year) %>%
  dplyr::summarize(
    count_opinions = dplyr::n()
  ) %>%
  dplyr::ungroup()

# rename variable
opinions_ddy <- dplyr::rename(opinions_ddy, year = start_year)

# merge
opinions_ddy <- dplyr::left_join(template_ddy, opinions_ddy, by = c("notifier" = "notification_by", "responder" = "opinion_by", "year"))

# convert to a tibble
opinions_ddy <- dplyr::as_tibble(opinions_ddy)

# code zeros
opinions_ddy$count_opinions[is.na(opinions_ddy$count_opinions)] <- 0

# merge in entity data
opinions_ddy <- dplyr::left_join(opinions_ddy, codes, by = c("notifier" = "entity"))

# rename variables
opinions_ddy <- dplyr::rename(
  opinions_ddy,
  notification_by = notifier,
  notification_by_id = entity_id,
  notification_by_code = entity_code
)

# merge in entity data
opinions_ddy <- dplyr::left_join(opinions_ddy, codes, by = c("responder" = "entity"))

# rename variables
opinions_ddy <- dplyr::rename(
  opinions_ddy,
  opinion_by = responder,
  opinion_by_id = entity_id,
  opinion_by_code = entity_code
)

# arrange
opinions_ddy <- dplyr::arrange(opinions_ddy, year, opinion_by_id, notification_by_id)

# key ID
opinions_ddy$key_id <- 1:nrow(opinions_ddy)

# select variables
opinions_ddy <- dplyr::select(
  opinions_ddy,
  key_id, year,
  opinion_by_id, opinion_by, opinion_by_code,
  notification_by_id, notification_by, notification_by_code,
  count_opinions
)

# save
save(opinions_ddy, file = "data/opinions_ddy.RData")

################################################################################
# end R script
################################################################################
