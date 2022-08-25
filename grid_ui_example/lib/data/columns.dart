String columnGroupJson  = """
{
  "columnGroups":[
{
     "name": "Vehicle",
     "columns":[
      {
      "id" : "test id",
      "title": "Test #",
      "type": "dashboard",
      "hide": false 
      },
      {
      "id" : "name",
      "title": "Name",
      "type": "text",
      "hide": false 
      },
      {
      "id" : "model year",
      "title": "MY",
      "type": "number",
      "hide": false 
      },
      {
      "id" : "brand",
      "title": "Brand",
      "type": "text",
      "hide": false 
      },
      {
      "id" : "fuel type",
      "title": "Fuel",
      "type": "text",
      "hide": false 
      },
      {
      "id" : "vin",
      "title": "VIN",
      "type": "text",
      "hide": false 
      },
      {
      "id" : "odo",
      "title": "ODO (km)",
      "type": "number",
      "hide": false 
      },
      {
      "id" : "layout",
      "title": "Layout",
      "type": "String",
      "hide": false 
      },
      {
      "id" : "tire",
      "title": "Tire",
      "type": "String",
      "hide": false 
      },
      {
      "id" : "fgr",
      "title": "FGR",
      "type": "double",
      "hide": false 
      }
     ]
},
{
     "name": "Coastdown",
     "columns":[
      {
      "id" : "a",
      "title": "A",
      "type": "double",
      "hide": false 
      },
      {
      "id" : "b",
      "title": "B",
      "type": "double",
      "hide": false 
      },
      {
      "id" : "c",
      "title": "C",
      "type": "double",
      "hide": false 
      },
      {
      "id" : "coastdown speed graph",
      "title": "Graph",
      "type": "graph",
      "hide": false 
      }
     ]
},
{
     "name": "Idle NVH",
     "columns":[
      {
      "id" : "idle noise",
      "title": "Noise",
      "type": "double",
      "hide": false 
      },
      {
      "id" : "idle vibration",
      "title": "Vib",
      "type": "double",
      "hide": false 
      },
      {
      "id" : "idle vibration source",
      "title": "Vib (Src)",
      "type": "double",
      "hide": false 
      }
    ]
},
{
     "name": "Wide Open Throttle NVH",
     "columns":[
      {
      "id" : "wot noise coefficient",
      "title": "Noise Coeff",
      "type": "double",
      "hide": false 
      },
      {
      "id" : "wot noise intercept",
      "title": "Noise Intrcpt",
      "type": "double",
      "hide": false 
      },
      {
      "id" : "wot vibration",
      "title": "Vib",
      "type": "double",
      "hide": false 
      }
    ]
},
{
     "name": "Cruise NVH (Road Noise)",
     "columns":[
      {
      "id" : "road noise",
      "title": "Road Noise",
      "type": "double",
      "hide": false 
      },
      {
      "id" : "road booming",
      "title": "Road Boom",
      "type": "double",
      "hide": false 
      },
      {
      "id" : "tire noise",
      "title": "Tire Noise",
      "type": "double",
      "hide": false 
      },
      {
      "id" : "rumble",
      "title": "Rumble",
      "type": "double",
      "hide": false 
      },
      {
      "id" : "cruise 60 vibration",
      "title": "Vib (60kph)",
      "type": "double",
      "hide": false 
      },
      {
      "id" : "wind noise",
      "title": "Wind Noise",
      "type": "double",
      "hide": false 
      },
      {
      "id" : "cruise 120 vibration",
      "title": "Vib (120kph)",
      "type": "double",
      "hide": false 
      }
    ]
},
{
     "name": "Acceleration NVH",
     "columns":[
      {
      "id" : "acceleration noise coefficient",
      "title": "Noise Coeff",
      "type": "double",
      "hide": false 
      },
      {
      "id" : "acceleration noise intercept",
      "title": "Noise Intrcpt",
      "type": "double",
      "hide": false 
      },
      {
      "id" : "acceleration vibration",
      "title": "Vib",
      "type": "double",
      "hide": false 
      }
   ]
},
{
     "name": "MDPS NVH",
     "columns":[
      {
      "id" : "mdps noise",
      "title": "Noise",
      "type": "double",
      "hide": false 
      }
   ]
}

]
}
""";

