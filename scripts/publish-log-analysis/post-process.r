library(readr)
library(dplyr)
library(ggplot2)
library(reshape2)
library(scales)

# Load output.csv
output <- read_csv("/Users/iankent/dev/src/github.com/ONSdigital/dp/scripts/publish-log-analysis/output.csv")

# Convert date strings
output$PublishDate <- as.POSIXct(strptime(output$PublishDate, "%Y-%m-%d %H:%M:%S"))
output$PublishStartDate <- as.POSIXct(strptime(output$PublishStartDate, "%Y-%m-%d %H:%M:%S"))
output$PublishEndDate <- as.POSIXct(strptime(output$PublishEndDate, "%Y-%m-%d %H:%M:%S"))

# Get scheduled releases
scheduled_releases <- data.frame(subset(output, !(is.na(PublishDate))))
scheduled_releases_since_launch <- subset(scheduled_releases, scheduled_releases$PublishStartDate > strptime("2016-02-25", "%Y-%m-%d"))
# Get manual releases
manual_releases <- data.frame(subset(output, is.na(PublishDate)))
manual_releases_since_launch <- subset(manual_releases, manual_releases$PublishStartDate > strptime("2016-02-25", "%Y-%m-%d"))
manual_releases_since_july16 <- subset(manual_releases, manual_releases$PublishStartDate >= strptime("2016-07-01", "%Y-%m-%d"))

# group by day
grouped_scheduled_releases_by_day <- scheduled_releases_since_launch %>% group_by(PublishStartDate) %>% summarise(Collections = n(), Type_dataset_Count=sum(Type_dataset_Count),Type_dataset_Words=sum(Type_dataset_Words),Type_dataset_Bytes=sum(Type_dataset_Bytes),Type_compendium_data_Count=sum(Type_compendium_data_Count),Type_compendium_data_Words=sum(Type_compendium_data_Words),Type_compendium_data_Bytes=sum(Type_compendium_data_Bytes),Type_article_download_Count=sum(Type_article_download_Count),Type_article_download_Words=sum(Type_article_download_Words),Type_article_download_Bytes=sum(Type_article_download_Bytes),Type__Count=sum(Type__Count),Type__Words=sum(Type__Words),Type__Bytes=sum(Type__Bytes),Type_static_methodology_Count=sum(Type_static_methodology_Count),Type_static_methodology_Words=sum(Type_static_methodology_Words),Type_static_methodology_Bytes=sum(Type_static_methodology_Bytes),Type_visualisation_Count=sum(Type_visualisation_Count),Type_visualisation_Words=sum(Type_visualisation_Words),Type_visualisation_Bytes=sum(Type_visualisation_Bytes),Type_product_page_Count=sum(Type_product_page_Count),Type_product_page_Words=sum(Type_product_page_Words),Type_product_page_Bytes=sum(Type_product_page_Bytes),Type_bulletin_Count=sum(Type_bulletin_Count),Type_bulletin_Words=sum(Type_bulletin_Words),Type_bulletin_Bytes=sum(Type_bulletin_Bytes),Type_compendium_landing_page_Count=sum(Type_compendium_landing_page_Count),Type_compendium_landing_page_Words=sum(Type_compendium_landing_page_Words),Type_compendium_landing_page_Bytes=sum(Type_compendium_landing_page_Bytes),Type_article_Count=sum(Type_article_Count),Type_article_Words=sum(Type_article_Words),Type_article_Bytes=sum(Type_article_Bytes),Type_timeseries_Count=sum(Type_timeseries_Count),Type_timeseries_Words=sum(Type_timeseries_Words),Type_timeseries_Bytes=sum(Type_timeseries_Bytes),Type_dataset_landing_page_Count=sum(Type_dataset_landing_page_Count),Type_dataset_landing_page_Words=sum(Type_dataset_landing_page_Words),Type_dataset_landing_page_Bytes=sum(Type_dataset_landing_page_Bytes),Type_static_page_Count=sum(Type_static_page_Count),Type_static_page_Words=sum(Type_static_page_Words),Type_static_page_Bytes=sum(Type_static_page_Bytes),Type_taxonomy_landing_page_Count=sum(Type_taxonomy_landing_page_Count),Type_taxonomy_landing_page_Words=sum(Type_taxonomy_landing_page_Words)
,Type_taxonomy_landing_page_Bytes=sum(Type_taxonomy_landing_page_Bytes),Type_timeseries_dataset_Count=sum(Type_timeseries_dataset_Count),Type_timeseries_dataset_Words=sum(Type_timeseries_dataset_Words),Type_timeseries_dataset_Bytes=sum(Type_timeseries_dataset_Bytes),Type_static_landing_page_Count=sum(Type_static_landing_page_Count),Type_static_landing_page_Words=sum(Type_static_landing_page_Words),Type_static_landing_page_Bytes=sum(Type_static_landing_page_Bytes),Type_static_methodology_download_Count=sum(Type_static_methodology_download_Count),Type_static_methodology_download_Words=sum(Type_static_methodology_download_Words),Type_static_methodology_download_Bytes=sum(Type_static_methodology_download_Bytes),Type_home_page_Count=sum(Type_home_page_Count),Type_home_page_Words=sum(Type_home_page_Words),Type_home_page_Bytes=sum(Type_home_page_Bytes),Type_static_qmi_Count=sum(Type_static_qmi_Count),Type_static_qmi_Words=sum(Type_static_qmi_Words),Type_static_qmi_Bytes=sum(Type_static_qmi_Bytes),Type_compendium_chapter_Count=sum(Type_compendium_chapter_Count),Type_compendium_chapter_Words=sum(Type_compendium_chapter_Words),Type_compendium_chapter_Bytes=sum(Type_compendium_chapter_Bytes),Type_static_foi_Count=sum(Type_static_foi_Count),Type_static_foi_Words=sum(Type_static_foi_Words),Type_static_foi_Bytes=sum(Type_static_foi_Bytes),Type_reference_tables_Count=sum(Type_reference_tables_Count),Type_reference_tables_Words=sum(Type_reference_tables_Words),Type_reference_tables_Bytes=sum(Type_reference_tables_Bytes),Type_static_article_Count=sum(Type_static_article_Count),Type_static_article_Words=sum(Type_static_article_Words),Type_static_article_Bytes=sum(Type_static_article_Bytes),Type_release_Count=sum(Type_release_Count),Type_release_Words=sum(Type_release_Words),Type_release_Bytes=sum(Type_release_Bytes),Type_static_adhoc_Count=sum(Type_static_adhoc_Count),Type_static_adhoc_Words=sum(Type_static_adhoc_Words),Type_static_adhoc_Bytes=sum(Type_static_adhoc_Bytes),Type_home_page_census_Count=sum(Type_home_page_census_Count),Type_home_page_census_Words=sum(Type_home_page_census_Words),Type_home_page_census_Bytes=sum(Type_home_page_census_Bytes))

