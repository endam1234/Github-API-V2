install.packages("plotly")
library(jsonlite)
library(httpuv)
library(httr)

require(devtools)
library(plotly)

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
req <- GET("https://api.github.com/users/endam1234", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
#gitDF[gitDF$full_name == "endam1234/datasharing", "created_at"] 

#link :https://towardsdatascience.com/accessing-data-from-github-api-using-r-3633fb62cb08


followingInfo = GET("https://api.github.com/users/endam1234/following", gtoken )
followingContent = content(followingInfo)
followingDataFrame = jsonlite::fromJSON(jsonlite::toJSON(followingContent))


followingID = followingDataFrame$login
followingReposNumber = followingDataFrame$repos
followingNumber = length(followingDataFrame$following)
followingID
followingReposNumber
followingNumber


followersInfo = GET("https://api.github.com/users/endam1234/followers", gtoken )
followersContent = content(followersInfo)
followersDataFrame = jsonlite::fromJSON(jsonlite::toJSON(followersContent))

followersID = followersDataFrame$login
followersReposNumber = followersDataFrame$repos
followersNumber = length(followersDataFrame$followers)
followersID
followersReposNumber
followersNumber

reposInfo = GET("https://api.github.com/users/endam1234/repos", gtoken )
reposContent = content(reposInfo)
reposDataFrame = jsonlite::fromJSON(jsonlite::toJSON(reposContent))


reposName =reposDataFrame$name
reposCreated = reposDataFrame$created_at #when these repositories were created
reposName
reposCreated

#followingID is a list of logins of the people I am following

#add users to a list, but don't include if they don't follow anyone, also break out of for loop if > 150 users
usersIDs = c(followingID)
allUsers = c()
usersDataFrame = data.frame(Username = integer(), Following = integer(), Followers = integer(), Repositories = integer())

for(x in 1:length(usersIDs))
{
  followUrl = paste("https://api.github.com/users/", usersIDs[x], "/following", sep = "")
  follow= GET(followUrl, gtoken)
  followCont = content(follow)
  
  if(length(followCont)==0)
  {
    next
  }
  allUsers[length(allUsers) + 1] = followingID[x]
  
  followersUrl = paste("https://api.github.com/users/", followingID[x], sep = "")
  myFollowers = GET(followersUrl, gtoken)
  followersCont = content(myFollowers)
  followersDataFrame = jsonlite::fromJSON(jsonlite::toJSON(followersCont))
  
  numberFollowing = followersDataFrame$following
  numberFollowers = followersDataFrame$followers
  numberRepos = followersDataFrame$public_repos
  
  usersDataFrame[nrow(usersDataFrame)+ 1, ] = c(followingID[x], numberFollowing, numberFollowers, numberRepos)
  
  if(length(allUsers)>150)
  {
    break
  }
  next
}


