###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R package
###########################################################################

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
template_DDY <- expand.grid(codes$entity[1:33], codes$entity, 1988:2020, stringsAsFactors = FALSE)
names(template_DDY) <- c("notifier", "responder", "year")

# drop invalid entity-years
template_DDY$drop <- FALSE
template_DDY$drop[template_DDY$notifier == "Turkey" & template_DDY$year < 1995] <- TRUE
template_DDY$drop[template_DDY$notifier == "Liechtenstein" & template_DDY$year < 1991] <- TRUE
template_DDY$drop[template_DDY$notifier %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & template_DDY$year < 2004] <- TRUE
template_DDY$drop[template_DDY$notifier %in% c("Bulgaria", "Romania") & template_DDY$year < 2007] <- TRUE
template_DDY$drop[template_DDY$notifier == "Croatia" & template_DDY$year < 2013] <- TRUE
template_DDY <- dplyr::filter(template_DDY, !drop)
template_DDY$drop <- FALSE
template_DDY$drop[template_DDY$responder == "Turkey" & template_DDY$year < 1995] <- TRUE
template_DDY$drop[template_DDY$responder == "Liechtenstein" & template_DDY$year < 1991] <- TRUE
template_DDY$drop[template_DDY$responder %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & template_DDY$year < 2004] <- TRUE
template_DDY$drop[template_DDY$responder %in% c("Bulgaria", "Romania") & template_DDY$year < 2007] <- TRUE
template_DDY$drop[template_DDY$responder == "Croatia" & template_DDY$year < 2013] <- TRUE
template_DDY <- dplyr::filter(template_DDY, !drop)

##################################################
# comments
##################################################

# collapse by member state and by year
comments_DDY <- comments %>%
  dplyr::group_by(notification_by, comment_by, start_year) %>%
  dplyr::summarize(
    count_comments = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
comments_DDY <- dplyr::rename(comments_DDY, year = start_year)

# merge
comments_DDY <- dplyr::left_join(template_DDY, comments_DDY, by = c("notifier" = "notification_by", "responder" = "comment_by", "year"))

# rename variables
comments_DDY <- dplyr::rename(comments_DDY, notification_by = notifier, comment_by = responder)

# convert to a tibble
comments_DDY <- dplyr::as_tibble(comments_DDY)

# code zeros
comments_DDY$count_comments[is.na(comments_DDY$count_comments)] <- 0

# arrange
comments_DDY <- dplyr::arrange(comments_DDY, year, comment_by, notification_by)

# key ID
comments_DDY$key_ID <- 1:nrow(comments_DDY)

# select variables
comments_DDY <- dplyr::select(
  comments_DDY,
  key_ID, year, comment_by, notification_by, count_comments
)

# save
save(comments_DDY, file = "data/comments_DDY.RData")

##################################################
# opinions
##################################################

# collapse by member state and by year
opinions_DDY <- opinions %>%
  dplyr::group_by(notification_by, opinion_by, start_year) %>%
  dplyr::summarize(
    count_opinions = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
opinions_DDY <- dplyr::rename(opinions_DDY, year = start_year)

# merge
opinions_DDY <- dplyr::left_join(template_DDY, opinions_DDY, by = c("notifier" = "notification_by", "responder" = "opinion_by", "year"))

# rename variables
opinions_DDY <- dplyr::rename(opinions_DDY, notification_by = notifier, opinion_by = responder)

# convert to a tibble
opinions_DDY <- dplyr::as_tibble(opinions_DDY)

# code zeros
opinions_DDY$count_opinions[is.na(opinions_DDY$count_opinions)] <- 0

# arrange
opinions_DDY <- dplyr::arrange(opinions_DDY, year, opinion_by, notification_by)

# key ID
opinions_DDY$key_ID <- 1:nrow(opinions_DDY)

# select variables
opinions_DDY <- dplyr::select(
  opinions_DDY,
  key_ID, year, opinion_by, notification_by, count_opinions
)

# save
save(opinions_DDY, file = "data/opinions_DDY.RData")

##################################################
# responses
##################################################

# duplicate tibbles
a <- comments_DDY
b <- opinions_DDY

# rename variables
a <- dplyr::rename(a, response_by = comment_by)
b <- dplyr::rename(b, response_by = opinion_by)

# select variables
a <- dplyr::select(a, -key_ID)
b <- dplyr::select(b, -key_ID)

# merge
responses_DDY <- dplyr::left_join(a, b, by = c("year", "response_by", "notification_by"))

# arrange
responses_DDY <- dplyr::arrange(responses_DDY, year, response_by, notification_by)

# key ID
responses_DDY$key_ID <- 1:nrow(responses_DDY)

# select variables
responses_DDY <- dplyr::select(
  responses_DDY,
  key_ID, year, response_by, notification_by, count_comments, count_opinions
)

# save
save(responses_DDY, file = "data/responses_DDY.RData")

##################################################
# responses (tidy)
##################################################

# duplicate tibbles
a <- comments_DDY
b <- opinions_DDY

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
responses_DDY_tidy <- dplyr::bind_rows(a, b)

# arrange
responses_DDY_tidy <- dplyr::arrange(responses_DDY_tidy, year, response_by, notification_by, response_type)

# key ID
responses_DDY_tidy$key_ID <- 1:nrow(responses_DDY_tidy)

# select variables
responses_DDY_tidy <- dplyr::select(
  responses_DDY_tidy,
  key_ID, year, response_by, notification_by, response_type, count
)

# save
save(responses_DDY_tidy, file = "data/responses_DDY_tidy.RData")

###########################################################################
# end R script
###########################################################################
