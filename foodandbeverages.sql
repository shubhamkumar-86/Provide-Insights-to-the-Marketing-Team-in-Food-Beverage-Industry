use foodandbeverage;
select * from fact_survey_responses;
select * from dim_cities;
select * from dim_repondents;


-- 1.Demographic Insights

-- a. Who prefers energy drink more? (male/female/non-binary?) 

SELECT DISTINCT Gender, COUNT(Gender) AS Gender_Count 
FROM dim_repondents
GROUP BY Gender
ORDER BY 2 DESC;

-- b. Which age group prefers energy drinks more? 

SELECT DISTINCT Age AS Age_Group, COUNT(Age) AS Age_group_count
FROM dim_repondents
GROUP BY Age
ORDER BY Age_group_count DESC;

-- c. Which type of marketing reaches the most Youth (15-30)? 

SELECT DISTINCT Marketing_channels, COUNT(Marketing_channels) AS Channels_Count
FROM fact_survey_responses fsr
JOIN dim_repondents dr
ON fsr.Respondent_ID = dr.Respondent_ID
WHERE Age IN ('15-18','19-30')
GROUP BY Marketing_channels
ORDER BY Channels_Count DESC;

-- 2.Consumer Preferences: 

-- a. What are the preferred ingredients of energy drinks among respondents? 

SELECT Current_brands AS Brand_Name, Ingredients_expected AS preferred_ingredients, COUNT(Ingredients_expected) AS preferred_ingredients_count
FROM fact_survey_responses
GROUP BY Current_brands, Ingredients_expected
ORDER BY preferred_ingredients_count DESC;

-- b. What packaging preferences do respondents have for energy drinks? 

SELECT Current_brands AS Brand_Name, Packaging_preference, COUNT(Packaging_preference) AS Packaging_preference_count  
FROM fact_survey_responses
GROUP BY Current_brands, Packaging_preference
ORDER BY Packaging_preference_count DESC;


--3.Competition Analysis: 

-- a. Who are the current market leaders? 

SELECT Current_brands AS Brand_Name, COUNT(Respondent_id) AS No_of_people
FROM fact_survey_responses
GROUP BY Current_brands
ORDER BY No_of_people DESC;

-- b. What are the primary reasons consumers prefer those brands over ours? 

SELECT Current_brands, Reasons_for_choosing_brands, COUNT(Reasons_for_choosing_brands) AS Consumers_count
FROM fact_survey_responses
GROUP BY Current_brands, Reasons_for_choosing_brands
ORDER BY Consumers_count DESC;

-- 4.Marketing Channels and Brand Awareness: 

-- a.Which marketing channel can be used to reach more customers? 

SELECT Marketing_channels, COUNT(Respondent_id) as No_of_customers
FROM fact_survey_responses
GROUP BY Marketing_channels
ORDER BY No_of_customers DESC;

-- b.How effective are different marketing strategies and channels in reaching our customers?

SELECT Marketing_channels, COUNT(Marketing_channels) AS Marketing_count
FROM fact_survey_responses
WHERE Current_brands = 'Codex'
GROUP BY Marketing_channels
ORDER BY Marketing_channels DESC;

-- 5.Brand Penetration: 

-- a.What do people think about our brand? (overall rating) 

SELECT Brand_perception, Current_brands,
COUNT(Brand_perception) AS Feedbacks
FROM fact_survey_responses
WHERE Current_brands = 'Codex'
GROUP BY Brand_perception, Current_brands
ORDER BY Feedbacks DESC;

-- b.Which cities do we need to focus more on? 

SELECT DISTINCT dc.city AS City_Name, COUNT(dr.Name) AS Customer_count
FROM dim_cities dc
JOIN dim_repondents dr
ON dc.City_ID = dr.City_ID
GROUP BY City
ORDER BY Customer_count DESC;

-- 6.Purchase Behavior: 

-- a. Where do respondents prefer to purchase energy drinks? 

SELECT Purchase_location, COUNT(Respondent_ID) AS No_of_respondents
FROM fact_survey_responses
GROUP BY Purchase_location
ORDER BY No_of_respondents DESC;

-- b. What are the typical consumption situations for energy drinks among respondents? 

SELECT Typical_consumption_situations, COUNT(Respondent_ID) AS No_of_Respondent
FROM fact_survey_responses
GROUP BY Typical_consumption_situations
ORDER BY No_of_Respondent DESC;

-- c. What factors influence respondents' purchase decisions, such as price range and limited edition packaging? 

SELECT Current_brands, Typical_consumption_situations, COUNT(Respondent_id) AS No_of_customer
FROM fact_survey_responses
GROUP BY Current_brands, Typical_consumption_situations
ORDER BY No_of_customer DESC;

-- d. What factors influence respondents' purchase decisions, such as price range and limited edition packaging?

SELECT Limited_edition_packaging, Price_range, COUNT(Respondent_id) AS No_of_respondent
FROM fact_survey_responses
GROUP BY Limited_edition_packaging, Price_range
ORDER BY No_of_respondent DESC;


--7.Product Development 

-- a. Which area of business should we focus more on our product development? (Branding/taste/availability)

SELECT Current_brands, Reasons_for_choosing_brands, COUNT(Respondent_ID) AS No_of_Respondent,
DENSE_RANK() OVER(PARTITION BY Current_brands ORDER BY COUNT(Respondent_ID) DESC) AS rnk
FROM fact_survey_responses
GROUP BY Current_brands, Reasons_for_choosing_brands;

-- Analysis

-- Which City our Brand drink is more consumed

SELECT DISTINCT fsr.Current_brands, dc.City, COUNT(fsr.Respondent_id) AS Respondent_count
FROM fact_survey_responses fsr
JOIN dim_repondents dr
ON fsr.Respondent_ID = dr.Respondent_ID
JOIN dim_cities dc
ON dc.City_id = dr.City_ID
WHERE Current_brands = 'Codex'
GROUP BY fsr.Current_brands, dc.City
ORDER BY Respondent_count DESC;

-- City wise total number of consumers

SELECT DISTINCT dc.City, COUNT(fsr.Respondent_id) AS Respondent_count
FROM fact_survey_responses fsr
JOIN dim_repondents dr
ON fsr.Respondent_ID = dr.Respondent_ID
JOIN dim_cities dc
ON dc.City_id = dr.City_ID
GROUP BY dc.City
ORDER BY Respondent_count DESC;

-- Tier wise no of consumers

SELECT DISTINCT dc.Tier, COUNT(fsr.Respondent_id) AS Respondent_count
FROM fact_survey_responses fsr
JOIN dim_repondents dr
ON fsr.Respondent_ID = dr.Respondent_ID
JOIN dim_cities dc
ON dc.City_id = dr.City_ID
GROUP BY dc.Tier
ORDER BY Respondent_count DESC;