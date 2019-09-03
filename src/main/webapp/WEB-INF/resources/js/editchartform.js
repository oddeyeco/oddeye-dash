/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global getParameterByName, pickerlabel, PicerOptionSet2, jsonmaker, editor, EditForm, colorPalette, EditForm, locale */

var ColorScheme = {
    "": ['#5ab1ef', '#e0ffff'],
    "Grade Grey": ["rgb(189, 195, 199)", "rgb(44, 62, 80)"],
    "Piggy Pink": ["rgb(238, 156, 167)", "rgb(255, 221, 225)"],
    "Cool Blues": ["rgb(33, 147, 176)", "rgb(109, 213, 237)"],
    "MegaTron": ["rgb(198, 255, 221)", "rgb(251, 215, 134)", "rgb(247, 121, 125)"],
    "Moonlit Asteroid": ["rgb(15, 32, 39)", "rgb(32, 58, 67)", "rgb(44, 83, 100)"],
    "JShine": ["rgb(18, 194, 233)", "rgb(196, 113, 237)", "rgb(246, 79, 89)"],
    "Evening Sunshine": ["rgb(185, 43, 39)", "rgb(21, 101, 192)"],
    "Dark Ocean": ["rgb(55, 59, 68)", "rgb(66, 134, 244)"],
    "Cool Sky": ["rgb(41, 128, 185)", "rgb(109, 213, 250)", "rgb(255, 255, 255)"],
    "Yoda": ["rgb(255, 0, 153)", "rgb(73, 50, 64)"],
    "Memariani": ["rgb(170, 75, 107)", "rgb(107, 107, 131)", "rgb(59, 141, 153)"],
    "Amin": ["rgb(142, 45, 226)", "rgb(74, 0, 224)"],
    "Harvey": ["rgb(31, 64, 55)", "rgb(153, 242, 200)"],
    "Neuromancer": ["rgb(249, 83, 198)", "rgb(185, 29, 115)"],
    "Azur Lane": ["rgb(127, 127, 213)", "rgb(134, 168, 231)", "rgb(145, 234, 228)"],
    "Witching Hour": ["rgb(195, 20, 50)", "rgb(36, 11, 54)"],
    "Flare": ["rgb(241, 39, 17)", "rgb(245, 175, 25)"],
    "Metapolis": ["rgb(101, 153, 153)", "rgb(244, 121, 31)"],
    "Kyoo Pal": ["rgb(221, 62, 84)", "rgb(107, 229, 133)"],
    "Kye Meh": ["rgb(131, 96, 195)", "rgb(46, 191, 145)"],
    "Kyoo Tah": ["rgb(84, 74, 125)", "rgb(255, 212, 82)"],
    "By Design": ["rgb(0, 159, 255)", "rgb(236, 47, 75)"],
    "Ultra Voilet": ["rgb(101, 78, 163)", "rgb(234, 175, 200)"],
    "Burning Orange": ["rgb(255, 65, 108)", "rgb(255, 75, 43)"],
    "Wiretap": ["rgb(138, 35, 135)", "rgb(233, 64, 87)", "rgb(242, 113, 33)"],
    "Summer Dog": ["rgb(168, 255, 120)", "rgb(120, 255, 214)"],
    "Rastafari": ["rgb(30, 150, 0)", "rgb(255, 242, 0)", "rgb(255, 0, 0)"],
    "Sin City Red": ["rgb(237, 33, 58)", "rgb(147, 41, 30)"],
    "Citrus Peel": ["rgb(253, 200, 48)", "rgb(243, 115, 53)"],
    "Blue Raspberry": ["rgb(0, 180, 219)", "rgb(0, 131, 176)"],
    "Margo": ["rgb(255, 239, 186)", "rgb(255, 255, 255)"],
    "Magic": ["rgb(89, 193, 115)", "rgb(161, 127, 224)", "rgb(93, 38, 193)"],
    "Evening Night": ["rgb(0, 90, 167)", "rgb(255, 253, 228)"],
    "Vanusa": ["rgb(218, 68, 83)", "rgb(137, 33, 107)"],
    "Shifty": ["rgb(99, 99, 99)", "rgb(162, 171, 88)"],
    "eXpresso": ["rgb(173, 83, 137)", "rgb(60, 16, 83)"],
    "Slight Ocean View": ["rgb(168, 192, 255)", "rgb(63, 43, 150)"],
    "Pure Lust": ["rgb(51, 51, 51)", "rgb(221, 24, 24)"],
    "Moon Purple": ["rgb(78, 84, 200)", "rgb(143, 148, 251)"],
    "Red Sunset": ["rgb(53, 92, 125)", "rgb(108, 91, 123)", "rgb(192, 108, 132)"],
    "Shifter": ["rgb(188, 78, 156)", "rgb(248, 7, 89)"],
    "Wedding Day Blues": ["rgb(64, 224, 208)", "rgb(255, 140, 0)", "rgb(255, 0, 128)"],
    "Sand to Blue": ["rgb(62, 81, 81)", "rgb(222, 203, 164)"],
    "Quepal": ["rgb(17, 153, 142)", "rgb(56, 239, 125)"],
    "Pun Yeta": ["rgb(16, 141, 199)", "rgb(239, 142, 56)"],
    "Sublime Light": ["rgb(252, 92, 125)", "rgb(106, 130, 251)"],
    "Sublime Vivid": ["rgb(252, 70, 107)", "rgb(63, 94, 251)"],
    "Bighead": ["rgb(201, 75, 75)", "rgb(75, 19, 79)"],
    "Taran Tado": ["rgb(35, 7, 77)", "rgb(204, 83, 51)"],
    "Relaxing red": ["rgb(255, 251, 213)", "rgb(178, 10, 44)"],
    "Lawrencium": ["rgb(15, 12, 41)", "rgb(48, 43, 99)", "rgb(36, 36, 62)"],
    "Ohhappiness": ["rgb(0, 176, 155)", "rgb(150, 201, 61)"],
    "Delicate": ["rgb(211, 204, 227)", "rgb(233, 228, 240)"],
    "Selenium": ["rgb(60, 59, 63)", "rgb(96, 92, 60)"],
    "Sulphur": ["rgb(202, 197, 49)", "rgb(243, 249, 167)"],
    "Pink Flavour": ["rgb(128, 0, 128)", "rgb(255, 192, 203)"],
    "Rainbow Blue": ["rgb(0, 242, 96)", "rgb(5, 117, 230)"],
    "Orange Fun": ["rgb(252, 74, 26)", "rgb(247, 183, 51)"],
    "Digital Water": ["rgb(116, 235, 213)", "rgb(172, 182, 229)"],
    "Lithium": ["rgb(109, 96, 39)", "rgb(211, 203, 184)"],
    "Argon": ["rgb(3, 0, 30)", "rgb(115, 3, 192)", "rgb(236, 56, 188)", "rgb(253, 239, 249)"],
    "Hydrogen": ["rgb(102, 125, 182)", "rgb(0, 130, 200)", "rgb(0, 130, 200)", "rgb(102, 125, 182)"],
    "Zinc": ["rgb(173, 169, 150)", "rgb(242, 242, 242)", "rgb(219, 219, 219)", "rgb(234, 234, 234)"],
    "Velvet Sun": ["rgb(225, 238, 195)", "rgb(240, 80, 83)"],
    "King Yna": ["rgb(26, 42, 108)", "rgb(178, 31, 31)", "rgb(253, 187, 45)"],
    "Summer": ["rgb(34, 193, 195)", "rgb(253, 187, 45)"],
    "Orange Coral": ["rgb(255, 153, 102)", "rgb(255, 94, 98)"],
    "Purpink": ["rgb(127, 0, 255)", "rgb(225, 0, 255)"],
    "Dull": ["rgb(201, 214, 255)", "rgb(226, 226, 226)"],
    "Kimoby Is The New Blue": ["rgb(57, 106, 252)", "rgb(41, 72, 255)"],
    "Broken Hearts": ["rgb(217, 167, 199)", "rgb(255, 252, 220)"],
    "Subu": ["rgb(12, 235, 235)", "rgb(32, 227, 178)", "rgb(41, 255, 198)"],
    "Socialive": ["rgb(6, 190, 182)", "rgb(72, 177, 191)"],
    "Crimson Tide": ["rgb(100, 43, 115)", "rgb(198, 66, 110)"],
    "Telegram": ["rgb(28, 146, 210)", "rgb(242, 252, 254)"],
    "Terminal": ["rgb(0, 0, 0)", "rgb(15, 155, 15)"],
    "Scooter": ["rgb(54, 209, 220)", "rgb(91, 134, 229)"],
    "Alive": ["rgb(203, 53, 107)", "rgb(189, 63, 50)"],
    "Relay": ["rgb(58, 28, 113)", "rgb(215, 109, 119)", "rgb(255, 175, 123)"],
    "Meridian": ["rgb(40, 60, 134)", "rgb(69, 162, 71)"],
    "Compare Now": ["rgb(239, 59, 54)", "rgb(255, 255, 255)"],
    "Mello": ["rgb(192, 57, 43)", "rgb(142, 68, 173)"],
    "Crystal Clear": ["rgb(21, 153, 87)", "rgb(21, 87, 153)"],
    "Visions of Grandeur": ["rgb(0, 0, 70)", "rgb(28, 181, 224)"],
    "Chitty Chitty Bang Bang": ["rgb(0, 121, 145)", "rgb(120, 255, 214)"],
    "Blue Skies": ["rgb(86, 204, 242)", "rgb(47, 128, 237)"],
    "Sunkist": ["rgb(242, 153, 74)", "rgb(242, 201, 76)"],
    "Coal": ["rgb(235, 87, 87)", "rgb(0, 0, 0)"],
    "Html": ["rgb(228, 77, 38)", "rgb(241, 101, 41)"],
    "Cinnamint": ["rgb(74, 194, 154)", "rgb(189, 255, 243)"],
    "Maldives": ["rgb(178, 254, 250)", "rgb(14, 210, 247)"],
    "Mini": ["rgb(48, 232, 191)", "rgb(255, 130, 53)"],
    "Sha la la": ["rgb(214, 109, 117)", "rgb(226, 149, 135)"],
    "Purplepine": ["rgb(32, 0, 44)", "rgb(203, 180, 212)"],
    "Celestial": ["rgb(195, 55, 100)", "rgb(29, 38, 113)"],
    "Learning and Leading": ["rgb(247, 151, 30)", "rgb(255, 210, 0)"],
    "Pacific Dream": ["rgb(52, 232, 158)", "rgb(15, 52, 67)"],
    "Venice": ["rgb(97, 144, 232)", "rgb(167, 191, 232)"],
    "Orca": ["rgb(68, 160, 141)", "rgb(9, 54, 55)"],
    "Love and Liberty": ["rgb(32, 1, 34)", "rgb(111, 0, 0)"],
    "Very Blue": ["rgb(5, 117, 230)", "rgb(2, 27, 121)"],
    "Can You Feel The Love Tonight": ["rgb(69, 104, 220)", "rgb(176, 106, 179)"],
    "The Blue Lagoon": ["rgb(67, 198, 172)", "rgb(25, 22, 84)"],
    "Under the Lake": ["rgb(9, 48, 40)", "rgb(35, 122, 87)"],
    "Honey Dew": ["rgb(67, 198, 172)", "rgb(248, 255, 174)"],
    "Roseanna": ["rgb(255, 175, 189)", "rgb(255, 195, 160)"],
    "What lies Beyond": ["rgb(240, 242, 240)", "rgb(0, 12, 64)"],
    "Rose Colored Lenses": ["rgb(232, 203, 192)", "rgb(99, 111, 164)"],
    "EasyMed": ["rgb(220, 227, 91)", "rgb(69, 182, 73)"],
    "Cocoaa Ice": ["rgb(192, 192, 170)", "rgb(28, 239, 255)"],
    "Jodhpur": ["rgb(156, 236, 251)", "rgb(101, 199, 247)", "rgb(0, 82, 212)"],
    "Jaipur": ["rgb(219, 230, 246)", "rgb(197, 121, 109)"],
    "Vice City": ["rgb(52, 148, 230)", "rgb(236, 110, 173)"],
    "Mild": ["rgb(103, 178, 111)", "rgb(76, 162, 205)"],
    "Dawn": ["rgb(243, 144, 79)", "rgb(59, 67, 113)"],
    "Ibiza Sunset": ["rgb(238, 9, 121)", "rgb(255, 106, 0)"],
    "Radar": ["rgb(167, 112, 239)", "rgb(207, 139, 243)", "rgb(253, 185, 155)"],
    "80's Purple": ["rgb(65, 41, 90)", "rgb(47, 7, 67)"],
    "Black Rosé": ["rgb(244, 196, 243)", "rgb(252, 103, 250)"],
    "Brady Brady Fun Fun": ["rgb(0, 195, 255)", "rgb(255, 255, 28)"],
    "Ed's Sunset Gradient": ["rgb(255, 126, 95)", "rgb(254, 180, 123)"],
    "Snapchat": ["rgb(255, 252, 0)", "rgb(255, 255, 255)"],
    "Cosmic Fusion": ["rgb(255, 0, 204)", "rgb(51, 51, 153)"],
    "Nepal": ["rgb(222, 97, 97)", "rgb(38, 87, 235)"],
    "Azure Pop": ["rgb(239, 50, 217)", "rgb(137, 255, 253)"],
    "Love Couple": ["rgb(58, 97, 134)", "rgb(137, 37, 62)"],
    "Disco": ["rgb(78, 205, 196)", "rgb(85, 98, 112)"],
    "Limeade": ["rgb(161, 255, 206)", "rgb(250, 255, 209)"],
    "Dania": ["rgb(190, 147, 197)", "rgb(123, 198, 204)"],
    "50 Shades of Grey": ["rgb(189, 195, 199)", "rgb(44, 62, 80)"],
    "Jupiter": ["rgb(255, 216, 155)", "rgb(25, 84, 123)"],
    "IIIT Delhi": ["rgb(128, 128, 128)", "rgb(63, 173, 168)"],
    "Sun on the Horizon": ["rgb(252, 234, 187)", "rgb(248, 181, 0)"],
    "Blood Red": ["rgb(248, 80, 50)", "rgb(231, 56, 39)"],
    "Sherbert": ["rgb(247, 157, 0)", "rgb(100, 243, 140)"],
    "Firewatch": ["rgb(203, 45, 62)", "rgb(239, 71, 58)"],
    "Lush": ["rgb(86, 171, 47)", "rgb(168, 224, 99)"],
    "Frost": ["rgb(0, 4, 40)", "rgb(0, 78, 146)"],
    "Mauve": ["rgb(66, 39, 90)", "rgb(115, 75, 109)"],
    "Royal": ["rgb(20, 30, 48)", "rgb(36, 59, 85)"],
    "Minimal Red": ["rgb(240, 0, 0)", "rgb(220, 40, 30)"],
    "Dusk": ["rgb(44, 62, 80)", "rgb(253, 116, 108)"],
    "Deep Sea Space": ["rgb(44, 62, 80)", "rgb(76, 161, 175)"],
    "Grapefruit Sunset": ["rgb(233, 100, 67)", "rgb(144, 78, 149)"],
    "Sunset": ["rgb(11, 72, 107)", "rgb(245, 98, 23)"],
    "Solid Vault": ["rgb(58, 123, 213)", "rgb(58, 96, 115)"],
    "Bright Vault": ["rgb(0, 210, 255)", "rgb(146, 141, 171)"],
    "Politics": ["rgb(33, 150, 243)", "rgb(244, 67, 54)"],
    "Sweet Morning": ["rgb(255, 95, 109)", "rgb(255, 195, 113)"],
    "Sylvia": ["rgb(255, 75, 31)", "rgb(255, 144, 104)"],
    "Transfile": ["rgb(22, 191, 253)", "rgb(203, 48, 102)"],
    "Tranquil": ["rgb(238, 205, 163)", "rgb(239, 98, 159)"],
    "Red Ocean": ["rgb(29, 67, 80)", "rgb(164, 57, 49)"],
    "Shahabi": ["rgb(168, 0, 119)", "rgb(102, 255, 0)"],
    "Alihossein": ["rgb(247, 255, 0)", "rgb(219, 54, 164)"],
    "Ali": ["rgb(255, 75, 31)", "rgb(31, 221, 255)"],
    "Purple White": ["rgb(186, 83, 112)", "rgb(244, 226, 216)"],
    "Colors Of Sky": ["rgb(224, 234, 252)", "rgb(207, 222, 243)"],
    "Decent": ["rgb(76, 161, 175)", "rgb(196, 224, 229)"],
    "Deep Space": ["rgb(0, 0, 0)", "rgb(67, 67, 67)"],
    "Dark Skies": ["rgb(75, 121, 161)", "rgb(40, 62, 81)"],
    "Suzy": ["rgb(131, 77, 155)", "rgb(208, 78, 214)"],
    "Superman": ["rgb(0, 153, 247)", "rgb(241, 23, 18)"],
    "Nighthawk": ["rgb(41, 128, 185)", "rgb(44, 62, 80)"],
    "Forest": ["rgb(90, 63, 55)", "rgb(44, 119, 68)"],
    "Miami Dolphins": ["rgb(77, 160, 176)", "rgb(211, 157, 56)"],
    "Minnesota Vikings": ["rgb(86, 20, 176)", "rgb(219, 214, 92)"],
    "Christmas": ["rgb(47, 115, 54)", "rgb(170, 58, 56)"],
    "Joomla": ["rgb(30, 60, 114)", "rgb(42, 82, 152)"],
    "Pizelex": ["rgb(17, 67, 87)", "rgb(242, 148, 146)"],
    "Haikus": ["rgb(253, 116, 108)", "rgb(255, 144, 104)"],
    "Pale Wood": ["rgb(234, 205, 163)", "rgb(214, 174, 123)"],
    "Purplin": ["rgb(106, 48, 147)", "rgb(160, 68, 255)"],
    "Inbox": ["rgb(69, 127, 202)", "rgb(86, 145, 200)"],
    "Blush": ["rgb(178, 69, 146)", "rgb(241, 95, 121)"],
    "Back to the Future": ["rgb(192, 36, 37)", "rgb(240, 203, 53)"],
    "Poncho": ["rgb(64, 58, 62)", "rgb(190, 88, 105)"],
    "Green and Blue": ["rgb(194, 229, 156)", "rgb(100, 179, 244)"],
    "Light Orange": ["rgb(255, 183, 94)", "rgb(237, 143, 3)"],
    "Netflix": ["rgb(142, 14, 0)", "rgb(31, 28, 24)"],
    "Little Leaf": ["rgb(118, 184, 82)", "rgb(141, 194, 111)"],
    "Deep Purple": ["rgb(103, 58, 183)", "rgb(81, 45, 168)"],
    "Back To Earth": ["rgb(0, 201, 255)", "rgb(146, 254, 157)"],
    "Master Card": ["rgb(244, 107, 69)", "rgb(238, 168, 73)"],
    "Clear Sky": ["rgb(0, 92, 151)", "rgb(54, 55, 149)"],
    "Passion": ["rgb(229, 57, 53)", "rgb(227, 93, 91)"],
    "Timber": ["rgb(252, 0, 255)", "rgb(0, 219, 222)"],
    "Between Night and Day": ["rgb(44, 62, 80)", "rgb(52, 152, 219)"],
    "Sage Persuasion": ["rgb(204, 204, 178)", "rgb(117, 117, 25)"],
    "Lizard": ["rgb(48, 67, 82)", "rgb(215, 210, 204)"],
    "Piglet": ["rgb(238, 156, 167)", "rgb(255, 221, 225)"],
    "Dark Knight": ["rgb(186, 139, 2)", "rgb(24, 24, 24)"],
    "Curiosity blue": ["rgb(82, 82, 82)", "rgb(61, 114, 180)"],
    "Ukraine": ["rgb(0, 79, 249)", "rgb(255, 249, 76)"],
    "Green to dark": ["rgb(106, 145, 19)", "rgb(20, 21, 23)"],
    "Fresh Turboscent": ["rgb(241, 242, 181)", "rgb(19, 80, 88)"],
    "Koko Caramel": ["rgb(209, 145, 60)", "rgb(255, 209, 148)"],
    "Virgin America": ["rgb(123, 67, 151)", "rgb(220, 36, 48)"],
    "Portrait": ["rgb(142, 158, 171)", "rgb(238, 242, 243)"],
    "Turquoise flow": ["rgb(19, 106, 138)", "rgb(38, 120, 113)"],
    "Vine": ["rgb(0, 191, 143)", "rgb(0, 21, 16)"],
    "Flickr": ["rgb(255, 0, 132)", "rgb(51, 0, 27)"],
    "Instagram": ["rgb(131, 58, 180)", "rgb(253, 29, 29)", "rgb(252, 176, 69)"],
    "Atlas": ["rgb(254, 172, 94)", "rgb(199, 121, 208)", "rgb(75, 192, 200)"],
    "Twitch": ["rgb(100, 65, 165)", "rgb(42, 8, 69)"],
    "Pastel Orange at the Sun": ["rgb(255, 179, 71)", "rgb(255, 204, 51)"],
    "Endless River": ["rgb(67, 206, 162)", "rgb(24, 90, 157)"],
    "Predawn": ["rgb(255, 161, 127)", "rgb(0, 34, 62)"],
    "Purple Bliss": ["rgb(54, 0, 51)", "rgb(11, 135, 147)"],
    "Talking To Mice Elf": ["rgb(148, 142, 153)", "rgb(46, 20, 55)"],
    "Hersheys": ["rgb(30, 19, 12)", "rgb(154, 132, 120)"],
    "Crazy Orange I": ["rgb(211, 131, 18)", "rgb(168, 50, 121)"],
    "Between The Clouds": ["rgb(115, 200, 169)", "rgb(55, 59, 68)"],
    "Metallic Toad": ["rgb(171, 186, 171)", "rgb(255, 255, 255)"],
    "Martini": ["rgb(253, 252, 71)", "rgb(36, 254, 65)"],
    "Friday": ["rgb(131, 164, 212)", "rgb(182, 251, 255)"],
    "ServQuick": ["rgb(72, 85, 99)", "rgb(41, 50, 60)"],
    "Behongo": ["rgb(82, 194, 52)", "rgb(6, 23, 0)"],
    "SoundCloud": ["rgb(254, 140, 0)", "rgb(248, 54, 0)"],
    "Facebook Messenger": ["rgb(0, 198, 255)", "rgb(0, 114, 255)"],
    "Shore": ["rgb(112, 225, 245)", "rgb(255, 209, 148)"],
    "Cheer Up Emo Kid": ["rgb(85, 98, 112)", "rgb(255, 107, 107)"],
    "Amethyst": ["rgb(157, 80, 187)", "rgb(110, 72, 170)"],
    "Man of Steel": ["rgb(120, 2, 6)", "rgb(6, 17, 97)"],
    "Neon Life": ["rgb(179, 255, 171)", "rgb(18, 255, 247)"],
    "Teal Love": ["rgb(170, 255, 169)", "rgb(17, 255, 189)"],
    "Red Mist": ["rgb(0, 0, 0)", "rgb(231, 76, 60)"],
    "Starfall": ["rgb(240, 194, 123)", "rgb(75, 18, 72)"],
    "Dance To Forget": ["rgb(255, 78, 80)", "rgb(249, 212, 35)"],
    "Parklife": ["rgb(173, 209, 0)", "rgb(123, 146, 10)"],
    "Cherryblossoms": ["rgb(251, 211, 233)", "rgb(187, 55, 125)"],
    "Ash": ["rgb(96, 108, 136)", "rgb(63, 76, 107)"],
    "Virgin": ["rgb(201, 255, 191)", "rgb(255, 175, 189)"],
    "Earthly": ["rgb(100, 145, 115)", "rgb(219, 213, 164)"],
    "Dirty Fog": ["rgb(185, 147, 214)", "rgb(140, 166, 219)"],
    "The Strain": ["rgb(135, 0, 0)", "rgb(25, 10, 5)"],
    "Reef": ["rgb(0, 210, 255)", "rgb(58, 123, 213)"],
    "Candy": ["rgb(211, 149, 155)", "rgb(191, 230, 186)"],
    "Autumn": ["rgb(218, 210, 153)", "rgb(176, 218, 185)"],
    "Nelson": ["rgb(242, 112, 156)", "rgb(255, 148, 114)"],
    "Winter": ["rgb(230, 218, 218)", "rgb(39, 64, 70)"],
    "Forever Lost": ["rgb(93, 65, 87)", "rgb(168, 202, 186)"],
    "Almost": ["rgb(221, 214, 243)", "rgb(250, 172, 168)"],
    "Moor": ["rgb(97, 97, 97)", "rgb(155, 197, 195)"],
    "Aqualicious": ["rgb(80, 201, 195)", "rgb(150, 222, 218)"],
    "Misty Meadow": ["rgb(33, 95, 0)", "rgb(228, 228, 217)"],
    "Kyoto": ["rgb(194, 21, 0)", "rgb(255, 197, 0)"],
    "Sirius Tamed": ["rgb(239, 239, 187)", "rgb(212, 211, 221)"],
    "Jonquil": ["rgb(255, 238, 238)", "rgb(221, 239, 187)"],
    "Petrichor": ["rgb(102, 102, 0)", "rgb(153, 153, 102)"],
    "A Lost Memory": ["rgb(222, 98, 98)", "rgb(255, 184, 140)"],
    "Vasily": ["rgb(233, 211, 98)", "rgb(51, 51, 51)"],
    "Blurry Beach": ["rgb(213, 51, 105)", "rgb(203, 173, 109)"],
    "Namn": ["rgb(167, 55, 55)", "rgb(122, 40, 40)"],
    "Day Tripper": ["rgb(248, 87, 166)", "rgb(255, 88, 88)"],
    "Pinot Noir": ["rgb(75, 108, 183)", "rgb(24, 40, 72)"],
    "Miaka": ["rgb(252, 53, 76)", "rgb(10, 191, 188)"],
    "Army": ["rgb(65, 77, 11)", "rgb(114, 122, 23)"],
    "Shrimpy": ["rgb(228, 58, 21)", "rgb(230, 82, 69)"],
    "Influenza": ["rgb(192, 72, 72)", "rgb(72, 0, 72)"],
    "Calm Darya": ["rgb(95, 44, 130)", "rgb(73, 160, 157)"],
    "Bourbon": ["rgb(236, 111, 102)", "rgb(243, 161, 131)"],
    "Stellar": ["rgb(116, 116, 191)", "rgb(52, 138, 199)"],
    "Clouds": ["rgb(236, 233, 230)", "rgb(255, 255, 255)"],
    "Moonrise": ["rgb(218, 226, 248)", "rgb(214, 164, 164)"],
    "Peach": ["rgb(237, 66, 100)", "rgb(255, 237, 188)"],
    "Dracula": ["rgb(220, 36, 36)", "rgb(74, 86, 157)"],
    "Mantle": ["rgb(36, 198, 220)", "rgb(81, 74, 157)"],
    "Titanium": ["rgb(40, 48, 72)", "rgb(133, 147, 152)"],
    "Opa": ["rgb(61, 126, 170)", "rgb(255, 228, 122)"],
    "Sea Blizz": ["rgb(28, 216, 210)", "rgb(147, 237, 199)"],
    "Midnight City": ["rgb(35, 37, 38)", "rgb(65, 67, 69)"],
    "Mystic": ["rgb(117, 127, 154)", "rgb(215, 221, 232)"],
    "Shroom Haze": ["rgb(92, 37, 141)", "rgb(67, 137, 162)"],
    "Moss": ["rgb(19, 78, 94)", "rgb(113, 178, 128)"],
    "Bora Bora": ["rgb(43, 192, 228)", "rgb(234, 236, 198)"],
    "Venice Blue": ["rgb(8, 80, 120)", "rgb(133, 216, 206)"],
    "Electric Violet": ["rgb(71, 118, 230)", "rgb(142, 84, 233)"],
    "Kashmir": ["rgb(97, 67, 133)", "rgb(81, 99, 149)"],
    "Steel Gray": ["rgb(31, 28, 44)", "rgb(146, 141, 171)"],
    "Mirage": ["rgb(22, 34, 42)", "rgb(58, 96, 115)"],
    "Juicy Orange": ["rgb(255, 128, 8)", "rgb(255, 200, 55)"],
    "Mojito": ["rgb(29, 151, 108)", "rgb(147, 249, 185)"],
    "Cherry": ["rgb(235, 51, 73)", "rgb(244, 92, 67)"],
    "Pinky": ["rgb(221, 94, 137)", "rgb(247, 187, 151)"],
    "Sea Weed": ["rgb(76, 184, 196)", "rgb(60, 211, 173)"],
    "Stripe": ["rgb(31, 162, 255)", "rgb(18, 216, 250)", "rgb(166, 255, 203)"],
    "Purple Paradise": ["rgb(29, 43, 100)", "rgb(248, 205, 218)"],
    "Sunrise": ["rgb(255, 81, 47)", "rgb(240, 152, 25)"],
    "Aqua Marine": ["rgb(26, 41, 128)", "rgb(38, 208, 206)"],
    "Aubergine": ["rgb(170, 7, 107)", "rgb(97, 4, 95)"],
    "Bloody Mary": ["rgb(255, 81, 47)", "rgb(221, 36, 118)"],
    "Mango Pulp": ["rgb(240, 152, 25)", "rgb(237, 222, 93)"],
    "Frozen": ["rgb(64, 59, 74)", "rgb(231, 233, 187)"],
    "Rose Water": ["rgb(229, 93, 135)", "rgb(95, 195, 228)"],
    "Horizon": ["rgb(0, 57, 115)", "rgb(229, 229, 190)"],
    "Monte Carlo": ["rgb(204, 149, 192)", "rgb(219, 212, 180)", "rgb(122, 161, 210)"],
    "Lemon Twist": ["rgb(60, 165, 92)", "rgb(181, 172, 73)"],
    "Emerald Water": ["rgb(52, 143, 80)", "rgb(86, 180, 211)"],
    "Intuitive Purple": ["rgb(218, 34, 255)", "rgb(151, 51, 238)"],
    "Green Beach": ["rgb(2, 170, 176)", "rgb(0, 205, 172)"],
    "Sunny Days": ["rgb(237, 229, 116)", "rgb(225, 245, 196)"],
    "Playing with Reds": ["rgb(211, 16, 39)", "rgb(234, 56, 77)"],
    "Harmonic Energy": ["rgb(22, 160, 133)", "rgb(244, 208, 63)"],
    "Cool Brown": ["rgb(96, 56, 19)", "rgb(178, 159, 148)"],
    "YouTube": ["rgb(229, 45, 39)", "rgb(179, 18, 23)"],
    "Noon to Dusk": ["rgb(255, 110, 127)", "rgb(191, 233, 255)"],
    "Hazel": ["rgb(119, 161, 211)", "rgb(121, 203, 202)", "rgb(230, 132, 174)"],
    "Nimvelo": ["rgb(49, 71, 85)", "rgb(38, 160, 218)"],
    "Sea Blue": ["rgb(43, 88, 118)", "rgb(78, 67, 118)"],
    "Blooker20": ["rgb(230, 92, 0)", "rgb(249, 212, 35)"],
    "Sexy Blue": ["rgb(33, 147, 176)", "rgb(109, 213, 237)"],
    "Purple Love": ["rgb(204, 43, 94)", "rgb(117, 58, 136)"],
    "DIMIGO": ["rgb(236, 0, 140)", "rgb(252, 103, 103)"],
    "Skyline": ["rgb(20, 136, 204)", "rgb(43, 50, 178)"],
    "Sel": ["rgb(0, 70, 127)", "rgb(165, 204, 130)"],
    "Sky": ["rgb(7, 101, 133)", "rgb(255, 255, 255)"],
    "Petrol": ["rgb(187, 210, 197)", "rgb(83, 105, 118)"],
    "Anamnisar": ["rgb(151, 150, 240)", "rgb(251, 199, 212)"],
    "Copper": ["rgb(183, 152, 145)", "rgb(148, 113, 107)"],
    "Royal Blue + Petrol": ["rgb(187, 210, 197)", "rgb(83, 105, 118)", "rgb(41, 46, 73)"],
    "Royal Blue": ["rgb(83, 105, 118)", "rgb(41, 46, 73)"],
    "Windy": ["rgb(172, 182, 229)", "rgb(134, 253, 232)"],
    "Rea": ["rgb(255, 224, 0)", "rgb(121, 159, 12)"],
    "Bupe": ["rgb(0, 65, 106)", "rgb(228, 229, 230)"],
    "Mango": ["rgb(255, 226, 89)", "rgb(255, 167, 81)"],
    "Reaqua": ["rgb(121, 159, 12)", "rgb(172, 187, 120)"],
    "Lunada": ["rgb(84, 51, 255)", "rgb(32, 189, 255)", "rgb(165, 254, 203)"],
    "Bluelagoo": ["rgb(0, 82, 212)", "rgb(67, 100, 247)", "rgb(111, 177, 252)"],
    "Anwar": ["rgb(51, 77, 80)", "rgb(203, 202, 165)"],
    "Combi": ["rgb(0, 65, 106)", "rgb(121, 159, 12)", "rgb(255, 224, 0)"],
    "Ver Black": ["rgb(247, 248, 248)", "rgb(172, 187, 120)"],
    "Ver": ["rgb(255, 224, 0)", "rgb(121, 159, 12)"],
    "Blu": ["rgb(0, 65, 106)", "rgb(228, 229, 230)"]
};

