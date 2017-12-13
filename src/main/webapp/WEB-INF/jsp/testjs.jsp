<%-- 
    Document   : testjs
    Created on : Apr 26, 2017, 12:06:56 PM
    Author     : vahan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<script src="${cp}/resources/echarts/dist/echarts.js?v=${version}"></script>
<script src="${cp}/resources/echarts/dist/extension/dataTool.min.js?v=${version}"></script>
<script src="${cp}/resources/js/theme/oddeyelight.js?v=${version}"></script>
<script src="${cp}/resources/js/chartsfuncs.js?v=${version}"></script>
<script>
geoJson= {
	"title": "Armenia",
	"version": "1.1.2",
	"type": "FeatureCollection",
	"copyright": "Copyright (c) 2015 Highsoft AS, Based on data from Natural Earth",
	"copyrightShort": "Natural Earth",
	"copyrightUrl": "http://www.naturalearthdata.com",
	"crs": {
		"type": "name",
		"properties": {
			"name": "urn:ogc:def:crs:EPSG:32638"
		}
	},
	"hc-transform": {
		"default": {
			"crs": "+proj=utm +zone=38 +datum=WGS84 +units=m +no_defs",
			"scale": 0.00259546189063,
			"jsonres": 15.5,
			"jsonmarginX": -999,
			"jsonmarginY": 9851.0,
			"xoffset": 368653.243489,
			"yoffset": 4571000.84883
		}
	},
	"features": [{
		"type": "Feature",
		"id": "AM.GR",
		"properties": {
			"name": "Gegharkunik",
			"country": "Armenia",
			"type-en": "Province",			
			"longitude": "45.3848",			
			"latitude": "40.278",
                        "cp": [6147, 6870],
			"woe-label": "Geghark'unik', AM, Armenia",
			"type": "Marz"
		},
		"geometry": {
			"type": "MultiPolygon",
			"coordinates": [
				[
					[
						[6147, 6870],
						[6033, 6781],
						[5916, 6816],
						[5889, 6905],
						[5915, 6996],
						[6004, 7041],
						[6103, 7036],
						[6192, 6986],
						[6147, 6870]
					]
				],
				[
					[
						[4662, 3489],
						[4632, 3557],
						[4621, 3683],
						[4572, 3853],
						[4571, 3983],
						[4502, 4033],
						[4336, 4443],
						[4332, 4542],
						[4370, 4689],
						[4387, 4818],
						[4336, 4895],
						[4102, 5169],
						[4096, 5277],
						[4146, 5342],
						[4140, 5394],
						[3981, 5987],
						[3941, 6047],
						[3840, 6116],
						[3823, 6154],
						[3849, 6273],
						[3830, 6351],
						[3749, 6459],
						[3632, 6463],
						[3600, 6518],
						[3564, 6757],
						[3570, 6835],
						[3603, 6905],
						[3593, 6992],
						[3997, 7077],
						[4098, 7034],
						[4164, 6976],
						[4274, 6936],
						[4417, 6964],
						[4505, 7010],
						[4571, 7153],
						[4619, 7208],
						[4750, 7263],
						[4877, 7358],
						[5107, 7332],
						[5159, 7304],
						[5237, 7207],
						[5377, 7144],
						[5490, 7023],
						[5556, 6999],
						[5556, 6916],
						[5605, 6813],
						[5740, 6695],
						[5799, 6621],
						[5821, 6478],
						[5869, 6395],
						[5940, 6349],
						[6080, 6063],
						[6284, 5875],
						[7083, 5431],
						[7233, 5269],
						[7301, 5266],
						[7448, 5293],
						[7548, 5220],
						[7637, 5105],
						[7644, 5027],
						[7585, 4739],
						[7544, 4629],
						[7480, 4541],
						[7405, 4473],
						[7354, 4234],
						[7285, 4147],
						[7045, 4121],
						[6481, 4210],
						[6264, 4067],
						[6269, 4023],
						[6188, 4086],
						[6160, 4089],
						[6044, 3955],
						[5923, 3891],
						[5865, 3872],
						[5631, 3831],
						[5545, 3831],
						[5439, 3811],
						[5186, 3824],
						[5047, 3775],
						[4962, 3721],
						[4825, 3595],
						[4662, 3489]
					]
				]
			]
		}
	}, {
		"type": "Feature",
		"id": "AM.AV",
		"properties": {
			"hc-group": "admin1",
			"hc-middle-x": 0.30,
			"hc-middle-y": 0.50,
			"hc-key": "am-av",
			"hc-a2": "AV",
			"labelrank": "9",
			"hasc": "AM.AV",
			"alt-name": null,
			"woe-id": "20070210",
			"subregion": null,
			"fips": "AM03",
			"postal-code": "AV",
			"name": "Armavir",
			"country": "Armenia",
			"type-en": "Province",
			"region": null,
			"longitude": "44.0464",
			"woe-name": "Armavir",
			"latitude": "40.0992",
			"woe-label": "Armavir, AM, Armenia",
			"type": "Marz"
		},
		"geometry": {
			"type": "Polygon",
			"coordinates": [
				[
					[2159, 4140],
					[1970, 4252],
					[1845, 4292],
					[1729, 4293],
					[1522, 4238],
					[1317, 4202],
					[1211, 4264],
					[1138, 4246],
					[1018, 4163],
					[963, 4145],
					[551, 4220],
					[178, 4432],
					[-135, 4526],
					[-291, 4615],
					[-333, 4744],
					[-285, 4788],
					[-129, 4819],
					[-95, 4876],
					[-116, 4927],
					[-221, 5060],
					[-257, 5139],
					[-197, 5195],
					[-106, 5246],
					[-26, 5317],
					[30, 5323],
					[115, 5285],
					[193, 5378],
					[235, 5386],
					[291, 5303],
					[340, 5277],
					[468, 5240],
					[602, 5138],
					[764, 5070],
					[869, 4963],
					[921, 4937],
					[1328, 4930],
					[1401, 4959],
					[1441, 4999],
					[1416, 5139],
					[1461, 5185],
					[1519, 5171],
					[1561, 5120],
					[1607, 5104],
					[1696, 5156],
					[1765, 5172],
					[1828, 5163],
					[1866, 5117],
					[1956, 5070],
					[2018, 5021],
					[2093, 4985],
					[2293, 4940],
					[2324, 4895],
					[2335, 4817],
					[2368, 4779],
					[2360, 4741],
					[2235, 4687],
					[2179, 4640],
					[2060, 4467],
					[2120, 4348],
					[2150, 4263],
					[2159, 4140]
				]
			]
		}
	}, {
		"type": "Feature",
		"id": "AM.SH",
		"properties": {
			"hc-group": "admin1",
			"hc-middle-x": 0.60,
			"hc-middle-y": 0.38,
			"hc-key": "am-sh",
			"hc-a2": "SH",
			"labelrank": "9",
			"hasc": "AM.SH",
			"alt-name": "?irak",
			"woe-id": "20070203",
			"subregion": null,
			"fips": "AM07",
			"postal-code": "SH",
			"name": "Shirak",
			"country": "Armenia",
			"type-en": "Province",
			"region": null,
			"longitude": "43.8178",
			"woe-name": "Shirak",
			"latitude": "40.8194",
			"woe-label": "Shirak, AM, Armenia",
			"type": "Marz"
		},
		"geometry": {
			"type": "Polygon",
			"coordinates": [
				[
					[-410, 5961],
					[-407, 6001],
					[-543, 6121],
					[-614, 6203],
					[-627, 6262],
					[-508, 6399],
					[-434, 6449],
					[-353, 6458],
					[-378, 6522],
					[-306, 6487],
					[-308, 6595],
					[-261, 6686],
					[-115, 6853],
					[-139, 6955],
					[-46, 7107],
					[-35, 7143],
					[-48, 7453],
					[-89, 7611],
					[-227, 7838],
					[-260, 7928],
					[-296, 8205],
					[-334, 8293],
					[-438, 8428],
					[-570, 8541],
					[-714, 8616],
					[-858, 8639],
					[-922, 8702],
					[-974, 8830],
					[-999, 8973],
					[-983, 9077],
					[-883, 9073],
					[-699, 9145],
					[-556, 9148],
					[-6, 9062],
					[77, 9067],
					[143, 9094],
					[303, 9231],
					[448, 9289],
					[761, 9292],
					[835, 9309],
					[792, 8970],
					[832, 8897],
					[934, 8851],
					[1032, 8709],
					[1163, 8586],
					[1163, 8534],
					[1096, 8451],
					[1163, 8390],
					[1316, 8383],
					[1331, 8359],
					[1305, 8216],
					[1240, 8132],
					[1229, 8054],
					[1168, 8010],
					[1032, 8045],
					[1004, 7991],
					[975, 7870],
					[945, 7812],
					[954, 7754],
					[1017, 7610],
					[1060, 7567],
					[1179, 7549],
					[1226, 7500],
					[1259, 7425],
					[1310, 7404],
					[1452, 7409],
					[1337, 7188],
					[1279, 7112],
					[1163, 7001],
					[1155, 6965],
					[1237, 6893],
					[1281, 6824],
					[1313, 6713],
					[1387, 6702],
					[1496, 6720],
					[1534, 6706],
					[1533, 6664],
					[1486, 6490],
					[1491, 6435],
					[1557, 6385],
					[1497, 6331],
					[1405, 6272],
					[1317, 6254],
					[1265, 6211],
					[1173, 6176],
					[1037, 6105],
					[979, 6145],
					[892, 6281],
					[750, 6290],
					[677, 6215],
					[536, 6212],
					[443, 6235],
					[374, 6289],
					[274, 6312],
					[220, 6345],
					[171, 6340],
					[66, 6277],
					[-60, 6240],
					[-129, 6198],
					[-176, 6089],
					[-272, 6028],
					[-351, 5952],
					[-410, 5961]
				]
			]
		}
	}, {
		"type": "Feature",
		"id": "AM.AR",
		"properties": {
			"hc-group": "admin1",
			"hc-middle-x": 0.66,
			"hc-middle-y": 0.52,
			"hc-key": "am-ar",
			"hc-a2": "AR",
			"labelrank": "9",
			"hasc": "AM.AR",
			"alt-name": null,
			"woe-id": "20070211",
			"subregion": null,
			"fips": "AM02",
			"postal-code": "AR",
			"name": "Ararat",
			"country": "Armenia",
			"type-en": "Province",
			"region": null,
			"longitude": "44.7304",
			"woe-name": "Ararat",
			"latitude": "39.9204",
			"woe-label": "Ararat, AM, Armenia",
			"type": "Marz"
		},
		"geometry": {
			"type": "Polygon",
			"coordinates": [
				[
					[4544, 2971],
					[4518, 3004],
					[4400, 3063],
					[4271, 3019],
					[4144, 2921],
					[4034, 2859],
					[3916, 2831],
					[3766, 2834],
					[3605, 2805],
					[3508, 2762],
					[3454, 2853],
					[3244, 3131],
					[3191, 3185],
					[3135, 3181],
					[3072, 3221],
					[2948, 3365],
					[2902, 3337],
					[2878, 3457],
					[2797, 3525],
					[2769, 3632],
					[2730, 3697],
					[2643, 3796],
					[2445, 3970],
					[2159, 4140],
					[2150, 4263],
					[2120, 4348],
					[2060, 4467],
					[2179, 4640],
					[2235, 4687],
					[2360, 4741],
					[2368, 4779],
					[2409, 4789],
					[2448, 4761],
					[2446, 4625],
					[2470, 4553],
					[2499, 4525],
					[2619, 4497],
					[2677, 4460],
					[2707, 4387],
					[2759, 4337],
					[2833, 4345],
					[2926, 4407],
					[3077, 4607],
					[3109, 4590],
					[3142, 4512],
					[3231, 4462],
					[3402, 4492],
					[3542, 4537],
					[3799, 4682],
					[3897, 4722],
					[4022, 4758],
					[4155, 4813],
					[4259, 4825],
					[4387, 4818],
					[4370, 4689],
					[4332, 4542],
					[4336, 4443],
					[4502, 4033],
					[4571, 3983],
					[4572, 3853],
					[4621, 3683],
					[4632, 3557],
					[4662, 3489],
					[4580, 3306],
					[4553, 3218],
					[4553, 3069],
					[4544, 2971]
				]
			]
		}
	}, {
		"type": "Feature",
		"id": "AM.TV",
		"properties": {
			"hc-group": "admin1",
			"hc-middle-x": 0.45,
			"hc-middle-y": 0.68,
			"hc-key": "am-tv",
			"hc-a2": "TV",
			"labelrank": "9",
			"hasc": "AM.TV",
			"alt-name": "Tavu?",
			"woe-id": "20070202",
			"subregion": null,
			"fips": "AJ40",
			"postal-code": "TV",
			"name": "Tavush",
			"country": "Armenia",
			"type-en": "Province",
			"region": null,
			"longitude": "45.1763",
			"woe-name": "Tavush",
			"latitude": "40.8883",
			"woe-label": "Tavush, AM, Armenia",
			"type": "Marz"
		},
		"geometry": {
			"type": "Polygon",
			"coordinates": [
				[
					[3792, 9552],
					[3769, 9585],
					[3643, 9646],
					[3615, 9709],
					[3681, 9775],
					[4006, 9723],
					[4134, 9727],
					[4293, 9851],
					[4418, 9586],
					[4384, 9492],
					[4403, 9437],
					[4460, 9412],
					[4681, 9412],
					[4739, 9393],
					[4915, 9255],
					[4959, 9192],
					[4964, 9121],
					[4848, 9036],
					[4514, 9049],
					[4478, 8906],
					[4522, 8831],
					[4595, 8782],
					[4660, 8775],
					[4691, 8910],
					[4747, 8880],
					[4857, 8765],
					[4926, 8722],
					[5035, 8619],
					[5194, 8601],
					[5343, 8541],
					[5420, 8528],
					[5609, 8624],
					[5703, 8635],
					[5724, 8529],
					[5695, 8384],
					[5737, 8339],
					[5818, 8318],
					[5908, 8245],
					[6054, 8060],
					[6108, 8005],
					[6257, 7978],
					[6316, 7948],
					[6323, 7849],
					[6261, 7664],
					[6172, 7562],
					[5773, 7367],
					[5640, 7257],
					[5555, 7106],
					[5556, 6999],
					[5490, 7023],
					[5377, 7144],
					[5237, 7207],
					[5159, 7304],
					[5107, 7332],
					[4877, 7358],
					[4750, 7263],
					[4619, 7208],
					[4571, 7153],
					[4505, 7010],
					[4417, 6964],
					[4274, 6936],
					[4164, 6976],
					[4098, 7034],
					[3997, 7077],
					[3593, 6992],
					[3511, 7060],
					[3515, 7320],
					[3443, 7540],
					[3492, 7611],
					[3556, 7642],
					[3672, 7673],
					[3717, 7702],
					[3754, 7763],
					[3826, 7994],
					[3856, 8048],
					[3964, 8148],
					[3954, 8206],
					[3876, 8297],
					[3814, 8329],
					[3684, 8344],
					[3556, 8444],
					[3512, 8502],
					[3515, 8553],
					[3625, 8680],
					[3691, 8700],
					[3758, 8657],
					[3850, 8666],
					[4069, 8835],
					[4072, 8899],
					[4032, 8960],
					[3934, 9013],
					[3893, 9082],
					[3879, 9175],
					[3893, 9268],
					[4019, 9360],
					[4022, 9430],
					[3988, 9467],
					[3873, 9544],
					[3792, 9552]
				],
				[
					[5031, 8461],
					[4934, 8545],
					[4885, 8527],
					[4917, 8424],
					[4996, 8412],
					[5031, 8461]
				],
				[
					[4386, 8761],
					[4349, 8888],
					[4216, 8920],
					[4163, 8883],
					[4152, 8821],
					[4173, 8754],
					[4216, 8700],
					[4338, 8658],
					[4386, 8761]
				]
			]
		}
	}, {
		"type": "Feature",
		"id": "AM.KT",
		"properties": {
			"hc-group": "admin1",
			"hc-middle-x": 0.46,
			"hc-middle-y": 0.55,
			"hc-key": "am-kt",
			"hc-a2": "KT",
			"labelrank": "9",
			"hasc": "AM.KT",
			"alt-name": "Kotaik|Kotayk'",
			"woe-id": "20070208",
			"subregion": null,
			"fips": "AM05",
			"postal-code": "KT",
			"name": "Kotayk",
			"country": "Armenia",
			"type-en": "Province",
			"region": null,
			"longitude": "44.7191",
			"woe-name": "Kotayk",
			"latitude": "40.3747",
			"woe-label": "Kotayk', AM, Armenia",
			"type": "Marz"
		},
		"geometry": {
			"type": "Polygon",
			"coordinates": [
				[
					[3511, 7060],
					[3593, 6992],
					[3603, 6905],
					[3570, 6835],
					[3564, 6757],
					[3600, 6518],
					[3632, 6463],
					[3749, 6459],
					[3830, 6351],
					[3849, 6273],
					[3823, 6154],
					[3840, 6116],
					[3941, 6047],
					[3981, 5987],
					[4140, 5394],
					[4146, 5342],
					[4096, 5277],
					[4102, 5169],
					[4336, 4895],
					[4387, 4818],
					[4259, 4825],
					[4155, 4813],
					[4022, 4758],
					[3897, 4722],
					[3799, 4682],
					[3542, 4537],
					[3402, 4492],
					[3231, 4462],
					[3142, 4512],
					[3109, 4590],
					[3077, 4607],
					[3051, 4674],
					[3006, 4698],
					[2881, 4694],
					[2849, 4737],
					[2875, 4825],
					[2977, 4962],
					[2879, 5087],
					[2820, 5115],
					[2663, 5051],
					[2530, 5040],
					[2477, 5051],
					[2417, 5026],
					[2364, 5034],
					[2320, 4991],
					[2277, 5095],
					[2272, 5177],
					[2343, 5238],
					[2352, 5296],
					[2290, 5348],
					[2264, 5393],
					[2274, 5442],
					[2383, 5505],
					[2511, 5730],
					[2593, 5790],
					[2600, 5852],
					[2568, 5952],
					[2735, 6428],
					[2761, 6543],
					[2764, 6612],
					[2717, 6635],
					[2558, 6671],
					[2341, 6834],
					[2315, 6883],
					[2331, 6986],
					[2308, 7139],
					[2592, 7211],
					[2676, 7217],
					[2764, 7164],
					[2858, 7198],
					[2905, 7194],
					[3075, 7104],
					[3214, 7059],
					[3376, 7044],
					[3511, 7060]
				]
			]
		}
	}, {
		"type": "Feature",
		"id": "AM.LO",
		"properties": {
			"hc-group": "admin1",
			"hc-middle-x": 0.55,
			"hc-middle-y": 0.51,
			"hc-key": "am-lo",
			"hc-a2": "LO",
			"labelrank": "9",
			"hasc": "AM.LO",
			"alt-name": "Lo?i",
			"woe-id": "20070207",
			"subregion": null,
			"fips": "AM06",
			"postal-code": "LO",
			"name": "Lori",
			"country": "Armenia",
			"type-en": "Province",
			"region": null,
			"longitude": "44.4524",
			"woe-name": "Lori",
			"latitude": "40.9347",
			"woe-label": "Lorri, AM, Armenia",
			"type": "Marz"
		},
		"geometry": {
			"type": "Polygon",
			"coordinates": [
				[
					[3511, 7060],
					[3376, 7044],
					[3214, 7059],
					[3075, 7104],
					[2905, 7194],
					[2858, 7198],
					[2764, 7164],
					[2676, 7217],
					[2592, 7211],
					[2308, 7139],
					[2291, 7208],
					[2244, 7266],
					[2159, 7319],
					[1981, 7394],
					[1865, 7408],
					[1754, 7310],
					[1695, 7298],
					[1632, 7316],
					[1535, 7414],
					[1452, 7409],
					[1310, 7404],
					[1259, 7425],
					[1226, 7500],
					[1179, 7549],
					[1060, 7567],
					[1017, 7610],
					[954, 7754],
					[945, 7812],
					[975, 7870],
					[1004, 7991],
					[1032, 8045],
					[1168, 8010],
					[1229, 8054],
					[1240, 8132],
					[1305, 8216],
					[1331, 8359],
					[1316, 8383],
					[1163, 8390],
					[1096, 8451],
					[1163, 8534],
					[1163, 8586],
					[1032, 8709],
					[934, 8851],
					[832, 8897],
					[792, 8970],
					[835, 9309],
					[914, 9327],
					[1050, 9387],
					[1118, 9393],
					[1260, 9352],
					[1332, 9364],
					[1398, 9399],
					[1452, 9451],
					[1481, 9566],
					[1557, 9594],
					[1648, 9555],
					[1811, 9440],
					[1873, 9416],
					[1952, 9429],
					[2036, 9502],
					[2117, 9509],
					[2297, 9399],
					[2370, 9371],
					[2446, 9366],
					[2528, 9389],
					[2619, 9481],
					[2655, 9482],
					[2703, 9369],
					[2772, 9348],
					[2822, 9392],
					[2907, 9521],
					[2980, 9553],
					[3048, 9544],
					[3189, 9487],
					[3683, 9475],
					[3772, 9487],
					[3792, 9552],
					[3873, 9544],
					[3988, 9467],
					[4022, 9430],
					[4019, 9360],
					[3893, 9268],
					[3879, 9175],
					[3893, 9082],
					[3934, 9013],
					[4032, 8960],
					[4072, 8899],
					[4069, 8835],
					[3850, 8666],
					[3758, 8657],
					[3691, 8700],
					[3625, 8680],
					[3515, 8553],
					[3512, 8502],
					[3556, 8444],
					[3684, 8344],
					[3814, 8329],
					[3876, 8297],
					[3954, 8206],
					[3964, 8148],
					[3856, 8048],
					[3826, 7994],
					[3754, 7763],
					[3717, 7702],
					[3672, 7673],
					[3556, 7642],
					[3492, 7611],
					[3443, 7540],
					[3515, 7320],
					[3511, 7060]
				]
			]
		}
	}, {
		"type": "Feature",
		"id": "AM.ER",
		"properties": {
			"hc-group": "admin1",
			"hc-middle-x": 0.52,
			"hc-middle-y": 0.51,
			"hc-key": "am-er",
			"hc-a2": "ER",
			"labelrank": "9",
			"hasc": "AM.ER",
			"alt-name": "Yerevan",
			"woe-id": "20070212",
			"subregion": null,
			"fips": "AM11",
			"postal-code": "ER",
			"name": "Erevan",
			"country": "Armenia",
			"type-en": "City",
			"region": null,
			"longitude": "44.533",
			"woe-name": "Erevan",
			"latitude": "40.1474",
			"woe-label": "Yerevan, AM, Armenia",
			"type": "Kaghak"
		},
		"geometry": {
			"type": "Polygon",
			"coordinates": [
				[
					[3077, 4607],
					[2926, 4407],
					[2833, 4345],
					[2759, 4337],
					[2707, 4387],
					[2677, 4460],
					[2619, 4497],
					[2499, 4525],
					[2470, 4553],
					[2446, 4625],
					[2448, 4761],
					[2409, 4789],
					[2368, 4779],
					[2335, 4817],
					[2324, 4895],
					[2293, 4940],
					[2320, 4991],
					[2364, 5034],
					[2417, 5026],
					[2477, 5051],
					[2530, 5040],
					[2663, 5051],
					[2820, 5115],
					[2879, 5087],
					[2977, 4962],
					[2875, 4825],
					[2849, 4737],
					[2881, 4694],
					[3006, 4698],
					[3051, 4674],
					[3077, 4607]
				]
			]
		}
	}, {
		"type": "Feature",
		"id": "AM.SU",
		"properties": {
			"hc-group": "admin1",
			"hc-middle-x": 0.50,
			"hc-middle-y": 0.52,
			"hc-key": "am-su",
			"hc-a2": "SU",
			"labelrank": "9",
			"hasc": "AM.SU",
			"alt-name": "Syunik'",
			"woe-id": "20070206",
			"subregion": null,
			"fips": "AM08",
			"postal-code": "SU",
			"name": "Syunik",
			"country": "Armenia",
			"type-en": "Province",
			"region": null,
			"longitude": "46.1518",
			"woe-name": "Syunik",
			"latitude": "39.2479",
			"woe-label": "Syunik', AM, Armenia",
			"type": "Marz"
		},
		"geometry": {
			"type": "Polygon",
			"coordinates": [
				[
					[7070, 3437],
					[7097, 3383],
					[7253, 3230],
					[7441, 3136],
					[7659, 3073],
					[7754, 2982],
					[7890, 2714],
					[8000, 2629],
					[8131, 2593],
					[8191, 2560],
					[8241, 2499],
					[8324, 2347],
					[8376, 2299],
					[8453, 2276],
					[8572, 2303],
					[8807, 2427],
					[8925, 2420],
					[8974, 2381],
					[9058, 2272],
					[9110, 2236],
					[9178, 2225],
					[9396, 2249],
					[9510, 2201],
					[9553, 2144],
					[9565, 2071],
					[9535, 2014],
					[9445, 1944],
					[9445, 1870],
					[9469, 1782],
					[9405, 1728],
					[9151, 1676],
					[9042, 1606],
					[8998, 1491],
					[9048, 1351],
					[9163, 1265],
					[9414, 1158],
					[9470, 1113],
					[9516, 978],
					[9551, 913],
					[9637, 826],
					[9787, 724],
					[9851, 635],
					[9748, 615],
					[9589, 498],
					[9546, 491],
					[9333, 595],
					[9211, 608],
					[9132, 532],
					[9138, 395],
					[9228, 308],
					[9345, 244],
					[9430, 178],
					[9476, 32],
					[9498, -94],
					[9490, -220],
					[9428, -444],
					[9427, -553],
					[9443, -605],
					[9568, -859],
					[9505, -842],
					[9139, -686],
					[9091, -676],
					[8970, -710],
					[8835, -718],
					[8722, -763],
					[8542, -896],
					[8482, -927],
					[8250, -960],
					[8042, -575],
					[7854, -72],
					[7782, 69],
					[7616, 318],
					[7583, 435],
					[7603, 548],
					[7709, 690],
					[7684, 791],
					[7612, 858],
					[7363, 977],
					[7279, 1040],
					[7141, 1168],
					[6944, 1217],
					[6914, 1284],
					[6935, 1374],
					[7050, 1566],
					[7065, 1637],
					[7032, 1841],
					[7041, 2030],
					[7009, 2086],
					[6930, 2142],
					[6835, 2178],
					[6735, 2171],
					[6707, 2266],
					[6797, 2627],
					[6808, 2791],
					[6741, 2911],
					[6778, 3027],
					[6958, 3338],
					[7009, 3402],
					[7070, 3437]
				]
			]
		}
	}, {
		"type": "Feature",
		"id": "AM.VD",
		"properties": {
			"hc-group": "admin1",
			"hc-middle-x": 0.45,
			"hc-middle-y": 0.51,
			"hc-key": "am-vd",
			"hc-a2": "VD",
			"labelrank": "9",
			"hasc": "AM.VD",
			"alt-name": "Vayoc'Jor",
			"woe-id": "20070205",
			"subregion": null,
			"fips": "AM10",
			"postal-code": "VD",
			"name": "Vayots Dzor",
			"country": "Armenia",
			"type-en": "Province",
			"region": null,
			"longitude": "45.4421",
			"woe-name": "Vayots Dzor",
			"latitude": "39.7183",
			"woe-label": "Vayots' Dzor, AM, Armenia",
			"type": "Marz"
		},
		"geometry": {
			"type": "Polygon",
			"coordinates": [
				[
					[6735, 2171],
					[6312, 2065],
					[6220, 2026],
					[5943, 1848],
					[5868, 1812],
					[5789, 1810],
					[5752, 1831],
					[5642, 1943],
					[5581, 1974],
					[5418, 1989],
					[5367, 2009],
					[5291, 2152],
					[5183, 2302],
					[5091, 2271],
					[4993, 2180],
					[4865, 2149],
					[4798, 2192],
					[4784, 2257],
					[4818, 2418],
					[4823, 2523],
					[4808, 2605],
					[4772, 2680],
					[4544, 2971],
					[4553, 3069],
					[4553, 3218],
					[4580, 3306],
					[4662, 3489],
					[4825, 3595],
					[4962, 3721],
					[5047, 3775],
					[5186, 3824],
					[5439, 3811],
					[5545, 3831],
					[5631, 3831],
					[5865, 3872],
					[5923, 3891],
					[6044, 3955],
					[6160, 4089],
					[6188, 4086],
					[6269, 4023],
					[6276, 3962],
					[6385, 3913],
					[6744, 3879],
					[6838, 3833],
					[6913, 3752],
					[7070, 3437],
					[7009, 3402],
					[6958, 3338],
					[6778, 3027],
					[6741, 2911],
					[6808, 2791],
					[6797, 2627],
					[6707, 2266],
					[6735, 2171]
				]
			]
		}
	}, {
		"type": "Feature",
		"id": "AM.AG",
		"properties": {
			"hc-group": "admin1",
			"hc-middle-x": 0.59,
			"hc-middle-y": 0.71,
			"hc-key": "am-ag",
			"hc-a2": "AG",
			"labelrank": "9",
			"hasc": "AM.AG",
			"alt-name": "Aragacot'n",
			"woe-id": "20070209",
			"subregion": null,
			"fips": "AM01",
			"postal-code": "AG",
			"name": "Aragatsotn",
			"country": "Armenia",
			"type-en": "Province",
			"region": null,
			"longitude": "44.0736",
			"woe-name": "Aragatsotn",
			"latitude": "40.3213",
			"woe-label": "Aragatsotn, AM, Armenia",
			"type": "Marz"
		},
		"geometry": {
			"type": "Polygon",
			"coordinates": [
				[
					[2293, 4940],
					[2093, 4985],
					[2018, 5021],
					[1956, 5070],
					[1866, 5117],
					[1828, 5163],
					[1765, 5172],
					[1696, 5156],
					[1607, 5104],
					[1561, 5120],
					[1519, 5171],
					[1461, 5185],
					[1416, 5139],
					[1441, 4999],
					[1401, 4959],
					[1328, 4930],
					[921, 4937],
					[869, 4963],
					[764, 5070],
					[602, 5138],
					[468, 5240],
					[340, 5277],
					[291, 5303],
					[235, 5386],
					[193, 5378],
					[115, 5285],
					[30, 5323],
					[-26, 5317],
					[-106, 5246],
					[-197, 5195],
					[-244, 5310],
					[-393, 5510],
					[-484, 5599],
					[-518, 5669],
					[-464, 5791],
					[-410, 5961],
					[-351, 5952],
					[-272, 6028],
					[-176, 6089],
					[-129, 6198],
					[-60, 6240],
					[66, 6277],
					[171, 6340],
					[220, 6345],
					[274, 6312],
					[374, 6289],
					[443, 6235],
					[536, 6212],
					[677, 6215],
					[750, 6290],
					[892, 6281],
					[979, 6145],
					[1037, 6105],
					[1173, 6176],
					[1265, 6211],
					[1317, 6254],
					[1405, 6272],
					[1497, 6331],
					[1557, 6385],
					[1491, 6435],
					[1486, 6490],
					[1533, 6664],
					[1534, 6706],
					[1496, 6720],
					[1387, 6702],
					[1313, 6713],
					[1281, 6824],
					[1237, 6893],
					[1155, 6965],
					[1163, 7001],
					[1279, 7112],
					[1337, 7188],
					[1452, 7409],
					[1535, 7414],
					[1632, 7316],
					[1695, 7298],
					[1754, 7310],
					[1865, 7408],
					[1981, 7394],
					[2159, 7319],
					[2244, 7266],
					[2291, 7208],
					[2308, 7139],
					[2331, 6986],
					[2315, 6883],
					[2341, 6834],
					[2558, 6671],
					[2717, 6635],
					[2764, 6612],
					[2761, 6543],
					[2735, 6428],
					[2568, 5952],
					[2600, 5852],
					[2593, 5790],
					[2511, 5730],
					[2383, 5505],
					[2274, 5442],
					[2264, 5393],
					[2290, 5348],
					[2352, 5296],
					[2343, 5238],
					[2272, 5177],
					[2277, 5095],
					[2320, 4991],
					[2293, 4940]
				]
			]
		}
	}]
}
    
    
    
