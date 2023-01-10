String columnGroupJson  = """
{
  "columnGroups":[
{
     "name": "Vehicle",
     "columns":[
      {
      "id" : "test_id",
      "title": "Test #",
      "type": "dashboard",
      "hide": false,
      "unit": ""
      },
      {
      "id" : "name",
      "title": "Name",
      "type": "text",
      "hide": false,
      "unit": ""
      },
      {
      "id" : "model_year",
      "title": "MY",
      "type": "number",
      "hide": false,
      "unit": "" 
      },
      {
      "id" : "brand",
      "title": "Brand",
      "type": "text",
      "hide": false,
      "unit": "" 
      },
      {
      "id" : "fuel_type",
      "title": "Fuel",
      "type": "text",
      "hide": false,
      "unit": "" 
      },
      {
      "id" : "engine_type",
      "title": "Eng. Type",
      "type": "text",
      "hide": true,
      "unit": "" 
      },
      {
      "id" : "engine_name",
      "title": "Eng. Name",
      "type": "text",
      "hide": true,
      "unit": "" 
      },
      {
       "id" : "cylinder_volumn",
      "title": "Cyl Vol",
      "type": "number",
      "hide": true,
      "unit": "cc" 
      },
      {
      "id" : "transmission",
      "title": "Trans",
      "type": "number",
      "hide": true,
      "unit": "" 
      },
      {
      "id" : "vin",
      "title": "VIN",
      "type": "text",
      "hide": false,
      "unit": "" 
      },
      {
      "id" : "odo",
      "title": "ODO",
      "type": "number",
      "hide": false,
      "unit": "km" 
      },
      {
      "id" : "layout",
      "title": "Layout",
      "type": "String",
      "hide": true,
      "unit": "" 
      },
      {
      "id" : "tire",
      "title": "Tire",
      "type": "String",
      "hide": true,
      "unit": "" 
      },
      {
      "id" : "wheel_drive",
      "title": "WD",
      "type": "String",
      "hide": true,
      "unit": "" 
      },
      {
      "id" : "fgr",
      "title": "FGR",
      "type": "double",
      "hide": true,
      "unit": "" 
      },
      {
      "id" : "details_page",
      "title": "Details",
      "type": "nav_to_test",
      "hide": true,
      "unit": "" 
      }
     ]
},
{
     "name": "Passing Performance",
     "columns":[
      {
      "id" : "passing_3070kph",
      "title": "Low Spd (30-70kph)",
      "type": "double",
      "hide": false,
      "unit": "s" 
      },
      {
      "id" : "passing_4080kph",
      "title": "City Spd (40-80kph)",
      "type": "double",
      "hide": false,
      "unit": "s" 
      },
      {
      "id" : "passing_60100kph",
      "title": "Mid Spd (60-100kph)",
      "type": "double",
      "hide": false,
      "unit": "s" 
      },
      {
      "id" : "passing_100140kph",
      "title": "High Spd (100-140kph)",
      "type": "double",
      "hide": false,
      "unit": "s" 
      },
      {
      "id" : "nav_to_test_passing",
      "title": "...",
      "type": "nav_to_test",
      "hide": false,
      "unit": "" 
      }
    ]
},
{
     "name": "Starting Performance",
     "columns":[
      {
      "id" : "starting_60kph",
      "title": "0-60kph",
      "type": "double",
      "hide": false,
      "unit": "s" 
      },
      {
      "id" : "starting_100kph",
      "title": "0-100kph",
      "type": "double",
      "hide": false,
      "unit": "s" 
      },
      {
      "id" : "starting_140kph",
      "title": "0-140kph",
      "type": "double",
      "hide": false,
      "unit": "s" 
      },
      {
      "id" : "starting_100m",
      "title": "0-100m",
      "type": "double",
      "hide": false,
      "unit": "s" 
      },
      {
      "id" : "starting_400m",
      "title": "0-400m",
      "type": "double",
      "hide": false,
      "unit": "s" 
      },
      {
      "id" : "nav_to_test_starting",
      "title": "...",
      "type": "nav_to_test",
      "hide": false,
      "unit": "" 
      }
    ]
},
{
     "name": "Braking Performance",
     "columns":[
      {
      "id" : "braking_distance",
      "title": "Distance",
      "type": "double",
      "hide": false,
      "unit": "m" 
      },
      {
      "id" : "braking_maxDecel",
      "title": "Deceleration",
      "type": "double",
      "hide": false,
      "unit": "㎨" 
      },
      {
      "id" : "nav_to_test_braking",
      "title": "...",
      "type": "nav_to_test",
      "hide": false,
      "unit": ""  
      }
    ]
},
{
     "name": "Coastdown (J2263)",
     "columns":[
      {
      "id" : "j2263_a",
      "title": "A",
      "type": "double",
      "hide": false,
      "unit": "N"  
      },
      {
      "id" : "j2263_b",
      "title": "B",
      "type": "double",
      "hide": false,
      "unit": "N/kph" 
      },
      {
      "id" : "j2263_c",
      "title": "C",
      "type": "double",
      "hide": false,
      "unit": "N/kph2" 
      },
      {
      "id" : "nav_to_test_j2263",
      "title": "...",
      "type": "nav_to_test",
      "hide": false,
      "unit": "" 
      }
    ]
},
{
     "name": "Coastdown (WLTP)",
     "columns":[
      {
      "id" : "wltp_a",
      "title": "A",
      "type": "double",
      "hide": false,
      "unit": "N" 
      },
      {
      "id" : "wltp_b",
      "title": "B",
      "type": "double",
      "hide": false,
      "unit": "N/kph" 
      },
      {
      "id" : "wltp_c",
      "title": "C",
      "type": "double",
      "hide": false,
      "unit": "N/kph2" 
      },
      {
      "id" : "nav_to_test_wltp",
      "title": "...",
      "type": "nav_to_test",
      "hide": false,
      "unit": "" 
      }
    ]
},
{
     "name": "Idle NVH",
     "columns":[
      {
      "id" : "idle_noise",
      "title": "Noise",
      "type": "double",
      "hide": false,
      "unit": "dBA" 
      },
      {
      "id" : "idle_vibration",
      "title": "Vib",
      "type": "double",
      "hide": false,
      "unit": "dB" 
      },
      {
      "id" : "idle_vibration_source",
      "title": "Vib (Src)",
      "type": "double",
      "hide": false,
      "unit": "dB" 
      }
    ]
},
{
     "name": "Wide Open Throttle NVH",
     "columns":[
      {
      "id" : "wot_noise_slope",
      "title": "Noise Slope",
      "type": "double",
      "hide": false,
      "unit": "dBA/kph" 
      },
      {
      "id" : "wot_noise_intercept",
      "title": "Noise Intrcpt",
      "type": "double",
      "hide": false,
      "unit": "dBA" 
      },
      {
      "id" : "wot_engine_vibration_body",
      "title": "Eng Vib (Bdy)",
      "type": "double",
      "hide": false,
      "unit": "dB" 
      },
      { 
      "id" : "wot_engine_vibration_source",
      "title": "Eng Vib (Src)",
      "type": "double",
      "hide": false,
      "unit": "dB" 
      }
    ]
},
{
     "name": "Cruise NVH (Road Noise)",
     "columns":[
      {
      "id" : "road_noise",
      "title": "Road Noise",
      "type": "double",
      "hide": false,
      "unit": "dBA" 
      },
      {
      "id" : "road_booming",
      "title": "Road Boom",
      "type": "double",
      "hide": false,
      "unit": "dBC" 
      },
      {
      "id" : "tire_noise",
      "title": "Tire Noise",
      "type": "double",
      "hide": false,
      "unit": "dBA" 
      },
      {
      "id" : "rumble",
      "title": "Rumble",
      "type": "double",
      "hide": false,
      "unit": "dBA" 
      },
      {
      "id" : "wind_noise",
      "title": "Wind Noise",
      "type": "double",
      "hide": false,
      "unit": "dBA" 
      },
      {
      "id" : "cruise_65_vibration",
      "title": "Vib (65kph)",
      "type": "double",
      "hide": false,
      "unit": "dB" 
      },
      {
      "id" : "cruise_80_vibration",
      "title": "Vib (80kph)",
      "type": "double",
      "hide": false,
      "unit": "dB" 
      },
      {
      "id" : "cruise_100_vibration",
      "title": "Vib (100kph)",
      "type": "double",
      "hide": false,
      "unit": "dB" 
      },
      {
      "id" : "cruise_120_vibration",
      "title": "Vib (120kph)",
      "type": "double",
      "hide": false,
      "unit": "dB" 
      }
    ]
},
{
     "name": "Acceleration NVH",
     "columns":[
      {
      "id" : "acceleration_noise_slope",
      "title": "Noise Slope",
      "type": "double",
      "hide": false,
      "unit": "dBA/kph" 
      },
      {
      "id" : "acceleration_noise_intercept",
      "title": "Noise Intrcpt",
      "type": "double",
      "hide": false,
      "unit": "dBA" 
      },
      {
      "id" : "acceleration_tire_vibration",
      "title": "Tire Vib",
      "type": "double",
      "hide": false,
      "unit": "dB" 
      }
   ]
},
{
     "name": "MDPS NVH",
     "columns":[
      {
      "id" : "mdps_noise",
      "title": "Noise",
      "type": "double",
      "hide": false,
      "unit": "dBA" 
      }
   ]
}

]
}
""";

