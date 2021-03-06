#set working directory
setwd("/Users/victorialarson/Desktop/Dev_League/Repos/Sprint7")

# Using Libray pdftools
library(pdftools)
library(stringr)

# Assigning a variable
jan1 <- pdf_text()


# Going to create functions to make this easier. listed below are mmy 6 files I will use. 
# "0107_0113.pdf"
# "0114_0120.pdf"
# "0121_0127.pdf"
# "0128_0203.pdf"
# "0204_0210.pdf"
# "0211_0217.pdf"


#getting page 3 from the file 
get_pg3_from_file = function(filename) {
  file_text = pdf_text(filename)
  # Want to focus on page 3 of the vector in the list.
  page3 = file_text[[3]]
  #Using regexpr to find the location of RevPAR\n
  tindex = regexpr("RevPAR\n", page3)
  #deleting "RevPAR\n" and everything before it using substring
  page3 = substring(page3,tindex+7)
  # String split with "\n" - creates new lines
  newline = strsplit(page3, "\n")
  #using substring turned my page into a list, i need it to be a character
  newchar = unlist(newline)
  #taking out all of the rows I dont need.
  newchar = newchar[-(2)]
  newchar = newchar[-(9)]
  newchar = newchar[-(15)]
  newchar = newchar[-(21)]
  newchar = newchar[-(46:48)]
  # Extracted all of the floats from the vectors
  extract = (str_extract_all(newchar,"[+-]?([0-9]*[.])?[0-9]+"))
  # turning the list back into a character
  un_list = unlist(extract)
  # telling it there need to be 18 lines
  rep_list = rep(1:18, times=length(un_list)/18)
  # I dont know whats going on here
  split_list = split(un_list, rep_list)
  # making the columns
  df = cbind.data.frame(split_list, stringsAsFactors=F)
  #adding column names
  names(df) = c("CurrentWeek_2017_Occ", "CurrentWeek_2016_Occ", "CurrentWeek_2017_ADR", "CurrentWeek_2016_ADR", 
                "CurrentWeek_2017_RevPar","CurrentWeek_2016_RevPar","CurrentWeek_PercentChange_Occ","CurrentWeek_PercentChange_ADR","CurrentWeek_PercentChange_Revpar",
                "28days_2017_Occ","28days_2016_Occ","28days_2017_ADR","28days_2016_ADR","28days_2017_RevPar","28days_2016_RevPar",
                "28days_PercentChange_Occ","28days_PercentChange_ADR","28days_PercentChange_Revpar")
  # Creating row names
  row.names(df) = hotelnames
  return(df)
}

# Creating vector called "hotelnames"
hotelnames = c("Total United States","ChainScale_Luxury","ChainScale_Upper Upscale","ChainScale_Upscale","ChainScale_Upper Midscale",
               "ChainScale_Midscale","ChainScale_Economy","ChainScale_Independents","Class_Luxury","Class_Upper_Upscale","Class_Upscale","Class_Upper_Midscale",
               "Class_Midscale","Class_Economy","Location_Urban","Location_Suburban","Location_Airport","Location_Interstate","Location_Resort","Location_Small_Metro/Town","Anaheim",
               "Atlanta","Boston","Chicago","Dallas","Denver","Detroit","Houston","Los Angeles","Miami","Minneapolis",
               "Nashville","New Orleans","New York","Norfolk","Oahu","Orlando","Philadelphia","Phoenix","San Diego",
               "San Francisco","Seattle","St Louis","Tampa/St Petersburg","Washington DC")

Jan7_13 = get_pg3_from_file("0107_0113.pdf")
Jan14_20 = get_pg3_from_file("0114_0120.pdf")
Jan21_27 = get_pg3_from_file("0121_0127.pdf")
Jan28_Feb3 = get_pg3_from_file("0128_0203.pdf")
Feb4_10 = get_pg3_from_file("0204_0210.pdf")
Feb11_17 = get_pg3_from_file("0211_0217.pdf")
