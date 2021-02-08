---
title: "wjg397_exercise1"
author: "Walter Gray"
date: "2/7/2021"
output: html_document
---

Boxplot

```r
library(tidyverse)
library(ggplot2)
ggplot(data=GasPrices) + 
  geom_boxplot(aes(x=factor(Competitors), y=(Price)))
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png)
Claim: Gas stations charge more if they lack direct competition in sight?
Conclusion: Although the price floor is roughly the same, gas stations without competitors in sight appear to charge substantially higher prices. This indicates the theory may hold water.
