library(tidyverse)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)
library(ggplot2)
library(ggthemes) 
library(wesanderson)

data <- read.csv("./data/fno_Nifty_data.csv", stringsAsFactors = F)

Nifty_clean_data <- data %>% 
  mutate(DATE = as.Date(TIMESTAMP, format = "%d-%b-%Y")) %>% 
  mutate(EXPIRY_DATE = as.Date(EXPIRY_DT,format = "%d-%b-%Y")) %>%
  select(INSTRUMENT,SYMBOL,EXPIRY_DATE,STRIKE_PR,OPTION_TYP,CLOSE,DATE) %>% 
  mutate(Month = month(DATE, label = TRUE, abbr = TRUE)) %>% 
  mutate(Year = lubridate::year(DATE)) %>%
  mutate(ExpiryMonth = month(EXPIRY_DATE, label = TRUE, abbr = TRUE)) %>% 
  mutate(ExpiryYear = lubridate::year(EXPIRY_DATE)) %>% 
  filter(Year != 12) %>% 
  filter(Year != 2001) %>% 
  filter(Year != 2002) %>% 
  filter(Year != 2003) %>% 
  filter(Year != 2004) %>%
  filter(Year != 2005) %>% 
  filter(Year != 2006) %>%
  filter(Year != 2007) %>%
  filter(STRIKE_PR != "FF") 

Nifty_clean_data$Weekday <- weekdays(Nifty_clean_data$DATE)
Nifty_clean_data$ExpiryWeekday <- weekdays(Nifty_clean_data$EXPIRY_DATE)
Nifty_clean_data <- Nifty_clean_data %>% 
  select(INSTRUMENT,SYMBOL,EXPIRY_DATE,ExpiryWeekday,ExpiryMonth,ExpiryYear,STRIKE_PR,OPTION_TYP,CLOSE,DATE,Weekday,Month,Year)
# View(Nifty_clean_data)
# write.csv(Nifty_clean_data,"nifty_data_clean.csv",row.names = F)

###########################################################################
###########################################################################
###########################################################################

create_files <- function(year,month) 
{
  #Dividing BNF_clean_data into smaller chunks.
  file_name <- sprintf("nifty_%s_%s.csv",month,year)
  #cat("Current file:",file_name,"\n")
  subset_data <- Nifty_clean_data[Nifty_clean_data$Year == year & Nifty_clean_data$Month == month, ]
  write.csv(subset_data, file = file_name, row.names = FALSE)
}

unique_combinations <- unique(Nifty_clean_data[ ,c("Year", "Month")])

for (i in 1:nrow(unique_combinations))
{
  year <- unique_combinations$Year[i]
  month <- unique_combinations$Month[i]
  create_files(year, month)
}


###########################################################################
###########################################################################
###########################################################################

process_csv_file <- function(year,month,file_name)
{
  new_data <- read.csv(file_name, stringsAsFactors = FALSE)
  new_data$DATE <- as.Date(new_data$DATE, "%Y-%m-%d")
  new_data$EXPIRY_DATE <- as.Date(new_data$EXPIRY_DATE, "%Y-%m-%d")
  #View(new_data)
  
  #FINDING THE CLOSE PRICE OF NIFTY
  filtered_data <- new_data %>%
    filter(INSTRUMENT == "FUTIDX" & DATE == min(DATE) & ExpiryMonth==Month) 
  #View(filtered_data)
  exact_expiry_date <- filtered_data$EXPIRY_DATE
  close_price <- filtered_data$CLOSE
  
  
  
  #ROUNDING OFF THE CLOSE PRICE TO 50
  round_to_nearest_50 <- function(x) {
    rounded_value <- round(x / 50) * 50
    return(rounded_value)
  }
  RoundedClose_50 <- round_to_nearest_50(close_price)
  RoundedClose_50
  #cat("Rounded Close price (50):", RoundedClose_50, "\n")
  #ROUNDING OFF THE CLOSE PRICE TO 100
  round_to_nearest_100 <- function(x) {
    rounded_value <- round(x / 100) * 100
    return(rounded_value)
  }
  RoundedClose_100 <- round_to_nearest_100(close_price)
  RoundedClose_100
  #cat("Rounded Close price (100):", RoundedClose_100, "\n")
  
  
  
  filtered_CEPE_50 <- new_data %>%
    filter((STRIKE_PR==RoundedClose_50 | STRIKE_PR==RoundedClose_100) & ExpiryMonth==Month & EXPIRY_DATE==exact_expiry_date) 
  #View(filtered_CEPE_50)
  
  finding_sum <- filtered_CEPE_50 %>%
    spread(key=OPTION_TYP,value=CLOSE)
  finding_sum$SUM=finding_sum$CE+finding_sum$PE
  #View(finding_sum)
  
  ready_to_plot <- finding_sum %>%
    gather(CE:SUM, key="Parameters", value="Value")
  
  
  my_plot <- ggplot(ready_to_plot) +
    geom_point(mapping=aes(x=DATE,y=Value,color=Parameters), size=3, alpha=0.7,na.rm=T) +
    labs(x=paste("Trading days:", month, year), y="", title=paste("Trend followed by CE, PE and their Sum for", month, year)) +
    scale_color_manual(values = wes_palette(name = "Darjeeling1",n = 5))+
    scale_x_date(date_breaks = "1 day", date_labels = "%Y-%m-%d") +
    theme(axis.text.x = element_text(angle = 45,hjust=1)) +
    theme(axis.text.x = element_text(size = 8)) +
    theme(axis.text.y = element_text(size = 10)) +
    theme(legend.key.size = unit(0.5, "cm")) +
    theme(legend.position = "top", legend.justification = "left")
  
  file_name <- paste("nifty_plot_", month,"_", year, ".png", sep="")
  cat("Plotting :",file_name,"\n")
  ggsave(file_name, plot = my_plot, width = 9, height = 6, units = "in")
  
  percentage_difference <- finding_sum %>%
    summarise(Year = year, Month = month, PercentageDiff = ((last(SUM) - first(SUM)) / first(SUM)) * 100)
  
  return(percentage_difference)
  
}

analysis_Nifty_2008_2020 <- data.frame()

for (i in 1:nrow(unique_combinations)) 
{
  year <- unique_combinations$Year[i]
  month <- unique_combinations$Month[i]
  file_name <- sprintf("nifty_%s_%s.csv",month,year)
  #process_csv_file(year, month,file_name)
  analysis_Nifty_2008_2020 <- bind_rows(analysis_Nifty_2008_2020, process_csv_file(year, month, file_name))
}

analysis_Nifty_2008_2020 <- spread(analysis_Nifty_2008_2020, key = Month, value = PercentageDiff)
write.csv(analysis_Nifty_2008_2020,"analysis_Nifty_2008_2020.csv",row.names = FALSE)
View(analysis_Nifty_2008_2020)