# group by week
grouped_scheduled_releases_by_week <- scheduled_releases_since_launch %>% group_by(strftime(PublishStartDate, "%Y/%V")) %>% summarise(Collections = n(), Type_dataset_Count=sum(Type_dataset_Count),Type_dataset_Words=sum(Type_dataset_Words),Type_dataset_Bytes=sum(Type_dataset_Bytes),Type_compendium_data_Count=sum(Type_compendium_data_Count),Type_compendium_data_Words=sum(Type_compendium_data_Words),Type_compendium_data_Bytes=sum(Type_compendium_data_Bytes),Type_article_download_Count=sum(Type_article_download_Count),Type_article_download_Words=sum(Type_article_download_Words),Type_article_download_Bytes=sum(Type_article_download_Bytes),Type__Count=sum(Type__Count),Type__Words=sum(Type__Words),Type__Bytes=sum(Type__Bytes),Type_static_methodology_Count=sum(Type_static_methodology_Count),Type_static_methodology_Words=sum(Type_static_methodology_Words),Type_static_methodology_Bytes=sum(Type_static_methodology_Bytes),Type_visualisation_Count=sum(Type_visualisation_Count),Type_visualisation_Words=sum(Type_visualisation_Words),Type_visualisation_Bytes=sum(Type_visualisation_Bytes),Type_product_page_Count=sum(Type_product_page_Count),Type_product_page_Words=sum(Type_product_page_Words),Type_product_page_Bytes=sum(Type_product_page_Bytes),Type_bulletin_Count=sum(Type_bulletin_Count),Type_bulletin_Words=sum(Type_bulletin_Words),Type_bulletin_Bytes=sum(Type_bulletin_Bytes),Type_compendium_landing_page_Count=sum(Type_compendium_landing_page_Count),Type_compendium_landing_page_Words=sum(Type_compendium_landing_page_Words),Type_compendium_landing_page_Bytes=sum(Type_compendium_landing_page_Bytes),Type_article_Count=sum(Type_article_Count),Type_article_Words=sum(Type_article_Words),Type_article_Bytes=sum(Type_article_Bytes),Type_timeseries_Count=sum(Type_timeseries_Count),Type_timeseries_Words=sum(Type_timeseries_Words),Type_timeseries_Bytes=sum(Type_timeseries_Bytes),Type_dataset_landing_page_Count=sum(Type_dataset_landing_page_Count),Type_dataset_landing_page_Words=sum(Type_dataset_landing_page_Words),Type_dataset_landing_page_Bytes=sum(Type_dataset_landing_page_Bytes),Type_static_page_Count=sum(Type_static_page_Count),Type_static_page_Words=sum(Type_static_page_Words),Type_static_page_Bytes=sum(Type_static_page_Bytes),Type_taxonomy_landing_page_Count=sum(Type_taxonomy_landing_page_Count),Type_taxonomy_landing_page_Words=sum(Type_taxonomy_landing_page_Words)
,Type_taxonomy_landing_page_Bytes=sum(Type_taxonomy_landing_page_Bytes),Type_timeseries_dataset_Count=sum(Type_timeseries_dataset_Count),Type_timeseries_dataset_Words=sum(Type_timeseries_dataset_Words),Type_timeseries_dataset_Bytes=sum(Type_timeseries_dataset_Bytes),Type_static_landing_page_Count=sum(Type_static_landing_page_Count),Type_static_landing_page_Words=sum(Type_static_landing_page_Words),Type_static_landing_page_Bytes=sum(Type_static_landing_page_Bytes),Type_static_methodology_download_Count=sum(Type_static_methodology_download_Count),Type_static_methodology_download_Words=sum(Type_static_methodology_download_Words),Type_static_methodology_download_Bytes=sum(Type_static_methodology_download_Bytes),Type_home_page_Count=sum(Type_home_page_Count),Type_home_page_Words=sum(Type_home_page_Words),Type_home_page_Bytes=sum(Type_home_page_Bytes),Type_static_qmi_Count=sum(Type_static_qmi_Count),Type_static_qmi_Words=sum(Type_static_qmi_Words),Type_static_qmi_Bytes=sum(Type_static_qmi_Bytes),Type_compendium_chapter_Count=sum(Type_compendium_chapter_Count),Type_compendium_chapter_Words=sum(Type_compendium_chapter_Words),Type_compendium_chapter_Bytes=sum(Type_compendium_chapter_Bytes),Type_static_foi_Count=sum(Type_static_foi_Count),Type_static_foi_Words=sum(Type_static_foi_Words),Type_static_foi_Bytes=sum(Type_static_foi_Bytes),Type_reference_tables_Count=sum(Type_reference_tables_Count),Type_reference_tables_Words=sum(Type_reference_tables_Words),Type_reference_tables_Bytes=sum(Type_reference_tables_Bytes),Type_static_article_Count=sum(Type_static_article_Count),Type_static_article_Words=sum(Type_static_article_Words),Type_static_article_Bytes=sum(Type_static_article_Bytes),Type_release_Count=sum(Type_release_Count),Type_release_Words=sum(Type_release_Words),Type_release_Bytes=sum(Type_release_Bytes),Type_static_adhoc_Count=sum(Type_static_adhoc_Count),Type_static_adhoc_Words=sum(Type_static_adhoc_Words),Type_static_adhoc_Bytes=sum(Type_static_adhoc_Bytes),Type_home_page_census_Count=sum(Type_home_page_census_Count),Type_home_page_census_Words=sum(Type_home_page_census_Words),Type_home_page_census_Bytes=sum(Type_home_page_census_Bytes))
melted_grouped_scheduled_releases_by_week <- melt(grouped_scheduled_releases_by_week)
melted_grouped_scheduled_releases_by_week$cat <- ''
melted_grouped_scheduled_releases_by_week[melted_grouped_scheduled_releases_by_week$variable=='Type_bulletin_Count',]$cat <- 'Count'
melted_grouped_scheduled_releases_by_week[melted_grouped_scheduled_releases_by_week$variable=='Type_bulletin_Words',]$cat <- 'Words'
melted_grouped_scheduled_releases_by_week[melted_grouped_scheduled_releases_by_week$variable=='Type_bulletin_Bytes',]$cat <- 'Bytes'

