# Futures-and-Options-BankNifty-Nifty

## Overview: 
* To obtain a comprehensive understanding of this project, the employed strategy and the findings, please refer to my kaggle notebooks:
  1. [BankNifty](https://www.kaggle.com/code/himanidh/futures-and-options-bank-nifty)
  2. [Nifty](https://www.kaggle.com/code/himanidh/futures-and-options-nifty)

## What is this project about?
>
Achieving success in trading involves grasping the technical details of options and understanding the psychology of market players. The success of buying and selling options relies heavily on factors like market conditions, volatility, and the trader's skills. Making money in the market requires not just investing, but also using smart strategies to manage risks. It's crucial to be aware of the potential risks in options trading. Additionally, keeping an eye out for any hidden patterns can provide valuable insights, helping us make informed decisions and potentially invest more wisely.
>
Interestingly, a notable trend in the trading landscape is the inclination of many traders towards selling options rather than buying them. This preference for options selling over buying sparks our curiosity, prompting us to investigate whether there are discernible reasons or trends driving this shift in trading behavior. 
## Problem Statement:
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

## How to run this project?

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