class BaseChartEditForm extends EditForm {
//    tabcontent = {};

    opencontent() {
        var target = $(this).attr('target');
        var shevron = $(this);
        if ($(this).hasClass("button_title_adv"))
        {
            shevron = $(this).find('i');
        }
        $('#' + $(this).attr('target')).fadeToggle(500, function () {
            if ($('#' + target).css('display') === 'block')
            {
                shevron.removeClass("fa-chevron-circle-down");
                shevron.addClass("fa-chevron-circle-up");
            } else
            {
                shevron.removeClass("fa-chevron-circle-up");
                shevron.addClass("fa-chevron-circle-down");

            }
        });
    }

    constructor(chart, formwraper, row, index, dashJSON, aftermodifier = null) {
//        this.chart = chart;
        super(formwraper, row, index, dashJSON, aftermodifier);
        // Add castoms
        this.deflist["title.show"] = true;
        this.deflist["max"] = "";
        this.deflist["min"] = "";

        this.jspluginsinit();
    }
    jspluginsinit()
    {
        super.jspluginsinit();
        this.axesmode();
        this.typemode();
        this.initzoomtype();
        var current = this;
        this.formwraper.find('[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            if (e.delegateTarget.hash === "#tab_data_zoom")
            {
                var contener = $(e.delegateTarget.hash + ' .form_main_block[key_path="options.dataZoom"]');
                current.repaintdatazoom(contener, current.gettabcontent('tab_data_zoom').forms[0].content[0].content);
            }
            if (e.delegateTarget.hash === "#tab_metric")
            {
                var contener = $(e.delegateTarget.hash + ' .form_main_block[key_path="q"]');
                current.repaintq(contener, current.gettabcontent('tab_metric').forms[0].content);
            }
            if (contener)
            {
                contener.find("select").select2({minimumResultsForSearch: 15});
                contener.find('[data-toggle="tooltip"]').tooltip();
            }

        });

    }
    axesmode() {
        this.formwraper.find('[name=axes_mode_x]').each(function () {
            if ($(this).val() === 'category') {
                $(this).parent().parent().find('.only-Series').show();
            } else {
                $(this).parent().parent().find('.only-Series').hide();
            }
        });
    }

    typemode(duration = 0) {

        this.formwraper.find('[name=display_charttype]').each(function () {
            switch ($(this).val()) {
                case 'line':
                    $(this).parents('.edit-display').find('.custominputs .typeline').fadeIn(duration);
                    $(this).parents('.edit-display').find('.custominputs >:not(.typeline)').fadeOut(duration);
                    break

                case 'bar':  // if (x === 'value2')
                    $(this).parents('.edit-display').find('.custominputs >:not(.typebars)').fadeOut(duration);
                    $(this).parents('.edit-display').find('.custominputs >.typebars').fadeIn(duration);

                    break
                case 'pie':  // if (x === 'value2')
                    $(this).parents('.edit-display').find('.custominputs >:not(.typepie)').fadeOut(duration);
                    $(this).parents('.edit-display').find('.custominputs >.typepie').fadeIn(duration);

                    break
                case 'treemap':  // if (x === 'value2')
                    $(this).parents('.edit-display').find('.custominputs >:not(.typemap)').fadeOut(duration);
                    $(this).parents('.edit-display').find('.custominputs >.typemap').fadeIn(duration);

                    break
                case 'funnel':  // if (x === 'value2')
                    $(this).parents('.edit-display').find('.custominputs >:not(.typefunnel)').fadeOut(duration);
                    $(this).parents('.edit-display').find('.custominputs >.typefunnel').fadeIn(duration);

                    break
                case 'gauge':  // if (x === 'value2')
                    $(this).parents('.edit-display').find('.custominputs >:not(.typegauge)').fadeOut(duration);
                    $(this).parents('.edit-display').find('.custominputs >.typegauge').fadeIn(duration);
                    break
                default:
                    $(this).parents('.edit-display').find('.custominputs > .form-group').fadeOut(duration);
                    break
            }
            $(this).parents('.edit-display').find('.custominputs > .typeall').fadeIn(0);

        });
    }

    gettabs()
    {
        return [{id: "general-tab", title: locale["editchartform.general"], contentid: "tab_general"},
            {id: "metrics-tab", title: locale["metrics"], contentid: "tab_metric"},
            {id: "axes-tab", title: locale["editchartform.axes"], contentid: "tab_axes"},
            {id: "data_zoom_tab", title: locale["editchartform.dataZoom"], contentid: "tab_data_zoom"},
            {id: "legend-tab", title: locale["editchartform.legend"], contentid: "tab_legend"},
            {id: "display-tab", title: locale["display"], contentid: "tab_display"},
            {id: "time-tab", title: locale["editchartform.timeRange"], contentid: "tab_time"},
            {id: "json-tab", title: locale["editchartform.json"], contentid: "tab_json"}
        ];
    }

    getdefvalue(path)
    {
        if (path === null)
        {
            return this.deflist;
        }
        return this.deflist[path];
    }

    inittabcontent()
    {
        super.inittabcontent();
        var edit_chart_title = {tag: "form", class: "form-horizontal form-label-left col-5", id: "edit_chart_title", label: {show: true, text: locale["info"]}};
        edit_chart_title.content = [{tag: "div", class: "form-group form-group-custom",
                content: [
                    {tag: "label", class: "control-label control-label-custom", text: locale["title"], lfor: "title_text"},
                    {tag: "input", type: "text", class: "form-control title_input_large", prop_key: "text", id: "title_text", name: "title_text", key_path: 'title.text', default: ""},
                    {tag: "label", class: "control-label control-label-custom2", text: locale["editchartform.fontSize"], lfor: "title_font"},
                    {tag: "input", type: "number", class: "form-control title_input_large general_font", prop_key: "text", id: "title_font", name: "title_font", key_path: 'title.style.fontSize', default: "18"},
                    {tag: "i", class: "dropdown_button fa fa-chevron-circle-down", target: "title_subtitle", id: "button_title_subtitle", actions: {click: this.opencontent}},
                    {tag: "div", class: "form-group form-group-custom", style: "display: none;", id: "title_subtitle",
                        content: [
                            {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.link"], lfor: "title_link"},
                            {tag: "input", type: "text", class: "form-control title_input", prop_key: "link", id: "title_link", name: "title_link", key_path: 'title.link', default: ""},
                            {tag: "label", class: "control-label control-label-custom2", text: locale["editchartform.target"], lfor: "title_target"},
                            {tag: "select", class: "form-control title_select_gen", prop_key: "target", id: "title_target", name: "title_target", key_path: 'title.target', default: "", options: this.targetoptions}
                        ]
                    }

                ]},
            {tag: "div", class: "form-group form-group-custom",
                content: [
                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.description"], lfor: "title_subtext"},
                    {tag: "input", type: "text", class: "form-control title_input_large", prop_key: "subtext", id: "title_subtext", name: "title_subtext", key_path: 'title.subtext', default: ""},
                    {tag: "label", class: "control-label control-label-custom2", text: locale["editchartform.fontSize"], lfor: "description_font"},
                    {tag: "input", type: "number", class: "form-control title_input_large general_font", prop_key: "text", id: "description_font", name: "description_font", key_path: 'title.subtextStyle.fontSize', default: "12"},
                    {tag: "i", class: "dropdown_button fa fa-chevron-circle-down", target: "title_subdescription", id: "button_title_description", actions: {click: this.opencontent}},
                    {tag: "div", class: "form-group form-group-custom", style: "display: none;", id: "title_subdescription",
                        content: [
                            {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.link"], lfor: "title_sublink"},
                            {tag: "input", type: "text", class: "form-control title_input", prop_key: "sublink", id: "title_sublink", name: "title_sublink", key_path: 'title.sublink', default: ""},
                            {tag: "label", class: "control-label control-label-custom2", text: locale["editchartform.target"], lfor: "title_subtarget"},
                            {tag: "select", class: "form-control title_select_gen ", prop_key: "subtarget", id: "title_subtarget", name: "title_subtarget", key_path: 'title.subtarget', default: "", options: this.targetoptions}
                        ]
                    }

                ]},
            {tag: "div", class: "raw", content: [
                    {tag: "div", id: "buttons_div", content: [
                            {tag: "button", type: "button", class: "btn btn-outline-primary btn-sm m-1 button_title_adv", target: "position_block", id: "button_title_position", text: locale["editchartform.positions"], content: [{tag: "i", class: "fa fa-chevron-circle-down"}], actions: {click: this.opencontent}},
                            {tag: "button", type: "button", class: "btn btn-outline-primary btn-sm m-1 button_title_adv", target: "color_block", id: "button_title_color", text: locale["editchartform.colors"], content: [{tag: "i", class: "fa fa-chevron-circle-down"}], actions: {click: this.opencontent}},
                            {tag: "button", type: "button", class: "btn btn-outline-primary btn-sm m-1 button_title_adv", target: "border_block", id: "button_title_border", text: locale["editchartform.border"], content: [{tag: "i", class: "fa fa-chevron-circle-down"}], actions: {click: this.opencontent}}
                        ]}
                ]},
            {tag: "div", id: "position_block", style: "display: none;", content: [{
                        tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: "X", lfor: "title_x_position"},
                            {tag: "select", class: "form-control title_select", prop_key: "x", id: "title_x_position", name: "title_x_position", key_path: 'title.x', default: "", options: this.xpositionoptions},
//                            {tag: "label", class: "control-label control-label-custom3 control_label_or", text: locale["editchartform.OR"]},
                            {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "x", id: "title_x_position_text", name: "title_x_position_text", key_path: 'title.x', placeholder: "or px", default: ""},
//                            {tag: "label", class: "control-label control-label-custom3 control_label_custom3", text: "px"},
                            {tag: "label", class: "control-label control-label_Y", text: "Y", lfor: "title_y_position"},
                            {tag: "select", class: "form-control title_select", prop_key: "y", id: "title_y_position", name: "title_y_position", key_path: 'title.y', default: "", options: this.ypositionoptions},
//                            {tag: "label", class: "control-label control-label-custom3 control_label_or", text: locale["editchartform.OR"]},
                            {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "y", id: "title_y_position_text", name: "title_y_position_text", key_path: 'title.y', placeholder: "or px", default: ""},
//                            {tag: "label", class: "control-label control-label-custom3 control_label_custom3", text: "px"}
                        ]
                    }]},
            {tag: "div", id: "color_block", style: "display: none;", content: [{
                        tag: "div", class: "form-group form-group-custom", id: "title_color", content: [
                            {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.border"], lfor: "title_border_color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "borderColor", id: "title_border_color", name: "title_border_color", key_path: 'title.style.borderColor', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]},
                            {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.background"], lfor: "title_background_color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "backgroundColor", id: "title_background_color", name: "title_background_color", key_path: 'title.style.backgroundColor', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}

                        ]
                    },

                    {tag: "div", class: "form-group form-group-custom ", content: [
                            {tag: "label", class: "control-label control-label-custom", text: locale["title"], lfor: "title_name_color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "TitleColor", id: "title_name_color", name: "title_name_color", key_path: 'title.style.color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]},
                            {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.description"], lfor: "title_description_color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "descriptioncolor", id: "title_description_color", name: "title_description_color", key_path: 'title.subtextStyle.color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}

                        ]
                    }]},

            {tag: "div", id: "border_block", style: "display: none;", content: [{
                        tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.color"], lfor: "title_border_color"},
                            {tag: "div", class: "titile_input_midle", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [
                                            {tag: "input", type: "text", class: "form-control", prop_key: "borderColor", id: "title_border_color", name: "title_border_color", key_path: 'title.style.borderColor', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]},
                            {tag: "label", class: "control-label control-label2", text: locale["editchartform.width"], lfor: "title_border_width"},
                            {tag: "div", class: "titile_input_midle2", content: [
                                    {tag: "div", class: "input-group", content: [
                                            {tag: "input", type: "number", class: "form-control titile_input_midle", prop_key: "borderWidth", id: "title_border_width", name: "title_border_width", key_path: 'title.style.borderWidth', default: ""}
                                        ]}
                                ]}
                        ]
                    }]}
        ];

        this.tabcontent.tab_general.forms.splice(0, 0, edit_chart_title);

        this.tabcontent.tab_axes = {};
        var edit_axes_y = {tag: "div", class: 'form_main_block col-3', id: "edit_y", label: {show: true, text: locale["editchartform.Yaxes"]}};
        var current = this;

        var axes_template = [{tag: "form", class: "form-horizontal form-label-left edit-axes", id: "{index}_yaxes", content: [
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.show"], lfor: "axes_show_y"},
                            {tag: "input", type: "checkbox", class: "js-switch-small axes_show_y", prop_key: "show", id: "{index}_axes_show_y", name: "axes_show_y", key_path: 'show', default: true}
                        ]},

                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.text"], lfor: "axes_name_y"},
                            {tag: "input", type: "text", class: "form-control axes_select", prop_key: "name", id: "{index}_axes_name_y", name: "axes_name_y", key_path: 'name', default: ""}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.position"], lfor: "axes_position_y"},
                            {tag: "select", class: "form-control axes_select", prop_key: "position", id: "{index}_axes_position_y", name: "axes_position_y", key_path: 'position', default: "", options: this.ypos}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.splitNumber"], lfor: "axes_splitNumber_y"},
                            {tag: "input", type: "number", class: "form-control axes_select", prop_key: "splitNumber", id: "{index}_splitNumber_y", name: "splitNumber_y", key_path: 'splitNumber', default: ""}
                        ]},

                    {tag: "div", class: "form-group  ", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.Ycolor"], lfor: "axes_color_y"},

                            {tag: "div", class: "titile_input_midle axes_select ", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input hasdublicatepath", content: [
                                            {tag: "input", type: "text", class: "form-control ", prop_key: "ycolor", id: "{index}_ycolor", name: "ycolor", key_path: 'axisLine.lineStyle.color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.fontSizeLabel"], lfor: "lable_size_y"},
                            {tag: "input", type: "number", class: "form-control axes_select axis_input-size", prop_key: "size_x", id: "{index}_label_size_y", name: "lable_size_y", key_path: 'axisLabel.fontSize', default: "12"},
                            {tag: "label", class: "control-label control-label-custom-legend axis_lable-size", text: locale["editchartform.text"], lfor: "text_size_x"},
                            {tag: "input", type: "number", class: "form-control axes_select axis_input-size", prop_key: "text_size_y", id: "{index}_text_size_y", name: "text_size_y", key_path: 'nameTextStyle.fontSize', default: "12"}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.unit"], lfor: "axes_unit_y"},
                            {tag: "select", class: "form-control axes_select", prop_key: "unit", id: "{index}_axes_unit_y", name: "axes_unit_y", key_path: 'unit', default: "", options: this.units}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.Y-Min"], lfor: "axes_min_y"},
                            {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "min", id: "{index}_axes_min_y", name: "axes_min_y", key_path: 'min', default: ""},
                            {tag: "label", class: "control-label control-label-custom-axes", text: locale["editchartform.Y-Max"], lfor: "axes_max_y"},
                            {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "max", id: "{index}_axes_max_y", name: "axes_max_y", key_path: 'max', default: ""}
                        ]},
//                   

                    {tag: "div", class: "btn btn-outline-success dublicateq btn-sm m-1", id: "{index}_dublicateaxesy",
                        text: locale["editchartform.dublicate"],
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                var qitem = clone_obg(current.dashJSON.rows[current.row].widgets[current.index].options.yAxis[curindex]);
                                current.dashJSON.rows[current.row].widgets[current.index].options.yAxis.splice(curindex, 0, qitem);
                                var contener = $(this).parent().parent();
                                contener.html("");
                                current.drawcontent(edit_axes_y.content[0].content, contener, current.dashJSON.rows[current.row].widgets[current.index]);
                                current.change($(this));
                                current.formwraper.find('.cl_picer_input').colorpicker({format: 'rgba'}).on('hidePicker', function () {
                                    current.change($(this).find("input"));
                                });
                            }
                        }
                    },
                    {tag: "div", class: "btn btn-outline-danger removeq btn-sm m-1", id: "{index}_removeaxesy",
                        text: locale["editchartform.remove"],
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                current.dashJSON.rows[current.row].widgets[current.index].options.yAxis.splice(curindex, 1);
                                var contener = $(this).parent().parent();
                                contener.html("");
                                current.drawcontent(edit_axes_y.content[0].content, contener, current.dashJSON.rows[current.row].widgets[current.index]);
                                current.change($(this));
                                current.formwraper.find('.cl_picer_input').colorpicker({format: 'rgba'}).on('hidePicker', function () {
                                    current.change($(this).find("input"));
                                });
                            }
                        }
                    }
                ]}];
        edit_axes_y.content = [{tag: "div", class: "form_main_block", content: [{tag: "button", class: "btn btn-outline-success Addq btn-sm m-1",
                        text: locale["editchartform.add"],
                        id: "addq",
                        key_path: "options.yAxis",
                        template: axes_template,
                        actions: {click: function () {
                                if (!current.dashJSON.rows[current.row].widgets[current.index].options.yAxis)
                                {
                                    current.dashJSON.rows[current.row].widgets[current.index].options.yAxis = [];
                                }
                                current.dashJSON.rows[current.row].widgets[current.index].options.yAxis.push({});
                                var contener = $(this).parent();
                                contener.html("");
                                current.drawcontent(edit_axes_y.content[0].content, contener, current.dashJSON.rows[current.row].widgets[current.index]);
                                current.formwraper.find('.cl_picer_input').colorpicker({format: 'rgba'}).on('hidePicker', function () {
                                    current.change($(this).find("input"));
                                });

                            }
                        }
                    }
                ]}]
                ;

        var edit_axes_x = {tag: "section", class: 'form_main_block col-3', id: "edit_x", label: {show: true, text: locale["editchartform.Xaxes"]}};
        var current = this;

        var axes_template = [{tag: "form", class: "form-horizontal form-label-left edit-axes", id: "{index}_xaxes", content: [
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.show"], lfor: "axes_show_x"},
                            {tag: "input", type: "checkbox", class: "js-switch-small axes_show_x", prop_key: "show", id: "{index}_axes_show_x", name: "axes_show_x", key_path: 'show', default: true}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.text"], lfor: "axes_name_x"},
                            {tag: "input", type: "text", class: "form-control axes_select", prop_key: "name", id: "{index}_axes_name_x", name: "axes_name_x", key_path: 'name', default: ""}
                        ]},

                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.position"], lfor: "axes_position_x"},
                            {tag: "select", class: "form-control axes_select", prop_key: "position", id: "{index}_axes_position_x", name: "axes_position_x", key_path: 'position', default: "", options: this.xpos}
                        ]},

                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.splitNumber"], lfor: "axes_splitNumber_x"},
                            {tag: "input", type: "number", class: "form-control axes_select", prop_key: "splitNumber", id: "{index}_splitNumber_x", name: "splitNumber_x", key_path: 'splitNumber', default: ""}
                        ]},

                    {tag: "div", class: "form-group ", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.Xcolor"], lfor: "axes_color_x"},

                            {tag: "div", class: "titile_input_midle axes_select ", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input hasdublicatepath", content: [
                                            {tag: "input", type: "text", class: "form-control axes_select ", prop_key: "xcolor", id: "{index}_xcolor", name: "xcolor", key_path: 'axisLine.lineStyle.color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.fontSizeLabel"], lfor: "lable_size_x"},
                            {tag: "input", type: "number", class: "form-control axes_select axis_input-size", prop_key: "size_x", id: "{index}_label_size_x", name: "lable_size_x", key_path: 'axisLabel.fontSize', default: "12"},
                            {tag: "label", class: "control-label control-label-custom-legend axis_lable-size", text: locale["editchartform.text"], lfor: "text_size_x"},
                            {tag: "input", type: "number", class: "form-control axes_select axis_input-size", prop_key: "text_size_x", id: "{index}_text_size_x", name: "text_size_x", key_path: 'nameTextStyle.fontSize', default: "12"}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.scale"], lfor: "axes_mode_x"},
                            {tag: "select", class: "form-control axes_select", prop_key: "type", id: "{index}_axes_mode_x", name: "axes_mode_x", key_path: 'type', default: "time", options: {time: locale["editchartform.time"], category: locale["editchartform.series"]}, actions: {"change": function () {
                                        if ($(this).val() === 'category') {
                                            $(this).parent().parent().find('.only-Series').fadeIn();
                                        } else {
                                            $(this).parent().parent().find('.only-Series').fadeOut();
                                        }
                                    }}}
                        ]},
                    {tag: "div", class: "form-group form-group-custom only-Series", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.value"], lfor: "axes_value_x"},
                            {tag: "select", class: "form-control axes_select", prop_key: "m_sample", id: "{index}_axes_value_x", name: "axes_value_x", key_path: 'm_sample', default: "", options: {"avg": "Avg",
                                    "min": "Min",
                                    "max": "Max",
                                    "total": "Total",
                                    "count": "Count",
                                    "current": "Current",
                                    "product": "Product"}}
                        ]},

                    {tag: "div", class: "btn btn-outline-success dublicateq btn-sm m-1", id: "{index}_dublicateaxesx",
                        text: locale["editchartform.dublicate"],
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                var qitem = clone_obg(current.dashJSON.rows[current.row].widgets[current.index].options.xAxis[curindex]);
                                current.dashJSON.rows[current.row].widgets[current.index].options.xAxis.splice(curindex, 0, qitem);
                                var contener = $(this).parent().parent();
                                contener.html("");
                                current.drawcontent(edit_axes_x.content[0].content, contener, current.dashJSON.rows[current.row].widgets[current.index]);
                                current.axesmode();
                                current.change($(this));
                                current.formwraper.find('.cl_picer_input').colorpicker({format: 'rgba'}).on('hidePicker', function () {
                                    current.change($(this).find("input"));
                                });
                            }
                        }
                    },
                    {tag: "div", class: "btn btn-outline-danger removeq btn-sm m-1", id: "{index}_removeaxesx",
                        text: locale["editchartform.remove"],
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                current.dashJSON.rows[current.row].widgets[current.index].options.xAxis.splice(curindex, 1);
                                var contener = $(this).parent().parent();
                                contener.html("");
                                current.drawcontent(edit_axes_x.content[0].content, contener, current.dashJSON.rows[current.row].widgets[current.index]);
                                current.axesmode();
                                current.change($(this));
                                current.formwraper.find('.cl_picer_input').colorpicker({format: 'rgba'}).on('hidePicker', function () {
                                    current.change($(this).find("input"));
                                });
                            }
                        }
                    }
                ]}];
        edit_axes_x.content = [{tag: "div", class: "form_main_block", content: [{tag: "button", class: "btn btn-outline-success Addq btn-sm m-1",
                        text: locale["editchartform.add"],
                        id: "addq",
                        key_path: "options.xAxis",
                        template: axes_template,
                        actions: {click: function () {
                                if (!current.dashJSON.rows[current.row].widgets[current.index].options.xAxis)
                                {
                                    current.dashJSON.rows[current.row].widgets[current.index].options.xAxis = [];
                                }
                                current.dashJSON.rows[current.row].widgets[current.index].options.xAxis.push({});
                                var contener = $(this).parent();
                                contener.html("");
                                current.drawcontent(edit_axes_x.content[0].content, contener, current.dashJSON.rows[current.row].widgets[current.index]);
                                current.axesmode();
                                current.formwraper.find('.cl_picer_input').colorpicker({format: 'rgba'}).on('hidePicker', function () {
                                    current.change($(this).find("input"));
                                });

                            }
                        }
                    }
                ]}]
                ;
