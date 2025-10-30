************************************************************************************
* Tsset and Date Formating
************************************************************************************
gen double date = quarterly(Year, "YQ")
format date %tq
tsset date

************************************************************************************
* Log Transformation
************************************************************************************
gen Log_GDP_R= log(GDP_R)
gen Log_WUI_Global= log(WUI_Global)
gen Log_WUI_BR= log(WUI_BR)
gen Log_FBCF= log(FBCF)
gen Log_Hours= log(Hours)
gen Log_Ex_rate= log(Ex_Rate)
gen Log_EPU_BR= log(EPU_BR)
gen Log_EPU_Global= log(EPU_Global)
gen Log_IIE_Br= log(IIEBr)
gen Log_IBCBr= log(IBC_BR)
*Drop missing data*
drop if IPCA == .
************************************************************************************
* Short-run restrictions
************************************************************************************
*For 8 Variables*
 matrix A = (1,0,0,0,0,0,0,0\.,1,0,0,0,0,0,0\.,.,1,0,0,0,0,0\.,.,.,1,0,0,0,0\.,.,.,.,1,0,0,0\.,.,.,.,.,1,0,0\.,.,.,.,.,.,1,0\.,.,.,.,.,.,.,1)
 matrix B = (.,0,0,0,0,0,0,0\0,.,0,0,0,0,0,0\0,0,.,0,0,0,0,0\0,0,0,.,0,0,0,0\0,0,0,0,.,0,0,0\0,0,0,0,0,.,0,0\0,0,0,0,0,0,.,0\0,0,0,0,0,0,0,1)

 *For 7 Variables*
 matrix A = (1,0,0,0,0,0,0\.,1,0,0,0,0,0\.,.,1,0,0,0,0\.,.,.,1,0,0,0\.,.,.,.,1,0,0\.,.,.,.,.,1,0\.,.,.,.,.,.,1)
 matrix B = (.,0,0,0,0,0,0\0,.,0,0,0,0,0\0,0,.,0,0,0,0\0,0,0,.,0,0,0\0,0,0,0,.,0,0\0,0,0,0,0,.,0\0,0,0,0,0,0,.)
 
*For 6 Variables*
 matrix A = (1,0,0,0,0,0\.,1,0,0,0,0\.,.,1,0,0,0\.,.,.,1,0,0\.,.,.,.,1,0\.,.,.,.,.,1)
 matrix B = (.,0,0,0,0,0\0,.,0,0,0,0\0,0,.,0,0,0\0,0,0,.,0,0\0,0,0,0,.,0\0,0,0,0,0,.)
 
*For 5 Variables*
matrix A = (1,0,0,0,0\.,1,0,0,0\.,.,1,0,0\.,.,.,1,0\.,.,.,.,1)
matrix B = (.,0,0,0,0\0,.,0,0,0\0,0,.,0,0\0,0,0,.,0\0,0,0,0,.)
 
 ************************************************************************************
* Main Model Roubustness with EPU 
************************************************************************************
varsoc Log_EPU_Global Log_EPU_BR Log_GDP_R IPCA Selic_Over Log_Ex_rate

svar Log_EPU_Global Log_EPU_BR Log_GDP_R IPCA Selic_Over Log_Ex_rate, lag(1) aeq(A) beq(B)

* Generate the IRF
irf create order1, set(irf_results1) replace step(12) 

* Display the IRF results
 irf graph sirf, impulse(Log_EPU_Global) response(Log_EPU_Global Log_EPU_BR Log_GDP_R IPCA Selic_Over Log_Ex_rate) xlabel(0(2)12) irf(order1) yline(0,lcolor(black)) byopts(yrescale) l(68)



************************************************************************************
* Alternative Model Roubustness with IIE-Br
************************************************************************************
varsoc Log_WUI_Global Log_IIE_Br Log_GDP_R IPCA Selic_Over Log_Ex_rate

svar  Log_WUI_Global Log_IIE_Br Log_GDP_R IPCA Selic_Over Log_Ex_rate, lag(1 2) aeq(A) beq(B)

* Generate the IRF
irf create order1, set(irf_results1) replace step(12) 

* Display the IRF results
 irf graph sirf, impulse(Log_WUI_Global) response( Log_WUI_Global Log_IIE_Br Log_GDP_R IPCA Selic_Over Log_Ex_rate ) xlabel(0(2)12) irf(order1) yline(0,lcolor(black)) byopts(yrescale) l(68)
 
 
************************************************************************************
* Alternative Model Roubustness with IBC_BR
************************************************************************************
varsoc Log_WUI_Global Log_WUI_BR Log_IBCBr  IPCA Selic_Over Log_Ex_rate

svar  Log_WUI_Global Log_WUI_BR Log_IBCBr  IPCA Selic_Over Log_Ex_rate, lag(1 2) aeq(A) beq(B)

* Generate the IRF
irf create order1, set(irf_results1) replace step(12) 

* Display the IRF results
 irf graph sirf, impulse(Log_WUI_Global) response( Log_WUI_Global Log_WUI_BR Log_IBCBr  IPCA Selic_Over Log_Ex_rate ) xlabel(0(2)12) irf(order1) yline(0,lcolor(black)) byopts(yrescale) l(68)




