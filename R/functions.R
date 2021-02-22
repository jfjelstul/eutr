###########################################################################
# Joshua C. Fjelstul, Ph.D.
# eutris R package
###########################################################################

##################################################
# function to query the API
##################################################

#' Query the EUTR Database API
#'
#' A function to query the EUTR Database API.
#'
#' @param parameters A named list. The names of the elements of the list should
#'   correspond exactly to parameters of the EUTR Database API. With the
#'   exception of the `limit` and `offset` parameters, each parameter
#'   corresponds to a variable from the dataset. See the EUTR Database API
#'   Codebook for a list of valid parameters and the corresponding variable in
#'   the dataset, if applicable. See the EUTR Database Codebook for a
#'   description of the variables. All API parameters are in `lowerCamelCase`
#'   with no exceptions. With the exception of the `limit` and `offset`
#'   parameters, value of the elements of the list are the values that will be
#'   used to filter the data. If specified, the `limit` parameter indicates the
#'   maximum number of observations to return, and the `offset` parameter
#'   indicates which observation of the filtered data to start at. If you
#'   include invalid parameters, the function will still run, but you will get a
#'   warning indicating which parameters are invalid.
#' @param route A string. The name of the API route to query.

query_API <- function(parameters, route) {
  
  # pipe function
  `%>%` <- magrittr::`%>%`
  
  # API host
  host <- "https://www.api.eulaw.app/EUTR-database/"
  
  # create an empty string to hold conditions
  conditions <- ""
  
  # loop through parameters
  for(i in 1:length(parameters)) {
    
    # construct the condition
    condition <- stringr::str_c("&", names(parameters)[i], "=", parameters[[i]])
    
    # add the condition to the string
    conditions <- stringr::str_c(conditions, condition)
  }
  
  # remove first &
  conditions <- stringr::str_replace(conditions, "^&", "?")
  
  # construct query
  query <- stringr::str_c(host, route, conditions)
  
  # fetch data
  response <- httr::GET(query)
  
  # error handling
  if(response$status_code != 200) {
    stop("Error: API query not successful")
  }
  
  # parse response
  out <- jsonlite::fromJSON(rawToChar(response$content), flatten = TRUE) %>% dplyr::as_tibble()
  
  # return a tibble
  return(out)
}

##################################################
# function to filter parameters
##################################################

#' A Function to Remove Invalid API Parameters
#'
#' A function to remove invalid API paramters from the named list of parameter
#' values provided by the user.
#'
#' @param provided A string vector. The names of the API parameters provided by the
#'   user. These are the names of the elements of the list proved via the
#'   `parameters` argument of the parent function.
#' @param valid A string vector. The names of all of the valid paramters for a model
#'   of the EUTR Database API.

filter_parameters <- function(provided, valid) {
  
  # filter parameteres
  filtered <- provided[names(provided) %in% valid]
  
  # invalid parameters
  invalid <- provided[!(names(provided) %in% valid)]
  
  # warn about invalid parameters
  if(length(invalid) > 0) {
    warning(stringr::str_c(
      "The following parameters were excluded because they were invalid: ",
      stringr::str_c(
        names(invalid), collapse = ", "
      ), 
      collapse = ""
    ))
  }
  
  # return filtered parameters
  return(filtered)
}

##################################################
# notifications
##################################################

#' Query the Notifications Dataset of the EUTR Database
#'
#' A function to query the `EUTR_notifications` dataset of the EUTR Database using the
#' EUTR Database API.
#'
#' @param parameters A named list. The names of the elements of the list should
#'   correspond exactly to parameters of the EUTR Database API. With the
#'   exception of the `limit` and `offset` parameters, each parameter
#'   corresponds to a variable from the dataset. See the EUTR Database API
#'   Codebook for a list of valid parameters and the corresponding variable in
#'   the dataset, if applicable. See the EUTR Database Codebook for a
#'   description of the variables. All API parameters are in `lowerCamelCase`
#'   with no exceptions. With the exception of the `limit` and `offset`
#'   parameters, value of the elements of the list are the values that will be
#'   used to filter the data. If specified, the `limit` parameter indicates the
#'   maximum number of observations to return, and the `offset` parameter
#'   indicates which observation of the filtered data to start at. If you
#'   include invalid parameters, the function will still run, but you will get a
#'   warning indicating which parameters are invalid.
#'
#' @export
EUTR_notifications_API <- function(parameters) {
  
  # API route
  route <- "notifications"

  # valid parameters
  valid_parameters <- dplyr::filter(API_codebook, API_route == route)$API_parameter
  
  # filter parameters
  parameters <- filter_parameters(parameters, valid_parameters)

  # query API
  out <- query_API(parameters, route)
  
  # return a tibble
  return(out)
}

##################################################
# cases_TS
##################################################

###########################################################################
# end R script
###########################################################################