//        this.tabcontent.tab_axes.active = true;
        this.tabcontent.tab_axes.forms = [edit_axes_y, edit_axes_x];

        this.tabcontent.tab_legend = {};
//        var edit_legend = {tag: "div", class: 'form-horizontal form-label-left edit-legend pull-left', id: "edit_legend", label: {show: true, text: 'Legend'}};

        var edit_legend = {tag: "div", class: "form-horizontal form-label-left edit-legend col", id: "edit_legend", label: {show: true, text: locale["editchartform.legend"], checker: {tag: "input", type: "checkbox", class: "js-switch-small", prop_key: "show", id: "legend_show", name: "legend_show", key_path: 'options.legend.show', default: true}}};
        edit_legend.content = [{tag: "div", class: "legendform row", content: [
                    {tag: "div", class: "form_main_block col-2", content: [
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.orient"], lfor: "legend_orient"},
                                    {tag: "select", class: "form-control title_select", prop_key: "orient", id: "legend_orient", name: "legend_orient", key_path: 'options.legend.orient', default: "", options: this.legendOrient}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.selectMode"], lfor: "legend_select_mode"},
                                    {tag: "select", class: "form-control title_select", prop_key: "selectedMode", id: "legend_mode", name: "legend_select_mode", key_path: 'options.legend.selectedMode', default: "", options: this.legendMode}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.background"], lfor: "legend_background_color"},
                                    {tag: "div", class: "color-button", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_noinput colorpicker-element", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "backgroundColor", id: "legend_background_color", name: "legend_background_color", key_path: 'options.legend.backgroundColor', default: ""},
                                                    {tag: "span", class: "input-group-addon legend_bg", content: [{tag: "i"}]}
                                                ]}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.textColor"], lfor: "legend_text_color"},
                                    {tag: "div", class: "color-button", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_noinput colorpicker-element", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "color", id: "legend_text_color", name: "legend_text_color", key_path: 'options.legend.textStyle.color', default: ""},
                                                    {tag: "span", class: "input-group-addon legend_clTxt", content: [{tag: "i"}]}
                                                ]}
                                        ]}
                                ]}
                        ]},
                    {tag: "div", class: "form_main_block col-3", content: [
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom-legend", text: "X", lfor: "legend_x_position"},
                                    {tag: "select", class: "form-control title_select", prop_key: "x", id: "legend_x_position", name: "legend_x_position", key_path: 'options.legend.x', default: "", options: this.xpositionoptions},
//                                    {tag: "label", class: "control-label control-label-custom-legend2", text: locale["editchartform.OR"]},
                                    {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "x", id: "legend_x_position_text", name: "legend_x_position_text", key_path: 'options.legend.x', placeholder: "or px", default: ""},
//                                    {tag: "label", class: "control-label control-label-custom3 control_label_custom3", text: "px"}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom-legend", text: "Y", lfor: "legend_y_position"},
                                    {tag: "select", class: "form-control title_select", prop_key: "y", id: "legend_y_position", name: "legend_y_position", key_path: 'options.legend.y', default: "", options: this.ypositionoptions},
//                                    {tag: "label", class: "control-label control-label-custom-legend2", text: locale["editchartform.OR"]},
                                    {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "y", id: "legend_y_position_text", name: "legend_y_position_text", key_path: 'options.legend.y', placeholder: "or px", default: ""},
//                                    {tag: "label", class: "control-label control-label-custom3 control_label_custom3", text: "px"}
                                ]},                            
                        ]},
                    {tag: "div", class: "form_main_block col-3", content: [
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.shapeWidth"], lfor: "legend_shape_width"},
                                    {tag: "input", type: "number", class: "form-control title_select", prop_key: "itemWidth", id: "legend_shape_width", name: "legend_shape_width", key_path: 'options.legend.itemWidth', placeholder: " px", default: ""},
                                    {tag: "label", class: "control-label control-label-custom-legend2", text: locale["editform.height"], lfor: "legend_shape_height"},
                                    {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "itemHeight", id: "legend_shape_height", name: "legend_shape_height", key_path: 'options.legend.itemHeight', placeholder: " px", default: ""},
//                                    {tag: "label", class: "control-label control-label-custom3 control_label_custom3", text: "px"}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.borderColor"], lfor: "legend_border_color"},
                                    {tag: "div", class: "color-button align-bottom ", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_noinput colorpicker-element", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "borderColor", id: "legend_border_color", name: "legend_border_color", key_path: 'options.legend.borderColor', default: ""},
                                                    {tag: "span", class: "input-group-addon legend_clBorder", content: [{tag: "i"}]}
                                                ]}
                                        ]},
                                    {tag: "label", class: "control-label control-label-custom-legend3", text: locale["editchartform.width"], lfor: "legend_border_width"},
                                    {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "borderWidth", id: "legend_border_width", name: "legend_border_width", key_path: 'options.legend.borderWidth', placeholder: " px", default: ""},
