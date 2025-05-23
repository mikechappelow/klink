% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/klink_snowflake.R
\name{klink_snowflake}
\alias{klink_snowflake}
\title{Kellogg Snowflake connections}
\usage{
klink_snowflake(environment, database, warehouse, schema, 
 connection_pane = TRUE, role = NULL)
}
\arguments{
\item{environment}{character string containing desired environment. Currently
only "DEV" and "PROD" are supported.}

\item{database}{character string containing exact name of desired database.
Any database in the specified snowflake environment should be valid so long
as the service account being used has adequate permissions.}

\item{warehouse}{character string containing exact name of desired warehouse.}

\item{schema}{character string containing exact name of desired schema.}

\item{connection_pane}{OPTIONAL logical indicating whether information about
your connection should be added to the Connections pane, default is TRUE.}

\item{role}{OPTIONAL character string containing exact name of desired warehouse}
}
\value{
Returns Snowflake DBI connection object
}
\description{
Enables users to create read-only connections to Kellogg
Snowflake databases

In order to use these tools users must first:
\enumerate{
\item Have a RStudio Connect account (you likely have one already if you're
using RStudio Workbench, if not you can request access through Digital
Concierge).
\item Create a local RStudio Connect API key
\url{https://docs.rstudio.com/connect/user/api-keys}
\item Create an .Renviron file in your Home folder assigning your API key value
to the name CONNECT_API_KEY \url{https://rstats.wtf/r-startup.html}
}
}
\examples{
# With connection pane
dev_con <- klink_snowflake(environment = "DEV", database = "DEV_KEU", 
  warehouse = "KEU_IT_SMALL", schema = "PRCURMT")

# Without connection pane
prod_con <- klink_snowflake("PROD", "KEU", "KEU_IT_SMALL", "PRCURMT", 
  connection_pane = FALSE)
}
