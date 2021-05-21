################################################################################
# Joshua C. Fjelstul, Ph.D.
# eutr R package
################################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# load data
load("data/comments_ddy.RData")
load("data/opinions_ddy.Rdata")

##################################################
# comments_net
##################################################

# make an edge list
comments_net <- dplyr::filter(comments_ddy, count_comments > 0)

# time
comments_net$time <- comments_net$year - min(comments_net$year) + 1

# from node ID
comments_net$from_node_id <- as.numeric(as.factor(comments_net$comment_by_id))

# from node
comments_net$from_node <- comments_net$comment_by

# to node ID
comments_net$to_node_id <- as.numeric(as.factor(comments_net$notification_by_id))

# to node
comments_net$to_node <- comments_net$notification_by

# edge weight
comments_net$edge_weight <- comments_net$count_comments

# arrange
comments_net <- dplyr::arrange(comments_net, time, from_node_id, to_node_id)

# key ID
comments_net$key_id <- 1:nrow(comments_net)

# select variables
comments_net <- dplyr::select(
  comments_net,
  key_id, time, 
  from_node_id, from_node, to_node_id, to_node,
  edge_weight
)

# save
save(comments_net, file = "data/comments_net.RData")

##################################################
# opinions_net
##################################################

# make an edge list
opinions_net <- dplyr::filter(opinions_ddy, count_opinions > 0)

# time
opinions_net$time <- opinions_net$year - min(opinions_net$year) + 1

# from node ID
opinions_net$from_node_id <- as.numeric(as.factor(opinions_net$opinion_by_id))

# from node
opinions_net$from_node <- opinions_net$opinion_by

# to node ID
opinions_net$to_node_id <- as.numeric(as.factor(opinions_net$notification_by_id))

# to node
opinions_net$to_node <- opinions_net$notification_by

# edge weight
opinions_net$edge_weight <- opinions_net$count_opinions

# arrange
opinions_net <- dplyr::arrange(opinions_net, time, from_node_id, to_node_id)

# key ID
opinions_net$key_id <- 1:nrow(opinions_net)

# select variables
opinions_net <- dplyr::select(
  opinions_net,
  key_id, time, 
  from_node_id, from_node, to_node_id, to_node,
  edge_weight
)

# save
save(opinions_net, file = "data/opinions_net.RData")

################################################################################
# end R script
################################################################################