# scheduled releases group by month
grouped_scheduled_releases_by_month <- scheduled_releases_since_launch %>% group_by(strftime(PublishStartDate, "%Y/%m")) %>% summarise(Collections = n(), Type_dataset_Count=sum(Type_dataset_Count),Type_dataset_Words=sum(Type_dataset_Words),Type_dataset_Bytes=sum(Type_dataset_Bytes),Type_compendium_data_Count=sum(Type_compendium_data_Count),Type_compendium_data_Words=sum(Type_compendium_data_Words),Type_compendium_data_Bytes=sum(Type_compendium_data_Bytes),Type_article_download_Count=sum(Type_article_download_Count),Type_article_download_Words=sum(Type_article_download_Words),Type_article_download_Bytes=sum(Type_article_download_Bytes),Type__Count=sum(Type__Count),Type__Words=sum(Type__Words),Type__Bytes=sum(Type__Bytes),Type_static_methodology_Count=sum(Type_static_methodology_Count),Type_static_methodology_Words=sum(Type_static_methodology_Words),Type_static_methodology_Bytes=sum(Type_static_methodology_Bytes),Type_visualisation_Count=sum(Type_visualisation_Count),Type_visualisation_Words=sum(Type_visualisation_Words),Type_visualisation_Bytes=sum(Type_visualisation_Bytes),Type_product_page_Count=sum(Type_product_page_Count),Type_product_page_Words=sum(Type_product_page_Words),Type_product_page_Bytes=sum(Type_product_page_Bytes),Type_bulletin_Count=sum(Type_bulletin_Count),Type_bulletin_Words=sum(Type_bulletin_Words),Type_bulletin_Bytes=sum(Type_bulletin_Bytes),Type_compendium_landing_page_Count=sum(Type_compendium_landing_page_Count),Type_compendium_landing_page_Words=sum(Type_compendium_landing_page_Words),Type_compendium_landing_page_Bytes=sum(Type_compendium_landing_page_Bytes),Type_article_Count=sum(Type_article_Count),Type_article_Words=sum(Type_article_Words),Type_article_Bytes=sum(Type_article_Bytes),Type_timeseries_Count=sum(Type_timeseries_Count),Type_timeseries_Words=sum(Type_timeseries_Words),Type_timeseries_Bytes=sum(Type_timeseries_Bytes),Type_dataset_landing_page_Count=sum(Type_dataset_landing_page_Count),Type_dataset_landing_page_Words=sum(Type_dataset_landing_page_Words),Type_dataset_landing_page_Bytes=sum(Type_dataset_landing_page_Bytes),Type_static_page_Count=sum(Type_static_page_Count),Type_static_page_Words=sum(Type_static_page_Words),Type_static_page_Bytes=sum(Type_static_page_Bytes),Type_taxonomy_landing_page_Count=sum(Type_taxonomy_landing_page_Count),Type_taxonomy_landing_page_Words=sum(Type_taxonomy_landing_page_Words)
                                                                                                                                 ,Type_taxonomy_landing_page_Bytes=sum(Type_taxonomy_landing_page_Bytes),Type_timeseries_dataset_Count=sum(Type_timeseries_dataset_Count),Type_timeseries_dataset_Words=sum(Type_timeseries_dataset_Words),Type_timeseries_dataset_Bytes=sum(Type_timeseries_dataset_Bytes),Type_static_landing_page_Count=sum(Type_static_landing_page_Count),Type_static_landing_page_Words=sum(Type_static_landing_page_Words),Type_static_landing_page_Bytes=sum(Type_static_landing_page_Bytes),Type_static_methodology_download_Count=sum(Type_static_methodology_download_Count),Type_static_methodology_download_Words=sum(Type_static_methodology_download_Words),Type_static_methodology_download_Bytes=sum(Type_static_methodology_download_Bytes),Type_home_page_Count=sum(Type_home_page_Count),Type_home_page_Words=sum(Type_home_page_Words),Type_home_page_Bytes=sum(Type_home_page_Bytes),Type_static_qmi_Count=sum(Type_static_qmi_Count),Type_static_qmi_Words=sum(Type_static_qmi_Words),Type_static_qmi_Bytes=sum(Type_static_qmi_Bytes),Type_compendium_chapter_Count=sum(Type_compendium_chapter_Count),Type_compendium_chapter_Words=sum(Type_compendium_chapter_Words),Type_compendium_chapter_Bytes=sum(Type_compendium_chapter_Bytes),Type_static_foi_Count=sum(Type_static_foi_Count),Type_static_foi_Words=sum(Type_static_foi_Words),Type_static_foi_Bytes=sum(Type_static_foi_Bytes),Type_reference_tables_Count=sum(Type_reference_tables_Count),Type_reference_tables_Words=sum(Type_reference_tables_Words),Type_reference_tables_Bytes=sum(Type_reference_tables_Bytes),Type_static_article_Count=sum(Type_static_article_Count),Type_static_article_Words=sum(Type_static_article_Words),Type_static_article_Bytes=sum(Type_static_article_Bytes),Type_release_Count=sum(Type_release_Count),Type_release_Words=sum(Type_release_Words),Type_release_Bytes=sum(Type_release_Bytes),Type_static_adhoc_Count=sum(Type_static_adhoc_Count),Type_static_adhoc_Words=sum(Type_static_adhoc_Words),Type_static_adhoc_Bytes=sum(Type_static_adhoc_Bytes),Type_home_page_census_Count=sum(Type_home_page_census_Count),Type_home_page_census_Words=sum(Type_home_page_census_Words),Type_home_page_census_Bytes=sum(Type_home_page_census_Bytes))
