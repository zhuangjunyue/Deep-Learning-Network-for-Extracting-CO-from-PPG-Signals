module LAYER1(
    input clk,
    input reset,
    input start,
    input logic signed [15:0] input_data[0:23],  // 24维输入数据，Q4.12格式
    output logic signed [15:0] output_data[0:63],  // 64维输出数据，Q4.12格式
    output logic valid,  // 输出数据有效信号
    input ready  // 下游模块准备好接收数据信号
);

typedef logic signed [15:0] signed_matrix_1x64_t[64];
const signed_matrix_1x64_t biases_1 = '{16'sd5, 16'sd0, 16'sd14, 16'sd2, 16'sd1, -16'sd7, 16'sd0, 16'sd2, -16'sd2, -16'sd8,     16'sd12, -16'sd7, -16'sd11, 16'sd9, 16'sd4, 16'sd7, -16'sd8, -16'sd10, -16'sd6, 16'sd5,     16'sd4, 16'sd13, 16'sd10, 16'sd6, -16'sd10, 16'sd8, -16'sd10, 16'sd9, 16'sd10, -16'sd1, -16'sd13, -16'sd6, 16'sd3, 16'sd23, 16'sd6, 16'sd1, 16'sd1, -16'sd2, -16'sd3, 16'sd0, -16'sd1, -16'sd18, -16'sd7, 16'sd15, 16'sd1, -16'sd20, 16'sd13, 16'sd6, -16'sd6, -16'sd3,     16'sd4, -16'sd2, 16'sd3, -16'sd2, 16'sd17, 16'sd10, -16'sd7, -16'sd4, 16'sd3, -16'sd3,     16'sd10, 16'sd8, 16'sd16, -16'sd2};

// 定义一个16位宽有符号整数的24元素一维数组类型
typedef logic signed [15:0] signed_matrix_1x24_t[24];

// 定义一个此类型的64元素一维数组，即二维数组
typedef signed_matrix_1x24_t signed_matrix_64x24_t[64];


