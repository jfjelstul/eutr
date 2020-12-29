###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R package
###########################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# load data
load("data/comments_DDY.RData")
load("data/opinions_DDY.Rdata")
load("data/responses_DDY_tidy.Rdata")

##################################################
# comments
##################################################

# create a new tibble
comments_network <- comments_DDY

# rename variables
names(comments_network) <- c("key_ID", "year", "from_node", "to_node", "edge_weight")

# drop dyads without an edge
comments_network <- dplyr::filter(comments_network, edge_weight != 0)

# arrange
comments_network <- dplyr::arrange(comments_network, year, from_node, to_node)

# key ID
comments_network$key_ID <- 1:nrow(comments_network)

# select variables
comments_network <- dplyr::select(
  comments_network,
  key_ID, year, from_node, to_node, edge_weight
)

# save
save(comments_network, file = "data/comments_network.RData")

##################################################
# opinions
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

##################################################
# responses
##################################################

# create a new tibble
responses_network <- responses_DDY_tidy

# rename variables
names(responses_network) <- c("key_ID", "year", "from_node", "to_node", "edge_type", "edge_weight")

# drop dyads without an edge
responses_network <- dplyr::filter(responses_network, edge_weight != 0)

# arrange
responses_network <- dplyr::arrange(responses_network, year, from_node, to_node, edge_type)

# key ID
responses_network$key_ID <- 1:nrow(responses_network)

# select variables
responses_network <- dplyr::select(
  responses_network,
  key_ID, year, from_node, to_node, edge_type, edge_weight
)

# save
save(responses_network, file = "data/responses_network.RData")

###########################################################################
# end R script
###########################################################################