//                                    {tag: "label", class: "control-label control-label-custom3 control_label_custom3", text: "px"}
                            ]}
                    ]}
                ]}];


        this.tabcontent.tab_legend.forms = [edit_legend];

        //SURO
        this.tabcontent.tab_display = {};//suren

        var edit_display = {tag: "div", class: 'forms col-12', id: "edit_display"};
        edit_display.content = [{tag: "div", class: "form-horizontal form-label-left edit-display row",
                content: [
                    {tag: "div", class: "form_main_block float-left", content: [
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.type"], lfor: "display_charttype"},
                                    {tag: "select", class: "form-control title_input_small", prop_key: "type", id: "display_charttype", name: "display_charttype", key_path: 'type', default: "", options: {
                                            "line": locale["editchartform.lines"],
                                            "bar": locale["editchartform.bars"],
                                            "pie": locale["editchartform.pie"],
                                            "gauge": locale["editchartform.gauge"],
                                            "funnel": locale["editchartform.funnel"],
                                            "treemap": locale["editchartform.treemap"]
                                        }, actions: {change: function () {
                                                current.typemode("slow");

                                            }
                                        }},
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.background"], lfor: "backgroundColor"},
                                    {tag: "div", class: "color-button", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_noinput colorpicker-element", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "backgroundColor", id: "backgroundColor", name: "backgroundColor", key_path: 'options.backgroundColor', default: ""},
                                                    {tag: "span", class: "input-group-addon display_bg", content: [{tag: "i"}]}
                                                ]}
                                        ]}

                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.animation"], lfor: "display_animation"},
                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                                            {tag: "input", type: "checkbox", class: "js-switch-small", checked: "checked", prop_key: "animation", id: "display_animation", name: "display_animation", key_path: 'options.animation', default: true}
                                        ]},
                                    {tag: "label", class: "control-label control-label-custom155", text: locale["editchartform.containsLabel"], lfor: "display_containLabel"},
                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                                            {tag: "input", type: "checkbox", class: "js-switch-small", checked: "checked", prop_key: "containLabel", id: "display_containLabel", name: "display_containLabel", key_path: 'options.grid.containLabel', default: true}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.left"], lfor: "padding_left"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_left", name: "padding_left", prop_key: "x", key_path: 'options.grid.x'},
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.top"], lfor: "padding_top"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_top", name: "padding_top", prop_key: "y", key_path: 'options.grid.y'}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.right"], lfor: "padding_right"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_right", name: "padding_right", prop_key: "x2", key_path: 'options.grid.x2'},
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.bottom"], lfor: "padding_bottom"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_bottom", name: "padding_bottom", prop_key: "y2", key_path: 'options.grid.y2'}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.width"], lfor: "padding_width"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_width", name: "padding_width", prop_key: "width", key_path: 'options.grid.width'},
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editform.height"], lfor: "padding_height"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_height", name: "padding_height", prop_key: "height", key_path: 'options.grid.height'}

                                ]}
                        ]},
                    {tag: "div", class: "form_main_block float-left custominputs", label: {show: true, text: locale["editchartform.options"], class: "typeline typebars"}, content: [
                            {tag: "div", class: "form-group form-group-custom typeline", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.points"], lfor: "display_points"},
                                    {tag: "select", class: "form-control title_select", prop_key: "points", id: "display_points", name: "display_points", key_path: 'points', default: "none", options: {
                                            "none": "None",
                                            "circle": locale["editchartform.circle"],
                                            "rectangle": locale["editchartform.rectangle"],
                                            "triangle": locale["editchartform.triangle"],
                                            "diamond": locale["editchartform.diamond"],
                                            "emptyCircle": locale["editchartform.emptyCircle"],
                                            "emptyRectangle": locale["editchartform.emptyRectang"],
                                            "emptyTriangle": locale["editchartform.emptyTriangl"],
                                            "emptyDiamond": locale["editchartform.emptyDiamond"]
                                        }}

                                ]},
                            {tag: "div", class: "form-group form-group-custom typeline", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.fillArea"], lfor: "display_fillArea"},
                                    {tag: "select", class: "form-control title_select", prop_key: "fill", id: "display_fillArea", name: "display_fillArea", key_path: 'fill', default: "none", options: {"none": "None",
                                            "0.1": "1",
                                            "0.2": "2",
                                            "0.3": "3",
                                            "0.4": "4",
                                            "0.5": "5",
                                            "0.6": "6",
                                            "0.7": "7",
                                            "0.8": "8",
                                            "0.9": "9",
                                            "1.0": "10"
                                        }}

                                ]},
                            {tag: "div", class: "form-group form-group-custom typeline", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.staircase"], lfor: "display_steped"},
                                    {tag: "select", class: "form-control title_select", prop_key: "step", id: "step", name: "display_steped", key_path: 'step', default: "", options: {
                                            "": "None",
                                            "start": locale["editchartform.start"],
                                            "middle": locale["editchartform.middle"],
                                            "end": locale["editchartform.end"]

                                        }}

                                ]},
                            {tag: "div", class: "form-group form-group-custom typeline typebars", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.stacked"], lfor: "display_stacked"},
                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                                            {tag: "input", type: "checkbox", class: "js-switch-small", checked: "checked", prop_key: "stacked", id: "display_stacked", name: "display_stacked", key_path: 'stacked', default: false}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom typeline", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.smooth"], lfor: "display_smooth"},
                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                                            {tag: "input", type: "checkbox", class: "js-switch-small", checked: "checked", prop_key: "smooth", id: "display_smooth", name: "display_smooth", key_path: 'smooth', default: true}
                                        ]}
                                ]}
                        ]},
                    {tag: "div", id: "axes_select", class: "form_main_block float-left custominputs", label: {show: true, text: locale["editchartform.labels"], class: "typeline typebars typemap typepie typefunnel"}, content: [
                            {tag: "div", class: "form-group form-group-custom typeline typebars typemap", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.labelPosition"], lfor: "display_label_pos"},
                                    {tag: "select", class: "form-control axes_select", prop_key: "label.position", id: "display_label_pos", name: "display_label_pos", key_path: 'label.position', default: "inside", options: {
                                            'top': locale["editchartform.top"],
                                            'left': locale["editchartform.left"],
                                            'right': locale["editchartform.right"],
                                            'bottom': locale["editchartform.bottom"],
                                            'inside': locale["editchartform.inside"],
                                            'insideLeft': locale["editchartform.insideLeft"],
                                            'insideRight': locale["editchartform.insideRight"],
                                            'insideTop': locale["editchartform.insideTop"],
                                            'insideBottom': locale["editchartform.insideBottom"]

                                        }}

                                ]},
                            {tag: "div", class: "form-group form-group-custom typefunnel ", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.labelPosition"], lfor: "display_label_pos"},
                                    {tag: "select", class: "form-control axes_select", prop_key: "label.position", id: "display_label_pos", name: "display_label_pos", key_path: 'label.position', default: "outside", options: {
                                            'left': locale["editchartform.left"],
                                            'right': locale["editchartform.right"],
                                            'inside': locale["editchartform.inside"]

                                        }}

                                ]},
                            {tag: "div", class: "form-group form-group-custom typepie", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.labelPosition"], lfor: "display_label_pos"},
                                    {tag: "select", class: "form-control axes_select", prop_key: "label.position", id: "display_label_pos", name: "display_label_pos", key_path: 'label.position', default: "outside", options: {
                                            'outside': locale["editchartform.outside"],
                                            'inner': locale["editchartform.inside"],
                                            'center': locale["editchartform.center"]

                                        }}

                                ]},
                            {tag: "div", class: "form-group form-group-custom typepie", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.labelFormat"], lfor: "display_label_parts", info: {text: locale["editchartform.labelFormat.text"]}},
                                    {tag: "input", type: "text", class: "form-control axes_select query_input display_label_parts", prop_key: "parts", id: "display_label_parts", name: "display_label_parts", key_path: 'label.parts', default: ""}
                                ]},

                            {tag: "div", class: "form-group form-group-custom typemap typefunnel typeline typebars", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.labelFormat"], lfor: "display_label_parts", info: {text: locale["editchartform.labelFormat.text2"]}},
                                    {tag: "input", type: "text", class: "form-control axes_select query_input display_label_parts", prop_key: "parts", id: "display_label_parts", name: "display_label_parts", key_path: 'label.parts', default: ""}
                                ]},

                            {tag: "div", class: "form-group form-group-custom typeline typebars", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.labelShow"], lfor: "display_label"},
                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                                            {tag: "input", type: "checkbox", class: "js-switch-small", checked: "checked", prop_key: "label.show", id: "display_label", name: "display_label", key_path: 'label.show', default: false}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom typepie typefunnel typemap", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.labelShow"], lfor: "display_label_2"},
                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                                            {tag: "input", type: "checkbox", class: "js-switch-small", checked: "checked", prop_key: "label.show", id: "display_label_2", name: "display_label_2", key_path: 'label.show', default: true}
                                        ]}
                                ]}
                        ]},
                    // -------  version tooliptip  -------
                        {tag: "div", id: "", class: "form_main_block float-left custominputs", label: {show: true, text: locale["editchartform.tooltip"] , class: "typeline"}, content: [
                            {tag: "div", class: "form-group form-group-custom typeline", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.triggerOn"], lfor: "display_trig"},
                                    {tag: "select", class: "form-control axes_select", prop_key: "triggerOn", id: "display_trig", name: "display_trig", key_path: 'options.tooltip.triggerOn', default: "mousemove",
                                            options: {
                                            'mousemove': locale["editchartform.mousemove"],
                                            'click': locale["editchartform.click"]                                            
                                        }                                                                                                                                                          
                                    }                                  
                                ]}
//                            {tag: "div", class: "form-group form-group-custom typeline", content: [
//                                    {tag: "label", class: "control-label control-label-custom120", text: 'Enterable'/*locale["editchartform.enterAble"]*/, lfor: "display_able"},
//                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
//                                            {tag: "input", type: "checkbox", class: "js-switch-small", checked: "checked", prop_key: "enterable", id: "display_able", name: "display_able", key_path: 'options.tooltip.enterable', default: false}
//                                        ]}
//                                ]}
                        ]},    
                    // ------- /version tooliptip  -------                   
                    {tag: "div", id: "axes_select", class: "form_main_block float-left custominputs", label: {show: true, text: locale["editchartform.detail"], class: "typegauge"}, content: [

                            {tag: "label", class: "control-label control-label-custom120 typegauge", text: locale["editchartform.color"], lfor: "detailColor"},

                            {tag: "div", class: "titile_input_midle typegauge", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input", content: [

                                            {tag: "input", type: "text", class: "form-control", prop_key: "backgroundColor", id: "detailColor", name: "detailColor", key_path: 'detail.color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]},

                            {tag: "div", class: "form-group form-group-custom typegauge", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.labelShow"], lfor: "display_label_gauge"},
                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                                            {tag: "input", type: "checkbox", class: "js-switch-small", checked: "checked", prop_key: "label.show", id: "display_label_gauge", name: "display_label_gauge", key_path: 'label.show', default: true}
                                        ]}
                                ]}
                        ]}

                ]}
        ];

        this.tabcontent.tab_display.forms = [edit_display];//suren
        this.tabcontent.tab_data_zoom = {};//suren

        var data_zoom_template = [{tag: "form", class: "form-horizontal form-label-left edit-datazoom float-left", id: "{index}_data_zoom", content: [
                    {tag: "div", class: "form-group form-group-custom forslider", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.show"], lfor: "data_zoom_show"},
                            {tag: "input", type: "checkbox", class: "js-switch-small data_zoom_show", prop_key: "show", id: "{index}_data_zoom_show", name: "data_zoom_show", key_path: 'show', default: true}
                        ]},
                    {tag: "div", class: "form-group form-group-custom forinside", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editform.disabled"], lfor: "data_zoom_disabled"},
                            {tag: "input", type: "checkbox", class: "js-switch-small data_zoom_disabled", prop_key: "disabled", id: "{index}_data_zoom_disabled", name: "data_zoom_disabled", key_path: 'disabled', default: false}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.start"] + " %", lfor: "datazoom_start"},
                            {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "start", id: "{index}_datazoom_start", name: "datazoom_start", key_path: 'start', default: 0, min: 0, max: 100},
                            {tag: "label", class: "control-label control-label-custom-axes", text: locale["editchartform.end"] + " %", lfor: "datazoom_end"},
                            {tag: "input", type: "number", class: "form-control title_input_small", prop_key: "end", id: "{index}_datazoom_end", name: "datazoom_end", key_path: 'end', default: 100, min: 0, max: 100}
                        ]},

                    {tag: "div", class: "form-group form-group-custom form-inline", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.type"], lfor: "datazoom_type"},
                            {tag: "select", class: "form-control query_input datazoom_type_width", prop_key: "type", id: "{index}_datazoom_type", name: "datazoom_type", key_path: 'type', default: "slider",
                                options: {"slider": locale["editchartform.slider"], "inside": locale["editchartform.inner"]}
                                , actions: {"change": function () {
                                        if ($(this).val() === 'slider') {
                                            $(this).parent().parent().find('.forslider').fadeIn();
                                        } else {
                                            $(this).parent().parent().find('.forslider').fadeOut();
                                        }
                                        if ($(this).val() === 'inside') {
                                            $(this).parent().parent().find('.forinside').fadeIn();
                                        } else {
                                            $(this).parent().parent().find('.forinside').fadeOut();
                                        }
                                    }}
                            }

                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.XaxisIndex"], lfor: "data_zoom_xAxisIndex"},
                            {tag: "div", type: "choose_array", init_key_path: "options.xAxis", key_path: "xAxisIndex", style: "display:inline-block", id: "{index}_data_zoom_xAxisIndex", name: "data_zoom_xAxisIndex"}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.YaxisIndex"], lfor: "data_zoom_yAxisIndex"},
                            {tag: "div", type: "choose_array", init_key_path: "options.yAxis", key_path: "yAxisIndex", style: "display:inline-block", id: "{index}_data_zoom_yAxisIndex", name: "data_zoom_yAxisIndex"}
                        ]},
                    {tag: "div", class: "btn btn-outline-success dublicateq btn-sm float-right m-1", id: "{index}_dublicatedatazoom",
                        text: locale["editchartform.dublicate"],
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                var qitem = clone_obg(current.dashJSON.rows[current.row].widgets[current.index].options.dataZoom[curindex]);
                                current.dashJSON.rows[current.row].widgets[current.index].options.dataZoom.splice(curindex, 0, qitem);
                                var contener = $(this).parent().parent();
                                current.repaintdatazoom(contener, edit_data_zoom.content[0].content);
                                current.change($(this));
                            }
                        }
                    },
                    {tag: "div", class: "btn btn-outline-danger removeq btn-sm float-right m-1", id: "{index}_removedatazoom",
                        text: locale["editchartform.remove"],
                        actions: {click: function () {
                                var curindex = parseInt($(this).attr('template_index'));
                                current.dashJSON.rows[current.row].widgets[current.index].options.dataZoom.splice(curindex, 1);
                                var contener = $(this).parent().parent();
                                current.repaintdatazoom(contener, edit_data_zoom.content[0].content);
                                current.change($(this));
                            }
                        }
                    }

                ]}];

        var edit_data_zoom = {tag: "div", class: 'forms col', id: "edit_data_zoom"};
        edit_data_zoom.content = [{tag: "div", class: "form_main_block", content: [{tag: "button", class: "btn btn-outline-success Addq btn-sm m-1",
                        text: locale["editchartform.add"],
                        id: "addq",
                        key_path: "options.dataZoom",
                        template: data_zoom_template,
                        actions: {click: function () {
                                if (!current.dashJSON.rows[current.row].widgets[current.index].options.dataZoom)
                                {
                                    current.dashJSON.rows[current.row].widgets[current.index].options.dataZoom = [];
                                }
                                current.dashJSON.rows[current.row].widgets[current.index].options.dataZoom.push({});
                                var contener = $(this).parent();
                                current.repaintdatazoom(contener, edit_data_zoom.content[0].content);

                            }
                        }
                    }
                ]}];
        this.tabcontent.tab_data_zoom.forms = [edit_data_zoom];//suren
        var inversef = {tag: "div", class: "form-group form-group-custom", content: [
                {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.inverse"]},
                {tag: "input", type: "checkbox", class: "js-switch-small enable_inverse", prop_key: "inverse", id: "{index}_enable_inverse", name: "enable_inverse", key_path: 'info.inverse', default: false}
            ]};
        this.tabcontent.tab_metric.forms[0].content[0].template[0].content.splice(this.tabcontent.tab_metric.forms[0].content[0].template[0].content.length - 2, 0, inversef);

        this.tabcontent.tab_metric.active = true;

    }

    repaintdatazoom(contener, content) {
        contener.empty();
        this.drawcontent(content, contener, this.dashJSON.rows[this.row]["widgets"][this.index]);
        this.formwraper.find("input.flat").iCheck({checkboxClass: icheckbox_flat_clr, radioClass: iradio_flat_clr});
        this.initzoomtype();
    }

    initzoomtype() {
        this.formwraper.find('[name=datazoom_type]').each(function () {
            if ($(this).val() === 'slider') {
                $(this).parent().parent().find('.forslider').show();
            } else {
                $(this).parent().parent().find('.forslider').hide();
            }

            if ($(this).val() === 'inside') {
                $(this).parent().parent().find('.forinside').show();
            } else {
                $(this).parent().parent().find('.forinside').hide();
            }
        });
    }
    gettabcontent(key)
    {
        if (key === null)
        {
            return this.tabcontent;
        }
        return this.tabcontent[key];
    }
    get ypos()
    {
        return {"": "&nbsp", left: locale["editchartform.left"], right: locale["editchartform.right"]};
    }

    get xpos()
    {
        return {"": "&nbsp", bottom: locale["editchartform.bottom"], top: locale["editchartform.top"]};
    }
    get legendOrient()
    {
        return {horizontal: locale["editchartform.horizontal"], vertical: locale["editchartform.vertical"]};
    }

    get legendMode()
    {
        return {single: locale["editchartform.single"], multiple: locale["editchartform.multiple"]};
    }

}