const signed_matrix_64x24_t weights_1 = '{
    

	 
	 
	 
	 
	 '{  16'sd901, -16'sd408, 16'sd120, -16'sd524, -16'sd450, 16'sd482, 16'sd577, -16'sd448, -16'sd24, 16'sd1228, 16'sd884, -16'sd373, 16'sd251, -16'sd68, -16'sd823, 16'sd1097, -16'sd234, 16'sd955, 16'sd905, -16'sd455, 16'sd3122, 16'sd1053, -16'sd225, -16'sd2634 },
    '{ 16'sd2246, -16'sd1101, 16'sd744, 16'sd667, -16'sd455, -16'sd280, -16'sd293, 16'sd291, 16'sd995, 16'sd555, -16'sd1909, 16'sd1337, 16'sd1286, -16'sd2847, -16'sd1838, -16'sd139, -16'sd1052, 16'sd456, -16'sd1184, -16'sd1095, 16'sd2013, -16'sd1357, -16'sd939, -16'sd588 },
    '{ 16'sd1415, 16'sd143, -16'sd568, -16'sd203, -16'sd976, -16'sd1923, 16'sd1462, 16'sd1882, -16'sd607, 16'sd1303, -16'sd339, 16'sd612, 16'sd814, -16'sd801, -16'sd162, 16'sd166, 16'sd251, -16'sd406, -16'sd1487, 16'sd1305, -16'sd85, -16'sd1282, 16'sd228, 16'sd50 },
    '{ 16'sd1430, 16'sd965, 16'sd277, 16'sd1442, -16'sd549, 16'sd1778, 16'sd2486, -16'sd284, -16'sd198, 16'sd164, -16'sd596, -16'sd357, 16'sd966, 16'sd353, 16'sd343, 16'sd839, -16'sd204, 16'sd34, -16'sd663, -16'sd656, -16'sd1796, -16'sd818, -16'sd2155, 16'sd1269 },
    '{ 16'sd979, 16'sd236, 16'sd52, 16'sd1364, -16'sd569, 16'sd1524, 16'sd543, 16'sd709, 16'sd348, -16'sd242, 16'sd255, 16'sd2185, 16'sd1899, 16'sd76, -16'sd1132, -16'sd1051, 16'sd1061, 16'sd1790, 16'sd2291, -16'sd706, -16'sd344, -16'sd291, 16'sd1662, -16'sd1072 },
    '{- 16'sd978, -16'sd1334, 16'sd638, 16'sd1132, -16'sd455, -16'sd940, 16'sd381, 16'sd1319, 16'sd2207, 16'sd168, -16'sd809, 16'sd492, 16'sd642, 16'sd1465, -16'sd1769, -16'sd1568, 16'sd437, 16'sd219, 16'sd790, -16'sd1123, -16'sd320, 16'sd129, 16'sd1856, 16'sd671 },
    '{ 16'sd1333, -16'sd77, -16'sd1096, -16'sd1503, -16'sd711, 16'sd1928, -16'sd359, -16'sd296, -16'sd43, 16'sd2695, 16'sd940, -16'sd1473, 16'sd750, -16'sd1053, -16'sd767, -16'sd404, -16'sd1182, -16'sd49, -16'sd164, 16'sd685, 16'sd344, -16'sd1511, -16'sd52, 16'sd1566 },
    '{- 16'sd1048, 16'sd182, -16'sd519, -16'sd2093, 16'sd1751, -16'sd28, 16'sd15, -16'sd1152, 16'sd254, 16'sd2462, 16'sd937, -16'sd1417, -16'sd73, -16'sd93, -16'sd626, -16'sd560, 16'sd1178, -16'sd1061, 16'sd556, 16'sd1779, 16'sd1876, -16'sd1344, -16'sd917, -16'sd468 },
    '{ 16'sd763, 16'sd80, 16'sd1607, -16'sd717, -16'sd223, -16'sd2386, 16'sd302, -16'sd1719, 16'sd751, -16'sd1229, 16'sd1647, 16'sd983, 16'sd421, -16'sd844, -16'sd600, 16'sd923, 16'sd1124, -16'sd1244, -16'sd556, 16'sd720, -16'sd2424, -16'sd180, -16'sd772, -16'sd1456 },
    '{- 16'sd264, -16'sd331, -16'sd553, 16'sd1162, -16'sd1915, 16'sd1206, 16'sd446, 16'sd3407, 16'sd1463, 16'sd198, -16'sd1438, 16'sd862, 16'sd252, -16'sd646, -16'sd78, 16'sd629, -16'sd2868, 16'sd696, 16'sd843, -16'sd321, -16'sd84, -16'sd168, 16'sd129, 16'sd1168 },
    '{- 16'sd524, -16'sd22, -16'sd515, 16'sd751, 16'sd380, 16'sd459, -16'sd835, -16'sd585, -16'sd932, 16'sd680, -16'sd1300, 16'sd1011, 16'sd2367, -16'sd5, -16'sd641, -16'sd38, 16'sd2192, -16'sd806, -16'sd893, -16'sd979, -16'sd2072, -16'sd758, 16'sd1487, 16'sd1585 },
    '{- 16'sd530, 16'sd1395, -16'sd477, -16'sd248, -16'sd1180, 16'sd288, 16'sd74, 16'sd237, -16'sd919, -16'sd899, 16'sd885, 16'sd1742, 16'sd1055, 16'sd53, 16'sd485, -16'sd2139, 16'sd1336, -16'sd1551, 16'sd146, -16'sd958, -16'sd2854, 16'sd1051, 16'sd1113, -16'sd1554 },
    '{ 16'sd1139, -16'sd3057, 16'sd418, -16'sd2177, -16'sd1502, 16'sd715, -16'sd611, -16'sd2215, 16'sd1041, 16'sd1197, -16'sd271, 16'sd263, 16'sd1130, -16'sd726, 16'sd154, -16'sd2379, 16'sd719, -16'sd770, -16'sd607, 16'sd2020, 16'sd1450, 16'sd3029, 16'sd868, 16'sd798 },
    '{ 16'sd1480, -16'sd479, -16'sd1078, 16'sd2722, -16'sd1166, -16'sd1379, -16'sd259, 16'sd484, 16'sd2227, 16'sd787, -16'sd1262, 16'sd804, 16'sd470, -16'sd81, 16'sd269, 16'sd985, -16'sd1891, 16'sd1805, 16'sd900, -16'sd232, 16'sd1584, -16'sd1392, -16'sd1342, -16'sd924 },
    '{ 16'sd1189, -16'sd1957, -16'sd737, 16'sd92, 16'sd796, 16'sd1084, 16'sd811, 16'sd523, -16'sd2290, 16'sd1329, -16'sd1636, -16'sd466, -16'sd1503, -16'sd219, -16'sd532, -16'sd1527, 16'sd118, -16'sd786, -16'sd1187, -16'sd105, 16'sd1010, 16'sd246, 16'sd1658, -16'sd1187 },
    '{- 16'sd324, 16'sd1049, 16'sd446, -16'sd328, 16'sd1253, -16'sd593, 16'sd1291, 16'sd558, 16'sd965, -16'sd872, 16'sd1185, 16'sd125, -16'sd816, -16'sd676, -16'sd1740, 16'sd2087, -16'sd10, -16'sd1313, 16'sd1580, 16'sd797, 16'sd813, -16'sd2368, 16'sd1472, -16'sd1059 },
    '{- 16'sd836, -16'sd191, -16'sd282, -16'sd1023, -16'sd967, -16'sd40, 16'sd566, -16'sd1647, 16'sd9, 16'sd585, -16'sd898, 16'sd1010, 16'sd263, -16'sd788, -16'sd2288, 16'sd856, -16'sd3091, 16'sd1037, -16'sd918, 16'sd799, -16'sd1527, 16'sd808, 16'sd1888, 16'sd165 },
    '{- 16'sd2792, 16'sd394, 16'sd1598, 16'sd66, 16'sd484, 16'sd743, -16'sd968, -16'sd1064, -16'sd240, 16'sd1171, 16'sd1444, -16'sd1434, 16'sd901, -16'sd507, 16'sd167, -16'sd1666, 16'sd268, -16'sd590, 16'sd159, -16'sd608, -16'sd836, 16'sd1511, 16'sd1142, -16'sd393 },
    '{- 16'sd371, -16'sd290, -16'sd1474, -16'sd1667, -16'sd1060, -16'sd80, -16'sd517, 16'sd1110, 16'sd738, -16'sd729, -16'sd602, -16'sd1466, -16'sd1962, -16'sd1373, 16'sd791, -16'sd147, 16'sd288, -16'sd1193, 16'sd85, 16'sd95, 16'sd613, 16'sd2163, 16'sd278, 16'sd526 },
    '{ 16'sd1197, 16'sd3018, -16'sd1751, 16'sd830, 16'sd89, -16'sd297, -16'sd1881, -16'sd1855, -16'sd2073, 16'sd2530, 16'sd1275, -16'sd1050, -16'sd1082, -16'sd378, -16'sd1575, 16'sd1444, -16'sd280, -16'sd358, 16'sd608, -16'sd245, 16'sd557, 16'sd1819, -16'sd1958, -16'sd571},
    '{- 16'sd3345, -16'sd452, 16'sd670, -16'sd911, -16'sd1534, 16'sd731, 16'sd1084, -16'sd1357, 16'sd77, -16'sd536, 16'sd1050, 16'sd1469, 16'sd1202, 16'sd409, -16'sd1122, -16'sd577, -16'sd47, 16'sd292, -16'sd1671, 16'sd687, -16'sd928, 16'sd335, -16'sd2194, 16'sd1646 },
    '{ 16'sd3085, 16'sd1534, -16'sd776, -16'sd1216, -16'sd1029, 16'sd881, 16'sd1415, 16'sd1733, 16'sd63, 16'sd353, 16'sd1090, -16'sd645, 16'sd845, 16'sd1670, -16'sd1205, 16'sd139, 16'sd602, -16'sd127, -16'sd254, -16'sd280, 16'sd1142, -16'sd167, -16'sd412, 16'sd690 },
    '{ 16'sd1004, -16'sd113, -16'sd517, 16'sd1583, -16'sd183, 16'sd1116, -16'sd181, -16'sd644, 16'sd364, 16'sd1069, -16'sd2159, 16'sd10, 16'sd1091, -16'sd154, -16'sd331, 16'sd1140, -16'sd2651, -16'sd333, 16'sd1342, 16'sd1401, -16'sd1182, -16'sd1194, 16'sd842, -16'sd567 },
    '{ 16'sd484, -16'sd1056, 16'sd611, 16'sd543, -16'sd64, 16'sd110, -16'sd1829, -16'sd491, -16'sd226, -16'sd198, -16'sd661, -16'sd1818, 16'sd1005, -16'sd1610, 16'sd528, -16'sd613, -16'sd103, 16'sd727, 16'sd763, 16'sd929, -16'sd1585, 16'sd92, -16'sd1022, 16'sd889 },
    '{ 16'sd1726, 16'sd2166, 16'sd1190, 16'sd815, 16'sd1232, 16'sd740, -16'sd1526, -16'sd1013, -16'sd1723, -16'sd1250, 16'sd279, 16'sd669, 16'sd3962, 16'sd304, 16'sd412, -16'sd714, 16'sd796, 16'sd2296, -16'sd1050, -16'sd1078, 16'sd148, 16'sd85, 16'sd283, -16'sd1656 },
    '{- 16'sd777, 16'sd2472, -16'sd1772, 16'sd794, -16'sd1365, 16'sd1945, 16'sd245, -16'sd1106, -16'sd431, -16'sd657, 16'sd352, 16'sd2211, -16'sd1356, -16'sd2350, -16'sd2536, 16'sd851, 16'sd878, -16'sd334, -16'sd1514, 16'sd297, -16'sd2501, 16'sd1098, 16'sd458, 16'sd1437 },
    '{ 16'sd28, -16'sd542, 16'sd649, -16'sd391, -16'sd223, 16'sd1146, -16'sd1967, 16'sd488, -16'sd664, -16'sd1149, -16'sd756, -16'sd1079, 16'sd902, 16'sd1135, 16'sd239, -16'sd825, -16'sd240, -16'sd1433, -16'sd729, -16'sd1058, 16'sd1997, -16'sd86, 16'sd747, 16'sd1182 },
    '{- 16'sd1064, -16'sd1967, -16'sd259, 16'sd244, 16'sd462, 16'sd726, -16'sd1297, 16'sd514, -16'sd197, -16'sd1826, 16'sd2723, -16'sd455, -16'sd746, 16'sd2096, -16'sd615, -16'sd1053, 16'sd743, -16'sd142, 16'sd1101, 16'sd464, 16'sd1322, 16'sd1016, 16'sd896, 16'sd1974 },
    '{- 16'sd865, -16'sd1035, -16'sd4039, 16'sd595, 16'sd732, -16'sd252, -16'sd164, 16'sd1057, 16'sd260, -16'sd694, 16'sd2060, -16'sd37, 16'sd445, -16'sd1365, 16'sd407, -16'sd2282, 16'sd972, 16'sd172, -16'sd2288, -16'sd689, -16'sd1378, 16'sd1458, 16'sd380, 16'sd1800 },
    '{- 16'sd2098, 16'sd563, 16'sd684, -16'sd1527, 16'sd2080, 16'sd764, -16'sd1310, 16'sd385, 16'sd718, 16'sd923, 16'sd933, -16'sd1474, -16'sd297, -16'sd449, -16'sd2294, 16'sd117, -16'sd742, 16'sd644, 16'sd203, -16'sd1395, 16'sd1385, -16'sd532, -16'sd600, 16'sd666 },
    '{ 16'sd1082, -16'sd188, -16'sd1619, 16'sd904, 16'sd2217, -16'sd956, -16'sd513, 16'sd521, -16'sd231, 16'sd1592, 16'sd1352, 16'sd1227, 16'sd574, 16'sd22, 16'sd797, 16'sd740, 16'sd277, 16'sd1907, 16'sd798, -16'sd1647, -16'sd1098, -16'sd1191, -16'sd842, -16'sd190 },
    '{- 16'sd1711, -16'sd1359, -16'sd501, 16'sd1325, -16'sd766, 16'sd529, 16'sd1374, -16'sd1487, 16'sd2959, -16'sd2181, -16'sd944, -16'sd224, -16'sd554, 16'sd1556, 16'sd737, -16'sd310, -16'sd917, -16'sd1758, 16'sd208, 16'sd467, 16'sd440, -16'sd744, -16'sd259, 16'sd717 },
    '{- 16'sd952, -16'sd1358, -16'sd183, 16'sd499, -16'sd1163, -16'sd1307, -16'sd924, 16'sd2074, 16'sd947, 16'sd2084, 16'sd1389, -16'sd539, 16'sd1818, 16'sd123, -16'sd2231, 16'sd1362, 16'sd1177, 16'sd98, 16'sd1240, 16'sd1004, -16'sd2593, 16'sd1382, -16'sd579, 16'sd222 },
    '{- 16'sd499, -16'sd1273, -16'sd802, 16'sd1060, -16'sd1882, -16'sd1191, 16'sd272, 16'sd1268, -16'sd1395, 16'sd417, 16'sd404, 16'sd577, 16'sd468, -16'sd539, 16'sd114, 16'sd785, 16'sd1702, -16'sd759, -16'sd1598, -16'sd1117, -16'sd2049, 16'sd2291, 16'sd311, -16'sd754 },
    '{ 16'sd487, 16'sd684, -16'sd1172, 16'sd1087, 16'sd1055, -16'sd152, -16'sd785, -16'sd147, 16'sd685, 16'sd2184, 16'sd2664, 16'sd809, 16'sd234, -16'sd1313, 16'sd663, 16'sd1765, 16'sd652, -16'sd1891, 16'sd1408, 16'sd444, -16'sd1284, -16'sd641, -16'sd747, 16'sd124 },
    '{- 16'sd918, 16'sd671, -16'sd818, -16'sd1075, 16'sd478, -16'sd1382, -16'sd167, -16'sd964, 16'sd1008, -16'sd1402, 16'sd1076, 16'sd776, 16'sd1325, -16'sd139, 16'sd1459, 16'sd1679, -16'sd836, 16'sd942, 16'sd1485, -16'sd3, 16'sd2313, 16'sd762, -16'sd2591, -16'sd1334 },
    '{ 16'sd305, 16'sd2856, 16'sd986, 16'sd1071, 16'sd88, -16'sd762, 16'sd523, 16'sd310, 16'sd909, 16'sd671, -16'sd926, 16'sd1464, -16'sd2115, 16'sd870, 16'sd70, 16'sd198, -16'sd2359, -16'sd993, -16'sd955, -16'sd751, 16'sd117, 16'sd1894, -16'sd152, 16'sd27 },
    '{ 16'sd886, -16'sd727, -16'sd1068, -16'sd2053, -16'sd1081, 16'sd732, -16'sd1110, 16'sd1194, -16'sd1739, 16'sd1815, -16'sd2279, 16'sd87, 16'sd463, 16'sd1480, -16'sd1308, -16'sd1710, 16'sd1883, 16'sd313, 16'sd2452, 16'sd392, -16'sd1436, -16'sd576, 16'sd149, 16'sd409 },
    '{ 16'sd390, 16'sd170, -16'sd531, 16'sd3026, -16'sd1271, 16'sd2852, -16'sd1018, -16'sd1064, 16'sd1948, -16'sd602, -16'sd558, -16'sd29, 16'sd370, 16'sd1190, 16'sd1220, -16'sd756, 16'sd508, -16'sd602, -16'sd1848, -16'sd1320, 16'sd1671, -16'sd1035, -16'sd538, -16'sd412 },
    '{ 16'sd761, 16'sd1327, 16'sd773, -16'sd382, 16'sd642, 16'sd835, -16'sd440, 16'sd44, -16'sd1617, -16'sd340, -16'sd1950, -16'sd427, -16'sd1316, -16'sd883, -16'sd329, 16'sd261, 16'sd606, 16'sd93, 16'sd1125, -16'sd2226, -16'sd200, -16'sd1104, 16'sd966, -16'sd215 },
    '{- 16'sd243, -16'sd338, -16'sd2847, -16'sd649, -16'sd888, 16'sd767, 16'sd924, -16'sd811, 16'sd194, -16'sd2223, -16'sd542, 16'sd454, 16'sd388, 16'sd3453, 16'sd856, -16'sd861, 16'sd1648, 16'sd2473, -16'sd1342, 16'sd894, -16'sd1073, -16'sd922, 16'sd606, 16'sd1275 },
    '{ 16'sd555, -16'sd1871, -16'sd800, 16'sd1633, 16'sd1440, -16'sd377, -16'sd78, 16'sd2366, 16'sd110, -16'sd86, -16'sd1001, -16'sd93, 16'sd1143, 16'sd539, -16'sd415, -16'sd1237, -16'sd159, 16'sd547, 16'sd1143, -16'sd261, 16'sd250, 16'sd134, 16'sd408, 16'sd39 },
    '{- 16'sd3062, -16'sd988, -16'sd862, 16'sd388, 16'sd337, 16'sd2118, -16'sd1829, -16'sd3070, -16'sd23, 16'sd1516, 16'sd2461, -16'sd106, -16'sd109, -16'sd1377, -16'sd1239, 16'sd332, 16'sd2475, -16'sd325, 16'sd1683, -16'sd93, -16'sd2968, 16'sd1054, 16'sd935, 16'sd117 },
    '{- 16'sd771, -16'sd145, -16'sd1075, -16'sd121, -16'sd241, -16'sd1357, -16'sd560, 16'sd1026, 16'sd201, -16'sd1075, 16'sd325, -16'sd698, -16'sd318, -16'sd819, 16'sd1624, -16'sd1689, -16'sd1176, 16'sd107, 16'sd1050, -16'sd2410, -16'sd344, 16'sd1417, -16'sd1087, 16'sd801 },
    '{ 16'sd212, -16'sd1795, -16'sd36, 16'sd1634, 16'sd650, -16'sd1343, 16'sd29, -16'sd126, 16'sd2205, -16'sd810, -16'sd1326, -16'sd1425, -16'sd1170, -16'sd1824, 16'sd81, -16'sd1705, 16'sd283, -16'sd566, -16'sd602, 16'sd632, 16'sd746, -16'sd905, -16'sd1409, -16'sd1028 },
    '{- 16'sd205, 16'sd615, 16'sd313, -16'sd983, -16'sd669, -16'sd970, 16'sd5, 16'sd2292, 16'sd130, -16'sd445, 16'sd584, 16'sd1555, -16'sd387, -16'sd1945, -16'sd582, -16'sd566, -16'sd1352, -16'sd677, 16'sd2867, 16'sd1311, 16'sd161, -16'sd245, -16'sd789, 16'sd724 },
    '{ 16'sd547, 16'sd1422, 16'sd150, -16'sd266, 16'sd764, 16'sd276, -16'sd287, 16'sd1094, 16'sd1676, -16'sd115, 16'sd1068, -16'sd261, 16'sd1700, -16'sd31, -16'sd1529, -16'sd274, -16'sd390, 16'sd1717, -16'sd911, 16'sd2571, -16'sd1845, 16'sd594, -16'sd356, 16'sd1537 },
    '{- 16'sd2032, 16'sd1028, -16'sd914, 16'sd1116, 16'sd727, 16'sd437, 16'sd310, 16'sd174, -16'sd1932, -16'sd2009, -16'sd2817, 16'sd20, 16'sd1036, 16'sd894, 16'sd114, 16'sd2769, 16'sd2275, -16'sd917, 16'sd86, -16'sd1003, 16'sd454, 16'sd268, -16'sd2, 16'sd514 },
    '{- 16'sd311, -16'sd578, -16'sd1565, -16'sd2182, 16'sd74, -16'sd1606, -16'sd798, 16'sd194, 16'sd618, 16'sd357, 16'sd1893, -16'sd295, -16'sd2847, -16'sd469, 16'sd1187, -16'sd1616, 16'sd678, 16'sd1627, 16'sd357, 16'sd1269, -16'sd564, 16'sd1957, 16'sd706, 16'sd1507 },
    '{ 16'sd860, 16'sd10, -16'sd374, -16'sd385, -16'sd424, -16'sd862, -16'sd14, 16'sd599, -16'sd734, -16'sd1239, -16'sd129, -16'sd25, 16'sd383, -16'sd451, -16'sd243, -16'sd153, 16'sd2109, -16'sd445, 16'sd1854, -16'sd1933, 16'sd19, 16'sd1460, -16'sd884, 16'sd276 },
    '{- 16'sd716, -16'sd1065, -16'sd121, 16'sd201, 16'sd1093, -16'sd20, 16'sd410, -16'sd1549, 16'sd911, -16'sd958, 16'sd1605, 16'sd1343, -16'sd518, -16'sd1436, 16'sd1311, 16'sd236, -16'sd3899, -16'sd810, -16'sd1525, 16'sd341, 16'sd929, -16'sd508, 16'sd1161, -16'sd1352 },
    '{ 16'sd688, -16'sd730, -16'sd288, -16'sd2440, 16'sd1580, 16'sd1606, -16'sd3601, 16'sd714, -16'sd811, -16'sd535, 16'sd537, 16'sd304, -16'sd2367, 16'sd482, 16'sd213, 16'sd772, -16'sd1501, -16'sd897, -16'sd362, -16'sd1342, 16'sd730, -16'sd420, 16'sd704, -16'sd2125 },
    '{ 16'sd115, -16'sd315, -16'sd321, 16'sd122, 16'sd195, 16'sd2154, -16'sd892, -16'sd1468, -16'sd2368, 16'sd541, -16'sd79, 16'sd1674, -16'sd1845, -16'sd1416, 16'sd911, 16'sd1061, 16'sd1552, -16'sd73, 16'sd889, 16'sd1218, -16'sd1700, 16'sd379, -16'sd1150, 16'sd1190 },
    '{ 16'sd866, 16'sd252, 16'sd461, -16'sd1800, -16'sd332, -16'sd2619, -16'sd1321, 16'sd1532, -16'sd100, -16'sd690, 16'sd421, 16'sd1220, -16'sd165, 16'sd385, -16'sd1178, 16'sd1834, 16'sd727, 16'sd426, -16'sd272, 16'sd892, -16'sd545, 16'sd412, -16'sd204, -16'sd2226 },
    '{- 16'sd1986, -16'sd1281, -16'sd277, 16'sd621, 16'sd1535, -16'sd1261, -16'sd173, -16'sd353, 16'sd708, -16'sd1393, -16'sd671, 16'sd423, -16'sd1814, 16'sd717, -16'sd1012, 16'sd1699, -16'sd1882, 16'sd1199, 16'sd865, 16'sd423, -16'sd2413, -16'sd483, 16'sd389, -16'sd920 },
    '{ 16'sd1184, -16'sd419, -16'sd173, -16'sd2325, 16'sd913, -16'sd395, -16'sd2524, 16'sd598, -16'sd110, -16'sd1337, 16'sd375, 16'sd2932, 16'sd2389, -16'sd219, 16'sd858, -16'sd2739, 16'sd262, -16'sd189, -16'sd243, -16'sd47, -16'sd423, -16'sd524, 16'sd246, -16'sd195 },
    '{- 16'sd962, -16'sd401, -16'sd248, 16'sd1273, -16'sd257, -16'sd2460, 16'sd1138, -16'sd1451, 16'sd471, -16'sd120, -16'sd405, -16'sd2085, 16'sd410, -16'sd1777, 16'sd1985, -16'sd281, 16'sd400, 16'sd116, -16'sd156, -16'sd1033, -16'sd117, 16'sd1647, -16'sd2790, 16'sd1714 },
    '{ 16'sd700, -16'sd623, -16'sd501, 16'sd1489, -16'sd931, 16'sd2117, -16'sd698, 16'sd779, -16'sd297, 16'sd2162, -16'sd801, 16'sd1649, -16'sd145, -16'sd2530, 16'sd194, -16'sd1042, -16'sd9, 16'sd999, 16'sd159, 16'sd591, -16'sd1278, -16'sd396, -16'sd1476, -16'sd51 },
    '{- 16'sd547, -16'sd356, 16'sd1282, -16'sd137, 16'sd1808, 16'sd938, 16'sd628, -16'sd869, 16'sd1312, 16'sd568, 16'sd710, 16'sd232, -16'sd37, -16'sd1805, -16'sd1462, -16'sd151, -16'sd1620, 16'sd2536, -16'sd437, 16'sd608, -16'sd790, 16'sd12, -16'sd2623, -16'sd76 },
    '{ 16'sd1790, -16'sd1235, 16'sd929, 16'sd216, -16'sd360, 16'sd734, -16'sd1879, 16'sd2058, 16'sd1429, -16'sd69, -16'sd577, -16'sd3164, -16'sd24, -16'sd827, 16'sd261, 16'sd75, -16'sd639, 16'sd222, 16'sd1427, -16'sd799, 16'sd378, -16'sd340, -16'sd1329, -16'sd158 },
    '{- 16'sd377, -16'sd853, -16'sd2304, -16'sd635, 16'sd662, 16'sd1535, -16'sd1849, 16'sd915, -16'sd2346, 16'sd95, -16'sd913, 16'sd869, -16'sd623, -16'sd502, -16'sd940, -16'sd2635, 16'sd1270, 16'sd823, 16'sd349, -16'sd938, 16'sd323, -16'sd26, -16'sd450, 16'sd1955 },
    '{ 16'sd1491, 16'sd1057, -16'sd896, -16'sd923, 16'sd1478, -16'sd739, 16'sd1632, -16'sd1119, 16'sd497, 16'sd1030, -16'sd381, 16'sd2032, -16'sd1078, -16'sd1524, -16'sd1355, 16'sd607, -16'sd1664, 16'sd945, -16'sd545, 16'sd569, 16'sd0, -16'sd679, 16'sd401, -16'sd702 },
    '{- 16'sd609, -16'sd461, 16'sd916, 16'sd1177, 16'sd346, 16'sd245, -16'sd928, 16'sd123, 16'sd287, 16'sd219, 16'sd2339, -16'sd2804, 16'sd420, 16'sd1070, -16'sd48, -16'sd380, 16'sd684, 16'sd1042, -16'sd401, -16'sd1662, 16'sd199, -16'sd1488, 16'sd2636, 16'sd282 },
    '{ 16'sd1219, -16'sd988, -16'sd227, 16'sd295, -16'sd732, -16'sd94, -16'sd299, 16'sd1592, 16'sd1869, -16'sd423, -16'sd3274, -16'sd422, 16'sd84, 16'sd1997, 16'sd1170, 16'sd442, -16'sd310, 16'sd1089, 16'sd937, 16'sd252, 16'sd677, 16'sd1670, -16'sd673, 16'sd600  }
	 
	 
	 
	 };




integer i, j;
reg signed [31:0] sum;  // 用于累加，扩展位宽以避免溢出
reg signed [15:0] temp_output_data[0:63];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        valid <= 0;
        // 可以在这里初始化output_data为一个确定的值，如果需要的话
         for (i = 0; i < 64; i = i + 1)begin output_data[i] <= 0;end
    end else if (start) begin
        for (i = 0; i < 64; i = i + 1) begin
            sum = 0; // 初始化sum为0
            for (j = 0; j < 24; j = j + 1) begin
                // 执行矩阵乘法和累加
                sum = sum + (input_data[j] * weights_1[i][j]);
            end
            // 所有加权和完成后，整体右移12位来调整格式
            sum = sum >>> 12;
            sum = sum + biases_1[i];
            // 使用临时变量来存储调整后的结果，然后在循环外赋值给output_data
            temp_output_data[i] = sum[15:0];
        end
        // 使用单独的循环或直接在上面的循环中使用非阻塞性赋值更新output_data
        for (i = 0; i < 64; i = i + 1) begin
            output_data[i] <= temp_output_data[i];
        end
        valid <= 1; // 标记所有输出数据为有效
    end
end



endmodule