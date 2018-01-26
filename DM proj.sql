--Data Set Tables
DROP TABLE Country_T CASCADE CONSTRAINTS;
DROP TABLE ClimateChange_T CASCADE CONSTRAINTS;
DROP TABLE EconDevelopment_T CASCADE CONSTRAINTS;

CREATE TABLE Country_T 
        	(CountryID  	VARCHAR2(3)    	NOT NULL, 
         	CountryName	VARCHAR2(30), 
         	Continent  	VARCHAR2(30), 
         	NSGlobal   	VARCHAR2(25),     	
CONSTRAINT CountryID_PK PRIMARY KEY (CountryID));

CREATE TABLE ClimateChange_T 
         	(CountryID   	VARCHAR2(3)  	NOT NULL, 
          	AutoID      	NUMBER(7)    	NOT NULL, 
       	DateAdded   	NUMBER, 
       	LandTemp    	NUMBER, 
          	SeaTemp     	NUMBER,        	
          	SeaLevel    	NUMBER,           	
          	Precipitation   NUMBER, 
          	Glacier     	NUMBER, 
          	FirstLeafDate   NUMBER, 
          	FirstBloomDate  NUMBER, 
CONSTRAINT ClimateChange_T_PK PRIMARY KEY (CountryID, AutoID),	
CONSTRAINT ClimateChange_T_FK FOREIGN KEY (CountryID) REFERENCES Country_T (CountryID));

CREATE TABLE EconDevelopment_T 
         	(CountryID   	VARCHAR2(3)  	NOT NULL, 
          	AutoID      	NUMBER(7)    	NOT NULL, 
       	DateAdded   	NUMBER, 
       	GDPUSD      	NUMBER,            	
          	Population  	NUMBER,  
          	CO2exclLUCF 	NUMBER,
          	CO2inclLUCF 	NUMBER,
          	GHGexclLUCF 	NUMBER,       	
          	GHGinclLUCF 	NUMBER,       	
CONSTRAINT EconDevelopment_T_PK PRIMARY KEY (CountryID, AutoID), 
CONSTRAINT EconDevelopment_T_FK FOREIGN KEY (CountryID) REFERENCES Country_T (CountryID));

--Climate Change
--Global Land and Sea Temperature
Select CountryName As Global, DateAdded As Year, LandTemp, SeaTemp  
From Country_T CT inner join ClimateChange_T CCT on CT.CountryID = CCT.CountryID 
Where CT.CountryID = 'GLB'  ;

--Global Land Temperature Map Series
--Creating the world map had some errors; so instead of using the query directly, the output of the query is transfered into XML codes via excel VBA and customized XML codes to make the world map series for global land temperature.

Select DateAdded, CountryName, LandTemp
From Country_T CT inner join ClimateChange_T CCT on CT.CountryID = CCT.CountryID 
Where CountryName Not in  
(select CountryName 
From Country_T CT inner join ClimateChange_T CCT on CT.CountryID = CCT.CountryID  
Where CountryName = 'Global')
And DateAdded = 1900 
Order by CountryName; 

--excel VBA code
--Column A: DateAdded; Column B: CountryName; Column C: LandTemp; Column E: XML codes
Sub mapQuery()
nRows = Range(Range("A2"), Range("A2").End(xlDown)).Rows.Count

For i = 1 To nRows
Range("E1").Offset(i, 0).Value = "<point name= " & Chr(34) & Range("B1").Offset(i, 0).Value & Chr(34) & " y= " & Chr(34) & Range("C1").Offset(i, 0).Value & Chr(34) & " />"
Next i
End Sub

--XML code
<?xml version = "1.0" encoding="utf-8" standalone = "yes"?>
<anychart>
<settings>
	<animation enabled="false"/>
	<no_data show_waiting_animation="False">
    	<label><text>#NO_DATA_MESSAGE#</text><font family="Helvetica" bold="yes" size="10"/></label>
	</no_data>