class ChartEditForm extends BaseChartEditForm {
    inittabcontent()
    {
        super.inittabcontent();
        var xfieds = {tag: "div", class: "form-group form-group-custom", content: [
                {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.axesIndexes"]},
                {tag: "label", class: "control-label ", text: "X", lfor: "q_xAxisIndex"},
                {tag: "div", type: "choose_array", choose_type: "radio", init_key_path: "options.xAxis", key_path: "xAxisIndex", style: "display:inline-block", id: "{index}_q_xAxisIndex", name: "q_xAxisIndex"},
                {tag: "label", class: "control-label", text: "Y", lfor: "q_yAxisIndex"},
                {tag: "div", type: "choose_array", choose_type: "radio", init_key_path: "options.yAxis", key_path: "yAxisIndex", style: "display:inline-block", id: "{index}_q_yAxisIndex", name: "q_yAxisIndex"}
            ]};
        this.tabcontent.tab_metric.forms[0].content[0].template[0].content.splice(this.tabcontent.tab_metric.forms[0].content[0].template[0].content.length - 2, 0, xfieds);

    }
}
;


class HmEditForm extends BaseChartEditForm {
    inittabcontent()
    {
        super.inittabcontent();
        this.tabcontent.tab_display = {};//suren

        var edit_display = {tag: "div", class: 'forms', id: "edit_display"};
        edit_display.content = [{tag: "div", class: "form-horizontal form-label-left edit-display float-left",
                content: [
                    {tag: "div", id: "desplay_info", class: "form_main_block float-left custominputs", content: [
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.visualMaporient"], lfor: "visualMap_orient"},
                                    {tag: "select", class: "form-control title_select", prop_key: "visualMap_orient", id: "visualMap_orient", name: "visualMap_orient", key_path: 'options.visualMap.orient', default: "horizontal", options: this.visualMaporientoptions},
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.visualMapshow"], lfor: "visualMap_show"},
                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                                            {tag: "input", type: "checkbox", class: "js-switch-small", prop_key: "visualMap_show", id: "visualMap_show", name: "visualMap_show", key_path: 'options.visualMap.show', default: true}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.visualMapColorScheme"], lfor: "visualMap_color"},
                                    {tag: "select", class: "form-control select_ColorScheme", prop_key: "visualMap_color", id: "visualMap_color", name: "visualMap_color", key_path: 'options.visualMap.other.color', default: "", options: this.visualMapColoroptions},
//                                    {tag: "div", class: "gradient", style: "display: inline-block; background-image:linear-gradient(to right, #5ab1ef, #e0ffff);"}
                                ]},

//                            {tag: "div", class: "form-group form-group-custom", content: [
//                                    {tag: "label", class: "control-label control-label-custom", text: "ColorScheme", lfor: "visualMap_color"},
//                                    {tag: "select", class: "form-control title_select", prop_key: "visualMap_color", id: "visualMap_color", name: "visualMap_color", key_path: 'options.visualMap.other.color', default: "", options: this.visualMapColoroptions},
//                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.visualMaporient"], lfor: "visualMap_orient"},
//                                    {tag: "select", class: "form-control title_select", prop_key: "visualMap_orient", id: "visualMap_orient", name: "visualMap_orient", key_path: 'options.visualMap.orient', default: "horizontal", options: this.visualMaporientoptions},
//                                ]},

                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.visualMapmin"], lfor: "visualMapmin"},
                                    {tag: "input", placeholder: "auto", type: "number", class: "form-control title_select", id: "visualMapmin", name: "visualMapmin", prop_key: "visualMapmin", key_path: 'options.visualMap.other.min'},
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.visualMapmax"], lfor: "visualMapmax"},
                                    {tag: "input", placeholder: "auto", type: "number", class: "form-control title_select", id: "visualMapmax", name: "visualMapmax", prop_key: "visualMapmax", key_path: 'options.visualMap.other.max'}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.visualMapleft"], lfor: "visualMap_left"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_select", id: "visualMap_left", name: "visualMap_left", prop_key: "visualMap_left", key_path: 'options.visualMap.left'},
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.visualMaptop"], lfor: "visualMap_top"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_select", id: "visualMap_top", name: "visualMap_top", prop_key: "visualMap_top", key_path: 'options.visualMap.top'}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.visualMapright"], lfor: "visualMap_right"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_select", id: "visualMap_right", name: "visualMap_right", prop_key: "visualMap_right", key_path: 'options.visualMap.right'},
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.visualMapbottom"], lfor: "visualMap_bottom"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_select", id: "visualMap_bottom", name: "visualMap_bottom", prop_key: "visualMap_bottom", key_path: 'options.visualMap.bottom'}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.visualMapwidth"], lfor: "visualMap_width"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_select", id: "visualMap_width", name: "visualMap_width", prop_key: "visualMap_width", key_path: 'options.visualMap.itemWidth'},
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.visualMapheight"], lfor: "visualMap_height"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_select", id: "visualMap_height", name: "visualMap_height", prop_key: "visualMap_height", key_path: 'options.visualMap.itemHeight'}
                                ]}
                        ]},

                    {tag: "div", class: "form_main_block float-left", content: [
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.animation"], lfor: "display_animation"},
                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                                            {tag: "input", type: "checkbox", class: "js-switch-small", checked: "checked", prop_key: "animation", id: "display_animation", name: "display_animation", key_path: 'options.animation', default: true}
                                        ]},
                                    {tag: "label", class: "control-label control-label-custom155", text: locale["editchartform.containsLabel"], lfor: "display_containLabel"},
                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                                            {tag: "input", type: "checkbox", class: "js-switch-small", checked: "checked", prop_key: "containLabel", id: "display_containLabel", name: "display_containLabel", key_path: 'options.grid.containLabel', default: true}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.left"], lfor: "padding_left"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_left", name: "padding_left", prop_key: "x", key_path: 'options.grid.x'},
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.top"], lfor: "padding_top"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_top", name: "padding_top", prop_key: "y", key_path: 'options.grid.y'}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.right"], lfor: "padding_right"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_right", name: "padding_right", prop_key: "x2", key_path: 'options.grid.x2'},
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editchartform.bottom"], lfor: "padding_bottom"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_bottom", name: "padding_bottom", prop_key: "y2", key_path: 'options.grid.y2'}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.width"], lfor: "padding_width"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_width", name: "padding_width", prop_key: "width", key_path: 'options.grid.width'},
                                    {tag: "label", class: "control-label control-label-custom120", text: locale["editform.height"], lfor: "padding_height"},
                                    {tag: "input", placeholder: "auto", type: "text", class: "form-control title_input_small", id: "padding_height", name: "padding_height", prop_key: "height", key_path: 'options.grid.height'}

                                ]}
                        ]},

                    {tag: "div", id: "desplay_info", class: "form_main_block float-left custominputs", content: [
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.labels"], lfor: "display_label"},
                                    {tag: "div", class: "checkbox", style: "display: inline-block", content: [
                                            {tag: "input", type: "checkbox", class: "js-switch-small", checked: "checked", prop_key: "label.show", id: "display_label", name: "display_label", key_path: 'label.show', default: false}
                                        ]}
                                ]},
                            {tag: "div", class: "form-group form-group-custom", content: [
                                    {tag: "label", class: "control-label control-label-custom", text: locale["editchartform.backgroundColors"], lfor: "backgroundColor"},
                                    {tag: "div", class: "color-button", content: [
                                            {tag: "div", class: "input-group cl_picer cl_picer_noinput colorpicker-element", content: [
                                                    {tag: "input", type: "text", class: "form-control", prop_key: "backgroundColor", id: "backgroundColor", name: "backgroundColor", key_path: 'options.backgroundColor', default: ""},
                                                    {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                                ]}
                                        ]}

                                ]}
                        ]}
                ]}
        ];

        this.tabcontent.tab_display.forms = [edit_display];

        this.tabcontent.tab_axes = {};
        var edit_axes_y = {tag: "div", class: 'form_main_block float-left', id: "edit_y", label: {show: true, text: locale["editchartform.Yaxes"]}};
        var current = this;

        var axes_template = [{tag: "form", class: "form-horizontal form-label-left edit-axes", id: "{index}_yaxes", content: [
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.show"], lfor: "axes_show_y"},
                            {tag: "input", type: "checkbox", class: "js-switch-small axes_show_y", prop_key: "show", id: "{index}_axes_show_y", name: "axes_show_y", key_path: 'show', default: true}
                        ]},

                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.text"], lfor: "axes_name_y"},
                            {tag: "input", type: "text", class: "form-control axes_select", prop_key: "name", id: "{index}_axes_name_y", name: "axes_name_y", key_path: 'name', default: ""}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.position"], lfor: "axes_position_y"},
                            {tag: "select", class: "form-control axes_select", prop_key: "position", id: "{index}_axes_position_y", name: "axes_position_y", key_path: 'position', default: "", options: this.ypos}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.splitNumber"], lfor: "axes_splitNumber_y"},
                            {tag: "input", type: "number", class: "form-control axes_select", prop_key: "splitNumber", id: "{index}_splitNumber_y", name: "splitNumber_y", key_path: 'splitNumber', default: ""}
                        ]},

                    {tag: "div", class: "form-group  ", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.Ycolor"], lfor: "axes_color_y"},

                            {tag: "div", class: "titile_input_midle axes_select ", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input hasdublicatepath", content: [
                                            {tag: "input", type: "text", class: "form-control ", prop_key: "ycolor", id: "{index}_ycolor", name: "ycolor", key_path: 'axisLine.lineStyle.color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.fontSizeLabel"], lfor: "lable_size_y"},
                            {tag: "input", type: "number", class: "form-control axes_select axis_input-size", prop_key: "size_x", id: "{index}_label_size_y", name: "lable_size_y", key_path: 'axisLabel.fontSize', default: "12"},
                            {tag: "label", class: "control-label control-label-custom-legend axis_lable-size", text: locale["editchartform.text"], lfor: "text_size_x"},
                            {tag: "input", type: "number", class: "form-control axes_select axis_input-size", prop_key: "text_size_y", id: "{index}_text_size_y", name: "text_size_y", key_path: 'nameTextStyle.fontSize', default: "12"}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.unit"], lfor: "axes_unit_y"},
                            {tag: "select", class: "form-control axes_select", prop_key: "unit", id: "{index}_axes_unit_y", name: "axes_unit_y", key_path: 'unit', default: "", options: this.units}
                        ]}
                ]}];
        edit_axes_y.content = [{tag: "div", class: "form_main_block", content: [{tag: "div", class: "",
                        id: "addq",
                        key_path: "options.yAxis",
                        template: axes_template
                    }
                ]}]
                ;

        var edit_axes_x = {tag: "section", class: 'form_main_block float-left', id: "edit_x", label: {show: true, text: locale["editchartform.Xaxes"]}};
        var current = this;

        var axes_template = [{tag: "form", class: "form-horizontal form-label-left edit-axes", id: "{index}_xaxes", content: [
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.show"], lfor: "axes_show_x"},
                            {tag: "input", type: "checkbox", class: "js-switch-small axes_show_x", prop_key: "show", id: "{index}_axes_show_x", name: "axes_show_x", key_path: 'show', default: true}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.text"], lfor: "axes_name_x"},
                            {tag: "input", type: "text", class: "form-control axes_select", prop_key: "name", id: "{index}_axes_name_x", name: "axes_name_x", key_path: 'name', default: ""}
                        ]},

                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.position"], lfor: "axes_position_x"},
                            {tag: "select", class: "form-control axes_select", prop_key: "position", id: "{index}_axes_position_x", name: "axes_position_x", key_path: 'position', default: "", options: this.xpos}
                        ]},

                    {tag: "div", class: "form-group ", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.Xcolor"], lfor: "axes_color_x"},

                            {tag: "div", class: "titile_input_midle axes_select ", content: [
                                    {tag: "div", class: "input-group cl_picer cl_picer_input hasdublicatepath", content: [
                                            {tag: "input", type: "text", class: "form-control axes_select ", prop_key: "xcolor", id: "{index}_xcolor", name: "xcolor", key_path: 'axisLine.lineStyle.color', default: ""},
                                            {tag: "span", class: "input-group-addon", content: [{tag: "i"}]}
                                        ]}
                                ]}
                        ]},
                    {tag: "div", class: "form-group form-group-custom", content: [
                            {tag: "label", class: "control-label control-label-custom-legend", text: locale["editchartform.fontSizeLabel"], lfor: "lable_size_x"},
                            {tag: "input", type: "number", class: "form-control axes_select axis_input-size", prop_key: "size_x", id: "{index}_label_size_x", name: "lable_size_x", key_path: 'axisLabel.fontSize', default: "12"},
                            {tag: "label", class: "control-label control-label-custom-legend axis_lable-size", text: locale["editchartform.text"], lfor: "text_size_x"},
                            {tag: "input", type: "number", class: "form-control axes_select axis_input-size", prop_key: "text_size_x", id: "{index}_text_size_x", name: "text_size_x", key_path: 'nameTextStyle.fontSize', default: "12"}
                        ]}
                ]}];
        edit_axes_x.content = [{tag: "div", class: "form_main_block", content: [{tag: "div", class: "",
                        id: "addq",
                        key_path: "options.xAxis",
                        template: axes_template
                    }
                ]}];
        this.tabcontent.tab_axes.forms = [edit_axes_y, edit_axes_x];

    }
}
;