//geoJson= 
        
var echartLine = echarts.init(document.getElementById("echart_line"), 'oddeyelight');

echarts.registerMap('jiangxi', geoJson);


    var geoCoordMap = {
        'Gegharkunik':[5147, 5800],
        'Armavir':[1500, 4500],
        'Shirak':[500, 7900],
        'Ararat':[4000, 3500],
        'Tavush':[4500, 8000],
        'Kotayk':[3000, 6200],
        'Lori':[ 2500, 8200],
        'Erevan':[2700, 4807],
        'Syunik':[8000, 1000],
        'Vayots Dzor':[6000, 3000],
        'Aragatsotn':[1000, 5800],
    };
    var data = [
        {name: 'Gegharkunik', value: Math.round(Math.random()*500)},        
        {name: 'Armavir', value: Math.round(Math.random()*500)},        
        {name: 'Shirak', value: Math.round(Math.random()*500)},        
        {name: 'Ararat', value: Math.round(Math.random()*500)},        
        {name: 'Tavush', value: Math.round(Math.random()*500)},        
        {name: 'Kotayk', value: Math.round(Math.random()*500)},        
        {name: 'Lori', value: Math.round(Math.random()*500)},        
        {name: 'Erevan', value: Math.round(Math.random()*500)},        
        {name: 'Syunik', value: Math.round(Math.random()*500)},        
        {name: 'Vayots Dzor', value: Math.round(Math.random()*500)},        
        {name: 'Aragatsotn', value: Math.round(Math.random()*500)},        
    ];
    var max = 480, min = 9; // todo 
    var maxSize4Pin = 100, minSize4Pin = 20;

  var convertData = function (data) {
    var res = [];
    for (var i = 0; i < data.length; i++) {
        var geoCoord = geoCoordMap[data[i].name];
        if (geoCoord) {
            res.push({
                name: data[i].name,
                value: geoCoord.concat(data[i].value)
            });
        }
    }
    console.log(res);
    return res;
};


    option = {
        title: {
            text: '“Armenia',
            subtext: '',
            x: 'center',
            textStyle: {
                color: '#ccc'
            }
        },
        tooltip: {
            trigger: 'item',
            formatter: function (params) {                
              if(typeof(params.value)[2] == "undefined"){
              	return params.name + ' : ' + params.value;
              }else{
              	return params.name + ' : ' + params.value[2];
              }
            }
        },
        legend: {
            orient: 'vertical',
            y: 'bottom',
            x: 'right',
            data: ['credit_pm2.5'],
            textStyle: {
                color: '#fff'
            }
        },
        visualMap: {
            show: true,
            min: 0,
            max: 500,
            left: 'left',
            top: 'bottom',
            text: ['min', 'max'], 
            calculable: true,
            seriesIndex: [1],
            inRange: {
                // color: ['#3B5077', '#031525'] // 蓝黑
                // color: ['#ffc0cb', '#800080'] // 红紫
                // color: ['#3C3B3F', '#605C3C'] // 黑绿
                color: ['#FF5500', '#00FF00', '#0055FF'] // 黑紫黑
                // color: ['#23074d', '#cc5333'] // 紫红
                // color: ['#00467F', '#A5CC82'] // 蓝绿
                // color: ['#1488CC', '#2B32B2'] // 浅蓝
                // color: ['#00467F', '#A5CC82'] // 蓝绿
                // color: ['#00467F', '#A5CC82'] // 蓝绿
                // color: ['#00467F', '#A5CC82'] // 蓝绿
                // color: ['#00467F', '#A5CC82'] // 蓝绿

            }
        },
        // toolbox: {
        //     show: true,
        //     orient: 'vertical',
        //     left: 'right',
        //     top: 'center',
        //     feature: {
        //             dataView: {readOnly: false},
        //             restore: {},
        //             saveAsImage: {}
        //             }
        // },
        geo: {
            show: true,
            map: 'jiangxi',
            label: {
                normal: {
                    show: false
                },
                emphasis: {
                    show: false,
                }
            },
            roam: true,
            itemStyle: {
                normal: {
                    areaColor: '#031525',
                    borderColor: '#3B5077',
                },
                emphasis: {
                    areaColor: '#2B91B7',
                }
            }
        },
        series : [
      {
            name: 'credit_pm2.5',
            type: 'scatter',
            coordinateSystem: 'geo',
            data: convertData(data),
            symbolSize: function (val) {
                return val[2] / 10;
            },
            label: {
                normal: {
                    formatter: '{b}',
                    position: 'right',
                    show: true
                },
                emphasis: {
                    show: true
                }
            },
            itemStyle: {
                normal: {
                    color: '#05C3F9'
                }
            }
        },
         {
            type: 'map',
            map: 'jiangxi',
            geoIndex: 0,
            aspectScale: 0.75, //长宽比
            showLegendSymbol: false, // 存在legend时显示
            label: {
                normal: {
                    show: false
                },
                emphasis: {
                    show: false,
                    textStyle: {
                        color: '#fff'
                    }
                }
            },
            roam: true,
            itemStyle: {
                normal: {
                    areaColor: '#031525',
                    borderColor: '#3B5077',
                },
                emphasis: {
                    areaColor: '#2B91B7'
                }
            },
            animation: false,
            data: data
        },
        {
            name: '点',
            type: 'scatter',
            coordinateSystem: 'geo',
            symbol: 'pin',
            symbolSize: function (val) {
                var a = (maxSize4Pin - minSize4Pin) / (max - min);
                var b = minSize4Pin - a*min;
                b = maxSize4Pin - a*max;
                return a*val[2]+b;
            },
            label: {
                normal: {
                    show: true,
                    textStyle: {
                        color: '#fff',
                        fontSize: 9,
                    }
                }
            },
            itemStyle: {
                normal: {
                    color: '#F62157', //标志颜色
                }
            },
            zlevel: 6,
            data: convertData(data),
        },
        {
            name: 'Top 5',
            type: 'effectScatter',
            coordinateSystem: 'geo',
            data: convertData(data.sort(function (a, b) {
                return b.value - a.value;
            }).slice(0, 5)),
            symbolSize: function (val) {
                return val[2] / 10;
            },
            showEffectOn: 'render',
            rippleEffect: {
                brushType: 'stroke'
            },
            hoverAnimation: true,
            label: {
                normal: {
                    formatter: '{b}',
                    position: 'right',
                    show: true
                }
            },
            itemStyle: {
                normal: {
                    color: '#05C3F9',
                    shadowBlur: 10,
                    shadowColor: '#05C3F9'
                }
            },
            zlevel: 1
        },
         
    ]
    };

 echartLine.setOption(option);

</script>