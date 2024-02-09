library(tidyverse)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)
library(ggplot2)
library(plotly)
library(ggthemes) 
library(wesanderson)

the_data <- read.csv("./data/fno_Banknifty_data.csv",stringsAsFactors = F)

BNF_clean_data <- the_data %>% 
  mutate(DATE = as.Date(TIMESTAMP, format = "%d-%b-%Y")) %>% 
  mutate(EXPIRY_DATE = as.Date(EXPIRY_DT,format = "%d-%b-%Y")) %>%
  select(INSTRUMENT,SYMBOL,EXPIRY_DATE,STRIKE_PR,OPTION_TYP,CLOSE,DATE) %>% 
  mutate(Month = month(DATE, label = TRUE, abbr = TRUE)) %>% 
  mutate(Year = lubridate::year(DATE)) %>%
  mutate(ExpiryMonth = month(EXPIRY_DATE, label = TRUE, abbr = TRUE)) %>% 
  mutate(ExpiryYear = lubridate::year(EXPIRY_DATE)) %>%
  filter(Year != 12) %>% 
  filter(Year != 2005) %>% 
  filter(Year != 2006) %>% 
  filter(Year != 2007) %>% 
  filter(Year != 2008) %>% 
  filter(STRIKE_PR != "FF") 

BNF_clean_data$Weekday <- weekdays(BNF_clean_data$DATE)
BNF_clean_data$ExpiryWeekday <- weekdays(BNF_clean_data$EXPIRY_DATE)
BNF_clean_data <- BNF_clean_data %>% 
  select(INSTRUMENT,SYMBOL,EXPIRY_DATE,ExpiryWeekday,ExpiryMonth,ExpiryYear,STRIKE_PR,OPTION_TYP,CLOSE,DATE,Weekday,Month,Year)

close_price_nifty <- BNF_clean_data[,"CLOSE"]
round_to_nearest_100 <- function(x) {
  rounded_value <- round(x / 100) * 100
  return(rounded_value)
}
Rounded_Close <- round_to_nearest_100(close_price_nifty)
BNF_clean_data$Rounded_Close <- Rounded_Close

BNF_clean_data <- BNF_clean_data %>% 
  select(INSTRUMENT,SYMBOL,EXPIRY_DATE,ExpiryWeekday,ExpiryMonth,ExpiryYear,STRIKE_PR,OPTION_TYP,CLOSE,Rounded_Close,DATE,Weekday,Month,Year)
#write.csv(BNF_clean_data,"BNF_clean_data.csv",row.names = F)

###########################################################################
###########################################################################
###########################################################################

#creating multiple files- of each month of each year

creating_files <- function(year,month) 
{
  #Dividing BNF_clean_data into smaller chunks.
  file_name <- sprintf("banknifty_%s_%s.csv",month,year)
  #cat("Current file:",file_name,"\n")
  subset_data <- BNF_clean_data[BNF_clean_data$Year == year & BNF_clean_data$Month == month, ]
  write.csv(subset_data,file = file_name,row.names = FALSE)
}

unique_combinations <- unique(BNF_clean_data[ ,c("Year", "Month")])

for (i in 1:nrow(unique_combinations)) 
{
  year <- unique_combinations$Year[i]
  month <- unique_combinations$Month[i]
  creating_files(year, month)
}

###########################################################################
###########################################################################
###########################################################################

process_csv_file <- function(year,month,file_name) 
{
  new_data <- read.csv(file_name, stringsAsFactors = FALSE)
  new_data$DATE <- as.Date(new_data$DATE, "%Y-%m-%d")
  new_data$EXPIRY_DATE <- as.Date(new_data$EXPIRY_DATE, "%Y-%m-%d")
  
  #FINDING THE ROUNDED CLOSE PRICE OF INDEX
  filtered_data <- new_data %>%
    filter(INSTRUMENT == "FUTIDX" & DATE == min(DATE) & ExpiryMonth==Month) 
  monthly_expiry_date <- filtered_data$EXPIRY_DATE
  rounded_close_price <- filtered_data$Rounded_Close
  #cat("Rounded_Close price:", rounded_close_price, "\n")
  #View(filtered_data)
  
  #FINDING THE STRIKE PRICE OF THE SAME VALUE ALONG WITH OPTION TYPE
  filtered_CE_PE <- new_data %>%
    filter(STRIKE_PR==rounded_close_price & ExpiryMonth==Month & EXPIRY_DATE==monthly_expiry_date) 
  #View(filtered_CE_PE)
  
  #FINDING THE SUM OF CE AND PE AND MAKING FILES READY TO PLOT 
  finding_sum <- filtered_CE_PE %>%
    select(-Rounded_Close) %>% 
    spread(key=OPTION_TYP,value=CLOSE)
  #View(finding_sum)
  
  finding_sum$SUM=finding_sum$CE+finding_sum$PE
  #View(finding_sum)
  
  ready_to_plot <- finding_sum %>% 
    gather(CE:SUM, key="Parameters", value="Value")
  
  #PLOTTING
  my_plot <- ggplot(ready_to_plot) +
    geom_point(mapping=aes(x=DATE,y=Value,color=Parameters), size=3, alpha=0.7, na.rm=T) +
    labs(x=paste("Trading days:", month, year), y="", title=paste("Bank Nifty: Trend followed by CE, PE and their Sum for", month, year)) +
    scale_color_manual(values = wes_palette(name = "Darjeeling1",n = 5))+
    scale_x_date(date_breaks = "1 day", date_labels = "%Y-%m-%d") +
    theme(axis.text.x = element_text(angle = 45,hjust=1)) +
    theme(axis.text.x = element_text(size = 8)) +
    theme(axis.text.y = element_text(size = 10)) +
    theme(legend.key.size = unit(0.5, "cm")) +
    theme(legend.position = "top", legend.justification = "left")
  
  file_name <- paste("banknifty_plot_", month,"_", year, ".png", sep = "")
  cat("Plotting :",file_name,"\n")
  ggsave(file_name, plot = my_plot, width = 9, height = 6, units = "in")
  
  
  percentage_difference <- finding_sum %>%
    summarise(Year = year, Month = month, PercentageDiff = ((last(SUM) - first(SUM)) / first(SUM)) * 100)
  
  return(percentage_difference)
  
}

analysis_BankNifty_2009_2020 <- data.frame()

for (i in 1:nrow(unique_combinations)) 
{
  year <- unique_combinations$Year[i]
  month <- unique_combinations$Month[i]
  file_name <- sprintf("banknifty_%s_%s.csv",month,year)
  #process_csv_file(year, month,file_name)
  analysis_BankNifty_2009_2020 <- bind_rows(analysis_BankNifty_2009_2020, process_csv_file(year, month, file_name))
}

analysis_BankNifty_2009_2020 <- spread(analysis_BankNifty_2009_2020, key = Month, value = PercentageDiff)
write.csv(analysis_BankNifty_2009_2020,"analysis_BankNifty_2009_2020.csv",row.names = FALSE)
View(analysis_BankNifty_2009_2020)