melted_grouped_scheduled_releases_by_month <- melt(grouped_scheduled_releases_by_month)
melted_grouped_scheduled_releases_by_month$cat <- ''
melted_grouped_scheduled_releases_by_month[melted_grouped_scheduled_releases_by_month$variable=='Type_bulletin_Count',]$cat <- 'Count'
melted_grouped_scheduled_releases_by_month[melted_grouped_scheduled_releases_by_month$variable=='Type_bulletin_Words',]$cat <- 'Words'
melted_grouped_scheduled_releases_by_month[melted_grouped_scheduled_releases_by_month$variable=='Type_bulletin_Bytes',]$cat <- 'Bytes'

# manual releases group by month
grouped_manual_releases_by_month <- manual_releases_since_july16 %>% group_by(strftime(PublishStartDate, "%Y/%m")) %>% summarise(Collections = n(), Type_dataset_Count=sum(Type_dataset_Count),Type_dataset_Words=sum(Type_dataset_Words),Type_dataset_Bytes=sum(Type_dataset_Bytes),Type_compendium_data_Count=sum(Type_compendium_data_Count),Type_compendium_data_Words=sum(Type_compendium_data_Words),Type_compendium_data_Bytes=sum(Type_compendium_data_Bytes),Type_article_download_Count=sum(Type_article_download_Count),Type_article_download_Words=sum(Type_article_download_Words),Type_article_download_Bytes=sum(Type_article_download_Bytes),Type__Count=sum(Type__Count),Type__Words=sum(Type__Words),Type__Bytes=sum(Type__Bytes),Type_static_methodology_Count=sum(Type_static_methodology_Count),Type_static_methodology_Words=sum(Type_static_methodology_Words),Type_static_methodology_Bytes=sum(Type_static_methodology_Bytes),Type_visualisation_Count=sum(Type_visualisation_Count),Type_visualisation_Words=sum(Type_visualisation_Words),Type_visualisation_Bytes=sum(Type_visualisation_Bytes),Type_product_page_Count=sum(Type_product_page_Count),Type_product_page_Words=sum(Type_product_page_Words),Type_product_page_Bytes=sum(Type_product_page_Bytes),Type_bulletin_Count=sum(Type_bulletin_Count),Type_bulletin_Words=sum(Type_bulletin_Words),Type_bulletin_Bytes=sum(Type_bulletin_Bytes),Type_compendium_landing_page_Count=sum(Type_compendium_landing_page_Count),Type_compendium_landing_page_Words=sum(Type_compendium_landing_page_Words),Type_compendium_landing_page_Bytes=sum(Type_compendium_landing_page_Bytes),Type_article_Count=sum(Type_article_Count),Type_article_Words=sum(Type_article_Words),Type_article_Bytes=sum(Type_article_Bytes),Type_timeseries_Count=sum(Type_timeseries_Count),Type_timeseries_Words=sum(Type_timeseries_Words),Type_timeseries_Bytes=sum(Type_timeseries_Bytes),Type_dataset_landing_page_Count=sum(Type_dataset_landing_page_Count),Type_dataset_landing_page_Words=sum(Type_dataset_landing_page_Words),Type_dataset_landing_page_Bytes=sum(Type_dataset_landing_page_Bytes),Type_static_page_Count=sum(Type_static_page_Count),Type_static_page_Words=sum(Type_static_page_Words),Type_static_page_Bytes=sum(Type_static_page_Bytes),Type_taxonomy_landing_page_Count=sum(Type_taxonomy_landing_page_Count),Type_taxonomy_landing_page_Words=sum(Type_taxonomy_landing_page_Words)
                                                                                                                                  ,Type_taxonomy_landing_page_Bytes=sum(Type_taxonomy_landing_page_Bytes),Type_timeseries_dataset_Count=sum(Type_timeseries_dataset_Count),Type_timeseries_dataset_Words=sum(Type_timeseries_dataset_Words),Type_timeseries_dataset_Bytes=sum(Type_timeseries_dataset_Bytes),Type_static_landing_page_Count=sum(Type_static_landing_page_Count),Type_static_landing_page_Words=sum(Type_static_landing_page_Words),Type_static_landing_page_Bytes=sum(Type_static_landing_page_Bytes),Type_static_methodology_download_Count=sum(Type_static_methodology_download_Count),Type_static_methodology_download_Words=sum(Type_static_methodology_download_Words),Type_static_methodology_download_Bytes=sum(Type_static_methodology_download_Bytes),Type_home_page_Count=sum(Type_home_page_Count),Type_home_page_Words=sum(Type_home_page_Words),Type_home_page_Bytes=sum(Type_home_page_Bytes),Type_static_qmi_Count=sum(Type_static_qmi_Count),Type_static_qmi_Words=sum(Type_static_qmi_Words),Type_static_qmi_Bytes=sum(Type_static_qmi_Bytes),Type_compendium_chapter_Count=sum(Type_compendium_chapter_Count),Type_compendium_chapter_Words=sum(Type_compendium_chapter_Words),Type_compendium_chapter_Bytes=sum(Type_compendium_chapter_Bytes),Type_static_foi_Count=sum(Type_static_foi_Count),Type_static_foi_Words=sum(Type_static_foi_Words),Type_static_foi_Bytes=sum(Type_static_foi_Bytes),Type_reference_tables_Count=sum(Type_reference_tables_Count),Type_reference_tables_Words=sum(Type_reference_tables_Words),Type_reference_tables_Bytes=sum(Type_reference_tables_Bytes),Type_static_article_Count=sum(Type_static_article_Count),Type_static_article_Words=sum(Type_static_article_Words),Type_static_article_Bytes=sum(Type_static_article_Bytes),Type_release_Count=sum(Type_release_Count),Type_release_Words=sum(Type_release_Words),Type_release_Bytes=sum(Type_release_Bytes),Type_static_adhoc_Count=sum(Type_static_adhoc_Count),Type_static_adhoc_Words=sum(Type_static_adhoc_Words),Type_static_adhoc_Bytes=sum(Type_static_adhoc_Bytes),Type_home_page_census_Count=sum(Type_home_page_census_Count),Type_home_page_census_Words=sum(Type_home_page_census_Words),Type_home_page_census_Bytes=sum(Type_home_page_census_Bytes))
