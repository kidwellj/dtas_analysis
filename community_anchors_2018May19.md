Analysing the Development Trust Association Scotland footprint
========================================================
author: Jeremy H. Kidwell, PhD
date: 18 May 2018
autosize: true

Provisional analysis compiled by Dr Jeremy Kidwell for DTAS. 
Based on live, open, and reproducible code!


Outline for the day
========================================================



- Representation in areas of deprivation
- Mapping community anchors
- Bonus: social media and DTAS


About the research
========================================================

- Begun in 2014 at Ediburgh Uni, now Birmingham
- Driving question: How do we improve visibility and efficacy of community-level work?
  - Generating (open access) data sets
  - Consultancy as participatory research
  - Connecting researchers, policymakers, third sector

Work to Date
========================================================

- Ongoing research partnerships
  - Scottish Community Alliance
  - DTAS (239 sites)
  - Eco-Congregation Scotland (~400) and Eco-Church England & Wales (~2500)
  - Christians Against Poverty (600)
  - Ecolise (European network of networks)
- Additional data sets produced for
  - GWSF, City Farms & Gardens, Community Land Scotland, Church(es) of Scotland, England & Wales...
- Digital "geospatial intelligence" Carto platform up and running
)


1. Focus: DTAS and Deprivation
========================================================

![plot of chunk unnamed-chunk-3](community_anchors-figure/unnamed-chunk-3-1.png)

DTAS Groups Located within 15% most deprived areas
========================================================


```
<!-- html table generated in R 3.4.4 by xtable 1.8-2 package -->
<!-- Fri May 18 08:57:09 2018 -->
<table border=1>
<tr> <th> name </th> <th> rank </th>  </tr>
  <tr> <td> Ferguslie Park Housing Association </td> <td align="right"> 1.00 </td> </tr>
  <tr> <td> Cassiltoun Housing Association </td> <td align="right"> 24.00 </td> </tr>
  <tr> <td> Cranhill Development Trust </td> <td align="right"> 65.00 </td> </tr>
  <tr> <td> Connect Community Trust </td> <td align="right"> 74.00 </td> </tr>
  <tr> <td> Rosemount Development Trust </td> <td align="right"> 128.00 </td> </tr>
  <tr> <td> Barmulloch Community Development Company </td> <td align="right"> 188.00 </td> </tr>
  <tr> <td> Community Central Hall </td> <td align="right"> 331.00 </td> </tr>
  <tr> <td> Thenue Housing Association Ltd </td> <td align="right"> 331.00 </td> </tr>
  <tr> <td> Dumbarton Road Corridor Environment Trust </td> <td align="right"> 338.00 </td> </tr>
  <tr> <td> Lambhill Stables </td> <td align="right"> 353.00 </td> </tr>
  <tr> <td> The Stove Network </td> <td align="right"> 361.00 </td> </tr>
  <tr> <td> Kirkhill &amp; Bunchrew Community Trust </td> <td align="right"> 362.00 </td> </tr>
  <tr> <td> Burntisland Community Development Trust </td> <td align="right"> 386.00 </td> </tr>
  <tr> <td> Catrine Community Trust </td> <td align="right"> 392.00 </td> </tr>
  <tr> <td> Renton Community Development Trust </td> <td align="right"> 593.00 </td> </tr>
  <tr> <td> Fauldhouse Community Development Trust Ltd </td> <td align="right"> 622.00 </td> </tr>
  <tr> <td> Galston Community Development Trust </td> <td align="right"> 624.00 </td> </tr>
  <tr> <td> Fuse Youth Cafe </td> <td align="right"> 662.00 </td> </tr>
  <tr> <td> CLEAR Buckhaven </td> <td align="right"> 669.00 </td> </tr>
  <tr> <td> Govanhill Community Development Trust </td> <td align="right"> 677.00 </td> </tr>
  <tr> <td> One Dalkeith </td> <td align="right"> 778.00 </td> </tr>
  <tr> <td> Burnfoot Community Futures </td> <td align="right"> 843.00 </td> </tr>
  <tr> <td> Healthy n Happy Community Development Trust </td> <td align="right"> 844.00 </td> </tr>
  <tr> <td> South Kintyre Development Trust </td> <td align="right"> 858.00 </td> </tr>
  <tr> <td> Love Milton </td> <td align="right"> 1027.00 </td> </tr>
   \end{longtable}
</table>
```

Running Comparisons
========================================================

It may be useful to know the number of groups present (as above), but we can illuminate this information by testing out how frequently different types of groups appear in these areas.



Pubs
========================================================

We can compare this frequency against some other features. The ordnance survey tells us that total pubs in Scotland are: 


```
[1] 3360
```

Pubs
========================================================

The total numnber of Pubs located within these deprived areas noted above is:


```
[1] 0.1505952
```

Churches
========================================================

To take another example, there are (according to the Ordnance Survey), the following number of places of worship in Scotland:


```
[1] 4468
```

Of all these, our deprived areas have: 


```
[1] 0.123769
```


Retail
========================================================

Another example we can look at is retail grocery stores. A geospatial company called GeoLytix publishes a complete set of British retailers on a regular basis. As of last November, they indicated that there were the following number of grocery stores in Scotland:


```
[1] 1408
```


Within our deprived areas, this represents 


```
[1] 0.1477273
```

Retail, ctd.
========================================================

We can break this down by brand to get a more interesting indication. There are the following number of Morrison's brand stores in Scotland:


```
[1] 60
```

Of these, the following percentage are located in deprived areas:


```
[1] 0.25
```

Retail, ctd.
========================================================

We find the predictable contrast by turning to Sainsburys. There are the following number of Sainsburys stores in Scotland:


```
[1] 101
```

Represented in our deprived areas are just:


```
[1] 0.06930693
```

Retail, ctd.
========================================================

Sadly, the best bellweather of a deprived area in Scotland isn't any of the above, but rather pawnbrokers and check cashing stores. There are the following number of pawnbrokers:


```
[1] 134
```

...and check cashing stores:


```
[1] 17
```


Retail, ctd.
========================================================

Representation in our areas of of deprivation is, for check cashing establishments:


```
[1] 0.2352941
```

and pawnbrokers:


```
[1] 0.3283582
```


Pawnbrokers Mapped
========================================================

![plot of chunk unnamed-chunk-20](community_anchors-figure/unnamed-chunk-20-1.png)


Targetting possile community anchors
========================================================

I've put together two different resources for DTAS to access this data:

- [On our Carto platform: a "slippy map""](https://carto.mapping.community/user/mapcomm-admin/builder/98dbb620-75d3-11e7-8dd5-005056372088/embed)
- A table of groups (forthcoming report!)


Discussion
========================================================

- What other kinds of data and analysis can you see being of value to you for strategic decision making?
- Possible demos:
  - Common Ground Map
  - Carto Platform
  - QGIS


Bonus: Social Media Use
========================================================

- Research question: how do community groups use social media?
