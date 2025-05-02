
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- # klink ![](vignettes/k_hex-DS.png){width=110px} -->

<img src="vignettes/klink.png" width="216" />

## What it’s for

The goal of klink is to provide simple functions to enable users
throughout Kellogg to connect to data sources more easily using the R
language.

## Example

klink currently supports connections for common SQL Server, Redshift,
Snowflake, Postgres, and Hadoop databases as well as S3 buckets:

``` r
# Old Approach to forming a SQL connection:
con <- DBI::dbConnect(
    odbc::odbc()
    ,Driver = "freetds"
    ,Server = "server"
    ,Database = "database_name"
    ,UID = "uid"
    ,PWD = "pwd"
    )

# New klink_sql Approach:
con <- klink_sql(environment = "DEV", database = "database_name")
```

In addition to the brevity of the klink syntax, end users also gain the
benefit of not having to rely on tribal knowledge to set up reliable
data connections or locally maintain credentials and risk exposing them
in their logic.

## Setup

In order to use klink there are a few setup steps that will need to be
completed first:

1.  Have a Posit Connect account (you likely have one already if you’re
    using Posit Workbench, if not you can request access through Digital
    Concierge)
2.  Create a local RStudio Connect API key
    <https://docs.rstudio.com/connect/user/api-keys>
3.  Create an .Renviron file in your Home folder assigning your API key
    value to the name CONNECT_API_KEY
    <https://rstats.wtf/r-startup.html>
4.  Install the klink package (instructions below)

## How to Install

The easiest way to install the klink package is to source it from the
public GitHub repo:

``` r
devtools::install_github("mikechappelow/klink")

library(klink)
```

Alternatively, you can download the package from GitHub and install it
from your local file.

In the future I intend to host these types of packages in our internal
Posit Package Manager environment.

## Current klink connection functions

<img src="vignettes/microsoft-sql.png" width="100" />

#### klink_sql

The klink_sql function enables users to connect to internal MS SQL
Server databases. The function only requires\* two arguments and removes
the necessity of locally defining service account credentials in your
code, .Renviron files, and Connect publications.

``` r
library(klink)

conn <- klink_sql("DEV", "database_name") 
# note: there are optional arguments, including a server designation that can be used for connections outside of Keystone. See documentation for more details (?klink::klink_sql)

DBI::dbGetQuery(conn,
          "SELECT TOP 5
          var1, var2
          FROM table")
```

<img src="vignettes/redshift.png" width="100" />

#### klink_redshift

The klink_redshift function enables users to link to predefined,
internal redshift databases. The function currently only requires\* two
arguments.

``` r
library(klink)

red_dev <- klink_redshift(environment = "DEV", region = "KNA") 
# note: there are additional, optional arguments available. See documentation for more details (?klink::klink_redshift)

# Then use your connection as you would any other DBI connection object
DBI::dbGetQuery(red_dev, "SELECT DISTINCT tablename FROM PG_TABLE_DEF") 
DBI::dbGetQuery(red_dev, "SELECT TOP 10 * FROM fin_acctg_ops.fisc_cal_wk")
```

<img src="vignettes/snowflake.png" width="200" />

#### klink_snowflake

The klink_snowflake function enables users to link to predefined,
internal snowflake databases. The function currently only requires\* two
arguments.

``` r
library(klink)

snowflake_prod <- klink_snowflake(environment = "PROD", database = "PROD_KNA", warehouse = "KNA_IT_SMALL", schema = "SALES_PRFMNC_EVAL")
# note: there are additional, optional arguments available. See documentation for more details (?klink::klink_snowflake)

# Then use your connection as you would any other DBI connection object
DBI::dbGetQuery(snowflake_prod, 'SELECT TOP 10 * FROM "KNA"."SALES_PRFMNC_EVAL"."MKT_PRFMNC_MKT_BRAND_CATG"')
```

<img src="vignettes/hadoop.png" width="200" />

