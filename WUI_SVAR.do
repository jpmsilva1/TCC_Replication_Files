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


*Drop missing data*
drop if IPCA == .

************************************************************************************
*  lag-order selection statistics
************************************************************************************
varsoc Log_WUI_Global Log_WUI_BR Log_GDP_R IPCA Selic_Over  Log_Ex_rate 

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

matrix A = (1,0,0\.,1,0\.,.,1)
matrix B = (.,0,0\0,.,0\0,0,.)
 
 ************************************************************************************
* Main SVAR
************************************************************************************

svar Log_WUI_Global Log_WUI_BR Log_GDP_R IPCA Selic_Over Log_Ex_rate , lags(1) aeq(A) beq(B)

* Generate the IRF
irf create order1, set(irf_results1) replace step(12) 

* Display the IRF results
 irf graph sirf, impulse(Log_WUI_Global) response(Log_WUI_Global Log_WUI_BR Log_GDP_R IPCA Selic_Over Log_Ex_rate) xlabel(0(2)12) irf(order1) yline(0,lcolor(black)) byopts(yrescale) l(68)
 
* Oirf if needed*
 irf graph oirf, irf(order1) impulse(Log_WUI_Global) response( Log_GDP_R )
 
 *FEVED if needed*
 irf table fevd, irf(order1) impulse(Log_WUI_Global)
 

************************************************************************************
* Alternative ordering I
************************************************************************************
svar Log_WUI_Global Log_GDP_R IPCA Selic_Over Log_Ex_rate Log_WUI_BR, lags(1) aeq(A) beq(B)

* Generate the IRF
irf create order2, set(irf_results2) replace step(12)

* Display the IRF results
 irf graph sirf, impulse(Log_WUI_Global) response(Log_WUI_Global Log_GDP_R IPCA Selic_Over Log_Ex_rate Log_WUI_BR) xlabel(0(2)12) irf(order2) yline(0,lcolor(black)) byopts(yrescale) l(68)

 
************************************************************************************
* Alternative Model Without Selic_Over
************************************************************************************
varsoc Log_WUI_Global Log_WUI_BR Log_GDP_R IPCA Log_Ex_rate


svar Log_WUI_Global Log_WUI_BR Log_GDP_R IPCA Log_Ex_rate , lags(1) aeq(A) beq(B)

* Generate the IRF
irf create order3, set(irf_results3) replace step(12)

* Display the IRF results
 irf graph sirf, impulse(Log_WUI_Global) response(Log_WUI_Global Log_GDP_R IPCA  Log_Ex_rate Log_WUI_BR) xlabel(0(2)12) irf(order3) yline(0,lcolor(black)) byopts(yrescale) l(68)
 
 
************************************************************************************
* Alternative Model Without WUI_Global
************************************************************************************
varsoc Log_WUI_BR Log_GDP_R IPCA Log_Ex_rate Selic_Over


svar Log_WUI_BR Log_GDP_R IPCA Log_Ex_rate Selic_Over , lags(1 2 3) aeq(A) beq(B)

* Generate the IRF
irf create order4, set(irf_results4) replace step(12)

* Display the IRF results
 irf graph sirf, impulse(Log_WUI_BR) response( Log_WUI_BR Log_GDP_R IPCA Log_Ex_rate Selic_Over) xlabel(0(2)12) irf(order4) yline(0,lcolor(black)) byopts(yrescale) l(68)
 
