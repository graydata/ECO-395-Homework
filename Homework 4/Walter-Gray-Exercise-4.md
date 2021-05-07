## Wine Analysis with Clustering and PCA

The dataset “wine.csv” contains chemical information from 6500 bottles
of wine along with a subjective quality rating and an indication of
whether the wine is red and white. This analysis attempts to uncover
patterns within the data that reveal the color of the wine and the
quality by solely looking at the chemical composition.

    ## Warning: package 'LICORS' was built under R version 4.0.5

![](Walter-Gray-Exercise-4_files/figure-markdown_strict/unnamed-chunk-1-1.png)
An initial look at the correlation matrix with hierarchical clustering
for the chemical properties shows some clustering around certain
chemical properties.

Running PCA against the data (with K=4) gives us four components that
account for 73.18% of the information contained in the original eleven
features.

    ## Importance of first k=4 (out of 11) components:
    ##                           PC1    PC2    PC3     PC4
    ## Standard deviation     1.7407 1.5792 1.2475 0.98517
    ## Proportion of Variance 0.2754 0.2267 0.1415 0.08823
    ## Cumulative Proportion  0.2754 0.5021 0.6436 0.73187

    ##                        PC1   PC2   PC3   PC4
    ## fixed.acidity        -0.24  0.34 -0.43  0.16
    ## volatile.acidity     -0.38  0.12  0.31  0.21
    ## citric.acid           0.15  0.18 -0.59 -0.26
    ## residual.sugar        0.35  0.33  0.16  0.17
    ## chlorides            -0.29  0.32  0.02 -0.24
    ## free.sulfur.dioxide   0.43  0.07  0.13 -0.36
    ## total.sulfur.dioxide  0.49  0.09  0.11 -0.21
    ## density              -0.04  0.58  0.18  0.07
    ## pH                   -0.22 -0.16  0.46 -0.41
    ## sulphates            -0.29  0.19 -0.07 -0.64
    ## alcohol              -0.11 -0.47 -0.26 -0.11

The loadings for each variable give an indication for what each PCA is
capturing: Pc1 might suggest wines with more sulfur dioxide are less
likely to be acidic Pc2 might suggest that denser wines are also less
alcoholic PC3 seems to be about acidity PC4 seems to be about sulfates

### Approaching the wine data with K Means

The next analysis will approach the dataset with K means. I chose K=2
given that there are two types of wines being evaluated.

Claim: Shell charges more than other brands  
Conclusion: It appears that Shell charges more than the other major
brands listed in the dataset, but not more than brands that fall into
the “other” category (which might be independent or smaller brands.)

![](Walter-Gray-Exercise-4_files/figure-markdown_strict/unnamed-chunk-4-1.png)

Two clusters start to emerge when looking at the chemical properties
residual.sugar and sulphates; one cluster is low in sugar but much
higher in sulfates. Higher sulfates might indicate something about the
wine’s quality.

![](Walter-Gray-Exercise-4_files/figure-markdown_strict/unnamed-chunk-5-1.png)

Applying K means against citric and chlorides paints a murkier picture
given how close the two clusters are here.

## 2) Market Segmentation