</settings>
<margin left="0" top="0" right="0" bottom="0" />
<charts>
	<chart plot_type="Map" name="chart_31941562625949180670"> 	
	<chart_settings>
    	<title text_align="Center" position="Top" >
        	<text>Global Land Temperature in Celcius in 1900</text>
        	<font family="Helvetica" size="18" color="0x000000" />
    	</title>
    	
    	<data_plot_background>
        	<fill type="Solid" color="0xffffff" opacity="0" />
        	<border enabled="false"/>
        	<corners type="Square"/>
    	</data_plot_background>
    	<controls>
        	<legend enabled="True" position="Right" align="Far" ignore_auto_item="True" rows_padding="2" inside_dataplot="False">
            	<title enabled="true">
                	<text>Land Temperature (ºC)</text>
            	</title>
            	<columns_separator enabled="false" />
            	<items>
              	<item source="Thresholds">
                	<text><![CDATA[{%Icon} {%RangeMin}{numDecimals:0,decimalSeparator:.,thousandsSeparator:\,} - {%RangeMax}{numDecimals:0,decimalSeparator:.,thousandsSeparator:\,}]]></text>
              	</item>
            	</items>
        	</legend>
        	<navigation_panel enabled="True"/>
        	<zoom_panel enabled="True"/>
    	</controls>
	</chart_settings>
	
	<data_plot_settings enable_3d_mode="false">
	<map_series source="world/world.amap" id_column="REGION_NAME" labels_display_mode="">
	<projection type="Equirectangular"  />
    	<grid enabled="true">
        	<parallels enabled="true"/>
        	<meridians enabled="false"/>
        	<background>
            	<fill type="Solid" color="0xFFFFFF" />
            	<border enabled="false"/>
            	<corners type="Square"/>
        	</background>
    	</grid>
    	<undefined_map_region>
        	<tooltip_settings enabled="true">
            	<format><![CDATA[Country: {%Name}{enabled:False}
LandTemp: undefined]]>
            	</format>
            	<font family="Helvetica" size="12" color="0x000000" />
            	<position anchor="Float" valign="Top" padding="10" />
        	</tooltip_settings>
        	<map_region_style>
            	<fill enabled="True" opacity="0.01"/>
            	<states>
                	<hover>
                	<fill enabled="True" color="Yellow" opacity="0.4"/>
                	</hover>
                	<selected_normal>
                	<fill enabled="True" color="Yellow" opacity="0.0"/>
                	<hatch_fill enabled="False"/>
                	</selected_normal>
                	<selected_hover>
                	<fill enabled="True" color="Yellow" opacity="1.0"/>
                	<hatch_fill enabled="False"/>
                	</selected_hover>
            	</states>
        	</map_region_style>
    	</undefined_map_region>
    	<defined_map_region >
        	<tooltip_settings enabled="true">
            	<format><![CDATA[Country: {%Name}{enabled:False}
        	LandTemp: {%Value}{numDecimals:0,decimalSeparator:.,thousandsSeparator:\,}ºC]]>
            	</format>
            	<font family="Helvetica" size="12" color="0x000000" />
            	<position anchor="Float" valign="Top" padding="10" />
        	</tooltip_settings>
        	<label_settings enabled="false"/>
    	</defined_map_region>
	</map_series>
	</data_plot_settings>
	<palettes>
    	<palette name="custom" type="ColorRange" color_count="20">
        	<gradient>
            	<key color="#64B5F6" />
            	<key color="#EC6E07" />
        	</gradient>
    	</palette>
	</palettes>
	<thresholds>
    	<threshold name= "tr" type="AbsoluteDeviation" range_count="20" palette="custom" />
	</thresholds>
  	
	<data>
    	<series name = "1900" threshold = "tr" >
        	<point name= "Bahamas, The" y= "25.06" />
        	<point name= "Gambia, The" y= "27.46" />
        	<point name= "Man, Isle of" y= "9.42" />
        	<point name= "Tanzania, United Republic of" y= "22.4" />
        	<point name= "Afghanistan" y= "13.75" />
        	<point name= "Albania" y= "13.07" />
        	<point name= "Algeria" y= "13.07" />
        	<point name= "American Samoa" y= "26.27" />
        	<point name= "Andorra" y= "11.35" />
        	<point name= "Angola" y= "21.79" />
        	<point name= "Antigua and Barbuda" y= "26.23" />
        	<point name= "Argentina" y= "14.81" />
        	<point name= "Armenia" y= "8.24" />
        	<point name= "Aruba" y= "28.03" />
        	<point name= "Australia" y= "21.77" />
        	<point name= "Austria" y= "6.67" />
        	<point name= "Azerbaijan" y= "10.58" />
        	<point name= "Bahrain" y= "25.9" />
        	<point name= "Bangladesh" y= "25.22" />
        	<point name= "Barbados" y= "26.28" />
        	<point name= "Belarus" y= "5.82" />
        	<point name= "Belgium" y= "9.79" />
        	<point name= "Belize" y= "24.55" />
        	<point name= "Benin" y= "27.03" />
        	<point name= "Bhutan" y= "12.02" />
        	<point name= "Bolivia" y= "21.11" />
        	<point name= "Botswana" y= "22.02" />
        	<point name= "Brazil" y= "24.9" />
        	<point name= "Bulgaria" y= "10.96" />
        	<point name= "Burkina Faso" y= "27.98" />
        	<point name= "Burundi" y= "20.08" />
        	<point name= "Cambodia" y= "26.63" />
        	<point name= "Cameroon" y= "24.12" />
        	<point name= "Canada" y= "-5.02" />
        	<point name= "Cayman ISlands" y= "26.59" />
        	<point name= "Central African Republic" y= "25.05" />
        	<point name= "Chad" y= "26.85" />
        	<point name= "Chile" y= "9.3" />
        	<point name= "China" y= "6.44" />
        	<point name= "Colombia" y= "24.87" />
        	<point name= "Comoros" y= "25.85" />
        	<point name= "Congo" y= "24.29" />
        	<point name= "Costa Rica" y= "25.42" />
        	<point name= "Croatia" y= "11.83" />
        	<point name= "Cuba" y= "25.34" />
        	<point name= "Curacao" y= "27.46" />
        	<point name= "Cyprus" y= "19.02" />
        	<point name= "Czech Republic" y= "7.97" />
        	<point name= "Denmark" y= "7.74" />
        	<point name= "Djibouti" y= "28.54" />
        	<point name= "Dominica" y= "25.9" />
        	<point name= "Dominican Republic" y= "25.76" />
        	<point name= "East Timor" y= "26.28" />
        	<point name= "Ecuador" y= "21.91" />
        	<point name= "Egypt" y= "22.8" />
        	<point name= "El Salvador" y= "24.66" />
        	<point name= "Equatorial Guinea" y= "24.71" />
        	<point name= "Eritrea" y= "26.43" />
        	<point name= "Estonia" y= "4.24" />
        	<point name= "Ethiopia" y= "22.79" />
        	<point name= "Faroe Islands" y= "6.43" />
        	<point name= "Fiji" y= "24.42" />
        	<point name= "Finland" y= "0" />
        	<point name= "France" y= "10.67" />
        	<point name= "French Polynesia" y= "1.49" />
        	<point name= "Gabon" y= "24.06" />
        	<point name= "Georgia" y= "7.87" />
        	<point name= "Germany" y= "8.45" />
        	<point name= "Ghana" y= "26.63" />
        	<point name= "Greece" y= "15.11" />
        	<point name= "Greenland" y= "-18.29" />
        	<point name= "Grenada" y= "26.62" />
        	<point name= "Guam" y= "26.4" />
        	<point name= "Guatemala" y= "22.86" />
        	<point name= "Guinea" y= "25.38" />
        	<point name= "Guinea-Bissau" y= "26.69" />
        	<point name= "Guyana" y= "25.93" />
        	<point name= "Haiti" y= "26.52" />
        	<point name= "Honduras" y= "24.38" />
        	<point name= "Hong kong" y= "22.29" />
        	<point name= "Hungary" y= "10.31" />
        	<point name= "Iceland" y= "1.36" />
        	<point name= "India" y= "24.37" />
        	<point name= "Indonesia" y= "25.73" />
        	<point name= "Iran" y= "17.12" />
        	<point name= "Iraq" y= "21.71" />
        	<point name= "Ireland" y= "9.33" />
        	<point name= "Israel" y= "19.86" />
        	<point name= "Italy" y= "13" />
        	<point name= "Jamaica" y= "26.2" />
        	<point name= "Japan" y= "11.47" />
        	<point name= "Jordan" y= "19.56" />
        	<point name= "Kazakhstan" y= "4.48" />
        	<point name= "Kenya" y= "24.13" />
        	<point name= "Kiribati" y= "26.56" />
        	<point name= "Kuwait" y= "25.1" />
        	<point name= "Kyrgyzstan" y= "2.76" />
        	<point name= "Latvia" y= "5" />
        	<point name= "Lebanon" y= "17.88" />
        	<point name= "Lesotho" y= "13.84" />
        	<point name= "Liberia" y= "25.33" />
        	<point name= "Libya" y= "22.17" />
        	<point name= "Liechtenstein" y= "5" />
        	<point name= "Lithuania" y= "5.85" />
        	<point name= "Luxembourg" y= "9.49" />
        	<point name= "Macau" y= "22.04" />
        	<point name= "Macedonia" y= "10.88" />
        	<point name= "Madagascar" y= "22.92" />
        	<point name= "Malawi" y= "21.61" />
        	<point name= "Malaysia" y= "25.79" />
        	<point name= "Mali" y= "28.26" />
        	<point name= "Malta" y= "18.49" />
        	<point name= "Mauritania" y= "27.44" />
        	<point name= "Mauritius" y= "23.46" />
        	<point name= "Mexico" y= "20.52" />
        	<point name= "Moldova" y= "8.91" />
        	<point name= "Monaco" y= "9.27" />
        	<point name= "Mongolia" y= "-1.17" />
        	<point name= "Montenegro" y= "10.71" />
        	<point name= "Morocco" y= "17.57" />
        	<point name= "Mozambique" y= "23.76" />
        	<point name= "Namibia" y= "20.61" />
        	<point name= "Nepal" y= "15.03" />
        	<point name= "Netherlands" y= "9.49" />
        	<point name= "New Caledonia" y= "22.13" />
        	<point name= "New Zealand" y= "9.97" />
        	<point name= "Nicaragua" y= "25.72" />
        	<point name= "Niger" y= "27.22" />
        	<point name= "Nigeria" y= "26.54" />
        	<point name= "North Korea" y= "6.74" />
        	<point name= "Norway" y= "-0.93" />
        	<point name= "Oman" y= "26.75" />
        	<point name= "Pakistan" y= "20.75" />
        	<point name= "Palau" y= "27.31" />
        	<point name= "Panama" y= "26.24" />
        	<point name= "Papua New Guinea" y= "24.54" />
        	<point name= "Paraguay" y= "23.74" />
        	<point name= "Peru" y= "20.01" />
        	<point name= "Philippines" y= "26.25" />
        	<point name= "Poland" y= "7.74" />
        	<point name= "Portugal" y= "14.71" />
        	<point name= "Puerto Rico" y= "25.37" />
        	<point name= "Qatar" y= "26.74" />
        	<point name= "Romania" y= "9.38" />
        	<point name= "Russia" y= "-5.87" />
        	<point name= "Rwanda" y= "19.24" />
        	<point name= "San marino" y= "14.16" />
        	<point name= "Sao Tome and Principe" y= "25.63" />
        	<point name= "Saudi Arabia" y= "25.49" />
        	<point name= "Senegal" y= "27.86" />
        	<point name= "Serbia" y= "10.51" />
        	<point name= "Seychelles" y= "26.6" />
        	<point name= "Sierra Leone" y= "25.96" />
        	<point name= "Singapore" y= "26.53" />
        	<point name= "Sint maarten" y= "26.41" />
        	<point name= "Slovenia" y= "10.14" />
        	<point name= "Solomon Islands" y= "26.21" />
        	<point name= "Somalia" y= "26.71" />
        	<point name= "South Korea" y= "11.59" />
        	<point name= "Spain" y= "13.63" />
        	<point name= "Sri Lanka" y= "27.24" />
        	<point name= "St. Kitts and Nevis" y= "25.65" />
        	<point name= "St. Lucia" y= "26.48" />
        	<point name= "St. Martin" y= "26.41" />
        	<point name= "St. Vincent and the Grenadines" y= "26.64" />
        	<point name= "Sudan" y= "26.89" />
        	<point name= "Suriname" y= "26.14" />
        	<point name= "Swaziland" y= "18.86" />
        	<point name= "Sweden" y= "1.34" />
        	<point name= "Switzerland" y= "7.31" />
        	<point name= "Syria" y= "18.09" />
        	<point name= "Tajikistan" y= "3.55" />
        	<point name= "Thailand" y= "26.1" />
        	<point name= "Togo" y= "26.76" />
        	<point name= "Tonga" y= "22.86" />
        	<point name= "Trinidad and Tobago" y= "26.05" />
        	<point name= "Tunisia" y= "19.84" />
        	<point name= "Turkey" y= "11.91" />
        	<point name= "Turkmenistan" y= "13.92" />
        	<point name= "Turks and Caicos Islands" y= "26.79" />
        	<point name= "Uganda" y= "22.97" />
        	<point name= "Ukraine" y= "7.82" />
        	<point name= "United Arab Emirates" y= "27.59" />
        	<point name= "United Kingdom" y= "8.55" />
        	<point name= "United States" y= "9.02" />
        	<point name= "Uruguay" y= "17.78" />
        	<point name= "Uzbekistan" y= "11.42" />
        	<point name= "Venezuela" y= "25.12" />
        	<point name= "Vietnam" y= "23.52" />
        	<point name= "Virgin Islands" y= "26.11" />
        	<point name= "Western Samoa" y= "25.97" />
        	<point name= "Yemen" y= "25.99" />
        	<point name= "Zambia" y= "21.37" />
        	<point name= "Zimbabwe" y= "21.28" />
    	</series>
	</data>