melted_grouped_manual_releases_by_month <- melt(grouped_manual_releases_by_month)
melted_grouped_manual_releases_by_month$cat <- ''
melted_grouped_manual_releases_by_month[melted_grouped_manual_releases_by_month$variable=='Type_bulletin_Count',]$cat <- 'Count'
melted_grouped_manual_releases_by_month[melted_grouped_manual_releases_by_month$variable=='Type_bulletin_Words',]$cat <- 'Words'
melted_grouped_manual_releases_by_month[melted_grouped_manual_releases_by_month$variable=='Type_bulletin_Bytes',]$cat <- 'Bytes'


# plot groups by month
# ggplot(data = melted_grouped_scheduled_releases_by_month[melted_grouped_scheduled_releases_by_month$cat != '',], aes(x=cat, y=value, fill=variable)) + geom_bar(stat = 'identity', position = 'stack') + facet_grid(~ `strftime(PublishStartDate, "%Y/%m")`)
# stacked chart
ggplot(data = melted_grouped_scheduled_releases_by_month[melted_grouped_scheduled_releases_by_month$variable %in% c('Type_bulletin_Count', 'Type_article_Count', 'Type_compendium_Count', 'Type_static_methodology_Count', 'Type_compendium_chapter_Count'),], aes(x=`strftime(PublishStartDate, "%Y/%m")`, y=value, fill=variable)) + geom_bar(stat = 'identity')
ggplot(data = melted_grouped_scheduled_releases_by_month[melted_grouped_scheduled_releases_by_month$variable %in% c('Type_bulletin_Words', 'Type_article_Words', 'Type_compendium_Words', 'Type_static_methodology_Words', 'Type_compendium_chapter_Words'),], aes(x=`strftime(PublishStartDate, "%Y/%m")`, y=value, fill=variable)) + geom_bar(stat = 'identity')
# line chart
ggplot(data = melted_grouped_scheduled_releases_by_month[melted_grouped_scheduled_releases_by_month$variable %in% c('Type_bulletin_Count', 'Type_article_Count', 'Type_compendium_Count', 'Type_static_methodology_Count', 'Type_compendium_chapter_Count'),], aes(x=`strftime(PublishStartDate, "%Y/%m")`, y=value, colour=variable)) + geom_line(aes(group=variable)) + geom_smooth(method = "lm", aes(group=variable)) + xlab("Month") + ylab("Count") + ggtitle("Number of pages by page type by month") + scale_y_continuous(label=comma)
ggplot(data = melted_grouped_scheduled_releases_by_month[melted_grouped_scheduled_releases_by_month$variable %in% c('Type_bulletin_Words', 'Type_article_Words', 'Type_compendium_Words', 'Type_static_methodology_Words', 'Type_compendium_chapter_Words'),], aes(x=`strftime(PublishStartDate, "%Y/%m")`, y=value, colour=variable)) + geom_line(aes(group=variable)) + geom_smooth(method = "lm", aes(group=variable)) + xlab("Month") + ylab("Words") + ggtitle("Number of words by page type by month") + scale_y_continuous(label=comma)

