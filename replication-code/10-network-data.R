###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R package
###########################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# load data
load("data/comments_DDY.RData")
load("data/opinions_DDY.Rdata")
load("data/responses_DDY.Rdata")

##################################################
# comments
##################################################

# create a new tibble
comments_network <- comments_DDY

# drop dyads without an edge
comments_network <- dplyr::filter(comments_network, count_comments != 0)

# key ID
comments_network$key_ID <- 1:nrow(comments_network)

# save
save(comments_network, file = "data/comments_network.RData")

##################################################
# opinions
##################################################

# create a new tibble
opinions_network <- opinions_DDY

# drop dyads without an edge
opinions_network <- dplyr::filter(opinions_network, count_opinions != 0)

# key ID
opinions_network$key_ID <- 1:nrow(opinions_network)

# save
save(opinions_network, file = "data/opinions_network.RData")

###########################################################################
# end R script
###########################################################################
