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
gen Log_selic= log(Selic_Over)
gen Log_IPCA= log(IPCA)
gen Log_Ex_rate= log(Ex_Rate)


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
* Main SVAR
************************************************************************************

svar  Log_WUI_Global Log_WUI_BR Log_GDP_R Log_FBCF Log_Hours , aeq(A) beq(B)

* Generate the IRF
irf create order1, set(irf_results1) replace step(12) 

* Display the IRF results
 irf graph sirf, impulse(Log_WUI_Global) response(Log_GDP_R Log_WUI_Global Log_WUI_BR Log_FBCF Log_Hours  ) xlabel(0(2)12) irf(order1) yline(0,lcolor(black)) byopts(yrescale) l(68)

* Save the IRF results
graph save irf_results1, replace


************************************************************************************
* Alternative ordering I
************************************************************************************
svar  Log_WUI_Global Log_GDP_R Log_FBCF Log_Hours Log_WUI_BR, aeq(A) beq(B)

* Generate the IRF
irf create order2, set(irf_results3) replace step(12)

* Display the IRF results
 irf graph sirf, impulse(Log_WUI_Global) response(Log_WUI_Global Log_WUI_BR Log_GDP_R Log_FBCF Log_Hours) xlabel(0(2)12) irf(order2) yline(0,lcolor(black)) byopts(yrescale)

* Save the IRF results
irf save irf_results3, replace




