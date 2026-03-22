#-------------------------------------------------
# Reading, combining and cleaning data
#-------------------------------------------------
install.packages("readxl")
library(readxl)

red   <- read_excel("winequality-red.xlsx")
white <- read_excel("winequality-white.xlsx")

head(red)
head(white)
str(red)
str(white)

#adding variables
red$type <- 'red'
white$type <- 'white'

#combining into data frame
wine <- rbind(red, white)
#checking combined data
dim(wine)
table(wine$type)
head(wine)

# Checking current names for fixing
names(wine)

colnames(wine) <- c(
  "fixed_acidity",
  "volatile_acidity",
  "citric_acid",
  "residual_sugar",
  "chlorides",
  "free_sulfur_dioxide",
  "total_sulfur_dioxide",
  "density",
  "pH",
  "sulphates",
  "alcohol",
  "quality",
  "type"
)

# Checking again
names(wine)

#-------------------------------------------------
# setting correct data and checking missing values
#-------------------------------------------------
str(wine)

#setting type as factor
wine$type <- as.factor(wine$type)
summary(wine$type)

#checking missing values
colSums(is.na(wine))

#-------------------------------------------------
# Quick initial exploration
#-------------------------------------------------
# Basic summary of all numeric variables
summary(wine[, sapply(wine, is.numeric)])

# Distribution of numeric scores
table(wine$quality)
barplot(table(wine$quality),
        main= 'Distribution of wine quality score',
        xlab = 'quality score', ylab = 'count')

#-------------------------------------------------
# 4. EDA: quality and type (red vs white)
#-------------------------------------------------

# Counts by type
table(wine$type)

# Boxplot: quality by type
boxplot(quality ~ type, data = wine,
        xlab = "Wine type",
        ylab = "Quality score",
        main = "Wine Quality by Type")

# Boxplot: alcohol by type
boxplot(alcohol ~ type, data = wine,
        xlab = "Wine type",
        ylab = "Alcohol (%)",
        main = "Alcohol Content by Wine Type")

#-------------------------------------------------
# Correlation analysis
#-------------------------------------------------
#keeping only numeric columns
num_vars <- wine[, sapply(wine, is.numeric)]
#correlation matrix (pearson)
cor_mat <- cor(num_vars)
#looking at correlation involving quality
cor_mat['quality', ]

#Visualizing correlation matrix
install.packages("corrplot")
library(corrplot)

corrplot(cor_mat,
         method = "color",
         type   = "upper",
         tl.cex = 0.7,
         addCoef.col = NA)  # skip numbers on top of colours

#-------------------------------------------------
# Key scatterplots: quality vs most important predictors
#-------------------------------------------------
#quality vs alcohol
plot(wine$alcohol, wine$quality,
     xlab = 'Alcohol (%)',
     ylab = 'Quality score',
     main = 'wine quality vs alcohol content',
     pch = 16, col= rgb(0, 0, 1, 0.3))

#quality vs volatile acidity
plot(wine$volatile_acidity, wine$quality,
     xlab = 'Volatile acidity (g/dm^3)',
     ylab = 'Quality score',
     main = 'wine quality vs Volatile acidity',
     pch = 16, col= rgb(1, 0, 0, 0.3))

cols <- ifelse(wine$type == "red", "red", "blue")

plot(wine$alcohol, wine$quality,
     xlab = "Alcohol (%)",
     ylab = "Quality score",
     main = "Quality vs alcohol by wine type",
     pch  = 16, col = adjustcolor(cols, alpha.f = 0.4))
legend("bottomright", legend = c("Red", "White"),
       col = c("red", "blue"), pch = 16)


#-------------------------------------------------
# linear regression
#-------------------------------------------------
# Simple linear regression: quality ~ alcohol
model1 <- lm(quality ~ alcohol, data = wine)
summary(model1)

# Multiple linear regression model
model2 <- lm(quality ~ alcohol + volatile_acidity + sulphates +
               residual_sugar + total_sulfur_dioxide + pH,
             data = wine)

summary(model2)

# Quick diagnostics
par(mfrow = c(2, 2))
plot(model2)
par(mfrow = c(1, 1))

# Ramsey RESET test for functional form
resettest(model_multi, power = 2:3, type = "fitted")



#----------------------------------------------------
# Advanced Model: Generalised Additive Model (GAM)
#----------------------------------------------------

# Loading package
library(mgcv)

# Fitting GAM with smooth terms for each predictor
gam_model <- gam(
  quality ~ s(alcohol) +
    s(volatile_acidity) +
    s(sulphates) +
    s(residual_sugar) +
    s(total_sulfur_dioxide) +
    s(pH),
  data   = wine,
  method = "REML"
)

# GAM summary
summary(gam_model)

# Comparing AIC for multiple linear model and GAM
AIC(model_multi, gam_model)

# Plotting smooth functions
par(mfrow = c(2, 3))
plot(gam_model, pages = 1, shade = TRUE, seWithMean = TRUE)
par(mfrow = c(1, 1))


#-------------------------------------------------
# Hypothesis tests
#-------------------------------------------------
# Test 1: Do red and white wines have the same mean quality?
# Quick check of means
tapply(wine$quality, wine$type, mean)

# Boxplot for visual check
boxplot(quality ~ type, data = wine,
        xlab = "Wine type",
        ylab = "Quality score",
        main = "Wine quality by type")

# Two-sample t-test (Welch)
t_test_quality <- t.test(quality ~ type, data = wine)
t_test_quality

# Test 2: Do red and white wine differ in mean alcohol content?
#checking means
tapply(wine$alcohol, wine$type, mean)

#boxplot
boxplot(alcohol ~ type, data = wine,
        xlab = 'white wine',
        ylab = 'Alcohol (%)',
        main = 'Alcohol content by wine type')

#Two-sample t-test for alcohol
t_test_alcohol <- t.test(alcohol ~ type, data= wine)
t_test_alcohol

# Test 3: ANOVA – mean quality across alcohol groups
wine$alcohol_group <- cut(wine$alcohol,
                          breaks = c(0, 10, 12, 16),
                          labels = c('low', 'medium', 'high'),
                          include.lowest = TRUE)
table(wine$alcohol_group)

anova_model <- aov(quality ~ alcohol_group, data= wine )
summary(anova_model)
TukeyHSD(anova_model)
