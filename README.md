# STATISTICAL-ANALYSIS-IN-R-Wine-Quality-Scenario-
This project investigates the intersection of viticulture and data science, specifically examining how the physicochemical properties of wine influence perceived quality. Acting as a data analyst for a wine supplier, I utilized the UCI Machine Learning Repository’s Wine Quality Dataset to provide management with actionable insights into the systematic differences between red and white varieties and the chemical drivers of taster scores.The dataset comprises two distinct subsets (red and white) with eleven continuous predictors, including acidity levels, residual sugar, sulfur dioxide, density, pH, sulfates, and alcohol content. While wine quality is technically an ordered factor (rated on a 0–10 scale), this study treats it as a numeric outcome to facilitate advanced statistical modeling and regression analysis.Analytical ObjectivesThe research is structured around four primary Research Questions (RQs) to decode the "chemistry of quality":
- RQ1 (Feature Significance): Identifying which physicochemical measures have the most significant statistical relationship with perceived quality.
- RQ2 (Predictive Modeling): Developing a regression model capable of explaining significant variance in quality scores based on chemical composition.
- RQ3 (Varietal Comparison): Determining if red and white wines differ in predictable, systematic ways regarding their alcohol content and overall quality ratings.
- RQ4 (The Alcohol Factor): Testing the specific hypothesis of whether higher alcohol volume $(\% \text{ vol})$ directly correlates with superior quality assessments.

Methodology in RThe analysis was conducted using R, employing a rigorous workflow of Exploratory Data Analysis (EDA) and inferential statistics:
- Correlation Analysis: To map the strength and direction of relationships between chemical variables.
- Hypothesis Testing & ANOVA: To statistically validate differences between wine types and across quality tiers.
- Multiple Linear Regression: To build a predictive framework that quantifies how changes in chemistry (like acidity or sulfates) impact the final quality score.
By translating laboratory readings into statistical trends, this project provides a data-driven foundation for wine suppliers to optimize production and inventory based on the chemical profiles most favored by trained tasters.
