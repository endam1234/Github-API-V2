install.packages("jsonlite")

library(jsonlite)

install.packages("httpuv")
library(httpuv)

install.packages("httr")
library(httr)

# Can be github, linkedin etc depending on application
oauth_endpoints("github")

# Change based on what you 
myapp <- oauth_app(appname = "mckennen",
                   key = "185861e816e2f990d814",
                   secret = "007e15efaa7f48e328d64b1617b1da69a1c5ca4e")

# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"] 

#link: https://towardsdatascience.com/accessing-data-from-github-api-using-r-3633fb62cb08

followingInfo = GET("https://api.github.com/users/endam1234/following", gtoken )
followingContent = content(followingInfo)
followingDataFrame = jsonlite::fromJSON(jsonlite::toJSON(followingContent))

followingID = followingDataFrame$login #list of people I am following
followingID
followingURL = followingDataFrame$url #links to the profiles of the people I am following
followingURL

followersInfo = GET("https://api.github.com/users/endam1234/followers", gtoken )
followersContent = content(followersInfo)
followersDataFrame = jsonlite::fromJSON(jsonlite::toJSON(followersContent))

followersID = followersDataFrame$login #list of people following me
followersID
amountFollowers = length(followersID) #number of followers I have
amountFollowers

reposInfo = GET("https://api.github.com/users/endam1234/repos", gtoken )
reposContent = content(reposInfo)
reposDataFrame = jsonlite::fromJSON(jsonlite::toJSON(reposContent))

reposName =reposDataFrame$name #name of my repositories
reposName
reposCreated = reposDataFrame$created_at #when these repositories were created
reposCreated


