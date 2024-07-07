# Tesla Stock Data Shiny App

## Project Overview

Since I bought a measly 0.3 shares of TSLA on November 9 2023, I got more intrigued by the stock market (and its ability to grow the money I had), and I would frequently talk about it with my friends, who probably had hundreds of times more shares of Tesla than I did. So of course I thought this would be a fun little project.

This Shiny App is an interactive tool designed to provide an in-depth analysis of Tesla stock data. This app allows users to visualize various aspects of Tesla’s stock performance, including open prices, close prices, volumes traded, ranges of prices, and frequencies by day of the week to help visualize if any trends exist/overlap. The tool is built to offer real-time data interaction, customizable visualizations, and the ability to display descriptive statistics.

## Features

- **User-Friendly Interface**: Intuitive interface designed for easy navigation and data selection.
- **Multiple Variables**: Options to plot Open price, Close price, Volume traded, Range of price, and Day of week.
- **Customization Options**: Users can select the color of the plots and choose to display descriptive statistics.
- **Real-Time Interaction**: Sliders to adjust the date and data ranges dynamically.
- **Descriptive Statistics**: Option to display correlations and proportions based on the selected variable.

## How It Works

### User Interface

- **Title Panel**: Displays the title "Tesla Stock Data," along with the Tesla company logo.
- **Sidebar Panel**: Provides controls for selecting variables, plot colors, and toggling descriptive statistics.
- **Main Panel**: Shows the selected variable's plot and, if enabled, descriptive statistics or frequency tables.

### Steps of Operation

1. **Data Loading**:
   - Reads the Tesla stock data from a CSV file (`TSLA.csv`).
   - Transforms the data using libraries such as `tidyverse`, `lubridate`, and `ggplot2`.

2. **Data Transformation**:
   - Converts the `date` variable to date format.
   - Creates new variables such as `weekday`, `maxRange`, and `date_numeric`.
   - Factors the `weekday` variable for accurate plotting.

3. **Plotting**:
   - Generates scatterplots for Open price, Close price, Volume traded, and Range of price.
   - Creates bar plots for the frequency of stock data by the day of the week.
   - Allows customization of plot colors and data range through user inputs.

4. **Descriptive Statistics**:
   - Computes and displays the correlation between time and the selected variable.
   - For the "Day of Week" option, displays a table of proportions.
