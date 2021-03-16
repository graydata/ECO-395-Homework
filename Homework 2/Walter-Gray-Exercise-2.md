---
title: "Walter Gray Exercise 2"
author: "Walter Gray"
date: "3/14/2021"
output: md_document
---
## Visualizing Bus Ridership

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png)
The charts above show that there are substantial differences between weekday and weekend trips. During the week, ridership peaks in early evening hours. Average boardings show substantial variability from month to month. In particular, there are relatively fewer Monday boardings in September- perhaps a reflection of students skipping class earlier in the semester. In November a decrease in Wed/Thu/Fri bookings may be partially attributed to students returning home during the Thanksgiving holidays.

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png)
The impact of temperature against ridership is relatively small during the early hours of the day on both weekdays and the weekend, but during weekday afternoons (from the period from 12PM through 3PM) there appears to be an increase in ridership at higher temperatures. One possible explanation for this is that students going to class during the week are somewhat more temperature sensitive during the hottest period of the day, so those that might have walked or biked might take the bus instead.

## Problem 3: Classification and retrospective sampling

```
## Error in eval(expr, envir, enclos): object 'german_credit' not found
```

```
## Error in ggplot(data = german_credit, mapping = aes(x = history, y = Default)): object 'german_credit' not found
```

Because there were relatively few loans to people with "terrible" history that resulted in defaults, the sample disproportionately pulled from people with "poor" credit scores. This makes it seem overly likely that people with poor credit scores are going to be more likely to default. 


```
## Error in eval_select_impl(NULL, .vars, expr(c(!!!dots)), include = .include, : object 'german_credit' not found
```

```
## Error in analysis(x): object 'german_credit_split' not found
```

```
## Error in assessment(x): object 'german_credit_split' not found
```

```
## Error in table(german_credit_train$Default): object 'german_credit_train' not found
```

```
## Error in is.data.frame(data): object 'german_credit_train' not found
```

Interpreting the coefficients in the model, having a "terrible" history multiplies odds of default by .17 and having "poor" history multiplies odds of default by .000099. 

Neither of these show a strong relationship to default, which is somewhat surprising. Two possibilities come to mind: one may be that credit history simply doesn't act as a good predictor of default. That's somewhat surprising, so before making that assumption I would first encourage the bank to widen their sampling pool to an audience that is more representative of their overall customer base. 

## Problem 4: Children and hotel reservations

```r
library(tidyverse)
library(ggplot2)
library(modelr)
library(rsample)
library(lubridate)
library(mosaic)

data = hotels_dev

hotels_dev <- hotels_dev %>% 
  mutate(arrival_date = ymd(arrival_date))

hotels_dev = mutate(hotels_dev, 
                       month = month(arrival_date) %>% factor(),     # month of day
                       wday = wday(arrival_date) %>% factor())     # day of week (1 = Monday)

hotels_split = initial_split(hotels_dev, prop = 0.8)
hotels_train = training(hotels_split)
hotels_test = testing(hotels_split)

# Fit to the training data
lm1 = lm(children ~ market_segment + adults + customer_type + is_repeated_guest, data=hotels_train)
lm2 = lm(children ~ . - arrival_date, data=hotels_train)
lm3 = lm(children ~ . - arrival_date + month + wday + is_repeated_guest*reserved_room_type, data=hotels_train)

rmse(lm1, hotels_test)
```

```
## [1] 0.2706513
```

```r
rmse(lm2, hotels_test)
```

```
## [1] 0.2373992
```

```r
rmse(lm3, hotels_test)
```

```
## Warning in predict.lm(model, data): prediction from a rank-deficient fit may be misleading
```

```
## [1] 0.2373401
```

```r
#Using K-fold cross validation
hotels_folds = crossv_kfold(hotels_dev, k=10)

foldlm1 = map(hotels_folds$train, ~ lm(children ~ market_segment + adults + customer_type + is_repeated_guest, data=hotels_train))
foldlm2 = map(hotels_folds$train, ~ lm(children ~ . - arrival_date, data=hotels_train))
foldlm3 = map(hotels_folds$train, ~ lm(children ~ . - arrival_date + month + wday + is_repeated_guest*reserved_room_type, data=hotels_train))
                
# map the RMSE calculation over the trained models and test sets simultaneously
map2_dbl(foldlm1, hotels_folds$test, modelr::rmse) %>% mean
```

```
## [1] 0.2682249
```

```r
map2_dbl(foldlm2, hotels_folds$test, modelr::rmse) %>% mean
```

```
## [1] 0.2319223
```

```r
map2_dbl(foldlm3, hotels_folds$test, modelr::rmse) %>% mean
```

```
## Warning in predict.lm(model, data): prediction from a rank-deficient fit may be misleading

## Warning in predict.lm(model, data): prediction from a rank-deficient fit may be misleading

## Warning in predict.lm(model, data): prediction from a rank-deficient fit may be misleading

## Warning in predict.lm(model, data): prediction from a rank-deficient fit may be misleading

## Warning in predict.lm(model, data): prediction from a rank-deficient fit may be misleading

## Warning in predict.lm(model, data): prediction from a rank-deficient fit may be misleading

## Warning in predict.lm(model, data): prediction from a rank-deficient fit may be misleading

## Warning in predict.lm(model, data): prediction from a rank-deficient fit may be misleading

## Warning in predict.lm(model, data): prediction from a rank-deficient fit may be misleading

## Warning in predict.lm(model, data): prediction from a rank-deficient fit may be misleading
```

```
## [1] 0.2315968
```

## Model Validation Step 1 

```r
library(tidyverse)
library(ggplot2)
library(modelr)
library(rsample)
library(lubridate)
library(mosaic)

data = hotels_val

hotels_val <- hotels_val %>% 
  mutate(arrival_date = ymd(arrival_date))

hotels_val = mutate(hotels_val, 
                    month = month(arrival_date) %>% factor(),     # month of day
                    wday = wday(arrival_date) %>% factor())     # day of week (1 = Monday)

val_split = initial_split(hotels_val, prop = 0.8)
val_train = training(val_split)
val_test = testing(val_split)

lm3 = lm(children ~ . - arrival_date + month + wday + is_repeated_guest*reserved_room_type, data=val_train)

phat_train_val = predict(lm3, val_train)
```

```
## Warning in predict.lm(lm3, val_train): prediction from a rank-deficient fit may be misleading
```

```r
yhat_train_val = ifelse(phat_train_val > 0.5, 1, 0)
confusion_in = table(y = val_train$children, yhat = yhat_train_val)
confusion_in
```

```
##    yhat
## y      0    1
##   0 3628   54
##   1  192  126
```

```r
#TPR is 128/334, roughly 38%
#FPR is 50/3666, roughly 1.3%

#Skipped the step to establish the ROC curve, wasn't sure how to visually represent that

#Establish baseline
table(hotels_val$children)
```

```
## 
##    0    1 
## 4597  402
```

```r
#402/4999 have children (12.4%)
```

