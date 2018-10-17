getwd()
setwd("/Users/hee-wonchang/Desktop/yelpny")

data<-read.csv("yelpny.csv")
head(data)
dim(data) #966 rows, 18 columns

library(dplyr)
library(tidyr)
library(lubridate)

#modification to date and price
table(data$price_range)
data[which(data$price_range == ""),7]
data

data$firstreviewdate <- as.Date(data$firstreviewdate, "%m/%d/%Y")
data$firstreviewyr <- year(data$firstreviewdate)
table(data$firstreviewyr)

## modification to neighborhood (84)
names(table(data$neighborhood))
sum(table(data$neighborhood))

eastvillage <- data$neighborhood %in% c("Alphabet City, East Village", 
                                        "East Village, Alphabet City",
                                        "East Village", "NoHo, East Village",
                                        "Union Square, Greenwich Village, East Village") 

fidi <- data$neighborhood %in% c("Battery Park",
                                      "Financial District",
                                      "South Street Seaport")

centralpark <- data$neighborhood %in% c("Central Park")

chelsea <- data$neighborhood %in% c("Chelsea", "Chelsea, Midtown West",
                                    "Meatpacking District, Chelsea", 
                                    "Meatpacking District, West Village",
                                    "Flatiron, Midtown West")

chinatown <- data$neighborhood %in% c("Chinatown", "Chinatown, Civic Center",
                                      "Chinatown, Lower East Side")

tribeca <- data$neighborhood %in% c("Civic Center, TriBeCa", "TriBeCa",
                                    "TriBeCa, Civic Center")

brooklyn <- data$neighborhood %in% c("Boerum Hill", "Clinton Hill", "Cobble Hill","DUMBO",
                                    "East Williamsburg", "East Williamsburg, Bushwick",
                                    "Fort Greene", "Williamsburg - North Side",
                                    "Williamsburg - South Side", 
                                    "Williamsburg - South Side, South Williamsburg",
                                    "Williamsburg - South Side, Williamsburg - North Side")

eastharlem <- data$neighborhood %in% c("East Harlem")

gramercy <- data$neighborhood %in% c("Flatiron", "Flatiron, Kips Bay", "Kips Bay, Flatiron",
                                     "Flatiron, Midtown East","Gramercy",
                                     "Gramercy, East Village", "Gramercy, Flatiron",
                                     "Kips Bay","Union Square, Flatiron",
                                     "Union Square, Gramercy, Flatiron")

greenwichvillage <- data$neighborhood %in% c("Greenwich Village", 
                                             "Union Square, Greenwich Village",
                                             "West Village", "South Village" )

harlem <- data$neighborhood %in% c("Harlem")

midtownwest <- data$neighborhood %in% c("Hell's Kitchen", "Hell's Kitchen, Midtown West",
                                        "Hell's Kitchen, Midtown West, Theater District",
                                        "Hell's Kitchen, Theater District, Midtown West",
                                        "Koreatown, Midtown West","Midtown West",
                                        "Midtown West, Chelsea, Hell's Kitchen",
                                        "Midtown West, Hell's Kitchen" ,
                                        "Midtown West, Hell's Kitchen, Theater District",
                                        "Midtown West, Theater District",
                                        "Midtown West, Theater District, Hell's Kitchen")

midtowneast <- data$neighborhood %in% c("Kips Bay, Midtown East","Koreatown, Midtown East",
                                        "Koreatown, Midtown East, Midtown West",
                                        "Midtown East", "Midtown East, Murray Hill")

stuytown <- data$neighborhood %in% c("Kips Bay, Stuyvesant Town", "Gramercy, Stuyvesant Town",
                                     "East Village, Stuyvesant Town")

littleitaly <- data$neighborhood %in% c("Little Italy", "Little Italy, Nolita", "Nolita",
                                        "Nolita, Little Italy")

queens <- data$neighborhood %in% c("Long Island City, Hunters Point", "Woodside")

les <- data$neighborhood %in% c("Lower East Side", "Lower East Side, Chinatown",
                                "Lower East Side, Two Bridges", "Two Bridges")

uws <- data$neighborhood %in% c("Manhattan Valley", "Upper West Side")

morningsideheight <- data$neighborhood %in% c("Morningside Heights")

murrayhill <- data$neighborhood %in% c("Murray Hill, Kips Bay, Midtown East",
                                       "Murray Hill, Midtown East")

soho <- data$neighborhood %in% c("SoHo", "NoHo")

theaterdist <- data$neighborhood %in% c("Theater District, Hell's Kitchen, Midtown West",
                                        "Theater District, Midtown West",
                                        "Theater District, Midtown West, Hell's Kitchen")

ues <- data$neighborhood %in% c("Upper East Side", "Upper East Side, Yorkville",
                                "Yorkville, Upper East Side")

