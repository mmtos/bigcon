###### null 값 비율 ######
### CHUNG_Y(청약보유여부), RETIRE_NEED(은퇴후 필요자금), TOT_YEA(정기예금 잔액), 
### TOT_JEOK(정기적금 잔액), TOT_CHUNG(청약 잔액), TOT_FUND(펀드 잔액), TOT_ELS_ETE(ELS/DLS/ETF 잔액)

sum(is.na(data$CHUNG_Y))/nrow(data)*100      #55.9%(청약 여부)
sum(is.na(data$RETIRE_NEED))/nrow(data)*100  #68.7%(은퇴후 자금)
sum(is.na(data$TOT_YEA))/nrow(data)*100      #60.4%(예금)
sum(is.na(data$TOT_JEOK))/nrow(data)*100     #52.0%(적금)
sum(is.na(data$TOT_CHUNG))/nrow(data)*100    #55.9%(청약)
sum(is.na(data$TOT_FUND))/nrow(data)*100     #83.4%(펀드)
sum(is.na(data$TOT_ELS_ETE))/nrow(data)*100  #96.5%(ELS/DLS/ETF)