#### klink_hadoop

The klink_hadoop function enables users to link to predefined, internal
hadoop databases. The function currently only requires\* one argument.

``` r
library(klink)

hadoop_dev <- klink_hadoop("DEV", "KNA_BW") 
```

*Note:* Currently, you can only connect to Hadoop DEV from the UAT
Workbench/Connect servers and PROD from the PROD Workbench/Connect
servers.

<img src="vignettes/postgresql.png" width="100" />

#### klink_postgres

The klink_postgres function enables users to connect to kortex
PostgreSQL databases.

``` r
library(klink)

conn <- klink_postgres("DEV", "postgres") 
```

<img src="vignettes/s3.png" width="100" />

#### klink_s3

The klink_s3 function enables users to link to our kortex s3 bucket
simply by calling the function (no arguments required).

``` r
library(klink)

# Retrieve required system settings (in background) and appropriate s3 bucket name
klink_s3()

# Use aws.s3 functions to retrieve information from s3 bucket
# (making sure to reference the bucket as "s3BucketName_kortex")
aws.s3::get_bucket_df(s3BucketName, max = 20)[["Key"]]
```

#### klink_s3R

The klink_s3R function enables users to link to our legacy s3 bucket by
simply calling the function (no arguments required).

Example:

``` r
library(klink)

# Retrieve required system settings (in background) and appropriate s3 bucket name
klink_s3R()

# Use aws.s3 functions to retrieve information from s3 bucket
aws.s3::object_exists("your_object.rds", bucket = s3BucketName)
aws.s3::object_size("your_object.csv", bucket = s3BucketName)
```

## How klink connections work

<img src="vignettes/zoltar-hex.png" width="216" />

### zoltar

The klink connection functions are wrappers that utilize an internal API
that I created called zoltar in order to simplify the user experience.
The user credentials and arguments users pass into their klink
connection function are filtered through logic to determine the most
appropriate service account to use and those credentials are then used
to create the data connection object in the user’s local environment.

If you would like to avoid these assumptions while leveraging the
underlying functionality you can do so by specifying your own connection
settings and using the zoltar function directly in your connection calls
(see example below).

Example:

``` r
library(klink)

con <- DBI::dbConnect(
          odbc::odbc()
          ,Driver = "freetds"
          ,Server = zoltar("server_alias") 
          ,Database = "database_name"
          ,UID = zoltar("uid_alias")
          ,PWD = zoltar("pwd_alias")
          )
```

Note: the values passed to the zoltar function in the example above are
not valid and are meant for illustrative purposes only. In order to
retrieve a full list of currently supported arguments to the zoltar API
users with a Connect API key can use the zoltar_list() function.

When a wish/alias of a known value is passed to this function our
internal zoltar API returns the requested value.

If there are required connections that are not yet supported by zoltar
please reach out to the Michael Chappelow or another member of the
Kellogg Data Science teams to have them added.

## Additional klink functions

### klink_scrub

The klink_scrub function replaces NaN and Inf values (which often cause
issues when writing to databases) with NAs (which are written as
standard NULL values). Running klink_scrub on your data before
attempting to write to a database is recommended as the error messages
associated with these type of issues can often be nondescript and
opaque.

Example:

``` r
library(klink)

# Replace NaN and Inf values with NAs
my_df <- klink_scrub(my_df)
```

### bumper

The bumper function is intended to be called when you want to trigger an
existing Connect job to run at the end of another process. This
essentially allows you to string together a series of jobs in sequence
without having to guess at/schedule specific run times.

Example:

``` r
library(klink)

bumper(GUID = "b824db78-07b8-4205-b29e-0dbea32b4d8a", environment = "PROD")
```

Note: Currently only supported in PROD. Can be added to DEV if needed.

### zoltar_list

This function returns a list of valid arguments currently defined in the
zoltar API.

Example:

``` r
library(klink)

zoltar_list()
```
