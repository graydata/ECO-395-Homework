library(tidyverse)
library(ggplot2)
library(reshape2)
library(ggmap)
library(fastDummies)
library(rpart)
library(rpart.plot)
library(rsample) 
library(randomForest)
library(modelr)
library(lubridate)


ggmap::register_google(key = "AIzaSyCpMrXann-2p7_m8S3uxPIXOdO7idIrsvM", write = TRUE)
# Note: to reproduce this step with your own API key, you'll first need to create a Google Cloud account (free), restrict access to the key, and enable several APIs: Static Maps, Geocoding, Geolocation, and Maps Embed. 
# Further documentation available here: https://www.rdocumentation.org/packages/ggmap/versions/3.0.0

noise = read.csv("C:/Users/JamesGray/Desktop/HW for ECO 3905/sound.csv")
noise = mutate(noise, date_sold = mdy(date_sold))

#Feature engineering to create "month" variable to capture seasonality in home sales.
noise = mutate(noise, month = month(date_sold))
noise = mutate(noise, year = year(date_sold))   
noise <- dummy_cols(noise, select_columns = 'noise')

# Plotting houses on Google Maps
###################
p <- ggmap(get_googlemap(center = c(lon = -97.715028, lat = 30.292194),
                         zoom = 15, scale = 2,
                         maptype ='roadmap',
                         color = 'color'))
p + geom_point(aes(x = lon, y = lat,  colour = noise), data = noise, size = 1) + 
  theme(legend.position="bottom",axis.text.x=element_blank(),
        axis.text.y=element_blank(),axis.ticks=element_blank(),axis.title.x=element_blank(),
        axis.title.y=element_blank()) +
  scale_color_discrete(type = "viridis")



# jittered scatterplot
#########
sp<-ggplot(noise, aes(x = soundscore, y = sold_price)) + geom_jitter(position = position_jitter(0.2))
sp + 
  scale_y_continuous(name="Sale Price", limits=c(100000, 1500000)) + 
  facet_wrap(~ housing_type) + 
  theme(strip.text.x = element_text(size=8), strip.text.y = element_text(size=12, face="bold"), strip.background = element_rect(colour="red", fill="#CCCCFF"))
#########

# boxplot by noise
bp2<-ggplot(data = noise, mapping = aes(x = factor(soundscore), y = sold_price)) +
  geom_boxplot()
bp2
bp2 + scale_y_continuous(name="House Sale Price", limits=c(100000, 1500000)) + 
  facet_wrap(~ housing_type) +
  theme(strip.text.x = element_text(size=8), strip.text.y = element_text(size=12, face="bold"), strip.background = element_rect(colour="red", fill="#CCCCFF"))


#### Train/Test before running random forest
noise_split =  initial_split(noise, prop=0.8)
noise_train = training(noise_split)
noise_test  = testing(noise_split)

noise_tree = rpart(sold_price ~ year_built + housing_type + year + soundscore + beds + month + sqft + lot_size,
                   data=noise_train, control = rpart.control(cp = 0.00001))

noise_forest = randomForest(sold_price ~ year_built + housing_type + year + soundscore + sqft + beds + month + lot_size,
                           data=noise_train, importance = TRUE)

modelr::rmse(noise_tree, noise_test)
modelr::rmse(noise_forest, noise_test) 

varImpPlot(noise_forest, type=1)

partialPlot(noise_forest, noise_test, 'soundscore', las=1)


