# Futures and Options: BankNifty and Nifty

## Overview: 
* To obtain a comprehensive understanding of this analysis, the employed strategy and the findings, please refer to my kaggle notebooks:
  1. [BankNifty](https://www.kaggle.com/code/himanidh/futures-and-options-bank-nifty)
  2. [Nifty](https://www.kaggle.com/code/himanidh/futures-and-options-nifty/notebook)

## What is this analysis about?
>
Achieving success in trading involves grasping the technical details of options and understanding the psychology of market players. The success of buying and selling options relies heavily on factors like market conditions, volatility, and the trader's skills. Making money in the market requires not just investing, but also using smart strategies to manage risks. It's crucial to be aware of the potential risks in options trading. Additionally, keeping an eye out for any hidden patterns can provide valuable insights, helping us make informed decisions and potentially invest more wisely.
>
Interestingly, a notable trend in the trading landscape is the inclination of many traders towards selling options rather than buying them. This preference for options selling over buying sparks our curiosity, prompting us to investigate whether there are discernible reasons or trends driving this shift in trading behavior. 

As FnO trading relies on predictive analysis of stock prices or indices, our objective is to identify any existing trends or patterns. This approach will assist us in predicting the direction of the price movement based on past trends of a particular Stock or Index and enhancing our ability to assess risks more effectively when making future investments in these contracts. Moreover, given the perceived notion that options buying is often associated with losses, we aim to conduct a thorough analysis to explore if there are ways to turn it into a profitable venture.

## Strategy employed:
The following strategy is implemented **sequentially**.
>
1. Identify the first trading day of a specific month.
2. Locate the row corresponding to the first trading day and the monthly expiry date, focusing on the instrument labeled "FUTIDX". Record the closing price listed in that row.
3. Round off the recorded closing price to the nearest hundred and make a note of this rounded value.
4. Filter the rows with the monthly expiry of that month and where the strike price matches the rounded off close price.
5. Record the values of both CE and PE for the first trading day of that month.
6. Calculate the sum of the values for CE and PE on the first trading day, referred to as SUM; this sum serves as our buying price.
7. Determine the total of CE and PE on the monthly expiry; this sum represents our selling price.
8. The strategy involves buying at the same price equivalent to SUM on the first trading day and selling it on price which is same as the SUM of CE and PE on the monthly expiry.
9. Assess whether the selling price is lower or higher than the buying price. A lower selling price indicates a loss, while a higher selling price signifies a profit for that particular month.


## Analytical Summary: Bank Nifty 
For analysis, we have crafted tables and corresponding scatterplots for each month, providing a comprehensive visual representation. Additionally, the tabulated data below shows the profit and loss percentages for every month across multiple years. To illustrate, let's delve into specific examples for selected months.


<img width="1241" alt="Screenshot 2024-02-20 at 8 34 49 PM" src="https://github.com/HimaniD27/Futures-and-Options-BankNifty-Nifty/assets/138992332/23594318-2eb1-4b64-a20c-fb63ceda50ce">

<img width="1239" alt="Screenshot 2024-02-20 at 9 37 16 PM" src="https://github.com/HimaniD27/Futures-and-Options-BankNifty-Nifty/assets/138992332/6d65ae25-a93b-43c2-9386-0856140b6e72">


<img width="938" alt="Screenshot 2024-02-20 at 7 20 47 PM" src="https://github.com/HimaniD27/Futures-and-Options-BankNifty-Nifty/assets/138992332/b2633335-038c-4b05-88e6-e2be162d7f18">

<img width="941" alt="Screenshot 2024-02-20 at 7 25 00 PM" src="https://github.com/HimaniD27/Futures-and-Options-BankNifty-Nifty/assets/138992332/05b89fc0-fa89-4b64-b3a1-1393847b43b5">


* Looking at the table, it's clear that if we bought an options contract on the first trading day of January 2020 and sold it on the monthly expiry, we'd make a nice profit of 69.6%. The scatterplot we created supports this finding.
* When we check out the scatterplot, it suggests that going for a Put Options contract makes sense for this month. Towards the end of the month, the Put value gets pretty close to the Sum value. So, for better results, it seems like choosing a Put Options contract would be a good move.

* We can say from the table that if we bought an options contract on the first trading day of December 2019 and sold it on the monthly expiry, we'd make a loss of 90.5% and the scatterplot verifies the same.
* Going for Call options contract would be the right choice for this month as the Call Option value is becoming the Sum towards the end of the month.

* Profitable Months: January, February, March, May, July, August, September, November
* Loss-Making Months: April, June, October, December
* Months in which buying Call Options contracts is preferable: March, April, May, September, October, December
* Months in which buying Put Options contracts is preferable: January, February, June, July, August


## Analytical Summary: Nifty 

<img width="1172" alt="Screenshot 2024-02-20 at 8 35 49 PM" src="https://github.com/HimaniD27/Futures-and-Options-BankNifty-Nifty/assets/138992332/95dfd688-160a-4d5d-baf8-f3ad2de537af">

<img width="1201" alt="Screenshot 2024-02-20 at 10 32 33 PM" src="https://github.com/HimaniD27/Futures-and-Options-BankNifty-Nifty/assets/138992332/e76e8077-06e5-4dd0-ac7d-2776e07df4a8">


<img width="930" alt="Screenshot 2024-02-20 at 8 15 08 PM" src="https://github.com/HimaniD27/Futures-and-Options-BankNifty-Nifty/assets/138992332/0e9f9f9d-4509-4d4d-ab20-662b271d1af4">

<img width="936" alt="Screenshot 2024-02-20 at 8 17 19 PM" src="https://github.com/HimaniD27/Futures-and-Options-BankNifty-Nifty/assets/138992332/6b3bfe80-37b3-45d4-99a9-0c0715c5a97b">


* From the table we can conclude that if we bought an options contract on the first trading day of January 2016 and sold it on the monthly expiry, we'd make a profit of 151.3% and the scatterplot verifies the same.
* Going for Put options would be the right choice for this month as the Put value is almost becoming the Sum during monthly expiry.

* From the table we can conclude that if we bought an options contract on the first trading day of July 2009 and sold it on the monthly expiry, we'd make a loss of 34.4% and the scatterplot verifies the same.
* Going for Call options would be the right choice for this month as the Call value is almost becoming the Sum during monthly expiry.

* Profitable Months: January, March, September, November
* Loss-Making Months: February, April, May, June, July, August, December
* Months in which buying Call Options contracts is preferable: March, April, May, July, September
* Months in which buying Put Options contracts is preferable: January, February, June, August, November, December 



## How to run?

1. Download R Studio:
>Go to the R Studio website.
>Download and install RStudio on your computer.

2. Clone Repository:
>Open GitHub Desktop.
>Clone this project repository in GitHub Desktop.

3. Open Project Folder:
>Locate the folder of this project on your computer.

4. Open R Studio:
>Inside the project folder, there will be an R project named [Futures and Options.Rproj](https://github.com/HimaniD27/Futures-and-Options-BankNifty-Nifty/blob/main/Futures%20and%20Options.Rproj).
>Open this, and it will automatically open RStudio.

5. Run Code:
>RStudio will automatically open the files named [fno_banknifty.R](https://github.com/HimaniD27/Futures-and-Options-BankNifty-Nifty/blob/main/fno_banknifty.R) and [fno_nifty.R](https://github.com/HimaniD27/Futures-and-Options-BankNifty-Nifty/blob/main/fno_nifty.R).
>Or from the Files pane, open these files and run the code inside.

6. View Plots:
>After running the code, check the working directory.
>You'll see all the monthwise CSVs and plots related to this project there.

## Installation of RStudio:
1. Windows 10/11: [RStudio](https://download1.rstudio.org/electron/windows/RStudio-2023.12.1-402.exe)
2. MacOS 12+ : [RStudio](https://download1.rstudio.org/electron/macos/RStudio-2023.12.1-402.dmg)
* Go to [Posit](https://posit.co/download/rstudio-desktop/) for more information and downloading options.