# manual releases by month chart
ggplot(data = melted_grouped_manual_releases_by_month[melted_grouped_manual_releases_by_month$variable %in% c('Type_bulletin_Count', 'Type_article_Count', 'Type_compendium_Count', 'Type_static_methodology_Count', 'Type_compendium_chapter_Count'),], aes(x=`strftime(PublishStartDate, "%Y/%m")`, y=value, colour=variable)) + geom_line(aes(group=variable)) + geom_smooth(method = "lm", aes(group=variable)) + xlab("Month") + ylab("Count") + ggtitle("Number of pages by page type by month") + scale_y_continuous(label=comma)
ggplot(data = melted_grouped_manual_releases_by_month[melted_grouped_manual_releases_by_month$variable %in% c('Type_bulletin_Words', 'Type_article_Words', 'Type_compendium_Words', 'Type_static_methodology_Words', 'Type_compendium_chapter_Words'),], aes(x=`strftime(PublishStartDate, "%Y/%m")`, y=value, colour=variable)) + geom_line(aes(group=variable)) + geom_smooth(method = "lm", aes(group=variable)) + xlab("Month") + ylab("Words") + ggtitle("Number of words by page type by month") + scale_y_continuous(label=comma)

# plot bulletins by week
# ggplot(data = melted_grouped_scheduled_releases_by_week[melted_grouped_scheduled_releases_by_week$variable %in% c('Type_bulletin_Count', 'Type_article_Count', 'Type_compendium_Count', 'Type_static_methodology_Count', 'Type_compendium_chapter_Count'),], aes(x=`strftime(PublishStartDate, "%Y/%V")`, y=value, fill=variable)) + geom_bar(stat = 'identity') + theme(axis.text.x = element_text(angle=90)) + scale_x_continuous(breaks=10)
ggplot(data = melted_grouped_scheduled_releases_by_week[melted_grouped_scheduled_releases_by_week$variable %in% c('Type_bulletin_Count', 'Type_article_Count', 'Type_compendium_Count', 'Type_static_methodology_Count', 'Type_compendium_chapter_Count'),], aes(x=`strftime(PublishStartDate, "%Y/%V")`, y=value, fill=variable)) + geom_bar(stat = 'identity')

write_csv(grouped_scheduled_releases_by_week, "/Users/iankent/dev/src/github.com/ONSdigital/dp/scripts/publish-log-analysis/processed.csv")