</chart>
</charts>
</anychart>
--Global Leaf Bloom Date
Select CountryName As Global, DateAdded As Year, FirstLeafDate, FirstBloomDate  
From Country_T CT inner join ClimateChange_T CCT on CT.CountryID = CCT.CountryID
Where CT.CountryID = 'GLB';

--GLB Sea Level
Select CountryName As Global, DateAdded As Year, SeaLevel 
From Country_T CT inner join ClimateChange_T CCT on CT.CountryID = CCT.CountryID	
Where CT.CountryID = 'GLB'; 

--GLB Precipitation
Select CountryName As Global, DateAdded As Year, Precipitation 
From Country_T CT inner join ClimateChange_T CCT on CT.CountryID = CCT.CountryID
Where CT.CountryID = 'GLB';

--GLB Glacier
Select CountryName As Global, DateAdded As Year, Glacier 
From Country_T CT inner join ClimateChange_T CCT on CT.CountryID = CCT.CountryID
Where CT.CountryID = 'GLB'
and DateAdded >= 1945
order by DateAdded ASC;

--Econ Development 
--GDP
select null link, DATEADDED label1, AVG(GDPUSD) As AVERAGEGDP 
from  "MS3200HW"."ECONDEVELOPMENT_T"
where DATEADDED >= 1960
group by DATEADDED
order by DATEADDED ASC;  

--Population
select null link, DATEADDED label1, AVG(Population) As Population
from  "MS3200HW"."ECONDEVELOPMENT_T"
where DATEADDED >= 1960
group by DATEADDED
order by DATEADDED ASC;

--CO2
select null link, DATEADDED label1, AVG(CO2INCLLUCF) As C02inclLUCF, AVG(CO2EXCLLUCF) As CO2exclLUCF 
from  "MS3200HW"."ECONDEVELOPMENT_T"
where DATEADDED >= 1960
group by DATEADDED
order by DATEADDED ASC;

--GHG
select null link, DATEADDED label1, AVG(GHGINCLLUCF) As GHGINCLLUCF, AVG(GHGEXCLLUCF) As GHGEXCLLUCF
from  "MS3200HW"."ECONDEVELOPMENT_T"
where DATEADDED >= 1960
group by DATEADDED
order by DATEADDED ASC;