data$neighborhood2[eastvillage] <- "East Village/ Stuyvesant Town"
data$neighborhood2[fidi] <- "Financial District"
data$neighborhood2[centralpark][1] <- "Upper West Side"
data$neighborhood2[centralpark][2] <- "Upper East Side"
data$neighborhood2[chelsea] <- "Chelsea"
data$neighborhood2[chinatown] <- "Chinatown"
data$neighborhood2[tribeca] <- "Tribeca"
data$neighborhood2[brooklyn] <- "Brooklyn"
data$neighborhood2[eastharlem] <- "Harlem/ Morningside Heights"
data$neighborhood2[gramercy] <- "Gramercy"
data$neighborhood2[greenwichvillage] <- "Greenwich Village"
data$neighborhood2[harlem] <- "Harlem/ Morningside Heights"
data$neighborhood2[midtowneast] <- "Midtown East"
data$neighborhood2[midtownwest] <- "Midtown West"
data$neighborhood2[stuytown] <- "East Village/ Stuyvesant Town"
data$neighborhood2[littleitaly] <- "Little Italy"
data$neighborhood2[queens] <- "Queens"
data$neighborhood2[les] <- "Lower East Side"
data$neighborhood2[uws] <- "Upper West Side"
data$neighborhood2[morningsideheight] <- "Harlem/ Morningside Heights"
data$neighborhood2[murrayhill] <- "Murray Hill"
data$neighborhood2[soho] <- "SoHo"
data$neighborhood2[theaterdist] <- "Theater District"
data$neighborhood2[ues] <- "Upper East Side"

data2 = data[-c(which(data$price_range == ""),407),]

sum(table(data2$neighborhood2))
table(data2$neighborhood2) # reduced to 18 neighborhoods for meaningful analysis

ndollar = rep(0,nrows(data2))
ndollar[which(data2$price_range == "$")] <- 1
ndollar[which(data2$price_range == "$$")] <- 2
ndollar[which(data2$price_range == "$$$")] <- 3
ndollar[which(data2$price_range == "$$$$")] <- 4

data2$ndollar = ndollar

Reviews <- data2$no_reviews
Photos <- data2$no_photos
boxplot(Reviews, Photos, names=c("Reviews","Photos"), horizontal = TRUE,main = "Number of Reviews & Photos") 

table(data2$reservation)/length(data2$reservation)
table(data2$takeout)/length(data2$reservation)
table(data2$delivery)/length(data2$reservation)

new <- as.numeric(table(data2$firstreviewyr))
plot(new~c(2004:2018),col="red",type='o',pch=16,xlab="year",ylab="No. New Restaurants",
     main="Timeline of Newly Opened Restaurants")


#rating, number of photos, reviews
table(data2$stars)
table(data2$price_range)
table(data2$stars,data2$price_range)
write.csv(table(data2$neighborhood2),file="neighborhood.csv")

rn <- data2 %>% group_by(neighborhood2) %>% summarise(count = n(), rating= mean(stars), price = mean(ndollar)) %>% arrange(desc(rating))
dn <- data2 %>% group_by(neighborhood2) %>% summarise(count = n(), rating= mean(stars), price = mean(ndollar)) %>% arrange(desc(price))
data2 %>% group_by(neighborhood2) %>% summarise(count = n(), rating= mean(stars), price = mean(ndollar)) %>% arrange(price)

c1 = data2 %>% group_by(cuisine1) %>% summarise(count=n()) %>% arrange(desc(count))
c2 = data2 %>% group_by(cuisine2) %>% summarise(count=n()) %>% arrange(desc(count))
c3 = data2 %>% group_by(cuisine3) %>% summarise(count=n()) %>% arrange(desc(count))
colnames(c1)[1] = "cuisine"
colnames(c2)[1] = "cuisine"
colnames(c3)[1] = "cuisine"

cjoin1 = left_join(c1,c2,by="cuisine")
cjoin2 = left_join(cjoin1,c3, by="cuisine")
write.csv(cjoin2, file="cuisine.csv")


#neighborhood specific
data2 %>% filter(neighborhood2=="Murray Hill") %>% group_by(cuisine1) %>% summarise(count=n())
data2 %>% filter(neighborhood2=="Murray Hill") %>% group_by(ndollar) %>% summarise(count=n())
data2 %>% filter(neighborhood2=="Lower East Side") %>% group_by(cuisine1) %>% summarise(count=n()) %>% arrange(desc(count))
data2 %>% filter(neighborhood2=="Lower East Side") %>% group_by(ndollar) %>% summarise(count=n()) %>% arrange(desc(count))

data2 %>% filter(neighborhood2=="Tribeca") %>% group_by(ndollar) %>% summarise(count=n())
data2 %>% filter(neighborhood2=="SoHo") %>% group_by(ndollar) %>% summarise(count=n())
data2 %>% filter(neighborhood2=="Brooklyn") %>% group_by(ndollar) %>% summarise(count=n())
data2 %>% filter(neighborhood2=="Chinatown") %>% group_by(ndollar) %>% summarise(count=n())
data2 %>% filter(neighborhood2=="Little Italy") %>% group_by(ndollar) %>% summarise(count=n())

#rating and review/photos
boxplot(log(data2$no_photos)~data2$stars, 
        xlab="Yelp Star Rating",ylab="Log of No. Photos",
        main="Boxplot of No. Photos and Star Rating")
boxplot(log(data2$no_reviews)~data2$stars, 
        xlab="Yelp Star Rating",ylab="Log of No. Reviews",
        main="Boxplot of No. Reviews and Star Rating")
cor(data2$no_photos,data2$stars)
cor(data2$no_reviews,data2$stars)

summary(aov(no_photos~ stars, data=data2))
summary(aov(no_reviews~ stars, data=data2))

## opening!
op <- data2 %>% filter(firstreviewyr==2018) %>% group_by(neighborhood2) %>% summarise(count = n()) %>% arrange(desc(count))
tot <- data2 %>% group_by(neighborhood2) %>% summarise(count = n()) %>% arrange(desc(count))
optot <- left_join(op,tot, by="neighborhood2")
prop <- optot[2]/optot[3]
opprop <- data.frame(optot[1],prop)
opprop %>% arrange(desc(count.x))
