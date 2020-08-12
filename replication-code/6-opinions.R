###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R package
###########################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# load data
load("data/notifications.RData")

##################################################
# network data
##################################################

# select variables
opinions <- dplyr::select(
  notifications,
  notification_ID, notification_by, start_date, end_date, opinions
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

# year
opinions$start_year <- lubridate::year(opinions$start_date)
opinions$end_year <- lubridate::year(opinions$end_date)

# opinion ID
opinions$opinion_ID <- stringr::str_c(opinions$notification_ID, opinions$entity_code, sep = ":")
opinions$opinion_ID <- stringr::str_replace(opinions$opinion_ID, ":N:", ":C:")

# arrange
opinions <- dplyr::arrange(opinions, start_date, notification_ID, opinion_ID)

# key ID
opinions$key_ID <- 1:nrow(opinions)

# select variables
opinions <- dplyr::select(
  opinions,
  key_ID, notification_ID, notification_by,
  start_date, start_year, end_date, end_year,
  opinion_ID, opinion_by
)

# save
save(opinions, file = "data/opinions.RData")

##################################################
# entity-year data
##################################################

# template
template <- expand.grid(codes$entity, 1988:2020, stringsAsFactors = FALSE)
names(template) <- c("opinion_by", "year")

# collapse by member state and by year
opinions_EY <- opinions %>%
  dplyr::group_by(opinion_by, start_year) %>%
  dplyr::summarize(
    count_opinions = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
opinions_EY <- dplyr::rename(opinions_EY, year = start_year)

# merge
opinions_EY <- dplyr::left_join(template, opinions_EY, by = c("opinion_by", "year"))

# convert to a tibble
opinions_EY <- dplyr::as_tibble(opinions_EY)

# code zeros
opinions_EY$count_opinions[is.na(opinions_EY$count_opinions)] <- 0

# drop invalid entity-years
opinions_EY$drop <- FALSE
opinions_EY$drop[opinions_EY$opinion_by == "Turkey" & opinions_EY$year < 1995] <- TRUE
opinions_EY$drop[opinions_EY$opinion_by == "Liechtenstein" & opinions_EY$year < 1991] <- TRUE
opinions_EY$drop[opinions_EY$opinion_by %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & opinions_EY$year < 2004] <- TRUE
opinions_EY$drop[opinions_EY$opinion_by %in% c("Bulgaria", "Romania") & opinions_EY$year < 2007] <- TRUE
opinions_EY$drop[opinions_EY$opinion_by == "Croatia" & opinions_EY$year < 2013] <- TRUE
opinions_EY <- dplyr::filter(opinions_EY, !drop)

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
# directed dyad-year data
##################################################

# template
template <- expand.grid(codes$entity[1:33], codes$entity, 1988:2020, stringsAsFactors = FALSE)
names(template) <- c("notification_by", "opinion_by", "year")

# collapse by member state and by year
opinions_DDY <- opinions %>%
  dplyr::group_by(notification_by, opinion_by, start_year) %>%
  dplyr::summarize(
    count_opinions = dplyr::n()
  ) %>% dplyr::ungroup()

# rename variable
opinions_DDY <- dplyr::rename(opinions_DDY, year = start_year)

# merge
opinions_DDY <- dplyr::left_join(template, opinions_DDY, by = c("notification_by", "opinion_by", "year"))

# convert to a tibble
opinions_DDY <- dplyr::as_tibble(opinions_DDY)

# code zeros
opinions_DDY$count_opinions[is.na(opinions_DDY$count_opinions)] <- 0

# drop invalid entity-years
opinions_DDY$drop <- FALSE
opinions_DDY$drop[opinions_DDY$opinion_by == "Turkey" & opinions_DDY$year < 1995] <- TRUE
opinions_DDY$drop[opinions_DDY$opinion_by == "Liechtenstein" & opinions_DDY$year < 1991] <- TRUE
opinions_DDY$drop[opinions_DDY$opinion_by %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & opinions_DDY$year < 2004] <- TRUE
opinions_DDY$drop[opinions_DDY$opinion_by %in% c("Bulgaria", "Romania") & opinions_DDY$year < 2007] <- TRUE
opinions_DDY$drop[opinions_DDY$opinion_by == "Croatia" & opinions_DDY$year < 2013] <- TRUE
opinions_DDY <- dplyr::filter(opinions_DDY, !drop)
opinions_DDY$drop <- FALSE
opinions_DDY$drop[opinions_DDY$notification_by == "Turkey" & opinions_DDY$year < 1995] <- TRUE
opinions_DDY$drop[opinions_DDY$notification_by == "Liechtenstein" & opinions_DDY$year < 1991] <- TRUE
opinions_DDY$drop[opinions_DDY$notification_by %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & opinions_DDY$year < 2004] <- TRUE
opinions_DDY$drop[opinions_DDY$notification_by %in% c("Bulgaria", "Romania") & opinions_DDY$year < 2007] <- TRUE
opinions_DDY$drop[opinions_DDY$notification_by == "Croatia" & opinions_DDY$year < 2013] <- TRUE
opinions_DDY <- dplyr::filter(opinions_DDY, !drop)

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
# network data
##################################################

# create a new tibble
opinions_network <- opinions_DDY

# rename variables
names(opinions_network) <- c("key_ID", "year", "from_node", "to_node", "edge_weight")

# drop dyads without an edge
opinions_network <- dplyr::filter(opinions_network, edge_weight != 0)

# arrange
opinions_network <- dplyr::arrange(opinions_network, year, from_node, to_node)

# key ID
opinions_network$key_ID <- 1:nrow(opinions_network)

# select variables
opinions_network <- dplyr::select(
  opinions_network,
  key_ID, year, from_node, to_node, edge_weight
)

# save
save(opinions_network, file = "data/opinions_network.RData")

###########################################################################
# end R script
###########################################################################
