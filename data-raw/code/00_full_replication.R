################################################################################
# Joshua C. Fjelstul, Ph.D.
# eutr R package
################################################################################

# clean workspace
rm(list = ls())

##################################################
# run replication scripts
##################################################

# parse XLS files
# source("replication-code/01_parse_xls.R")
# rm(list = ls())
# input: data-raw/XLS-files/ (hand collected)
# output: data-raw/notifications_raw.RData

# download HTML files
# source("replication-code/02_download_html.R")
# rm(list = ls())
# input: data-raw/notifications-raw.RData
# output: data-raw/HTML-pages/

# parse HTML files
# source("replication-code/03_parse_html.R")
# rm(list = ls())
# input: data-raw/notifications-raw.RData
# input: data-raw/HTML-pages/
# output: data-raw/notifications_raw_metadata.RData

# make notifications data
source("data-raw/code/04_notifications.R")
rm(list = ls())
# input: data-raw/notifications_raw_metadata.RData
# input: data-raw/entity_codes.csv (hand coded)
# output: data/notifications.Rdata
# output: data/notifications_extended.Rdata

# make comments data
source("data-raw/code/05_comments.R")
rm(list = ls())
# input: data/notifications.RData
# input: data-raw/entity_codes.csv (hand coded)
# output: data/comments.RData

# make opinions data
source("data-raw/code/06_opinions.R")
rm(list = ls())
# input: data/notifications.RData
# input: data-raw/entity_codes.csv (hand coded)
# output: data/opinions.RData

# make TS data
source("data-raw/code/07_ts_data.R")
rm(list = ls())
# input: data/notifications.RData
# input: data/comments.RData
# input: data/opinions.RDatA
# output: data/notifications_ts.Rdata
# output: data/comments_ts.Rdata
# output: data/opinions_ts.Rdata

# make CSTS data
source("data-raw/code/08_csts_data.R")
rm(list = ls())
# input: data-raw/entity_codes.csv (hand coded)
# input: data/notifications.RData
# input: data/comments.RData
# input: data/opinions.RData
# output: data/notifications_csts.Rdata
# output: data/comments_csts.Rdata
# output: data/opinions_csts.Rdata

# make DDY data
source("data-raw/code/09_ddy_data.R")
rm(list = ls())
# input: data-raw/entity_codes.csv (hand coded)
# input: data/comments.RData
# input: data/opinions.RData
# output: data/comments_ddy.Rdata
# output: data/opinions_ddy.Rdata

# make network data
source("data-raw/code/10_net_data.R")
rm(list = ls())
# input: data/comments_ddy.RData
# input: data/opinions_ddy.RData
# output: data/comments_net.Rdata
# output: data/opinions_net.Rdata

##################################################
# variables
##################################################

# read in data
variables <- read.csv("data-raw/documentation/eutr_variables.csv", stringsAsFactors = FALSE)

# convert to a tibble
variables <- dplyr::as_tibble(variables)

# save
save(variables, file = "data/variables.RData")

##################################################
# datasets
##################################################

# read in data
datasets <- read.csv("data-raw/documentation/eutr_datasets.csv", stringsAsFactors = FALSE)

# convert to a tibble
datasets <- dplyr::as_tibble(datasets)

# save
save(datasets, file = "data/datasets.RData")

##################################################
# documentation
##################################################

# documentation
load("data/variables.RData")
load("data/datasets.RData")

# document data
codebookr::document_data(
  file_path = "R/",
  variables_input = variables,
  datasets_input = datasets,
  include_variable_type = TRUE,
  author = "Joshua C. Fjelstul, Ph.D.",
  package = "eutr"
)

##################################################
# codebook
##################################################

# create a codebook
codebookr::create_codebook(
  file_path = "codebook/eutr_codebook.tex",
  datasets_input = datasets,
  variables_input = variables,
  title_text = "The European Union Technical Regulations \\\\ (EUTR) Database",
  version_text = "1.0",
  footer_text = "The EUTR Database Codebook \\hspace{5pt} | \\hspace{5pt} Joshua C. Fjelstul, Ph.D.",
  author_names = "Joshua C. Fjelstul, Ph.D.",
  theme_color = "#4B94E6",
  heading_font_size = 30,
  subheading_font_size = 10,
  title_font_size = 16,
  table_of_contents = TRUE,
  include_variable_type = TRUE
)

##################################################
# load data
##################################################

# notifications
load("data/notifications.RData")
load("data/notifications_ts.RData")
load("data/notifications_csts.RData")

# comments
load("data/comments.RData")
load("data/comments_ts.RData")
load("data/comments_csts_n.RData")
load("data/comments_csts_s.RData")
load("data/comments_ddy.RData")
load("data/comments_net.RData")

# opinions
load("data/opinions.RData")
load("data/opinions_ts.RData")
load("data/opinions_csts_n.RData")
load("data/opinions_csts_s.RData")
load("data/opinions_ddy.RData")
load("data/opinions_net.RData")

# documentation
load("data/variables.RData")
load("data/datasets.RData")

##################################################
# build
##################################################

# notificatons
write.csv(notifications, "build/eutr_notifications.csv", row.names = FALSE)
write.csv(notifications_ts, "build/eutr_notifications_ts.csv", row.names = FALSE)
write.csv(notifications_csts, "build/eutr_notifications_csts.csv", row.names = FALSE)

# comments
write.csv(comments, "build/eutr_comments.csv", row.names = FALSE)
write.csv(comments_ts, "build/eutr_comments_ts.csv", row.names = FALSE)
write.csv(comments_csts_n, "build/eutr_comments_csts_n.csv", row.names = FALSE)
write.csv(comments_csts_s, "build/eutr_comments_csts_s.csv", row.names = FALSE)
write.csv(comments_ddy, "build/eutr_comments_ddy.csv", row.names = FALSE)
write.csv(comments_net, "build/eutr_comments_net.csv", row.names = FALSE)

# opinions
write.csv(opinions, "build/eutr_opinions.csv", row.names = FALSE)
write.csv(opinions_ts, "build/eutr_opinions_ts.csv", row.names = FALSE)
write.csv(opinions_csts_n, "build/eutr_opinions_csts_n.csv", row.names = FALSE)
write.csv(opinions_csts_s, "build/eutr_opinions_csts_s.csv", row.names = FALSE)
write.csv(opinions_ddy, "build/eutr_opinions_ddy.csv", row.names = FALSE)
write.csv(opinions_net, "build/eutr_opinions_net.csv", row.names = FALSE)

# documentation
write.csv(variables, "build/eutr_variables.csv", row.names = FALSE)
write.csv(datasets, "build/eutr_datasets.csv", row.names = FALSE)

################################################################################
# end R script
################################################################################
