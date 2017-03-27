/**********************************************************
 * The following C source code was automatically generated
 * by the new DTREE version: 1.x  
 **********************************************************/

#include <string.h>  /* for strcmp() */

/*******************************************
 * APPLICATION DEPENDENT MISSING VALUE CODES
 *******************************************/

const double DBL_MISSING_VALUE = 0.0;
const int    INT_MISSING_VALUE = 0;

/************
 * PREDICTORS
 ************/
double BRAND_NAME$, IDF_FRAC, IDF_MISS_LEFT$, IDF_MISS_LEFT_WEIGHT, IDF_MISS_RIGHT$, IDF_MISS_RIGHT_WEIGHT, LEN_Q_2_LEN_P_1$, LEN_Q_2_LEN_P_2$, LEN_Q_3_LEN_P_1$, 
        LEN_Q_3_LEN_P_2$, LEN_Q_3_LEN_P_3$, LEN_Q_4_LEN_P_1$, LEN_Q_4_LEN_P_2$, LEN_Q_4_LEN_P_3$, LEN_Q_4_LEN_P_4$, LEN_Q_5_LEN_P_1$, LEN_Q_5_LEN_P_2$, 
        LEN_Q_5_LEN_P_3$, LEN_Q_5_LEN_P_4$, LEN_Q_6_LEN_P_3$, LEN_Q_6_LEN_P_4$, LEN_Q_6_LEN_P_5$, PARTIAL_BRAND$, POS_L_P_0_S_0$, POS_L_P_0_S_3$, 
        POS_L_P_0_S_5$, POS_L_P_1$, POS_L_P_1_S_1$, POS_L_P_3$, POS_L_P_3_S_0$, POS_L_P_3_S_3$, POS_L_P_4$, POS_L_P_4_S_0$, 
        POS_L_P_5$, POS_L_P_5_S_0$, POS_L_P_5_S_5$, POS_L_P_NO$, POS_N_Q_0_P_0$, POS_N_Q_1_P_1$, POS_N_Q_2_P_0$, POS_N_Q_2_P_1$, 
        POS_N_Q_2_P_2$, POS_N_Q_3_P_3$, POS_N_Q_4_P_3$, POS_R_P_0_E_0$, POS_R_P_0_E_5$, POS_R_P_1_E_0$, POS_R_P_2_E_0$, POS_R_P_3_E_0$, 
        POS_R_P_3_E_5$, POS_R_P_4_E_0$, POS_R_P_4_E_5$, POS_R_P_5_E_0$, POS_R_P_5_E_5$, POS_R_P_6_E_0$, POS_R_P_NO$, QBERT_SCORE$, 
        TP_FRAC, TP_INCLUDE$, TP_PARTIAL$;

/***************************************************************
 * Here come the trees in the treenet.  A shell for calling them
 * appears at the end of this source file.
 ***************************************************************/
/* Data Dictionary, Number Of Variables = 60*/
/*    Name = BRAND_NAME$, Type = categorical. */
/*    Name = IDF_FRAC, Type = continuous. */
/*    Name = IDF_MISS_LEFT$, Type = categorical. */
/*    Name = IDF_MISS_LEFT_WEIGHT, Type = continuous. */
/*    Name = IDF_MISS_RIGHT$, Type = categorical. */
/*    Name = IDF_MISS_RIGHT_WEIGHT, Type = continuous. */
/*    Name = LEN_Q_2_LEN_P_1$, Type = categorical. */
/*    Name = LEN_Q_2_LEN_P_2$, Type = categorical. */
/*    Name = LEN_Q_3_LEN_P_1$, Type = categorical. */
/*    Name = LEN_Q_3_LEN_P_2$, Type = categorical. */
/*    Name = LEN_Q_3_LEN_P_3$, Type = categorical. */
/*    Name = LEN_Q_4_LEN_P_1$, Type = categorical. */
/*    Name = LEN_Q_4_LEN_P_2$, Type = categorical. */
/*    Name = LEN_Q_4_LEN_P_3$, Type = categorical. */
/*    Name = LEN_Q_4_LEN_P_4$, Type = categorical. */
/*    Name = LEN_Q_5_LEN_P_1$, Type = categorical. */
/*    Name = LEN_Q_5_LEN_P_2$, Type = categorical. */
/*    Name = LEN_Q_5_LEN_P_3$, Type = categorical. */
/*    Name = LEN_Q_5_LEN_P_4$, Type = categorical. */
/*    Name = LEN_Q_6_LEN_P_3$, Type = categorical. */
/*    Name = LEN_Q_6_LEN_P_4$, Type = categorical. */
/*    Name = LEN_Q_6_LEN_P_5$, Type = categorical. */
/*    Name = PARTIAL_BRAND$, Type = categorical. */
/*    Name = POS_L_P_0_S_0$, Type = categorical. */
/*    Name = POS_L_P_0_S_3$, Type = categorical. */
/*    Name = POS_L_P_0_S_5$, Type = categorical. */
/*    Name = POS_L_P_1$, Type = categorical. */
/*    Name = POS_L_P_1_S_1$, Type = categorical. */
/*    Name = POS_L_P_3$, Type = categorical. */
/*    Name = POS_L_P_3_S_0$, Type = categorical. */
/*    Name = POS_L_P_3_S_3$, Type = categorical. */
/*    Name = POS_L_P_4$, Type = categorical. */
/*    Name = POS_L_P_4_S_0$, Type = categorical. */
/*    Name = POS_L_P_5$, Type = categorical. */
/*    Name = POS_L_P_5_S_0$, Type = categorical. */
/*    Name = POS_L_P_5_S_5$, Type = categorical. */
/*    Name = POS_L_P_NO$, Type = categorical. */
/*    Name = POS_N_Q_0_P_0$, Type = categorical. */
/*    Name = POS_N_Q_1_P_1$, Type = categorical. */
/*    Name = POS_N_Q_2_P_0$, Type = categorical. */
/*    Name = POS_N_Q_2_P_1$, Type = categorical. */
/*    Name = POS_N_Q_2_P_2$, Type = categorical. */
/*    Name = POS_N_Q_3_P_3$, Type = categorical. */
/*    Name = POS_N_Q_4_P_3$, Type = categorical. */
/*    Name = POS_R_P_0_E_0$, Type = categorical. */
/*    Name = POS_R_P_0_E_5$, Type = categorical. */
/*    Name = POS_R_P_1_E_0$, Type = categorical. */
/*    Name = POS_R_P_2_E_0$, Type = categorical. */
/*    Name = POS_R_P_3_E_0$, Type = categorical. */
/*    Name = POS_R_P_3_E_5$, Type = categorical. */
/*    Name = POS_R_P_4_E_0$, Type = categorical. */
/*    Name = POS_R_P_4_E_5$, Type = categorical. */
/*    Name = POS_R_P_5_E_0$, Type = categorical. */
/*    Name = POS_R_P_5_E_5$, Type = categorical. */
/*    Name = POS_R_P_6_E_0$, Type = categorical. */
/*    Name = POS_R_P_NO$, Type = categorical. */
/*    Name = QBERT_SCORE$, Type = categorical. */
/*    Name = TP_FRAC, Type = continuous. */
/*    Name = TP_INCLUDE$, Type = categorical. */
/*    Name = TP_PARTIAL$, Type = categorical. */

MODELBEGIN:

  /* N trees: 150 */

link TN0;
pred = tnscore; /* predicted value for GRADE */

/*********************/
/* Model is complete */
/*********************/

return;


tnscore = 0.0;

TN0:

  /* Tree 1 of 150 */
N0_1: 
  if IDF_FRAC < 0.6324560046 then goto N0_2;
 else goto N0_5;

N0_2: 
  if QBERT_SCORE$ in (0) then goto N0_3;
 else goto T0_4;

N0_3: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T0_1;
 else goto N0_4;

T0_1: 
  response = 0.0023966586;
 goto D0;

N0_4: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T0_2;
 else goto T0_3;

T0_2: 
  response = 0.0016110335;
 goto D0;

T0_3: 
  response = 0.0079852062;
 goto D0;

T0_4: 
  response = 0.0168303868;
 goto D0;

N0_5: 
  if POS_L_P_NO$ in (0) then goto N0_6;
 else goto N0_7;

N0_6: 
  if QBERT_SCORE$ in (0) then goto T0_5;
 else goto T0_6;

T0_5: 
  response = 0.0122840773;
 goto D0;

T0_6: 
  response = 0.0174227829;
 goto D0;

N0_7: 
  if POS_R_P_NO$ in (0) then goto N0_8;
 else goto T0_10;

N0_8: 
  if QBERT_SCORE$ in (0) then goto T0_7;
 else goto N0_9;

T0_7: 
  response = 0.0143342598;
 goto D0;

N0_9: 
  if IDF_MISS_RIGHT$ in (0) then goto T0_8;
 else goto T0_9;

T0_8: 
  response = 0.0183778096;
 goto D0;

T0_9: 
  response = 0.0245136543;
 goto D0;

T0_10: 
  response = 0.0498888760;
 goto D0;

D0:

tnscore = tnscore + response;

  /* Tree 2 of 150 */
N1_1: 
  if IDF_FRAC < 0.6881945133 then goto N1_2;
 else goto N1_6;

N1_2: 
  if QBERT_SCORE$ in (0) then goto N1_3;
 else goto T1_5;

N1_3: 
  if IDF_FRAC < 0.4868324995 then goto N1_4;
 else goto T1_4;

N1_4: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N1_5;
 else goto T1_3;

N1_5: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto T1_1;
 else goto T1_2;

T1_1: 
  response = 0.0035511675;
 goto D1;

T1_2: 
  response = 0.0089859983;
 goto D1;

T1_3: 
  response = 0.0145240839;
 goto D1;

T1_4: 
  response = 0.0089242499;
 goto D1;

T1_5: 
  response = 0.0158188614;
 goto D1;

N1_6: 
  if POS_L_P_NO$ in (0) then goto N1_7;
 else goto N1_8;

N1_7: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T1_6;
 else goto T1_7;

T1_6: 
  response = 0.0029889986;
 goto D1;

T1_7: 
  response = 0.0136823027;
 goto D1;

N1_8: 
  if POS_R_P_NO$ in (0) then goto N1_9;
 else goto T1_10;

N1_9: 
  if QBERT_SCORE$ in (0) then goto T1_8;
 else goto T1_9;

T1_8: 
  response = 0.0146287802;
 goto D1;

T1_9: 
  response = 0.0207621858;
 goto D1;

T1_10: 
  response = 0.0474016267;
 goto D1;

D1:

tnscore = tnscore + response;

  /* Tree 3 of 150 */
N2_1: 
  if IDF_FRAC < 0.6731635332 then goto N2_2;
 else goto N2_5;

N2_2: 
  if QBERT_SCORE$ in (0) then goto N2_3;
 else goto T2_4;

N2_3: 
  if IDF_FRAC < 0.4843595028 then goto N2_4;
 else goto T2_3;

N2_4: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto T2_1;
 else goto T2_2;

T2_1: 
  response = 0.0038545544;
 goto D2;

T2_2: 
  response = 0.0147313625;
 goto D2;

T2_3: 
  response = 0.0083412962;
 goto D2;

T2_4: 
  response = 0.0154303019;
 goto D2;

N2_5: 
  if POS_L_P_NO$ in (0) then goto N2_6;
 else goto N2_7;

N2_6: 
  if QBERT_SCORE$ in (0) then goto T2_5;
 else goto T2_6;

T2_5: 
  response = 0.0116364311;
 goto D2;

T2_6: 
  response = 0.0163069385;
 goto D2;

N2_7: 
  if POS_R_P_NO$ in (0) then goto N2_8;
 else goto T2_10;

N2_8: 
  if QBERT_SCORE$ in (0) then goto T2_7;
 else goto N2_9;

T2_7: 
  response = 0.0134601400;
 goto D2;

N2_9: 
  if IDF_MISS_RIGHT$ in (0) then goto T2_8;
 else goto T2_9;

T2_8: 
  response = 0.0168341103;
 goto D2;

T2_9: 
  response = 0.0225138546;
 goto D2;

T2_10: 
  response = 0.0450310790;
 goto D2;

D2:

tnscore = tnscore + response;

  /* Tree 4 of 150 */
N3_1: 
  if IDF_FRAC < 0.6731635332 then goto N3_2;
 else goto N3_5;

N3_2: 
  if QBERT_SCORE$ in (0) then goto N3_3;
 else goto T3_4;

N3_3: 
  if IDF_FRAC < 0.4791305065 then goto N3_4;
 else goto T3_3;

N3_4: 
  if POS_N_Q_0_P_0$ in (0) then goto T3_1;
 else goto T3_2;

T3_1: 
  response = 0.0034886147;
 goto D3;

T3_2: 
  response = 0.0101689191;
 goto D3;

T3_3: 
  response = 0.0078699368;
 goto D3;

T3_4: 
  response = 0.0146170454;
 goto D3;

N3_5: 
  if POS_L_P_NO$ in (0) then goto T3_5;
 else goto N3_6;

T3_5: 
  response = 0.0118698930;
 goto D3;

N3_6: 
  if POS_R_P_NO$ in (0) then goto N3_7;
 else goto T3_10;

N3_7: 
  if QBERT_SCORE$ in (0) then goto N3_8;
 else goto N3_9;

N3_8: 
  if IDF_MISS_RIGHT$ in (0) then goto T3_6;
 else goto T3_7;

T3_6: 
  response = 0.0095170347;
 goto D3;

T3_7: 
  response = 0.0152036263;
 goto D3;

N3_9: 
  if IDF_MISS_RIGHT$ in (0) then goto T3_8;
 else goto T3_9;

T3_8: 
  response = 0.0154990286;
 goto D3;

T3_9: 
  response = 0.0215155912;
 goto D3;

T3_10: 
  response = 0.0428628465;
 goto D3;

D3:

tnscore = tnscore + response;

  /* Tree 5 of 150 */
N4_1: 
  if IDF_FRAC < 0.6173340082 then goto N4_2;
 else goto N4_6;

N4_2: 
  if QBERT_SCORE$ in (0) then goto N4_3;
 else goto T4_5;

N4_3: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T4_1;
 else goto N4_4;

T4_1: 
  response = 0.0016434757;
 goto D4;

N4_4: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T4_2;
 else goto N4_5;

T4_2: 
  response = 0.0009567552;
 goto D4;

N4_5: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T4_3;
 else goto T4_4;

T4_3: 
  response = 0.0027894488;
 goto D4;

T4_4: 
  response = 0.0073520751;
 goto D4;

T4_5: 
  response = 0.0137839929;
 goto D4;

N4_6: 
  if POS_L_P_NO$ in (0) then goto N4_7;
 else goto N4_8;

N4_7: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T4_6;
 else goto T4_7;

T4_6: 
  response = 0.0017164384;
 goto D4;

T4_7: 
  response = 0.0112671449;
 goto D4;

N4_8: 
  if POS_R_P_NO$ in (0) then goto N4_9;
 else goto T4_10;

N4_9: 
  if QBERT_SCORE$ in (0) then goto T4_8;
 else goto T4_9;

T4_8: 
  response = 0.0118506571;
 goto D4;

T4_9: 
  response = 0.0170678151;
 goto D4;

T4_10: 
  response = 0.0406294652;
 goto D4;

D4:

tnscore = tnscore + response;

  /* Tree 6 of 150 */
N5_1: 
  if IDF_FRAC < 0.6892720461 then goto N5_2;
 else goto N5_4;

N5_2: 
  if QBERT_SCORE$ in (0) then goto N5_3;
 else goto T5_3;

N5_3: 
  if IDF_FRAC < 0.4647009969 then goto T5_1;
 else goto T5_2;

T5_1: 
  response = 0.0034937402;
 goto D5;

T5_2: 
  response = 0.0071681905;
 goto D5;

T5_3: 
  response = 0.0131673369;
 goto D5;

N5_4: 
  if POS_L_P_NO$ in (0) then goto N5_5;
 else goto N5_6;

N5_5: 
  if QBERT_SCORE$ in (0) then goto T5_4;
 else goto T5_5;

T5_4: 
  response = 0.0099013395;
 goto D5;

T5_5: 
  response = 0.0143381086;
 goto D5;

N5_6: 
  if POS_R_P_NO$ in (0) then goto N5_7;
 else goto T5_10;

N5_7: 
  if QBERT_SCORE$ in (0) then goto N5_8;
 else goto N5_9;

N5_8: 
  if IDF_MISS_RIGHT$ in (0) then goto T5_6;
 else goto T5_7;

T5_6: 
  response = 0.0087984377;
 goto D5;

T5_7: 
  response = 0.0141394254;
 goto D5;

N5_9: 
  if IDF_MISS_RIGHT$ in (0) then goto T5_8;
 else goto T5_9;

T5_8: 
  response = 0.0144260438;
 goto D5;

T5_9: 
  response = 0.0198266158;
 goto D5;

T5_10: 
  response = 0.0385964588;
 goto D5;

D5:

tnscore = tnscore + response;

  /* Tree 7 of 150 */
N6_1: 
  if IDF_FRAC < 0.5857864618 then goto N6_2;
 else goto N6_5;

N6_2: 
  if QBERT_SCORE$ in (0) then goto N6_3;
 else goto T6_4;

N6_3: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N6_4;
 else goto T6_3;

N6_4: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T6_1;
 else goto T6_2;

T6_1: 
  response = 0.0011777252;
 goto D6;

T6_2: 
  response = 0.0043947272;
 goto D6;

T6_3: 
  response = 0.0117720187;
 goto D6;

T6_4: 
  response = 0.0122802558;
 goto D6;

N6_5: 
  if POS_L_P_NO$ in (0) then goto N6_6;
 else goto N6_7;

N6_6: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T6_5;
 else goto T6_6;

T6_5: 
  response = 0.0014522993;
 goto D6;

T6_6: 
  response = 0.0100553776;
 goto D6;

N6_7: 
  if POS_R_P_NO$ in (0) then goto N6_8;
 else goto T6_10;

N6_8: 
  if QBERT_SCORE$ in (0) then goto N6_9;
 else goto T6_9;

N6_9: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto T6_7;
 else goto T6_8;

T6_7: 
  response = 0.0091382774;
 goto D6;

T6_8: 
  response = 0.0150698771;
 goto D6;

T6_9: 
  response = 0.0155167397;
 goto D6;

T6_10: 
  response = 0.0366179509;
 goto D6;

D6:

tnscore = tnscore + response;

  /* Tree 8 of 150 */
N7_1: 
  if IDF_FRAC < 0.6881945133 then goto N7_2;
 else goto N7_5;

N7_2: 
  if QBERT_SCORE$ in (0) then goto N7_3;
 else goto T7_4;

N7_3: 
  if IDF_FRAC < 0.4874920249 then goto N7_4;
 else goto T7_3;

N7_4: 
  if POS_N_Q_0_P_0$ in (0) then goto T7_1;
 else goto T7_2;

T7_1: 
  response = 0.0027951532;
 goto D7;

T7_2: 
  response = 0.0089598737;
 goto D7;

T7_3: 
  response = 0.0066560162;
 goto D7;

T7_4: 
  response = 0.0117473532;
 goto D7;

N7_5: 
  if POS_L_P_NO$ in (0) then goto N7_6;
 else goto N7_7;

N7_6: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T7_5;
 else goto T7_6;

T7_5: 
  response = 0.0006933336;
 goto D7;

T7_6: 
  response = 0.0101166837;
 goto D7;

N7_7: 
  if POS_R_P_NO$ in (0) then goto N7_8;
 else goto T7_10;

N7_8: 
  if QBERT_SCORE$ in (0) then goto N7_9;
 else goto T7_9;

N7_9: 
  if IDF_MISS_RIGHT$ in (0) then goto T7_7;
 else goto T7_8;

T7_7: 
  response = 0.0078768655;
 goto D7;

T7_8: 
  response = 0.0129085567;
 goto D7;

T7_9: 
  response = 0.0154365531;
 goto D7;

T7_10: 
  response = 0.0348943558;
 goto D7;

D7:

tnscore = tnscore + response;

  /* Tree 9 of 150 */
N8_1: 
  if IDF_FRAC < 0.7090049982 then goto N8_2;
 else goto N8_7;

N8_2: 
  if QBERT_SCORE$ in (0) then goto N8_3;
 else goto T8_6;

N8_3: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N8_4;
 else goto T8_5;

N8_4: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto N8_5;
 else goto T8_4;

N8_5: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N8_6;
 else goto T8_3;

N8_6: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto T8_1;
 else goto T8_2;

T8_1: 
  response = 0.0025793336;
 goto D8;

T8_2: 
  response = 0.0144222749;
 goto D8;

T8_3: 
  response = 0.0093664167;
 goto D8;

T8_4: 
  response = 0.0068851202;
 goto D8;

T8_5: 
  response = 0.0105712022;
 goto D8;

T8_6: 
  response = 0.0110313888;
 goto D8;

N8_7: 
  if POS_L_P_NO$ in (0) then goto T8_7;
 else goto N8_8;

T8_7: 
  response = 0.0094269603;
 goto D8;

N8_8: 
  if POS_R_P_NO$ in (0) then goto N8_9;
 else goto T8_10;

N8_9: 
  if QBERT_SCORE$ in (0) then goto T8_8;
 else goto T8_9;

T8_8: 
  response = 0.0100805963;
 goto D8;

T8_9: 
  response = 0.0149689822;
 goto D8;

T8_10: 
  response = 0.0330980564;
 goto D8;

D8:

tnscore = tnscore + response;

  /* Tree 10 of 150 */
N9_1: 
  if QBERT_SCORE$ in (0) then goto N9_2;
 else goto N9_9;

N9_2: 
  if IDF_FRAC < 0.5656275153 then goto N9_3;
 else goto N9_4;

N9_3: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto T9_1;
 else goto T9_2;

T9_1: 
  response = 0.0028951367;
 goto D9;

T9_2: 
  response = 0.0107380993;
 goto D9;

N9_4: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N9_5;
 else goto T9_8;

N9_5: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T9_3;
 else goto N9_6;

T9_3: 
  response = 0.0007557865;
 goto D9;

N9_6: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T9_4;
 else goto N9_7;

T9_4: 
  response = 0.0025489289;
 goto D9;

N9_7: 
  if LEN_Q_4_LEN_P_4$ in (0) then goto N9_8;
 else goto T9_7;

N9_8: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto T9_5;
 else goto T9_6;

T9_5: 
  response = 0.0085507415;
 goto D9;

T9_6: 
  response = 0.0151908553;
 goto D9;

T9_7: 
  response = 0.0232227685;
 goto D9;

T9_8: 
  response = 0.0200776860;
 goto D9;

N9_9: 
  if IDF_FRAC < 0.8733974695 then goto T9_9;
 else goto T9_10;

T9_9: 
  response = 0.0109524263;
 goto D9;

T9_10: 
  response = 0.0158598885;
 goto D9;

D9:

tnscore = tnscore + response;

  /* Tree 11 of 150 */
N10_1: 
  if QBERT_SCORE$ in (0) then goto N10_2;
 else goto N10_9;

N10_2: 
  if IDF_FRAC < 0.5671175122 then goto N10_3;
 else goto N10_4;

N10_3: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T10_1;
 else goto T10_2;

T10_1: 
  response = 0.0007223798;
 goto D10;

T10_2: 
  response = 0.0038014735;
 goto D10;

N10_4: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N10_5;
 else goto N10_8;

N10_5: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T10_3;
 else goto N10_6;

T10_3: 
  response = 0.0003139900;
 goto D10;

N10_6: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T10_4;
 else goto N10_7;

T10_4: 
  response = 0.0027403900;
 goto D10;

N10_7: 
  if LEN_Q_4_LEN_P_4$ in (0) then goto T10_5;
 else goto T10_6;

T10_5: 
  response = 0.0086300469;
 goto D10;

T10_6: 
  response = 0.0213750982;
 goto D10;

N10_8: 
  if POS_L_P_NO$ in (0) then goto T10_7;
 else goto T10_8;

T10_7: 
  response = 0.0114903760;
 goto D10;

T10_8: 
  response = 0.0289000800;
 goto D10;

N10_9: 
  if IDF_FRAC < 0.8280785084 then goto T10_9;
 else goto T10_10;

T10_9: 
  response = 0.0103614997;
 goto D10;

T10_10: 
  response = 0.0148002078;
 goto D10;

D10:

tnscore = tnscore + response;

  /* Tree 12 of 150 */
N11_1: 
  if IDF_FRAC < 0.7231799960 then goto N11_2;
 else goto N11_6;

N11_2: 
  if QBERT_SCORE$ in (0) then goto N11_3;
 else goto T11_5;

N11_3: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N11_4;
 else goto T11_4;

N11_4: 
  if IDF_FRAC < 0.4045085013 then goto N11_5;
 else goto T11_3;

N11_5: 
  if POS_N_Q_0_P_0$ in (0) then goto T11_1;
 else goto T11_2;

T11_1: 
  response = 0.0014884782;
 goto D11;

T11_2: 
  response = 0.0071476888;
 goto D11;

T11_3: 
  response = 0.0046667350;
 goto D11;

T11_4: 
  response = 0.0096100716;
 goto D11;

T11_5: 
  response = 0.0094269504;
 goto D11;

N11_6: 
  if POS_L_P_NO$ in (0) then goto T11_6;
 else goto N11_7;

T11_6: 
  response = 0.0082738626;
 goto D11;

N11_7: 
  if POS_R_P_NO$ in (0) then goto N11_8;
 else goto T11_10;

N11_8: 
  if IDF_MISS_RIGHT$ in (0) then goto T11_7;
 else goto N11_9;

T11_7: 
  response = 0.0084552827;
 goto D11;

N11_9: 
  if TP_FRAC < 0.9902659655 then goto T11_8;
 else goto T11_9;

T11_8: 
  response = 0.0099099996;
 goto D11;

T11_9: 
  response = 0.0147448397;
 goto D11;

T11_10: 
  response = 0.0296623065;
 goto D11;

D11:

tnscore = tnscore + response;

  /* Tree 13 of 150 */
N12_1: 
  if QBERT_SCORE$ in (0) then goto N12_2;
 else goto N12_9;

N12_2: 
  if IDF_FRAC < 0.6262254715 then goto N12_3;
 else goto N12_5;

N12_3: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T12_1;
 else goto N12_4;

T12_1: 
  response = 0.0005824836;
 goto D12;

N12_4: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T12_2;
 else goto T12_3;

T12_2: 
  response = -0.0001630391;
 goto D12;

T12_3: 
  response = 0.0047093616;
 goto D12;

N12_5: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N12_6;
 else goto T12_8;

N12_6: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T12_4;
 else goto N12_7;

T12_4: 
  response = -0.0006535265;
 goto D12;

N12_7: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T12_5;
 else goto N12_8;

T12_5: 
  response = 0.0020097327;
 goto D12;

N12_8: 
  if POS_L_P_NO$ in (0) then goto T12_6;
 else goto T12_7;

T12_6: 
  response = 0.0068961286;
 goto D12;

T12_7: 
  response = 0.0103580685;
 goto D12;

T12_8: 
  response = 0.0175912425;
 goto D12;

N12_9: 
  if IDF_FRAC < 0.8492425084 then goto T12_9;
 else goto T12_10;

T12_9: 
  response = 0.0094446544;
 goto D12;

T12_10: 
  response = 0.0138594529;
 goto D12;

D12:

tnscore = tnscore + response;

  /* Tree 14 of 150 */
N13_1: 
  if IDF_FRAC < 0.7395650148 then goto N13_2;
 else goto N13_7;

N13_2: 
  if QBERT_SCORE$ in (0) then goto N13_3;
 else goto T13_6;

N13_3: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N13_4;
 else goto T13_5;

N13_4: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T13_1;
 else goto N13_5;

T13_1: 
  response = 0.0006630379;
 goto D13;

N13_5: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T13_2;
 else goto N13_6;

T13_2: 
  response = -0.0002907807;
 goto D13;

N13_6: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T13_3;
 else goto T13_4;

T13_3: 
  response = 0.0014007508;
 goto D13;

T13_4: 
  response = 0.0049303325;
 goto D13;

T13_5: 
  response = 0.0086725929;
 goto D13;

T13_6: 
  response = 0.0083563244;
 goto D13;

N13_7: 
  if POS_L_P_NO$ in (0) then goto T13_7;
 else goto N13_8;

T13_7: 
  response = 0.0073692022;
 goto D13;

N13_8: 
  if POS_R_P_NO$ in (0) then goto N13_9;
 else goto T13_10;

N13_9: 
  if IDF_MISS_RIGHT$ in (0) then goto T13_8;
 else goto T13_9;

T13_8: 
  response = 0.0077091379;
 goto D13;

T13_9: 
  response = 0.0120591775;
 goto D13;

T13_10: 
  response = 0.0274557859;
 goto D13;

D13:

tnscore = tnscore + response;

  /* Tree 15 of 150 */
N14_1: 
  if IDF_FRAC < 0.7395650148 then goto N14_2;
 else goto N14_7;

N14_2: 
  if QBERT_SCORE$ in (0) then goto N14_3;
 else goto T14_6;

N14_3: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N14_4;
 else goto T14_5;

N14_4: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T14_1;
 else goto N14_5;

T14_1: 
  response = 0.0005321787;
 goto D14;

N14_5: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T14_2;
 else goto N14_6;

T14_2: 
  response = -0.0002220175;
 goto D14;

N14_6: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T14_3;
 else goto T14_4;

T14_3: 
  response = 0.0013219236;
 goto D14;

T14_4: 
  response = 0.0046122266;
 goto D14;

T14_5: 
  response = 0.0081832862;
 goto D14;

T14_6: 
  response = 0.0081594760;
 goto D14;

N14_7: 
  if POS_L_P_NO$ in (0) then goto T14_7;
 else goto N14_8;

T14_7: 
  response = 0.0069881454;
 goto D14;

N14_8: 
  if POS_R_P_NO$ in (0) then goto N14_9;
 else goto T14_10;

N14_9: 
  if IDF_MISS_RIGHT$ in (0) then goto T14_8;
 else goto T14_9;

T14_8: 
  response = 0.0070536999;
 goto D14;

T14_9: 
  response = 0.0116831378;
 goto D14;

T14_10: 
  response = 0.0261913008;
 goto D14;

D14:

tnscore = tnscore + response;

  /* Tree 16 of 150 */
N15_1: 
  if QBERT_SCORE$ in (0) then goto N15_2;
 else goto N15_8;

N15_2: 
  if IDF_FRAC < 0.5671175122 then goto T15_1;
 else goto N15_3;

T15_1: 
  response = 0.0023876956;
 goto D15;

N15_3: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N15_4;
 else goto T15_7;

N15_4: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N15_5;
 else goto T15_6;

N15_5: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N15_6;
 else goto T15_5;

N15_6: 
  if LEN_Q_4_LEN_P_4$ in (0) then goto N15_7;
 else goto T15_4;

N15_7: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto T15_2;
 else goto T15_3;

T15_2: 
  response = 0.0038281989;
 goto D15;

T15_3: 
  response = 0.0129049422;
 goto D15;

T15_4: 
  response = 0.0181119927;
 goto D15;

T15_5: 
  response = 0.0119407503;
 goto D15;

T15_6: 
  response = 0.0089540910;
 goto D15;

T15_7: 
  response = 0.0157679855;
 goto D15;

N15_8: 
  if IDF_FRAC < 0.8509260416 then goto T15_8;
 else goto N15_9;

T15_8: 
  response = 0.0079818621;
 goto D15;

N15_9: 
  if POS_L_P_4$ in (1) then goto T15_9;
 else goto T15_10;

T15_9: 
  response = -0.0008433037;
 goto D15;

T15_10: 
  response = 0.0127791866;
 goto D15;

D15:

tnscore = tnscore + response;

  /* Tree 17 of 150 */
N16_1: 
  if QBERT_SCORE$ in (0) then goto N16_2;
 else goto N16_9;

N16_2: 
  if IDF_FRAC < 0.6023254991 then goto T16_1;
 else goto N16_3;

T16_1: 
  response = 0.0023610998;
 goto D16;

N16_3: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N16_4;
 else goto T16_8;

N16_4: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T16_2;
 else goto N16_5;

T16_2: 
  response = -0.0005761606;
 goto D16;

N16_5: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T16_3;
 else goto N16_6;

T16_3: 
  response = 0.0011184144;
 goto D16;

N16_6: 
  if LEN_Q_4_LEN_P_2$ in (1) then goto T16_4;
 else goto N16_7;

T16_4: 
  response = 0.0023909317;
 goto D16;

N16_7: 
  if LEN_Q_3_LEN_P_2$ in (1) then goto T16_5;
 else goto N16_8;

T16_5: 
  response = 0.0049084529;
 goto D16;

N16_8: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T16_6;
 else goto T16_7;

T16_6: 
  response = -0.0040817368;
 goto D16;

T16_7: 
  response = 0.0092160399;
 goto D16;

T16_8: 
  response = 0.0142494440;
 goto D16;

N16_9: 
  if IDF_FRAC < 0.8280785084 then goto T16_9;
 else goto T16_10;

T16_9: 
  response = 0.0075352941;
 goto D16;

T16_10: 
  response = 0.0116084430;
 goto D16;

D16:

tnscore = tnscore + response;

  /* Tree 18 of 150 */
N17_1: 
  if QBERT_SCORE$ in (0) then goto N17_2;
 else goto N17_8;

N17_2: 
  if IDF_FRAC < 0.7204650044 then goto N17_3;
 else goto N17_5;

N17_3: 
  if POS_L_P_NO$ in (0) then goto N17_4;
 else goto T17_3;

N17_4: 
  if PARTIAL_BRAND$ in (0) then goto T17_1;
 else goto T17_2;

T17_1: 
  response = 0.0012510478;
 goto D17;

T17_2: 
  response = 0.0056001465;
 goto D17;

T17_3: 
  response = 0.0044802061;
 goto D17;

N17_5: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T17_4;
 else goto N17_6;

T17_4: 
  response = -0.0021078995;
 goto D17;

N17_6: 
  if POS_L_P_NO$ in (0) then goto T17_5;
 else goto N17_7;

T17_5: 
  response = 0.0054411883;
 goto D17;

N17_7: 
  if POS_R_P_NO$ in (0) then goto T17_6;
 else goto T17_7;

T17_6: 
  response = 0.0070128823;
 goto D17;

T17_7: 
  response = 0.0233316838;
 goto D17;

N17_8: 
  if IDF_FRAC < 0.8153020144 then goto T17_8;
 else goto N17_9;

T17_8: 
  response = 0.0071655811;
 goto D17;

N17_9: 
  if POS_L_P_4$ in (1) then goto T17_9;
 else goto T17_10;

T17_9: 
  response = -0.0012979364;
 goto D17;

T17_10: 
  response = 0.0117871659;
 goto D17;

D17:

tnscore = tnscore + response;

  /* Tree 19 of 150 */
N18_1: 
  if IDF_FRAC < 0.7625315189 then goto N18_2;
 else goto N18_7;

N18_2: 
  if QBERT_SCORE$ in (0) then goto N18_3;
 else goto N18_6;

N18_3: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N18_4;
 else goto T18_4;

N18_4: 
  if POS_L_P_NO$ in (0) then goto N18_5;
 else goto T18_3;

N18_5: 
  if PARTIAL_BRAND$ in (0) then goto T18_1;
 else goto T18_2;

T18_1: 
  response = 0.0009950631;
 goto D18;

T18_2: 
  response = 0.0050573369;
 goto D18;

T18_3: 
  response = 0.0040472180;
 goto D18;

T18_4: 
  response = 0.0070530893;
 goto D18;

N18_6: 
  if IDF_FRAC < 0.0399999991 then goto T18_5;
 else goto T18_6;

T18_5: 
  response = 0.0104780234;
 goto D18;

T18_6: 
  response = 0.0058772754;
 goto D18;

N18_7: 
  if POS_L_P_NO$ in (0) then goto T18_7;
 else goto N18_8;

T18_7: 
  response = 0.0056008828;
 goto D18;

N18_8: 
  if POS_R_P_NO$ in (0) then goto N18_9;
 else goto T18_10;

N18_9: 
  if IDF_MISS_RIGHT$ in (0) then goto T18_8;
 else goto T18_9;

T18_8: 
  response = 0.0059142960;
 goto D18;

T18_9: 
  response = 0.0097696485;
 goto D18;

T18_10: 
  response = 0.0225698611;
 goto D18;

D18:

tnscore = tnscore + response;

  /* Tree 20 of 150 */
N19_1: 
  if QBERT_SCORE$ in (0) then goto N19_2;
 else goto T19_10;

N19_2: 
  if IDF_FRAC < 0.5633015037 then goto T19_1;
 else goto N19_3;

T19_1: 
  response = 0.0018264953;
 goto D19;

N19_3: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T19_2;
 else goto N19_4;

T19_2: 
  response = -0.0004101751;
 goto D19;

N19_4: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T19_3;
 else goto N19_5;

T19_3: 
  response = 0.0007807673;
 goto D19;

N19_5: 
  if LEN_Q_3_LEN_P_2$ in (1) then goto T19_4;
 else goto N19_6;

T19_4: 
  response = 0.0040422658;
 goto D19;

N19_6: 
  if LEN_Q_4_LEN_P_2$ in (1) then goto T19_5;
 else goto N19_7;

T19_5: 
  response = 0.0022383332;
 goto D19;

N19_7: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T19_6;
 else goto N19_8;

T19_6: 
  response = -0.0036285112;
 goto D19;

N19_8: 
  if POS_L_P_NO$ in (0) then goto T19_7;
 else goto N19_9;

T19_7: 
  response = 0.0068634153;
 goto D19;

N19_9: 
  if POS_R_P_NO$ in (0) then goto T19_8;
 else goto T19_9;

T19_8: 
  response = 0.0084834581;
 goto D19;

T19_9: 
  response = 0.0211150076;
 goto D19;

T19_10: 
  response = 0.0074759223;
 goto D19;

D19:

tnscore = tnscore + response;

  /* Tree 21 of 150 */
N20_1: 
  if IDF_FRAC < 0.7625315189 then goto N20_2;
 else goto N20_7;

N20_2: 
  if QBERT_SCORE$ in (0) then goto N20_3;
 else goto T20_6;

N20_3: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T20_1;
 else goto N20_4;

T20_1: 
  response = 0.0000040682;
 goto D20;

N20_4: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T20_2;
 else goto N20_5;

T20_2: 
  response = -0.0007929045;
 goto D20;

N20_5: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T20_3;
 else goto N20_6;

T20_3: 
  response = 0.0007776523;
 goto D20;

N20_6: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T20_4;
 else goto T20_5;

T20_4: 
  response = -0.0024015311;
 goto D20;

T20_5: 
  response = 0.0044991507;
 goto D20;

T20_6: 
  response = 0.0058978739;
 goto D20;

N20_7: 
  if POS_L_P_NO$ in (0) then goto T20_7;
 else goto N20_8;

T20_7: 
  response = 0.0050098945;
 goto D20;

N20_8: 
  if POS_R_P_NO$ in (0) then goto N20_9;
 else goto T20_10;

N20_9: 
  if QBERT_SCORE$ in (0) then goto T20_8;
 else goto T20_9;

T20_8: 
  response = 0.0053972258;
 goto D20;

T20_9: 
  response = 0.0095563764;
 goto D20;

T20_10: 
  response = 0.0205454854;
 goto D20;

D20:

tnscore = tnscore + response;

  /* Tree 22 of 150 */
N21_1: 
  if QBERT_SCORE$ in (0) then goto N21_2;
 else goto N21_8;

N21_2: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T21_1;
 else goto N21_3;

T21_1: 
  response = -0.0002910505;
 goto D21;

N21_3: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T21_2;
 else goto N21_4;

T21_2: 
  response = -0.0010150528;
 goto D21;

N21_4: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T21_3;
 else goto N21_5;

T21_3: 
  response = 0.0005797440;
 goto D21;

N21_5: 
  if POS_L_P_NO$ in (0) then goto N21_6;
 else goto N21_7;

N21_6: 
  if PARTIAL_BRAND$ in (0) then goto T21_4;
 else goto T21_5;

T21_4: 
  response = 0.0030770037;
 goto D21;

T21_5: 
  response = 0.0068337203;
 goto D21;

N21_7: 
  if POS_R_P_NO$ in (0) then goto T21_6;
 else goto T21_7;

T21_6: 
  response = 0.0056169757;
 goto D21;

T21_7: 
  response = 0.0202416989;
 goto D21;

N21_8: 
  if IDF_FRAC < 0.8021739721 then goto T21_8;
 else goto N21_9;

T21_8: 
  response = 0.0058542822;
 goto D21;

N21_9: 
  if POS_L_P_4$ in (1) then goto T21_9;
 else goto T21_10;

T21_9: 
  response = -0.0024037972;
 goto D21;

T21_10: 
  response = 0.0096892362;
 goto D21;

D21:

tnscore = tnscore + response;

  /* Tree 23 of 150 */
N22_1: 
  if QBERT_SCORE$ in (0) then goto N22_2;
 else goto N22_8;

N22_2: 
  if IDF_FRAC < 0.5465369821 then goto N22_3;
 else goto N22_4;

N22_3: 
  if POS_N_Q_0_P_0$ in (0) then goto T22_1;
 else goto T22_2;

T22_1: 
  response = 0.0011107274;
 goto D22;

T22_2: 
  response = 0.0060988622;
 goto D22;

N22_4: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N22_5;
 else goto T22_7;

N22_5: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N22_6;
 else goto T22_6;

N22_6: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N22_7;
 else goto T22_5;

N22_7: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto T22_3;
 else goto T22_4;

T22_3: 
  response = 0.0028481957;
 goto D22;

T22_4: 
  response = 0.0095077613;
 goto D22;

T22_5: 
  response = 0.0106832841;
 goto D22;

T22_6: 
  response = 0.0066748171;
 goto D22;

T22_7: 
  response = 0.0099015448;
 goto D22;

N22_8: 
  if IDF_FRAC < 0.7923849821 then goto N22_9;
 else goto T22_10;

N22_9: 
  if IDF_FRAC < 0.0399999991 then goto T22_8;
 else goto T22_9;

T22_8: 
  response = 0.0094902712;
 goto D22;

T22_9: 
  response = 0.0050307242;
 goto D22;

T22_10: 
  response = 0.0086602360;
 goto D22;

D22:

tnscore = tnscore + response;

  /* Tree 24 of 150 */
N23_1: 
  if IDF_FRAC < 0.7700320482 then goto N23_2;
 else goto N23_7;

N23_2: 
  if POS_L_P_NO$ in (0) then goto N23_3;
 else goto N23_6;

N23_3: 
  if PARTIAL_BRAND$ in (0) then goto N23_4;
 else goto T23_4;

N23_4: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N23_5;
 else goto T23_3;

N23_5: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto T23_1;
 else goto T23_2;

T23_1: 
  response = 0.0006752867;
 goto D23;

T23_2: 
  response = 0.0103415141;
 goto D23;

T23_3: 
  response = 0.0048368063;
 goto D23;

T23_4: 
  response = 0.0048877288;
 goto D23;

N23_6: 
  if POS_N_Q_0_P_0$ in (0) then goto T23_5;
 else goto T23_6;

T23_5: 
  response = 0.0039086637;
 goto D23;

T23_6: 
  response = 0.0099911884;
 goto D23;

N23_7: 
  if POS_L_P_NO$ in (0) then goto T23_7;
 else goto N23_8;

T23_7: 
  response = 0.0043358288;
 goto D23;

N23_8: 
  if POS_R_P_NO$ in (0) then goto N23_9;
 else goto T23_10;

N23_9: 
  if IDF_MISS_RIGHT$ in (0) then goto T23_8;
 else goto T23_9;

T23_8: 
  response = 0.0040692100;
 goto D23;

T23_9: 
  response = 0.0082384844;
 goto D23;

T23_10: 
  response = 0.0182691442;
 goto D23;

D23:

tnscore = tnscore + response;

  /* Tree 25 of 150 */
N24_1: 
  if QBERT_SCORE$ in (0) then goto N24_2;
 else goto N24_9;

N24_2: 
  if IDF_FRAC < 0.5422619581 then goto T24_1;
 else goto N24_3;

T24_1: 
  response = 0.0012548181;
 goto D24;

N24_3: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T24_2;
 else goto N24_4;

T24_2: 
  response = -0.0010771061;
 goto D24;

N24_4: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T24_3;
 else goto N24_5;

T24_3: 
  response = 0.0002824121;
 goto D24;

N24_5: 
  if LEN_Q_4_LEN_P_2$ in (1) then goto T24_4;
 else goto N24_6;

T24_4: 
  response = 0.0012379606;
 goto D24;

N24_6: 
  if LEN_Q_3_LEN_P_2$ in (1) then goto T24_5;
 else goto N24_7;

T24_5: 
  response = 0.0033694571;
 goto D24;

N24_7: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T24_6;
 else goto N24_8;

T24_6: 
  response = -0.0036934914;
 goto D24;

N24_8: 
  if IDF_FRAC < 0.8487709761 then goto T24_7;
 else goto T24_8;

T24_7: 
  response = 0.0050701006;
 goto D24;

T24_8: 
  response = 0.0082424545;
 goto D24;

N24_9: 
  if IDF_FRAC < 0.8355854750 then goto T24_9;
 else goto T24_10;

T24_9: 
  response = 0.0050883260;
 goto D24;

T24_10: 
  response = 0.0079881949;
 goto D24;

D24:

tnscore = tnscore + response;

  /* Tree 26 of 150 */
N25_1: 
  if IDF_FRAC < 0.7395650148 then goto N25_2;
 else goto N25_5;

N25_2: 
  if POS_L_P_NO$ in (0) then goto N25_3;
 else goto N25_4;

N25_3: 
  if PARTIAL_BRAND$ in (0) then goto T25_1;
 else goto T25_2;

T25_1: 
  response = 0.0009783148;
 goto D25;

T25_2: 
  response = 0.0043868374;
 goto D25;

N25_4: 
  if POS_R_P_NO$ in (0) then goto T25_3;
 else goto T25_4;

T25_3: 
  response = 0.0036488945;
 goto D25;

T25_4: 
  response = 0.0413278097;
 goto D25;

N25_5: 
  if POS_L_P_NO$ in (0) then goto N25_6;
 else goto N25_8;

N25_6: 
  if IDF_MISS_LEFT$ in (0) then goto T25_5;
 else goto N25_7;

T25_5: 
  response = 0.0018335934;
 goto D25;

N25_7: 
  if POS_N_Q_1_P_1$ in (1) then goto T25_6;
 else goto T25_7;

T25_6: 
  response = 0.0019391381;
 goto D25;

T25_7: 
  response = 0.0067070579;
 goto D25;

N25_8: 
  if POS_R_P_NO$ in (0) then goto N25_9;
 else goto T25_10;

N25_9: 
  if IDF_MISS_RIGHT$ in (0) then goto T25_8;
 else goto T25_9;

T25_8: 
  response = 0.0037772670;
 goto D25;

T25_9: 
  response = 0.0071563452;
 goto D25;

T25_10: 
  response = 0.0168322303;
 goto D25;

D25:

tnscore = tnscore + response;

  /* Tree 27 of 150 */
N26_1: 
  if QBERT_SCORE$ in (0) then goto N26_2;
 else goto T26_10;

N26_2: 
  if TP_FRAC < 0.2648494840 then goto T26_1;
 else goto N26_3;

T26_1: 
  response = 0.0000905896;
 goto D26;

N26_3: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T26_2;
 else goto N26_4;

T26_2: 
  response = -0.0001091886;
 goto D26;

N26_4: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T26_3;
 else goto N26_5;

T26_3: 
  response = -0.0010816080;
 goto D26;

N26_5: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T26_4;
 else goto N26_6;

T26_4: 
  response = 0.0001391181;
 goto D26;

N26_6: 
  if LEN_Q_4_LEN_P_2$ in (1) then goto T26_5;
 else goto N26_7;

T26_5: 
  response = 0.0016230897;
 goto D26;

N26_7: 
  if LEN_Q_3_LEN_P_2$ in (1) then goto T26_6;
 else goto N26_8;

T26_6: 
  response = 0.0031241803;
 goto D26;

N26_8: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T26_7;
 else goto N26_9;

T26_7: 
  response = -0.0026788155;
 goto D26;

N26_9: 
  if LEN_Q_5_LEN_P_2$ in (1) then goto T26_8;
 else goto T26_9;

T26_8: 
  response = 0.0014213552;
 goto D26;

T26_9: 
  response = 0.0066702624;
 goto D26;

T26_10: 
  response = 0.0054153311;
 goto D26;

D26:

tnscore = tnscore + response;

  /* Tree 28 of 150 */
N27_1: 
  if QBERT_SCORE$ in (0) then goto N27_2;
 else goto T27_10;

N27_2: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T27_1;
 else goto N27_3;

T27_1: 
  response = -0.0004916612;
 goto D27;

N27_3: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T27_2;
 else goto N27_4;

T27_2: 
  response = -0.0013642453;
 goto D27;

N27_4: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T27_3;
 else goto N27_5;

T27_3: 
  response = -0.0000043270;
 goto D27;

N27_5: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T27_4;
 else goto N27_6;

T27_4: 
  response = -0.0030550068;
 goto D27;

N27_6: 
  if LEN_Q_4_LEN_P_2$ in (1) then goto T27_5;
 else goto N27_7;

T27_5: 
  response = 0.0016765683;
 goto D27;

N27_7: 
  if LEN_Q_3_LEN_P_2$ in (1) then goto T27_6;
 else goto N27_8;

T27_6: 
  response = 0.0029983560;
 goto D27;

N27_8: 
  if IDF_FRAC < 0.8816524744 then goto N27_9;
 else goto T27_9;

N27_9: 
  if POS_N_Q_0_P_0$ in (0) then goto T27_7;
 else goto T27_8;

T27_7: 
  response = 0.0041477054;
 goto D27;

T27_8: 
  response = 0.0141772566;
 goto D27;

T27_9: 
  response = 0.0075878181;
 goto D27;

T27_10: 
  response = 0.0052245907;
 goto D27;

D27:

tnscore = tnscore + response;

  /* Tree 29 of 150 */
N28_1: 
  if POS_L_P_NO$ in (0) then goto N28_2;
 else goto N28_6;

N28_2: 
  if PARTIAL_BRAND$ in (0) then goto N28_3;
 else goto N28_5;

N28_3: 
  if POS_L_P_5_S_5$ in (0) then goto N28_4;
 else goto T28_3;

N28_4: 
  if IDF_FRAC < 0.4023810029 then goto T28_1;
 else goto T28_2;

T28_1: 
  response = -0.0004089736;
 goto D28;

T28_2: 
  response = 0.0014994297;
 goto D28;

T28_3: 
  response = 0.0051965496;
 goto D28;

N28_5: 
  if POS_R_P_NO$ in (0) then goto T28_4;
 else goto T28_5;

T28_4: 
  response = 0.0018757879;
 goto D28;

T28_5: 
  response = 0.0066876813;
 goto D28;

N28_6: 
  if POS_R_P_NO$ in (0) then goto N28_7;
 else goto T28_10;

N28_7: 
  if IDF_MISS_RIGHT$ in (0) then goto T28_6;
 else goto N28_8;

T28_6: 
  response = 0.0024604652;
 goto D28;

N28_8: 
  if TP_FRAC < 0.9902199507 then goto T28_7;
 else goto N28_9;

T28_7: 
  response = 0.0033523954;
 goto D28;

N28_9: 
  if IDF_MISS_RIGHT_WEIGHT < 0.3169854879 then goto T28_8;
 else goto T28_9;

T28_8: 
  response = 0.0096340128;
 goto D28;

T28_9: 
  response = 0.0048370289;
 goto D28;

T28_10: 
  response = 0.0161892712;
 goto D28;

D28:

tnscore = tnscore + response;

  /* Tree 30 of 150 */
N29_1: 
  if POS_L_P_NO$ in (0) then goto N29_2;
 else goto N29_6;

N29_2: 
  if PARTIAL_BRAND$ in (0) then goto N29_3;
 else goto T29_5;

N29_3: 
  if POS_L_P_5_S_5$ in (0) then goto N29_4;
 else goto T29_4;

N29_4: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N29_5;
 else goto T29_3;

N29_5: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto T29_1;
 else goto T29_2;

T29_1: 
  response = 0.0003089505;
 goto D29;

T29_2: 
  response = 0.0030994508;
 goto D29;

T29_3: 
  response = 0.0067300788;
 goto D29;

T29_4: 
  response = 0.0047075004;
 goto D29;

T29_5: 
  response = 0.0044627732;
 goto D29;

N29_6: 
  if POS_R_P_NO$ in (0) then goto N29_7;
 else goto T29_10;

N29_7: 
  if IDF_MISS_RIGHT$ in (0) then goto T29_6;
 else goto N29_8;

T29_6: 
  response = 0.0024117079;
 goto D29;

N29_8: 
  if TP_FRAC < 0.9919040203 then goto T29_7;
 else goto N29_9;

T29_7: 
  response = 0.0033096120;
 goto D29;

N29_9: 
  if IDF_MISS_RIGHT_WEIGHT < 0.3550420105 then goto T29_8;
 else goto T29_9;

T29_8: 
  response = 0.0086935932;
 goto D29;

T29_9: 
  response = 0.0046190299;
 goto D29;

T29_10: 
  response = 0.0155033461;
 goto D29;

D29:

tnscore = tnscore + response;

  /* Tree 31 of 150 */
N30_1: 
  if QBERT_SCORE$ in (0) then goto N30_2;
 else goto T30_10;

N30_2: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T30_1;
 else goto N30_3;

T30_1: 
  response = -0.0006466892;
 goto D30;

N30_3: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T30_2;
 else goto N30_4;

T30_2: 
  response = -0.0013917078;
 goto D30;

N30_4: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T30_3;
 else goto N30_5;

T30_3: 
  response = -0.0002099747;
 goto D30;

N30_5: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T30_4;
 else goto N30_6;

T30_4: 
  response = -0.0031258126;
 goto D30;

N30_6: 
  if LEN_Q_4_LEN_P_2$ in (1) then goto T30_5;
 else goto N30_7;

T30_5: 
  response = 0.0013141503;
 goto D30;

N30_7: 
  if LEN_Q_3_LEN_P_2$ in (1) then goto T30_6;
 else goto N30_8;

T30_6: 
  response = 0.0026309306;
 goto D30;

N30_8: 
  if POS_L_P_NO$ in (0) then goto T30_7;
 else goto N30_9;

T30_7: 
  response = 0.0040188695;
 goto D30;

N30_9: 
  if POS_R_P_NO$ in (0) then goto T30_8;
 else goto T30_9;

T30_8: 
  response = 0.0052409944;
 goto D30;

T30_9: 
  response = 0.0139915120;
 goto D30;

T30_10: 
  response = 0.0046445985;
 goto D30;

D30:

tnscore = tnscore + response;

  /* Tree 32 of 150 */
N31_1: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T31_1;
 else goto N31_2;

T31_1: 
  response = -0.0003688595;
 goto D31;

N31_2: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T31_2;
 else goto N31_3;

T31_2: 
  response = -0.0012209902;
 goto D31;

N31_3: 
  if POS_L_P_NO$ in (0) then goto N31_4;
 else goto N31_6;

N31_4: 
  if POS_L_P_5_S_5$ in (0) then goto N31_5;
 else goto T31_5;

N31_5: 
  if TP_PARTIAL$ in (0) then goto T31_3;
 else goto T31_4;

T31_3: 
  response = 0.0009614323;
 goto D31;

T31_4: 
  response = 0.0036174194;
 goto D31;

T31_5: 
  response = 0.0074219054;
 goto D31;

N31_6: 
  if POS_R_P_NO$ in (0) then goto N31_7;
 else goto T31_10;

N31_7: 
  if IDF_MISS_RIGHT$ in (0) then goto T31_6;
 else goto N31_8;

T31_6: 
  response = 0.0024336504;
 goto D31;

N31_8: 
  if IDF_MISS_RIGHT_WEIGHT < 0.3514705002 then goto N31_9;
 else goto T31_9;

N31_9: 
  if TP_FRAC < 0.9903064966 then goto T31_7;
 else goto T31_8;

T31_7: 
  response = 0.0047006832;
 goto D31;

T31_8: 
  response = 0.0086501588;
 goto D31;

T31_9: 
  response = 0.0037240939;
 goto D31;

T31_10: 
  response = 0.0142984958;
 goto D31;

D31:

tnscore = tnscore + response;

  /* Tree 33 of 150 */
N32_1: 
  if POS_L_P_NO$ in (0) then goto N32_2;
 else goto N32_6;

N32_2: 
  if PARTIAL_BRAND$ in (0) then goto N32_3;
 else goto N32_5;

N32_3: 
  if POS_L_P_5_S_5$ in (0) then goto N32_4;
 else goto T32_3;

N32_4: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T32_1;
 else goto T32_2;

T32_1: 
  response = -0.0012795330;
 goto D32;

T32_2: 
  response = 0.0008761166;
 goto D32;

T32_3: 
  response = 0.0041600812;
 goto D32;

N32_5: 
  if POS_R_P_NO$ in (0) then goto T32_4;
 else goto T32_5;

T32_4: 
  response = 0.0016011935;
 goto D32;

T32_5: 
  response = 0.0058588773;
 goto D32;

N32_6: 
  if POS_R_P_NO$ in (0) then goto N32_7;
 else goto T32_10;

N32_7: 
  if IDF_MISS_RIGHT$ in (0) then goto T32_6;
 else goto N32_8;

T32_6: 
  response = 0.0020441835;
 goto D32;

N32_8: 
  if TP_FRAC < 0.9987039566 then goto T32_7;
 else goto N32_9;

T32_7: 
  response = 0.0028378962;
 goto D32;

N32_9: 
  if IDF_MISS_RIGHT_WEIGHT < 0.3190909922 then goto T32_8;
 else goto T32_9;

T32_8: 
  response = 0.0078965487;
 goto D32;

T32_9: 
  response = 0.0041323930;
 goto D32;

T32_10: 
  response = 0.0132949323;
 goto D32;

D32:

tnscore = tnscore + response;

  /* Tree 34 of 150 */
N33_1: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T33_1;
 else goto N33_2;

T33_1: 
  response = -0.0005387383;
 goto D33;

N33_2: 
  if IDF_FRAC < 0.7700320482 then goto N33_3;
 else goto N33_6;

N33_3: 
  if POS_N_Q_0_P_0$ in (0) then goto N33_4;
 else goto N33_5;

N33_4: 
  if POS_L_P_0_S_0$ in (1) then goto T33_2;
 else goto T33_3;

T33_2: 
  response = -0.0000855496;
 goto D33;

T33_3: 
  response = 0.0020966781;
 goto D33;

N33_5: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T33_4;
 else goto T33_5;

T33_4: 
  response = 0.0003102773;
 goto D33;

T33_5: 
  response = 0.0085755655;
 goto D33;

N33_6: 
  if POS_L_P_4$ in (1) then goto T33_6;
 else goto N33_7;

T33_6: 
  response = -0.0033267643;
 goto D33;

N33_7: 
  if TP_FRAC < 0.3811265230 then goto T33_7;
 else goto N33_8;

T33_7: 
  response = 0.0005056668;
 goto D33;

N33_8: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T33_8;
 else goto N33_9;

T33_8: 
  response = 0.0007815216;
 goto D33;

N33_9: 
  if LEN_Q_3_LEN_P_2$ in (1) then goto T33_9;
 else goto T33_10;

T33_9: 
  response = 0.0031440222;
 goto D33;

T33_10: 
  response = 0.0058551571;
 goto D33;

D33:

tnscore = tnscore + response;

  /* Tree 35 of 150 */
N34_1: 
  if QBERT_SCORE$ in (0) then goto N34_2;
 else goto N34_9;

N34_2: 
  if TP_FRAC < 0.2932879925 then goto T34_1;
 else goto N34_3;

T34_1: 
  response = -0.0002909282;
 goto D34;

N34_3: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N34_4;
 else goto T34_8;

N34_4: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T34_2;
 else goto N34_5;

T34_2: 
  response = -0.0003153205;
 goto D34;

N34_5: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T34_3;
 else goto N34_6;

T34_3: 
  response = -0.0004536568;
 goto D34;

N34_6: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T34_4;
 else goto N34_7;

T34_4: 
  response = -0.0011332151;
 goto D34;

N34_7: 
  if LEN_Q_4_LEN_P_2$ in (1) then goto T34_5;
 else goto N34_8;

T34_5: 
  response = 0.0010850015;
 goto D34;

N34_8: 
  if LEN_Q_3_LEN_P_2$ in (1) then goto T34_6;
 else goto T34_7;

T34_6: 
  response = 0.0020865365;
 goto D34;

T34_7: 
  response = 0.0040569557;
 goto D34;

T34_8: 
  response = 0.0066812695;
 goto D34;

N34_9: 
  if IDF_FRAC < 0.8628525138 then goto T34_9;
 else goto T34_10;

T34_9: 
  response = 0.0030773843;
 goto D34;

T34_10: 
  response = 0.0058915679;
 goto D34;

D34:

tnscore = tnscore + response;

  /* Tree 36 of 150 */
N35_1: 
  if QBERT_SCORE$ in (0) then goto N35_2;
 else goto N35_7;

N35_2: 
  if TP_FRAC < 0.2933595181 then goto T35_1;
 else goto N35_3;

T35_1: 
  response = -0.0002534659;
 goto D35;

N35_3: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N35_4;
 else goto T35_6;

N35_4: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N35_5;
 else goto T35_5;

N35_5: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N35_6;
 else goto T35_4;

N35_6: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto T35_2;
 else goto T35_3;

T35_2: 
  response = 0.0010816527;
 goto D35;

T35_3: 
  response = 0.0064033170;
 goto D35;

T35_4: 
  response = 0.0035269977;
 goto D35;

T35_5: 
  response = 0.0068024915;
 goto D35;

T35_6: 
  response = 0.0065303247;
 goto D35;

N35_7: 
  if POS_R_P_0_E_0$ in (1) then goto T35_7;
 else goto N35_8;

T35_7: 
  response = 0.0023161681;
 goto D35;

N35_8: 
  if IDF_MISS_RIGHT$ in (0) then goto N35_9;
 else goto T35_10;

N35_9: 
  if POS_L_P_5_S_5$ in (0) then goto T35_8;
 else goto T35_9;

T35_8: 
  response = 0.0034337582;
 goto D35;

T35_9: 
  response = 0.0091211924;
 goto D35;

T35_10: 
  response = 0.0071041080;
 goto D35;

D35:

tnscore = tnscore + response;

  /* Tree 37 of 150 */
N36_1: 
  if QBERT_SCORE$ in (0) then goto N36_2;
 else goto T36_10;

N36_2: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N36_3;
 else goto T36_9;

N36_3: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N36_4;
 else goto T36_8;

N36_4: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N36_5;
 else goto T36_7;

N36_5: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto N36_6;
 else goto T36_6;

N36_6: 
  if LEN_Q_4_LEN_P_4$ in (0) then goto N36_7;
 else goto T36_5;

N36_7: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto N36_8;
 else goto T36_4;

N36_8: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N36_9;
 else goto T36_3;

N36_9: 
  if POS_R_P_0_E_5$ in (0) then goto T36_1;
 else goto T36_2;

T36_1: 
  response = -0.0005706073;
 goto D36;

T36_2: 
  response = 0.0022854116;
 goto D36;

T36_3: 
  response = 0.0037464957;
 goto D36;

T36_4: 
  response = 0.0017671204;
 goto D36;

T36_5: 
  response = 0.0091767506;
 goto D36;

T36_6: 
  response = 0.0062464386;
 goto D36;

T36_7: 
  response = 0.0063260768;
 goto D36;

T36_8: 
  response = 0.0033242144;
 goto D36;

T36_9: 
  response = 0.0058570822;
 goto D36;

T36_10: 
  response = 0.0035118246;
 goto D36;

D36:

tnscore = tnscore + response;

  /* Tree 38 of 150 */
N37_1: 
  if POS_L_P_NO$ in (0) then goto N37_2;
 else goto N37_6;

N37_2: 
  if PARTIAL_BRAND$ in (0) then goto N37_3;
 else goto N37_5;

N37_3: 
  if POS_L_P_5_S_5$ in (0) then goto N37_4;
 else goto T37_3;

N37_4: 
  if POS_L_P_1_S_1$ in (0) then goto T37_1;
 else goto T37_2;

T37_1: 
  response = 0.0002169493;
 goto D37;

T37_2: 
  response = 0.0074065439;
 goto D37;

T37_3: 
  response = 0.0037152752;
 goto D37;

N37_5: 
  if POS_R_P_NO$ in (0) then goto T37_4;
 else goto T37_5;

T37_4: 
  response = 0.0012929074;
 goto D37;

T37_5: 
  response = 0.0050486111;
 goto D37;

N37_6: 
  if POS_R_P_NO$ in (0) then goto N37_7;
 else goto T37_10;

N37_7: 
  if IDF_MISS_RIGHT$ in (0) then goto T37_6;
 else goto N37_8;

T37_6: 
  response = 0.0014380991;
 goto D37;

N37_8: 
  if IDF_MISS_RIGHT_WEIGHT < 0.3100959957 then goto N37_9;
 else goto T37_9;

N37_9: 
  if TP_FRAC < 0.9901959896 then goto T37_7;
 else goto T37_8;

T37_7: 
  response = 0.0032074842;
 goto D37;

T37_8: 
  response = 0.0070413572;
 goto D37;

T37_9: 
  response = 0.0026583435;
 goto D37;

T37_10: 
  response = 0.0116830728;
 goto D37;

D37:

tnscore = tnscore + response;

  /* Tree 39 of 150 */
N38_1: 
  if QBERT_SCORE$ in (0) then goto N38_2;
 else goto N38_9;

N38_2: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N38_3;
 else goto T38_8;

N38_3: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N38_4;
 else goto T38_7;

N38_4: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N38_5;
 else goto T38_6;

N38_5: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto N38_6;
 else goto T38_5;

N38_6: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto N38_7;
 else goto T38_4;

N38_7: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N38_8;
 else goto T38_3;

N38_8: 
  if LEN_Q_4_LEN_P_4$ in (0) then goto T38_1;
 else goto T38_2;

T38_1: 
  response = -0.0002768786;
 goto D38;

T38_2: 
  response = 0.0079390742;
 goto D38;

T38_3: 
  response = 0.0033903164;
 goto D38;

T38_4: 
  response = 0.0015778620;
 goto D38;

T38_5: 
  response = 0.0058310575;
 goto D38;

T38_6: 
  response = 0.0058387039;
 goto D38;

T38_7: 
  response = 0.0032020716;
 goto D38;

T38_8: 
  response = 0.0062064134;
 goto D38;

N38_9: 
  if POS_L_P_5_S_5$ in (0) then goto T38_9;
 else goto T38_10;

T38_9: 
  response = 0.0030007884;
 goto D38;

T38_10: 
  response = 0.0086402116;
 goto D38;

D38:

tnscore = tnscore + response;

  /* Tree 40 of 150 */
N39_1: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T39_1;
 else goto N39_2;

T39_1: 
  response = -0.0006115142;
 goto D39;

N39_2: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T39_2;
 else goto N39_3;

T39_2: 
  response = -0.0014272685;
 goto D39;

N39_3: 
  if IDF_MISS_RIGHT$ in (0) then goto N39_4;
 else goto N39_9;

N39_4: 
  if POS_L_P_5_S_5$ in (0) then goto N39_5;
 else goto T39_8;

N39_5: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N39_6;
 else goto T39_7;

N39_6: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto N39_7;
 else goto T39_6;

N39_7: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N39_8;
 else goto T39_5;

N39_8: 
  if TP_PARTIAL$ in (0) then goto T39_3;
 else goto T39_4;

T39_3: 
  response = 0.0006165132;
 goto D39;

T39_4: 
  response = 0.0024142092;
 goto D39;

T39_5: 
  response = 0.0051139851;
 goto D39;

T39_6: 
  response = 0.0057610182;
 goto D39;

T39_7: 
  response = 0.0059621532;
 goto D39;

T39_8: 
  response = 0.0060379425;
 goto D39;

N39_9: 
  if IDF_MISS_RIGHT_WEIGHT < 0.3190909922 then goto T39_9;
 else goto T39_10;

T39_9: 
  response = 0.0048928885;
 goto D39;

T39_10: 
  response = 0.0024901994;
 goto D39;

D39:

tnscore = tnscore + response;

  /* Tree 41 of 150 */
N40_1: 
  if QBERT_SCORE$ in (0) then goto N40_2;
 else goto N40_7;

N40_2: 
  if TP_FRAC < 0.2685225010 then goto T40_1;
 else goto N40_3;

T40_1: 
  response = -0.0004667899;
 goto D40;

N40_3: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T40_2;
 else goto N40_4;

T40_2: 
  response = -0.0005241501;
 goto D40;

N40_4: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T40_3;
 else goto N40_5;

T40_3: 
  response = -0.0006134788;
 goto D40;

N40_5: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T40_4;
 else goto N40_6;

T40_4: 
  response = -0.0008990319;
 goto D40;

N40_6: 
  if POS_N_Q_0_P_0$ in (0) then goto T40_5;
 else goto T40_6;

T40_5: 
  response = 0.0021288543;
 goto D40;

T40_6: 
  response = 0.0078836675;
 goto D40;

N40_7: 
  if IDF_FRAC < 0.7734605074 then goto N40_8;
 else goto N40_9;

N40_8: 
  if IDF_FRAC < 0.0555555001 then goto T40_7;
 else goto T40_8;

T40_7: 
  response = 0.0051724209;
 goto D40;

T40_8: 
  response = 0.0015725125;
 goto D40;

N40_9: 
  if POS_L_P_4$ in (1) then goto T40_9;
 else goto T40_10;

T40_9: 
  response = -0.0049933601;
 goto D40;

T40_10: 
  response = 0.0045694994;
 goto D40;

D40:

tnscore = tnscore + response;

  /* Tree 42 of 150 */
N41_1: 
  if POS_L_P_NO$ in (0) then goto N41_2;
 else goto N41_6;

N41_2: 
  if PARTIAL_BRAND$ in (0) then goto N41_3;
 else goto N41_5;

N41_3: 
  if POS_L_P_5_S_5$ in (0) then goto N41_4;
 else goto T41_3;

N41_4: 
  if POS_L_P_1_S_1$ in (0) then goto T41_1;
 else goto T41_2;

T41_1: 
  response = -0.0000333683;
 goto D41;

T41_2: 
  response = 0.0066695467;
 goto D41;

T41_3: 
  response = 0.0030821545;
 goto D41;

N41_5: 
  if IDF_MISS_LEFT_WEIGHT < 0.3514705002 then goto T41_4;
 else goto T41_5;

T41_4: 
  response = 0.0043906756;
 goto D41;

T41_5: 
  response = 0.0013385392;
 goto D41;

N41_6: 
  if POS_R_P_NO$ in (0) then goto N41_7;
 else goto T41_10;

N41_7: 
  if IDF_MISS_RIGHT$ in (0) then goto T41_6;
 else goto N41_8;

T41_6: 
  response = 0.0011050170;
 goto D41;

N41_8: 
  if IDF_MISS_RIGHT_WEIGHT < 0.3190909922 then goto N41_9;
 else goto T41_9;

N41_9: 
  if TP_FRAC < 0.9944665432 then goto T41_7;
 else goto T41_8;

T41_7: 
  response = 0.0028154683;
 goto D41;

T41_8: 
  response = 0.0064106519;
 goto D41;

T41_9: 
  response = 0.0021007071;
 goto D41;

T41_10: 
  response = 0.0108980880;
 goto D41;

D41:

tnscore = tnscore + response;

  /* Tree 43 of 150 */
N42_1: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T42_1;
 else goto N42_2;

T42_1: 
  response = -0.0005728306;
 goto D42;

N42_2: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T42_2;
 else goto N42_3;

T42_2: 
  response = -0.0013792294;
 goto D42;

N42_3: 
  if POS_L_P_5_S_5$ in (0) then goto N42_4;
 else goto T42_10;

N42_4: 
  if POS_L_P_NO$ in (0) then goto N42_5;
 else goto N42_7;

N42_5: 
  if TP_PARTIAL$ in (0) then goto T42_3;
 else goto N42_6;

T42_3: 
  response = 0.0002581307;
 goto D42;

N42_6: 
  if IDF_MISS_LEFT_WEIGHT < 0.3514705002 then goto T42_4;
 else goto T42_5;

T42_4: 
  response = 0.0037091315;
 goto D42;

T42_5: 
  response = 0.0013520694;
 goto D42;

N42_7: 
  if POS_R_P_NO$ in (0) then goto N42_8;
 else goto T42_9;

N42_8: 
  if IDF_MISS_RIGHT$ in (0) then goto T42_6;
 else goto N42_9;

T42_6: 
  response = 0.0012478742;
 goto D42;

N42_9: 
  if IDF_MISS_RIGHT_WEIGHT < 0.3169854879 then goto T42_7;
 else goto T42_8;

T42_7: 
  response = 0.0050606481;
 goto D42;

T42_8: 
  response = 0.0024563128;
 goto D42;

T42_9: 
  response = 0.0099902618;
 goto D42;

T42_10: 
  response = 0.0056807460;
 goto D42;

D42:

tnscore = tnscore + response;

  /* Tree 44 of 150 */
N43_1: 
  if POS_L_P_NO$ in (0) then goto N43_2;
 else goto N43_7;

N43_2: 
  if TP_PARTIAL$ in (0) then goto N43_3;
 else goto N43_4;

N43_3: 
  if POS_L_P_4$ in (1) then goto T43_1;
 else goto T43_2;

T43_1: 
  response = -0.0036296784;
 goto D43;

T43_2: 
  response = 0.0001033082;
 goto D43;

N43_4: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T43_3;
 else goto N43_5;

T43_3: 
  response = -0.0009814376;
 goto D43;

N43_5: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T43_4;
 else goto N43_6;

T43_4: 
  response = -0.0015255734;
 goto D43;

N43_6: 
  if IDF_MISS_LEFT_WEIGHT < 0.3603895009 then goto T43_5;
 else goto T43_6;

T43_5: 
  response = 0.0037217992;
 goto D43;

T43_6: 
  response = 0.0015524688;
 goto D43;

N43_7: 
  if POS_R_P_NO$ in (0) then goto N43_8;
 else goto T43_10;

N43_8: 
  if IDF_MISS_RIGHT$ in (0) then goto T43_7;
 else goto N43_9;

T43_7: 
  response = 0.0011126890;
 goto D43;

N43_9: 
  if IDF_MISS_RIGHT_WEIGHT < 0.3100959957 then goto T43_8;
 else goto T43_9;

T43_8: 
  response = 0.0043786933;
 goto D43;

T43_9: 
  response = 0.0018955115;
 goto D43;

T43_10: 
  response = 0.0096542037;
 goto D43;

D43:

tnscore = tnscore + response;

  /* Tree 45 of 150 */
N44_1: 
  if QBERT_SCORE$ in (0) then goto N44_2;
 else goto N44_8;

N44_2: 
  if TP_FRAC < 0.2661620080 then goto T44_1;
 else goto N44_3;

T44_1: 
  response = -0.0004916999;
 goto D44;

N44_3: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T44_2;
 else goto N44_4;

T44_2: 
  response = -0.0007788973;
 goto D44;

N44_4: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T44_3;
 else goto N44_5;

T44_3: 
  response = -0.0003439112;
 goto D44;

N44_5: 
  if POS_N_Q_0_P_0$ in (0) then goto N44_6;
 else goto T44_7;

N44_6: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T44_4;
 else goto N44_7;

T44_4: 
  response = -0.0009672243;
 goto D44;

N44_7: 
  if LEN_Q_4_LEN_P_2$ in (1) then goto T44_5;
 else goto T44_6;

T44_5: 
  response = 0.0002958207;
 goto D44;

T44_6: 
  response = 0.0020493588;
 goto D44;

T44_7: 
  response = 0.0072335201;
 goto D44;

N44_8: 
  if POS_R_P_0_E_0$ in (1) then goto T44_8;
 else goto N44_9;

T44_8: 
  response = 0.0010461519;
 goto D44;

N44_9: 
  if POS_L_P_4$ in (1) then goto T44_9;
 else goto T44_10;

T44_9: 
  response = -0.0042668558;
 goto D44;

T44_10: 
  response = 0.0034120097;
 goto D44;

D44:

tnscore = tnscore + response;

  /* Tree 46 of 150 */
N45_1: 
  if POS_L_P_NO$ in (0) then goto N45_2;
 else goto N45_6;

N45_2: 
  if PARTIAL_BRAND$ in (0) then goto N45_3;
 else goto N45_5;

N45_3: 
  if POS_L_P_5_S_5$ in (0) then goto N45_4;
 else goto T45_3;

N45_4: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T45_1;
 else goto T45_2;

T45_1: 
  response = -0.0021665274;
 goto D45;

T45_2: 
  response = 0.0001769013;
 goto D45;

T45_3: 
  response = 0.0027440548;
 goto D45;

N45_5: 
  if POS_R_P_NO$ in (0) then goto T45_4;
 else goto T45_5;

T45_4: 
  response = 0.0006704633;
 goto D45;

T45_5: 
  response = 0.0039358399;
 goto D45;

N45_6: 
  if POS_R_P_NO$ in (0) then goto N45_7;
 else goto T45_10;

N45_7: 
  if IDF_MISS_RIGHT$ in (0) then goto T45_6;
 else goto N45_8;

T45_6: 
  response = 0.0008457799;
 goto D45;

N45_8: 
  if IDF_MISS_RIGHT_WEIGHT < 0.0801282004 then goto T45_7;
 else goto N45_9;

T45_7: 
  response = 0.0074043718;
 goto D45;

N45_9: 
  if TP_FRAC < 0.9902694821 then goto T45_8;
 else goto T45_9;

T45_8: 
  response = 0.0012960456;
 goto D45;

T45_9: 
  response = 0.0032488971;
 goto D45;

T45_10: 
  response = 0.0091697582;
 goto D45;

D45:

tnscore = tnscore + response;

  /* Tree 47 of 150 */
N46_1: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N46_2;
 else goto T46_10;

N46_2: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N46_3;
 else goto N46_9;

N46_3: 
  if POS_L_P_NO$ in (0) then goto N46_4;
 else goto N46_7;

N46_4: 
  if TP_PARTIAL$ in (0) then goto T46_1;
 else goto N46_5;

T46_1: 
  response = -0.0004911314;
 goto D46;

N46_5: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto N46_6;
 else goto T46_4;

N46_6: 
  if POS_L_P_3_S_3$ in (0) then goto T46_2;
 else goto T46_3;

T46_2: 
  response = 0.0001304605;
 goto D46;

T46_3: 
  response = 0.0080604530;
 goto D46;

T46_4: 
  response = 0.0030050718;
 goto D46;

N46_7: 
  if POS_R_P_NO$ in (0) then goto N46_8;
 else goto T46_7;

N46_8: 
  if POS_R_P_0_E_5$ in (0) then goto T46_5;
 else goto T46_6;

T46_5: 
  response = 0.0007366977;
 goto D46;

T46_6: 
  response = 0.0028782787;
 goto D46;

T46_7: 
  response = 0.0083453948;
 goto D46;

N46_9: 
  if POS_R_P_5_E_5$ in (0) then goto T46_8;
 else goto T46_9;

T46_8: 
  response = 0.0024586978;
 goto D46;

T46_9: 
  response = 0.0079141930;
 goto D46;

T46_10: 
  response = 0.0049456937;
 goto D46;

D46:

tnscore = tnscore + response;

  /* Tree 48 of 150 */
N47_1: 
  if QBERT_SCORE$ in (0) then goto N47_2;
 else goto N47_7;

N47_2: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N47_3;
 else goto T47_6;

N47_3: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N47_4;
 else goto T47_5;

N47_4: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T47_1;
 else goto N47_5;

T47_1: 
  response = -0.0039055918;
 goto D47;

N47_5: 
  if POS_L_P_0_S_0$ in (1) then goto T47_2;
 else goto N47_6;

T47_2: 
  response = -0.0007797460;
 goto D47;

N47_6: 
  if POS_L_P_5_S_0$ in (1) then goto T47_3;
 else goto T47_4;

T47_3: 
  response = -0.0011949394;
 goto D47;

T47_4: 
  response = 0.0009169436;
 goto D47;

T47_5: 
  response = 0.0021618366;
 goto D47;

T47_6: 
  response = 0.0047877249;
 goto D47;

N47_7: 
  if IDF_FRAC < 0.8289195299 then goto N47_8;
 else goto N47_9;

N47_8: 
  if IDF_FRAC < 0.0434782505 then goto T47_7;
 else goto T47_8;

T47_7: 
  response = 0.0047402659;
 goto D47;

T47_8: 
  response = 0.0011092161;
 goto D47;

N47_9: 
  if POS_L_P_4$ in (1) then goto T47_9;
 else goto T47_10;

T47_9: 
  response = -0.0047934288;
 goto D47;

T47_10: 
  response = 0.0040557759;
 goto D47;

D47:

tnscore = tnscore + response;

  /* Tree 49 of 150 */
N48_1: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T48_1;
 else goto N48_2;

T48_1: 
  response = -0.0006129312;
 goto D48;

N48_2: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T48_2;
 else goto N48_3;

T48_2: 
  response = -0.0010868851;
 goto D48;

N48_3: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T48_3;
 else goto N48_4;

T48_3: 
  response = -0.0034947757;
 goto D48;

N48_4: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto N48_5;
 else goto N48_6;

N48_5: 
  if POS_R_P_0_E_5$ in (0) then goto T48_4;
 else goto T48_5;

T48_4: 
  response = -0.0009790261;
 goto D48;

T48_5: 
  response = 0.0037323533;
 goto D48;

N48_6: 
  if POS_N_Q_0_P_0$ in (0) then goto N48_7;
 else goto T48_10;

N48_7: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N48_8;
 else goto T48_9;

N48_8: 
  if TP_PARTIAL$ in (0) then goto N48_9;
 else goto T48_8;

N48_9: 
  if POS_R_P_5_E_5$ in (0) then goto T48_6;
 else goto T48_7;

T48_6: 
  response = 0.0010553588;
 goto D48;

T48_7: 
  response = 0.0054743506;
 goto D48;

T48_8: 
  response = 0.0024820106;
 goto D48;

T48_9: 
  response = 0.0044498649;
 goto D48;

T48_10: 
  response = 0.0065470501;
 goto D48;

D48:

tnscore = tnscore + response;

  /* Tree 50 of 150 */
N49_1: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N49_2;
 else goto T49_10;

N49_2: 
  if POS_L_P_NO$ in (0) then goto N49_3;
 else goto N49_6;

N49_3: 
  if PARTIAL_BRAND$ in (0) then goto N49_4;
 else goto N49_5;

N49_4: 
  if POS_L_P_1_S_1$ in (0) then goto T49_1;
 else goto T49_2;

T49_1: 
  response = -0.0001164359;
 goto D49;

T49_2: 
  response = 0.0067073393;
 goto D49;

N49_5: 
  if POS_R_P_NO$ in (0) then goto T49_3;
 else goto T49_4;

T49_3: 
  response = 0.0005332203;
 goto D49;

T49_4: 
  response = 0.0034040843;
 goto D49;

N49_6: 
  if POS_R_P_NO$ in (0) then goto N49_7;
 else goto T49_9;

N49_7: 
  if IDF_MISS_RIGHT$ in (0) then goto T49_5;
 else goto N49_8;

T49_5: 
  response = 0.0005776274;
 goto D49;

N49_8: 
  if IDF_MISS_RIGHT_WEIGHT < 0.3514705002 then goto N49_9;
 else goto T49_8;

N49_9: 
  if TP_FRAC < 0.9901959896 then goto T49_6;
 else goto T49_7;

T49_6: 
  response = 0.0017230362;
 goto D49;

T49_7: 
  response = 0.0048234855;
 goto D49;

T49_8: 
  response = 0.0011851890;
 goto D49;

T49_9: 
  response = 0.0078394955;
 goto D49;

T49_10: 
  response = 0.0044329101;
 goto D49;

D49:

tnscore = tnscore + response;

  /* Tree 51 of 150 */
N50_1: 
  if QBERT_SCORE$ in (0) then goto N50_2;
 else goto N50_6;

N50_2: 
  if TP_FRAC < 0.4406554997 then goto N50_3;
 else goto N50_4;

N50_3: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto T50_1;
 else goto T50_2;

T50_1: 
  response = -0.0006350399;
 goto D50;

T50_2: 
  response = 0.0015822438;
 goto D50;

N50_4: 
  if PARTIAL_BRAND$ in (0) then goto N50_5;
 else goto T50_5;

N50_5: 
  if BRAND_NAME$ in (0) then goto T50_3;
 else goto T50_4;

T50_3: 
  response = -0.0002158160;
 goto D50;

T50_4: 
  response = 0.0012503407;
 goto D50;

T50_5: 
  response = 0.0027016676;
 goto D50;

N50_6: 
  if POS_R_P_0_E_0$ in (1) then goto N50_7;
 else goto N50_8;

N50_7: 
  if IDF_MISS_RIGHT$ in (0) then goto T50_6;
 else goto T50_7;

T50_6: 
  response = -0.0011442698;
 goto D50;

T50_7: 
  response = 0.0021256353;
 goto D50;

N50_8: 
  if POS_L_P_4$ in (1) then goto T50_8;
 else goto N50_9;

T50_8: 
  response = -0.0046826252;
 goto D50;

N50_9: 
  if IDF_FRAC < 0.0833334997 then goto T50_9;
 else goto T50_10;

T50_9: 
  response = 0.0054890949;
 goto D50;

T50_10: 
  response = 0.0026270328;
 goto D50;

D50:

tnscore = tnscore + response;

  /* Tree 52 of 150 */
N51_1: 
  if POS_L_P_0_S_0$ in (1) then goto T51_1;
 else goto N51_2;

T51_1: 
  response = -0.0005069012;
 goto D51;

N51_2: 
  if POS_L_P_4$ in (1) then goto T51_2;
 else goto N51_3;

T51_2: 
  response = -0.0028698382;
 goto D51;

N51_3: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T51_3;
 else goto N51_4;

T51_3: 
  response = -0.0003081054;
 goto D51;

N51_4: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T51_4;
 else goto N51_5;

T51_4: 
  response = -0.0009900960;
 goto D51;

N51_5: 
  if POS_N_Q_0_P_0$ in (0) then goto N51_6;
 else goto N51_9;

N51_6: 
  if IDF_FRAC < 0.7734605074 then goto N51_7;
 else goto N51_8;

N51_7: 
  if TP_PARTIAL$ in (0) then goto T51_5;
 else goto T51_6;

T51_5: 
  response = 0.0007612193;
 goto D51;

T51_6: 
  response = 0.0020874587;
 goto D51;

N51_8: 
  if POS_L_P_5_S_0$ in (1) then goto T51_7;
 else goto T51_8;

T51_7: 
  response = -0.0013825768;
 goto D51;

T51_8: 
  response = 0.0026936331;
 goto D51;

N51_9: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T51_9;
 else goto T51_10;

T51_9: 
  response = -0.0007979441;
 goto D51;

T51_10: 
  response = 0.0069570665;
 goto D51;

D51:

tnscore = tnscore + response;

  /* Tree 53 of 150 */
N52_1: 
  if QBERT_SCORE$ in (0) then goto N52_2;
 else goto N52_6;

N52_2: 
  if TP_FRAC < 0.2927860022 then goto T52_1;
 else goto N52_3;

T52_1: 
  response = -0.0005723700;
 goto D52;

N52_3: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T52_2;
 else goto N52_4;

T52_2: 
  response = -0.0009795775;
 goto D52;

N52_4: 
  if POS_N_Q_0_P_0$ in (0) then goto N52_5;
 else goto T52_5;

N52_5: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T52_3;
 else goto T52_4;

T52_3: 
  response = -0.0003767591;
 goto D52;

T52_4: 
  response = 0.0010861342;
 goto D52;

T52_5: 
  response = 0.0049918535;
 goto D52;

N52_6: 
  if IDF_FRAC < 0.8615900278 then goto N52_7;
 else goto T52_10;

N52_7: 
  if TP_FRAC < 0.9246764779 then goto T52_6;
 else goto N52_8;

T52_6: 
  response = 0.0028262054;
 goto D52;

N52_8: 
  if IDF_MISS_RIGHT$ in (0) then goto N52_9;
 else goto T52_9;

N52_9: 
  if POS_R_P_0_E_0$ in (1) then goto T52_7;
 else goto T52_8;

T52_7: 
  response = -0.0021760138;
 goto D52;

T52_8: 
  response = 0.0006766789;
 goto D52;

T52_9: 
  response = 0.0023767535;
 goto D52;

T52_10: 
  response = 0.0031767454;
 goto D52;

D52:

tnscore = tnscore + response;

  /* Tree 54 of 150 */
N53_1: 
  if POS_L_P_0_S_0$ in (1) then goto T53_1;
 else goto N53_2;

T53_1: 
  response = -0.0004637778;
 goto D53;

N53_2: 
  if QBERT_SCORE$ in (0) then goto N53_3;
 else goto N53_6;

N53_3: 
  if POS_R_P_5_E_0$ in (1) then goto T53_2;
 else goto N53_4;

T53_2: 
  response = -0.0021882462;
 goto D53;

N53_4: 
  if TP_FRAC < 0.2684144974 then goto T53_3;
 else goto N53_5;

T53_3: 
  response = -0.0002331662;
 goto D53;

N53_5: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T53_4;
 else goto T53_5;

T53_4: 
  response = -0.0006049312;
 goto D53;

T53_5: 
  response = 0.0012178632;
 goto D53;

N53_6: 
  if TP_FRAC < 0.1433680058 then goto T53_6;
 else goto N53_7;

T53_6: 
  response = 0.0068546327;
 goto D53;

N53_7: 
  if IDF_FRAC < 0.8689930439 then goto N53_8;
 else goto T53_10;

N53_8: 
  if IDF_MISS_RIGHT$ in (0) then goto N53_9;
 else goto T53_9;

N53_9: 
  if TP_FRAC < 0.9949225187 then goto T53_7;
 else goto T53_8;

T53_7: 
  response = 0.0024179883;
 goto D53;

T53_8: 
  response = -0.0004880207;
 goto D53;

T53_9: 
  response = 0.0023137978;
 goto D53;

T53_10: 
  response = 0.0030133084;
 goto D53;

D53:

tnscore = tnscore + response;

  /* Tree 55 of 150 */
N54_1: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T54_1;
 else goto N54_2;

T54_1: 
  response = -0.0006480509;
 goto D54;

N54_2: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T54_2;
 else goto N54_3;

T54_2: 
  response = -0.0013557859;
 goto D54;

N54_3: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T54_3;
 else goto N54_4;

T54_3: 
  response = -0.0030761466;
 goto D54;

N54_4: 
  if TP_PARTIAL$ in (0) then goto N54_5;
 else goto N54_9;

N54_5: 
  if POS_R_P_5_E_5$ in (0) then goto N54_6;
 else goto T54_8;

N54_6: 
  if POS_L_P_NO$ in (0) then goto N54_7;
 else goto N54_8;

N54_7: 
  if POS_L_P_4$ in (1) then goto T54_4;
 else goto T54_5;

T54_4: 
  response = -0.0033446839;
 goto D54;

T54_5: 
  response = 0.0002760322;
 goto D54;

N54_8: 
  if POS_R_P_NO$ in (0) then goto T54_6;
 else goto T54_7;

T54_6: 
  response = 0.0009675096;
 goto D54;

T54_7: 
  response = 0.0072187305;
 goto D54;

T54_8: 
  response = 0.0044287496;
 goto D54;

N54_9: 
  if POS_L_P_5_S_5$ in (0) then goto T54_9;
 else goto T54_10;

T54_9: 
  response = 0.0018743408;
 goto D54;

T54_10: 
  response = 0.0054153019;
 goto D54;

D54:

tnscore = tnscore + response;

  /* Tree 56 of 150 */
N55_1: 
  if POS_L_P_0_S_0$ in (1) then goto T55_1;
 else goto N55_2;

T55_1: 
  response = -0.0005271758;
 goto D55;

N55_2: 
  if POS_L_P_4$ in (1) then goto T55_2;
 else goto N55_3;

T55_2: 
  response = -0.0030568970;
 goto D55;

N55_3: 
  if QBERT_SCORE$ in (0) then goto N55_4;
 else goto N55_7;

N55_4: 
  if POS_L_P_5_S_0$ in (1) then goto T55_3;
 else goto N55_5;

T55_3: 
  response = -0.0007971993;
 goto D55;

N55_5: 
  if IDF_FRAC < 0.3417840004 then goto T55_4;
 else goto N55_6;

T55_4: 
  response = 0.0001227417;
 goto D55;

N55_6: 
  if POS_R_P_5_E_0$ in (1) then goto T55_5;
 else goto T55_6;

T55_5: 
  response = -0.0015023232;
 goto D55;

T55_6: 
  response = 0.0013340826;
 goto D55;

N55_7: 
  if POS_R_P_0_E_0$ in (1) then goto N55_8;
 else goto N55_9;

N55_8: 
  if IDF_MISS_RIGHT$ in (0) then goto T55_7;
 else goto T55_8;

T55_7: 
  response = -0.0012273361;
 goto D55;

T55_8: 
  response = 0.0012650376;
 goto D55;

N55_9: 
  if POS_L_P_3$ in (1) then goto T55_9;
 else goto T55_10;

T55_9: 
  response = -0.0003285206;
 goto D55;

T55_10: 
  response = 0.0030588616;
 goto D55;

D55:

tnscore = tnscore + response;

  /* Tree 57 of 150 */
N56_1: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N56_2;
 else goto T56_10;

N56_2: 
  if POS_L_P_0_S_0$ in (1) then goto T56_1;
 else goto N56_3;

T56_1: 
  response = -0.0006479913;
 goto D56;

N56_3: 
  if QBERT_SCORE$ in (0) then goto N56_4;
 else goto N56_7;

N56_4: 
  if POS_L_P_5_S_0$ in (1) then goto T56_2;
 else goto N56_5;

T56_2: 
  response = -0.0010969812;
 goto D56;

N56_5: 
  if POS_R_P_5_E_0$ in (1) then goto T56_3;
 else goto N56_6;

T56_3: 
  response = -0.0018995622;
 goto D56;

N56_6: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T56_4;
 else goto T56_5;

T56_4: 
  response = -0.0031277665;
 goto D56;

T56_5: 
  response = 0.0008281808;
 goto D56;

N56_7: 
  if POS_R_P_0_E_0$ in (1) then goto T56_6;
 else goto N56_8;

T56_6: 
  response = 0.0001440744;
 goto D56;

N56_8: 
  if POS_L_P_3_S_0$ in (1) then goto T56_7;
 else goto N56_9;

T56_7: 
  response = -0.0016112436;
 goto D56;

N56_9: 
  if TP_FRAC < 0.1335095018 then goto T56_8;
 else goto T56_9;

T56_8: 
  response = 0.0069778178;
 goto D56;

T56_9: 
  response = 0.0023966126;
 goto D56;

T56_10: 
  response = 0.0037327245;
 goto D56;

D56:

tnscore = tnscore + response;

  /* Tree 58 of 150 */
N57_1: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T57_1;
 else goto N57_2;

T57_1: 
  response = -0.0007147827;
 goto D57;

N57_2: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T57_2;
 else goto N57_3;

T57_2: 
  response = -0.0011731090;
 goto D57;

N57_3: 
  if POS_L_P_5_S_5$ in (0) then goto N57_4;
 else goto T57_10;

N57_4: 
  if POS_N_Q_0_P_0$ in (0) then goto N57_5;
 else goto T57_9;

N57_5: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto N57_6;
 else goto N57_7;

N57_6: 
  if POS_R_P_0_E_5$ in (0) then goto T57_3;
 else goto T57_4;

T57_3: 
  response = -0.0016183479;
 goto D57;

T57_4: 
  response = 0.0028016378;
 goto D57;

N57_7: 
  if IDF_FRAC < 0.8021739721 then goto T57_5;
 else goto N57_8;

T57_5: 
  response = 0.0005785336;
 goto D57;

N57_8: 
  if LEN_Q_3_LEN_P_2$ in (1) then goto T57_6;
 else goto N57_9;

T57_6: 
  response = 0.0001705023;
 goto D57;

N57_9: 
  if LEN_Q_4_LEN_P_2$ in (1) then goto T57_7;
 else goto T57_8;

T57_7: 
  response = -0.0011570875;
 goto D57;

T57_8: 
  response = 0.0028758958;
 goto D57;

T57_9: 
  response = 0.0041891244;
 goto D57;

T57_10: 
  response = 0.0038391567;
 goto D57;

D57:

tnscore = tnscore + response;

  /* Tree 59 of 150 */
N58_1: 
  if POS_L_P_NO$ in (0) then goto N58_2;
 else goto N58_6;

N58_2: 
  if TP_PARTIAL$ in (0) then goto N58_3;
 else goto N58_4;

N58_3: 
  if TP_FRAC < -0.0000335919 then goto T58_1;
 else goto T58_2;

T58_1: 
  response = 0.0038160364;
 goto D58;

T58_2: 
  response = -0.0004707416;
 goto D58;

N58_4: 
  if TP_FRAC < 0.5646530390 then goto T58_3;
 else goto N58_5;

T58_3: 
  response = 0.0002657669;
 goto D58;

N58_5: 
  if IDF_FRAC < 0.9069265127 then goto T58_4;
 else goto T58_5;

T58_4: 
  response = 0.0016756343;
 goto D58;

T58_5: 
  response = 0.0047296540;
 goto D58;

N58_6: 
  if POS_R_P_NO$ in (0) then goto N58_7;
 else goto T58_10;

N58_7: 
  if IDF_MISS_RIGHT$ in (0) then goto T58_6;
 else goto N58_8;

T58_6: 
  response = 0.0001933716;
 goto D58;

N58_8: 
  if IDF_MISS_RIGHT_WEIGHT < 0.4599354863 then goto N58_9;
 else goto T58_9;

N58_9: 
  if TP_FRAC < 0.9952235222 then goto T58_7;
 else goto T58_8;

T58_7: 
  response = 0.0010555172;
 goto D58;

T58_8: 
  response = 0.0033607772;
 goto D58;

T58_9: 
  response = 0.0005725056;
 goto D58;

T58_10: 
  response = 0.0065533709;
 goto D58;

D58:

tnscore = tnscore + response;

  /* Tree 60 of 150 */
N59_1: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T59_1;
 else goto N59_2;

T59_1: 
  response = -0.0005705157;
 goto D59;

N59_2: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T59_2;
 else goto N59_3;

T59_2: 
  response = -0.0010401610;
 goto D59;

N59_3: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T59_3;
 else goto N59_4;

T59_3: 
  response = -0.0029167772;
 goto D59;

N59_4: 
  if POS_L_P_5_S_5$ in (0) then goto N59_5;
 else goto T59_10;

N59_5: 
  if IDF_MISS_RIGHT$ in (0) then goto N59_6;
 else goto N59_9;

N59_6: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T59_4;
 else goto N59_7;

T59_4: 
  response = -0.0010774028;
 goto D59;

N59_7: 
  if LEN_Q_3_LEN_P_2$ in (1) then goto T59_5;
 else goto N59_8;

T59_5: 
  response = -0.0001596618;
 goto D59;

N59_8: 
  if POS_N_Q_0_P_0$ in (0) then goto T59_6;
 else goto T59_7;

T59_6: 
  response = 0.0012413712;
 goto D59;

T59_7: 
  response = 0.0077089324;
 goto D59;

N59_9: 
  if IDF_MISS_RIGHT_WEIGHT < 0.1633335054 then goto T59_8;
 else goto T59_9;

T59_8: 
  response = 0.0048155402;
 goto D59;

T59_9: 
  response = 0.0014457839;
 goto D59;

T59_10: 
  response = 0.0039346591;
 goto D59;

D59:

tnscore = tnscore + response;

  /* Tree 61 of 150 */
N60_1: 
  if POS_R_P_0_E_5$ in (0) then goto N60_2;
 else goto T60_10;

N60_2: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T60_1;
 else goto N60_3;

T60_1: 
  response = -0.0009412726;
 goto D60;

N60_3: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T60_2;
 else goto N60_4;

T60_2: 
  response = -0.0011986504;
 goto D60;

N60_4: 
  if POS_N_Q_0_P_0$ in (0) then goto N60_5;
 else goto T60_9;

N60_5: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T60_3;
 else goto N60_6;

T60_3: 
  response = -0.0013780554;
 goto D60;

N60_6: 
  if POS_L_P_5_S_5$ in (0) then goto N60_7;
 else goto T60_8;

N60_7: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T60_4;
 else goto N60_8;

T60_4: 
  response = -0.0029272260;
 goto D60;

N60_8: 
  if POS_R_P_5_E_5$ in (0) then goto N60_9;
 else goto T60_7;

N60_9: 
  if TP_PARTIAL$ in (0) then goto T60_5;
 else goto T60_6;

T60_5: 
  response = 0.0004450726;
 goto D60;

T60_6: 
  response = 0.0015545167;
 goto D60;

T60_7: 
  response = 0.0034795485;
 goto D60;

T60_8: 
  response = 0.0040633595;
 goto D60;

T60_9: 
  response = 0.0051218140;
 goto D60;

T60_10: 
  response = 0.0021318744;
 goto D60;

D60:

tnscore = tnscore + response;

  /* Tree 62 of 150 */
N61_1: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N61_2;
 else goto T61_10;

N61_2: 
  if QBERT_SCORE$ in (0) then goto N61_3;
 else goto N61_8;

N61_3: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N61_4;
 else goto T61_6;

N61_4: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N61_5;
 else goto T61_5;

N61_5: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N61_6;
 else goto T61_4;

N61_6: 
  if POS_R_P_5_E_0$ in (1) then goto T61_1;
 else goto N61_7;

T61_1: 
  response = -0.0027638490;
 goto D61;

N61_7: 
  if POS_L_P_0_S_0$ in (1) then goto T61_2;
 else goto T61_3;

T61_2: 
  response = -0.0010577960;
 goto D61;

T61_3: 
  response = 0.0001588356;
 goto D61;

T61_4: 
  response = 0.0026128269;
 goto D61;

T61_5: 
  response = 0.0024952622;
 goto D61;

T61_6: 
  response = 0.0014907985;
 goto D61;

N61_8: 
  if TP_FRAC < 0.2635390162 then goto T61_7;
 else goto N61_9;

T61_7: 
  response = 0.0047134950;
 goto D61;

N61_9: 
  if POS_R_P_5_E_0$ in (0) then goto T61_8;
 else goto T61_9;

T61_8: 
  response = 0.0008994099;
 goto D61;

T61_9: 
  response = 0.0047568279;
 goto D61;

T61_10: 
  response = 0.0099962892;
 goto D61;

D61:

tnscore = tnscore + response;

  /* Tree 63 of 150 */
N62_1: 
  if POS_L_P_0_S_0$ in (1) then goto T62_1;
 else goto N62_2;

T62_1: 
  response = -0.0005173559;
 goto D62;

N62_2: 
  if POS_L_P_3_S_0$ in (1) then goto T62_2;
 else goto N62_3;

T62_2: 
  response = -0.0007359102;
 goto D62;

N62_3: 
  if POS_L_P_4$ in (1) then goto T62_3;
 else goto N62_4;

T62_3: 
  response = -0.0023933081;
 goto D62;

N62_4: 
  if POS_R_P_1_E_0$ in (1) then goto T62_4;
 else goto N62_5;

T62_4: 
  response = -0.0036083176;
 goto D62;

N62_5: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T62_5;
 else goto N62_6;

T62_5: 
  response = -0.0002304283;
 goto D62;

N62_6: 
  if TP_PARTIAL$ in (0) then goto N62_7;
 else goto N62_8;

N62_7: 
  if IDF_FRAC < 0.8132264614 then goto T62_6;
 else goto T62_7;

T62_6: 
  response = 0.0005260477;
 goto D62;

T62_7: 
  response = 0.0016553259;
 goto D62;

N62_8: 
  if IDF_MISS_RIGHT_WEIGHT < 0.1751919985 then goto N62_9;
 else goto T62_10;

N62_9: 
  if IDF_MISS_LEFT_WEIGHT < 0.3489130139 then goto T62_8;
 else goto T62_9;

T62_8: 
  response = 0.0043836178;
 goto D62;

T62_9: 
  response = 0.0014381080;
 goto D62;

T62_10: 
  response = 0.0008517824;
 goto D62;

D62:

tnscore = tnscore + response;

  /* Tree 64 of 150 */
N63_1: 
  if PARTIAL_BRAND$ in (0) then goto N63_2;
 else goto N63_9;

N63_2: 
  if POS_L_P_NO$ in (0) then goto N63_3;
 else goto N63_4;

N63_3: 
  if POS_L_P_1_S_1$ in (0) then goto T63_1;
 else goto T63_2;

T63_1: 
  response = -0.0002583541;
 goto D63;

T63_2: 
  response = 0.0050733823;
 goto D63;

N63_4: 
  if POS_R_P_NO$ in (0) then goto N63_5;
 else goto T63_8;

N63_5: 
  if POS_R_P_1_E_0$ in (1) then goto T63_3;
 else goto N63_6;

T63_3: 
  response = -0.0041778831;
 goto D63;

N63_6: 
  if IDF_MISS_RIGHT$ in (0) then goto T63_4;
 else goto N63_7;

T63_4: 
  response = 0.0001679838;
 goto D63;

N63_7: 
  if IDF_MISS_RIGHT_WEIGHT < 0.3514705002 then goto N63_8;
 else goto T63_7;

N63_8: 
  if IDF_FRAC < 0.8049520254 then goto T63_5;
 else goto T63_6;

T63_5: 
  response = 0.0015495856;
 goto D63;

T63_6: 
  response = 0.0042550816;
 goto D63;

T63_7: 
  response = 0.0004666537;
 goto D63;

T63_8: 
  response = 0.0058718691;
 goto D63;

N63_9: 
  if TP_FRAC < 0.4770454764 then goto T63_9;
 else goto T63_10;

T63_9: 
  response = 0.0003268058;
 goto D63;

T63_10: 
  response = 0.0026182994;
 goto D63;

D63:

tnscore = tnscore + response;

  /* Tree 65 of 150 */
N64_1: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N64_2;
 else goto T64_10;

N64_2: 
  if TP_FRAC < -0.0000340733 then goto T64_1;
 else goto N64_3;

T64_1: 
  response = 0.0045465543;
 goto D64;

N64_3: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N64_4;
 else goto T64_9;

N64_4: 
  if POS_L_P_0_S_0$ in (1) then goto T64_2;
 else goto N64_5;

T64_2: 
  response = -0.0008478628;
 goto D64;

N64_5: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto N64_6;
 else goto T64_8;

N64_6: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N64_7;
 else goto T64_7;

N64_7: 
  if POS_R_P_0_E_5$ in (0) then goto N64_8;
 else goto T64_6;

N64_8: 
  if LEN_Q_4_LEN_P_4$ in (0) then goto N64_9;
 else goto T64_5;

N64_9: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto T64_3;
 else goto T64_4;

T64_3: 
  response = -0.0001954197;
 goto D64;

T64_4: 
  response = 0.0020643472;
 goto D64;

T64_5: 
  response = 0.0053127689;
 goto D64;

T64_6: 
  response = 0.0013597001;
 goto D64;

T64_7: 
  response = 0.0029276281;
 goto D64;

T64_8: 
  response = 0.0030553174;
 goto D64;

T64_9: 
  response = 0.0014048108;
 goto D64;

T64_10: 
  response = 0.0028994878;
 goto D64;

D64:

tnscore = tnscore + response;

  /* Tree 66 of 150 */
N65_1: 
  if POS_R_P_0_E_5$ in (0) then goto N65_2;
 else goto T65_10;

N65_2: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N65_3;
 else goto T65_9;

N65_3: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N65_4;
 else goto T65_8;

N65_4: 
  if LEN_Q_4_LEN_P_4$ in (0) then goto N65_5;
 else goto T65_7;

N65_5: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N65_6;
 else goto T65_6;

N65_6: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N65_7;
 else goto T65_5;

N65_7: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto T65_1;
 else goto N65_8;

T65_1: 
  response = -0.0005304341;
 goto D65;

N65_8: 
  if TP_PARTIAL$ in (0) then goto N65_9;
 else goto T65_4;

N65_9: 
  if IDF_MISS_RIGHT$ in (0) then goto T65_2;
 else goto T65_3;

T65_2: 
  response = -0.0006864811;
 goto D65;

T65_3: 
  response = 0.0015175762;
 goto D65;

T65_4: 
  response = 0.0018575530;
 goto D65;

T65_5: 
  response = 0.0018717004;
 goto D65;

T65_6: 
  response = 0.0027788187;
 goto D65;

T65_7: 
  response = 0.0052898767;
 goto D65;

T65_8: 
  response = 0.0024003815;
 goto D65;

T65_9: 
  response = 0.0014918532;
 goto D65;

T65_10: 
  response = 0.0020683723;
 goto D65;

D65:

tnscore = tnscore + response;

  /* Tree 67 of 150 */
N66_1: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T66_1;
 else goto N66_2;

T66_1: 
  response = -0.0029294768;
 goto D66;

N66_2: 
  if PARTIAL_BRAND$ in (0) then goto N66_3;
 else goto N66_9;

N66_3: 
  if IDF_MISS_RIGHT$ in (0) then goto N66_4;
 else goto N66_8;

N66_4: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto N66_5;
 else goto T66_6;

N66_5: 
  if TP_FRAC < -0.0000340698 then goto T66_2;
 else goto N66_6;

T66_2: 
  response = 0.0035759466;
 goto D66;

N66_6: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T66_3;
 else goto N66_7;

T66_3: 
  response = -0.0014742714;
 goto D66;

N66_7: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto T66_4;
 else goto T66_5;

T66_4: 
  response = -0.0000496730;
 goto D66;

T66_5: 
  response = 0.0027098589;
 goto D66;

T66_6: 
  response = 0.0031257213;
 goto D66;

N66_8: 
  if IDF_MISS_RIGHT_WEIGHT < 0.1702899933 then goto T66_7;
 else goto T66_8;

T66_7: 
  response = 0.0035373445;
 goto D66;

T66_8: 
  response = 0.0005876560;
 goto D66;

N66_9: 
  if IDF_MISS_LEFT_WEIGHT < 0.3416664898 then goto T66_9;
 else goto T66_10;

T66_9: 
  response = 0.0023170449;
 goto D66;

T66_10: 
  response = 0.0000616782;
 goto D66;

D66:

tnscore = tnscore + response;

  /* Tree 68 of 150 */
N67_1: 
  if QBERT_SCORE$ in (0) then goto N67_2;
 else goto N67_6;

N67_2: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N67_3;
 else goto T67_5;

N67_3: 
  if POS_R_P_5_E_0$ in (1) then goto T67_1;
 else goto N67_4;

T67_1: 
  response = -0.0022650481;
 goto D67;

N67_4: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N67_5;
 else goto T67_4;

N67_5: 
  if TP_FRAC < 0.2314044982 then goto T67_2;
 else goto T67_3;

T67_2: 
  response = -0.0006474839;
 goto D67;

T67_3: 
  response = 0.0003627279;
 goto D67;

T67_4: 
  response = 0.0084244291;
 goto D67;

T67_5: 
  response = 0.0024553302;
 goto D67;

N67_6: 
  if POS_L_P_5_S_5$ in (0) then goto N67_7;
 else goto T67_10;

N67_7: 
  if IDF_MISS_RIGHT$ in (0) then goto N67_8;
 else goto T67_9;

N67_8: 
  if TP_INCLUDE$ in (1) then goto N67_9;
 else goto T67_8;

N67_9: 
  if POS_R_P_5_E_0$ in (0) then goto T67_6;
 else goto T67_7;

T67_6: 
  response = -0.0004279251;
 goto D67;

T67_7: 
  response = 0.0036087902;
 goto D67;

T67_8: 
  response = 0.0023153491;
 goto D67;

T67_9: 
  response = 0.0018510745;
 goto D67;

T67_10: 
  response = 0.0050266278;
 goto D67;

D67:

tnscore = tnscore + response;

  /* Tree 69 of 150 */
N68_1: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N68_2;
 else goto T68_10;

N68_2: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N68_3;
 else goto T68_9;

N68_3: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N68_4;
 else goto N68_9;

N68_4: 
  if POS_L_P_0_S_0$ in (1) then goto T68_1;
 else goto N68_5;

T68_1: 
  response = -0.0008690603;
 goto D68;

N68_5: 
  if TP_FRAC < -0.0000350140 then goto T68_2;
 else goto N68_6;

T68_2: 
  response = 0.0036752278;
 goto D68;

N68_6: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N68_7;
 else goto T68_6;

N68_7: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N68_8;
 else goto T68_5;

N68_8: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto T68_3;
 else goto T68_4;

T68_3: 
  response = -0.0000142242;
 goto D68;

T68_4: 
  response = 0.0024553197;
 goto D68;

T68_5: 
  response = 0.0020359389;
 goto D68;

T68_6: 
  response = 0.0026864604;
 goto D68;

N68_9: 
  if TP_PARTIAL$ in (0) then goto T68_7;
 else goto T68_8;

T68_7: 
  response = 0.0006280848;
 goto D68;

T68_8: 
  response = 0.0027928293;
 goto D68;

T68_9: 
  response = 0.0075049400;
 goto D68;

T68_10: 
  response = 0.0027537165;
 goto D68;

D68:

tnscore = tnscore + response;

  /* Tree 70 of 150 */
N69_1: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N69_2;
 else goto T69_10;

N69_2: 
  if QBERT_SCORE$ in (0) then goto N69_3;
 else goto N69_7;

N69_3: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N69_4;
 else goto T69_5;

N69_4: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N69_5;
 else goto T69_4;

N69_5: 
  if POS_R_P_5_E_0$ in (1) then goto T69_1;
 else goto N69_6;

T69_1: 
  response = -0.0025731530;
 goto D69;

N69_6: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto T69_2;
 else goto T69_3;

T69_2: 
  response = -0.0001602140;
 goto D69;

T69_3: 
  response = 0.0017744715;
 goto D69;

T69_4: 
  response = 0.0011764491;
 goto D69;

T69_5: 
  response = 0.0024900727;
 goto D69;

N69_7: 
  if TP_FRAC < 0.9676324725 then goto T69_6;
 else goto N69_8;

T69_6: 
  response = 0.0021360059;
 goto D69;

N69_8: 
  if IDF_FRAC < 0.8689930439 then goto N69_9;
 else goto T69_9;

N69_9: 
  if IDF_MISS_RIGHT$ in (0) then goto T69_7;
 else goto T69_8;

T69_7: 
  response = -0.0007800984;
 goto D69;

T69_8: 
  response = 0.0011990767;
 goto D69;

T69_9: 
  response = 0.0016659765;
 goto D69;

T69_10: 
  response = 0.0078751086;
 goto D69;

D69:

tnscore = tnscore + response;

  /* Tree 71 of 150 */
N70_1: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N70_2;
 else goto T70_10;

N70_2: 
  if POS_R_P_5_E_5$ in (0) then goto N70_3;
 else goto T70_9;

N70_3: 
  if POS_R_P_0_E_5$ in (0) then goto N70_4;
 else goto T70_8;

N70_4: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto N70_5;
 else goto N70_6;

N70_5: 
  if IDF_FRAC < 0.1775209904 then goto T70_1;
 else goto T70_2;

T70_1: 
  response = 0.0013201317;
 goto D70;

T70_2: 
  response = -0.0020217964;
 goto D70;

N70_6: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T70_3;
 else goto N70_7;

T70_3: 
  response = -0.0010145451;
 goto D70;

N70_7: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T70_4;
 else goto N70_8;

T70_4: 
  response = -0.0012585744;
 goto D70;

N70_8: 
  if TP_PARTIAL$ in (0) then goto N70_9;
 else goto T70_7;

N70_9: 
  if BRAND_NAME$ in (0) then goto T70_5;
 else goto T70_6;

T70_5: 
  response = -0.0004208341;
 goto D70;

T70_6: 
  response = 0.0005895431;
 goto D70;

T70_7: 
  response = 0.0012893785;
 goto D70;

T70_8: 
  response = 0.0014357435;
 goto D70;

T70_9: 
  response = 0.0022007359;
 goto D70;

T70_10: 
  response = 0.0080016031;
 goto D70;

D70:

tnscore = tnscore + response;

  /* Tree 72 of 150 */
N71_1: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T71_1;
 else goto N71_2;

T71_1: 
  response = -0.0028005599;
 goto D71;

N71_2: 
  if POS_L_P_4$ in (1) then goto T71_2;
 else goto N71_3;

T71_2: 
  response = -0.0025463415;
 goto D71;

N71_3: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T71_3;
 else goto N71_4;

T71_3: 
  response = -0.0005274668;
 goto D71;

N71_4: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T71_4;
 else goto N71_5;

T71_4: 
  response = -0.0009989681;
 goto D71;

N71_5: 
  if PARTIAL_BRAND$ in (0) then goto N71_6;
 else goto N71_8;

N71_6: 
  if IDF_MISS_RIGHT$ in (0) then goto T71_5;
 else goto N71_7;

T71_5: 
  response = 0.0002505514;
 goto D71;

N71_7: 
  if IDF_MISS_RIGHT_WEIGHT < 0.3827835023 then goto T71_6;
 else goto T71_7;

T71_6: 
  response = 0.0023135464;
 goto D71;

T71_7: 
  response = 0.0003333556;
 goto D71;

N71_8: 
  if IDF_MISS_LEFT_WEIGHT < 0.3416664898 then goto N71_9;
 else goto T71_10;

N71_9: 
  if LEN_Q_4_LEN_P_2$ in (1) then goto T71_8;
 else goto T71_9;

T71_8: 
  response = -0.0001225848;
 goto D71;

T71_9: 
  response = 0.0037537225;
 goto D71;

T71_10: 
  response = 0.0000636428;
 goto D71;

D71:

tnscore = tnscore + response;

  /* Tree 73 of 150 */
N72_1: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N72_2;
 else goto T72_10;

N72_2: 
  if POS_L_P_3_S_0$ in (1) then goto T72_1;
 else goto N72_3;

T72_1: 
  response = -0.0010727120;
 goto D72;

N72_3: 
  if POS_L_P_0_S_0$ in (1) then goto T72_2;
 else goto N72_4;

T72_2: 
  response = -0.0005162415;
 goto D72;

N72_4: 
  if POS_L_P_5_S_0$ in (1) then goto N72_5;
 else goto N72_6;

N72_5: 
  if POS_N_Q_1_P_1$ in (1) then goto T72_3;
 else goto T72_4;

T72_3: 
  response = -0.0042414257;
 goto D72;

T72_4: 
  response = -0.0002692257;
 goto D72;

N72_6: 
  if IDF_MISS_LEFT$ in (0) then goto N72_7;
 else goto N72_9;

N72_7: 
  if POS_L_P_4$ in (1) then goto T72_5;
 else goto N72_8;

T72_5: 
  response = -0.0026414656;
 goto D72;

N72_8: 
  if POS_R_P_1_E_0$ in (1) then goto T72_6;
 else goto T72_7;

T72_6: 
  response = -0.0032661759;
 goto D72;

T72_7: 
  response = 0.0005578381;
 goto D72;

N72_9: 
  if TP_FRAC < 0.1356030107 then goto T72_8;
 else goto T72_9;

T72_8: 
  response = -0.0006309534;
 goto D72;

T72_9: 
  response = 0.0024699151;
 goto D72;

T72_10: 
  response = 0.0027448986;
 goto D72;

D72:

tnscore = tnscore + response;

  /* Tree 74 of 150 */
N73_1: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N73_2;
 else goto T73_10;

N73_2: 
  if POS_R_P_0_E_5$ in (0) then goto N73_3;
 else goto T73_9;

N73_3: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto N73_4;
 else goto N73_5;

N73_4: 
  if TP_FRAC < 0.0028823949 then goto T73_1;
 else goto T73_2;

T73_1: 
  response = 0.0055188770;
 goto D73;

T73_2: 
  response = -0.0015210729;
 goto D73;

N73_5: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T73_3;
 else goto N73_6;

T73_3: 
  response = -0.0009549962;
 goto D73;

N73_6: 
  if POS_N_Q_0_P_0$ in (0) then goto N73_7;
 else goto T73_8;

N73_7: 
  if POS_L_P_5_S_5$ in (0) then goto N73_8;
 else goto T73_7;

N73_8: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N73_9;
 else goto T73_6;

N73_9: 
  if LEN_Q_6_LEN_P_4$ in (0) then goto T73_4;
 else goto T73_5;

T73_4: 
  response = 0.0001174862;
 goto D73;

T73_5: 
  response = 0.0054414947;
 goto D73;

T73_6: 
  response = 0.0064446153;
 goto D73;

T73_7: 
  response = 0.0028095007;
 goto D73;

T73_8: 
  response = 0.0036607105;
 goto D73;

T73_9: 
  response = 0.0013255577;
 goto D73;

T73_10: 
  response = 0.0025012869;
 goto D73;

D73:

tnscore = tnscore + response;

  /* Tree 75 of 150 */
N74_1: 
  if IDF_MISS_LEFT_WEIGHT < 0.9583334923 then goto N74_2;
 else goto T74_10;

N74_2: 
  if POS_N_Q_0_P_0$ in (0) then goto N74_3;
 else goto T74_9;

N74_3: 
  if TP_FRAC < -0.0000350140 then goto T74_1;
 else goto N74_4;

T74_1: 
  response = 0.0040320472;
 goto D74;

N74_4: 
  if IDF_FRAC < 0.3670070171 then goto T74_2;
 else goto N74_5;

T74_2: 
  response = -0.0005098218;
 goto D74;

N74_5: 
  if POS_L_P_0_S_5$ in (0) then goto N74_6;
 else goto T74_8;

N74_6: 
  if POS_R_P_0_E_5$ in (0) then goto N74_7;
 else goto T74_7;

N74_7: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T74_3;
 else goto N74_8;

T74_3: 
  response = -0.0016142799;
 goto D74;

N74_8: 
  if POS_R_P_5_E_5$ in (0) then goto N74_9;
 else goto T74_6;

N74_9: 
  if POS_L_P_5_S_5$ in (0) then goto T74_4;
 else goto T74_5;

T74_4: 
  response = 0.0000963212;
 goto D74;

T74_5: 
  response = 0.0025956234;
 goto D74;

T74_6: 
  response = 0.0023879808;
 goto D74;

T74_7: 
  response = 0.0015966371;
 goto D74;

T74_8: 
  response = 0.0029262914;
 goto D74;

T74_9: 
  response = 0.0023309793;
 goto D74;

T74_10: 
  response = 0.0069964516;
 goto D74;

D74:

tnscore = tnscore + response;

  /* Tree 76 of 150 */
N75_1: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T75_1;
 else goto N75_2;

T75_1: 
  response = -0.0026740884;
 goto D75;

N75_2: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T75_2;
 else goto N75_3;

T75_2: 
  response = -0.0010390417;
 goto D75;

N75_3: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T75_3;
 else goto N75_4;

T75_3: 
  response = -0.0005124868;
 goto D75;

N75_4: 
  if POS_L_P_4$ in (1) then goto T75_4;
 else goto N75_5;

T75_4: 
  response = -0.0026750901;
 goto D75;

N75_5: 
  if POS_N_Q_0_P_0$ in (0) then goto N75_6;
 else goto N75_9;

N75_6: 
  if POS_R_P_1_E_0$ in (1) then goto T75_5;
 else goto N75_7;

T75_5: 
  response = -0.0035225806;
 goto D75;

N75_7: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N75_8;
 else goto T75_8;

N75_8: 
  if POS_R_P_0_E_5$ in (0) then goto T75_6;
 else goto T75_7;

T75_6: 
  response = 0.0004160251;
 goto D75;

T75_7: 
  response = 0.0017448294;
 goto D75;

T75_8: 
  response = 0.0021936124;
 goto D75;

N75_9: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T75_9;
 else goto T75_10;

T75_9: 
  response = -0.0015440761;
 goto D75;

T75_10: 
  response = 0.0047231265;
 goto D75;

D75:

tnscore = tnscore + response;

  /* Tree 77 of 150 */
N76_1: 
  if PARTIAL_BRAND$ in (0) then goto N76_2;
 else goto N76_8;

N76_2: 
  if POS_L_P_NO$ in (0) then goto N76_3;
 else goto N76_4;

N76_3: 
  if IDF_MISS_LEFT$ in (0) then goto T76_1;
 else goto T76_2;

T76_1: 
  response = -0.0007744856;
 goto D76;

T76_2: 
  response = 0.0002739449;
 goto D76;

N76_4: 
  if POS_R_P_NO$ in (0) then goto N76_5;
 else goto T76_7;

N76_5: 
  if POS_R_P_0_E_5$ in (0) then goto N76_6;
 else goto T76_6;

N76_6: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T76_3;
 else goto N76_7;

T76_3: 
  response = -0.0014701764;
 goto D76;

N76_7: 
  if POS_R_P_5_E_5$ in (0) then goto T76_4;
 else goto T76_5;

T76_4: 
  response = 0.0001090801;
 goto D76;

T76_5: 
  response = 0.0022516450;
 goto D76;

T76_6: 
  response = 0.0012062040;
 goto D76;

T76_7: 
  response = 0.0049966479;
 goto D76;

N76_8: 
  if IDF_MISS_LEFT_WEIGHT < 0.3416664898 then goto N76_9;
 else goto T76_10;

N76_9: 
  if POS_L_P_3_S_3$ in (0) then goto T76_8;
 else goto T76_9;

T76_8: 
  response = 0.0014999573;
 goto D76;

T76_9: 
  response = 0.0095801782;
 goto D76;

T76_10: 
  response = -0.0002288591;
 goto D76;

D76:

tnscore = tnscore + response;

  /* Tree 78 of 150 */
N77_1: 
  if POS_L_P_5_S_0$ in (1) then goto N77_2;
 else goto N77_3;

N77_2: 
  if POS_N_Q_1_P_1$ in (1) then goto T77_1;
 else goto T77_2;

T77_1: 
  response = -0.0047557712;
 goto D77;

T77_2: 
  response = -0.0003378871;
 goto D77;

N77_3: 
  if POS_R_P_1_E_0$ in (1) then goto T77_3;
 else goto N77_4;

T77_3: 
  response = -0.0034925313;
 goto D77;

N77_4: 
  if POS_L_P_0_S_0$ in (1) then goto T77_4;
 else goto N77_5;

T77_4: 
  response = -0.0003255927;
 goto D77;

N77_5: 
  if POS_L_P_4$ in (1) then goto T77_5;
 else goto N77_6;

T77_5: 
  response = -0.0021034733;
 goto D77;

N77_6: 
  if POS_R_P_0_E_0$ in (1) then goto T77_6;
 else goto N77_7;

T77_6: 
  response = 0.0000421372;
 goto D77;

N77_7: 
  if QBERT_SCORE$ in (0) then goto T77_7;
 else goto N77_8;

T77_7: 
  response = 0.0005108096;
 goto D77;

N77_8: 
  if IDF_FRAC < 0.8793939948 then goto N77_9;
 else goto T77_10;

N77_9: 
  if TP_FRAC < 0.5825840235 then goto T77_8;
 else goto T77_9;

T77_8: 
  response = 0.0029703512;
 goto D77;

T77_9: 
  response = 0.0006737595;
 goto D77;

T77_10: 
  response = 0.0027563736;
 goto D77;

D77:

tnscore = tnscore + response;

  /* Tree 79 of 150 */
N78_1: 
  if POS_R_P_5_E_5$ in (0) then goto N78_2;
 else goto T78_10;

N78_2: 
  if POS_R_P_0_E_5$ in (0) then goto N78_3;
 else goto T78_9;

N78_3: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T78_1;
 else goto N78_4;

T78_1: 
  response = -0.0011231168;
 goto D78;

N78_4: 
  if TP_PARTIAL$ in (0) then goto N78_5;
 else goto N78_8;

N78_5: 
  if BRAND_NAME$ in (0) then goto T78_2;
 else goto N78_6;

T78_2: 
  response = -0.0005470586;
 goto D78;

N78_6: 
  if LEN_Q_3_LEN_P_2$ in (1) then goto T78_3;
 else goto N78_7;

T78_3: 
  response = -0.0004908261;
 goto D78;

N78_7: 
  if IDF_FRAC < 0.8492425084 then goto T78_4;
 else goto T78_5;

T78_4: 
  response = 0.0001196532;
 goto D78;

T78_5: 
  response = 0.0015720771;
 goto D78;

N78_8: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto N78_9;
 else goto T78_8;

N78_9: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto T78_6;
 else goto T78_7;

T78_6: 
  response = -0.0001825825;
 goto D78;

T78_7: 
  response = 0.0019414263;
 goto D78;

T78_8: 
  response = 0.0017916437;
 goto D78;

T78_9: 
  response = 0.0011956450;
 goto D78;

T78_10: 
  response = 0.0018793185;
 goto D78;

D78:

tnscore = tnscore + response;

  /* Tree 80 of 150 */
N79_1: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N79_2;
 else goto T79_10;

N79_2: 
  if LEN_Q_6_LEN_P_4$ in (0) then goto N79_3;
 else goto T79_9;

N79_3: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N79_4;
 else goto N79_8;

N79_4: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N79_5;
 else goto T79_5;

N79_5: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto N79_6;
 else goto T79_4;

N79_6: 
  if POS_N_Q_1_P_1$ in (1) then goto T79_1;
 else goto N79_7;

T79_1: 
  response = -0.0011445778;
 goto D79;

N79_7: 
  if POS_L_P_3_S_0$ in (1) then goto T79_2;
 else goto T79_3;

T79_2: 
  response = -0.0013293914;
 goto D79;

T79_3: 
  response = 0.0000912448;
 goto D79;

T79_4: 
  response = 0.0024007496;
 goto D79;

T79_5: 
  response = 0.0064319829;
 goto D79;

N79_8: 
  if POS_R_P_5_E_5$ in (0) then goto N79_9;
 else goto T79_8;

N79_9: 
  if IDF_MISS_LEFT$ in (0) then goto T79_6;
 else goto T79_7;

T79_6: 
  response = 0.0001282171;
 goto D79;

T79_7: 
  response = 0.0019647498;
 goto D79;

T79_8: 
  response = 0.0049074337;
 goto D79;

T79_9: 
  response = 0.0059742191;
 goto D79;

T79_10: 
  response = 0.0022468716;
 goto D79;

D79:

tnscore = tnscore + response;

  /* Tree 81 of 150 */
N80_1: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N80_2;
 else goto T80_10;

N80_2: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N80_3;
 else goto N80_9;

N80_3: 
  if TP_FRAC < -0.0000340698 then goto T80_1;
 else goto N80_4;

T80_1: 
  response = 0.0029424237;
 goto D80;

N80_4: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N80_5;
 else goto T80_7;

N80_5: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto N80_6;
 else goto T80_6;

N80_6: 
  if POS_N_Q_1_P_1$ in (1) then goto T80_2;
 else goto N80_7;

T80_2: 
  response = -0.0011451392;
 goto D80;

N80_7: 
  if IDF_FRAC < 0.3538900018 then goto N80_8;
 else goto T80_5;

N80_8: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto T80_3;
 else goto T80_4;

T80_3: 
  response = -0.0007528852;
 goto D80;

T80_4: 
  response = 0.0013192692;
 goto D80;

T80_5: 
  response = 0.0001480974;
 goto D80;

T80_6: 
  response = 0.0020742182;
 goto D80;

T80_7: 
  response = 0.0064048636;
 goto D80;

N80_9: 
  if POS_N_Q_3_P_3$ in (1) then goto T80_8;
 else goto T80_9;

T80_8: 
  response = -0.0012747889;
 goto D80;

T80_9: 
  response = 0.0012165125;
 goto D80;

T80_10: 
  response = 0.0021208718;
 goto D80;

D80:

tnscore = tnscore + response;

  /* Tree 82 of 150 */
N81_1: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N81_2;
 else goto T81_10;

N81_2: 
  if LEN_Q_6_LEN_P_4$ in (0) then goto N81_3;
 else goto T81_9;

N81_3: 
  if POS_L_P_0_S_0$ in (1) then goto T81_1;
 else goto N81_4;

T81_1: 
  response = -0.0005944984;
 goto D81;

N81_4: 
  if POS_L_P_5_S_0$ in (1) then goto T81_2;
 else goto N81_5;

T81_2: 
  response = -0.0008872153;
 goto D81;

N81_5: 
  if POS_R_P_NO$ in (0) then goto N81_6;
 else goto N81_7;

N81_6: 
  if POS_R_P_4_E_0$ in (1) then goto T81_3;
 else goto T81_4;

T81_3: 
  response = -0.0046954158;
 goto D81;

T81_4: 
  response = 0.0001285615;
 goto D81;

N81_7: 
  if POS_L_P_NO$ in (0) then goto N81_8;
 else goto T81_8;

N81_8: 
  if TP_PARTIAL$ in (0) then goto T81_5;
 else goto N81_9;

T81_5: 
  response = 0.0000658760;
 goto D81;

N81_9: 
  if IDF_MISS_LEFT_WEIGHT < 0.4248119891 then goto T81_6;
 else goto T81_7;

T81_6: 
  response = 0.0031562212;
 goto D81;

T81_7: 
  response = -0.0001589211;
 goto D81;

T81_8: 
  response = 0.0045958773;
 goto D81;

T81_9: 
  response = 0.0049043846;
 goto D81;

T81_10: 
  response = 0.0010491574;
 goto D81;

D81:

tnscore = tnscore + response;

  /* Tree 83 of 150 */
N82_1: 
  if POS_L_P_4$ in (1) then goto T82_1;
 else goto N82_2;

T82_1: 
  response = -0.0023967280;
 goto D82;

N82_2: 
  if POS_L_P_3_S_0$ in (1) then goto T82_2;
 else goto N82_3;

T82_2: 
  response = -0.0008556512;
 goto D82;

N82_3: 
  if POS_L_P_0_S_0$ in (1) then goto T82_3;
 else goto N82_4;

T82_3: 
  response = -0.0004333145;
 goto D82;

N82_4: 
  if IDF_MISS_RIGHT_WEIGHT < 0.5278639793 then goto N82_5;
 else goto T82_10;

N82_5: 
  if POS_R_P_4_E_0$ in (1) then goto T82_4;
 else goto N82_6;

T82_4: 
  response = -0.0036934194;
 goto D82;

N82_6: 
  if POS_L_P_5_S_0$ in (1) then goto N82_7;
 else goto N82_8;

N82_7: 
  if IDF_FRAC < 0.9572725296 then goto T82_5;
 else goto T82_6;

T82_5: 
  response = 0.0003428263;
 goto D82;

T82_6: 
  response = -0.0026323565;
 goto D82;

N82_8: 
  if IDF_MISS_LEFT$ in (0) then goto T82_7;
 else goto N82_9;

T82_7: 
  response = 0.0006228983;
 goto D82;

N82_9: 
  if TP_FRAC < 0.1423465014 then goto T82_8;
 else goto T82_9;

T82_8: 
  response = -0.0005448537;
 goto D82;

T82_9: 
  response = 0.0022161173;
 goto D82;

T82_10: 
  response = -0.0006660964;
 goto D82;

D82:

tnscore = tnscore + response;

  /* Tree 84 of 150 */
N83_1: 
  if TP_FRAC < -0.0000340733 then goto T83_1;
 else goto N83_2;

T83_1: 
  response = 0.0034055156;
 goto D83;

N83_2: 
  if TP_FRAC < 0.1915504932 then goto T83_2;
 else goto N83_3;

T83_2: 
  response = -0.0007405728;
 goto D83;

N83_3: 
  if POS_N_Q_0_P_0$ in (0) then goto N83_4;
 else goto T83_10;

N83_4: 
  if PARTIAL_BRAND$ in (0) then goto N83_5;
 else goto T83_9;

N83_5: 
  if IDF_MISS_RIGHT$ in (0) then goto N83_6;
 else goto N83_7;

N83_6: 
  if IDF_MISS_LEFT$ in (0) then goto T83_3;
 else goto T83_4;

T83_3: 
  response = -0.0004094572;
 goto D83;

T83_4: 
  response = 0.0003633165;
 goto D83;

N83_7: 
  if IDF_MISS_RIGHT_WEIGHT < 0.0690476447 then goto T83_5;
 else goto N83_8;

T83_5: 
  response = 0.0042821773;
 goto D83;

N83_8: 
  if TP_FRAC < 0.9998545051 then goto T83_6;
 else goto N83_9;

T83_6: 
  response = -0.0001832444;
 goto D83;

N83_9: 
  if IDF_MISS_RIGHT_WEIGHT < 0.4791305065 then goto T83_7;
 else goto T83_8;

T83_7: 
  response = 0.0015845466;
 goto D83;

T83_8: 
  response = -0.0001405451;
 goto D83;

T83_9: 
  response = 0.0012591910;
 goto D83;

T83_10: 
  response = 0.0029086217;
 goto D83;

D83:

tnscore = tnscore + response;

  /* Tree 85 of 150 */
N84_1: 
  if QBERT_SCORE$ in (0) then goto N84_2;
 else goto N84_5;

N84_2: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T84_1;
 else goto N84_3;

T84_1: 
  response = -0.0024221279;
 goto D84;

N84_3: 
  if LEN_Q_6_LEN_P_4$ in (0) then goto N84_4;
 else goto T84_4;

N84_4: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto T84_2;
 else goto T84_3;

T84_2: 
  response = -0.0001294475;
 goto D84;

T84_3: 
  response = 0.0014562932;
 goto D84;

T84_4: 
  response = 0.0054078464;
 goto D84;

N84_5: 
  if POS_R_P_0_E_0$ in (1) then goto N84_6;
 else goto N84_7;

N84_6: 
  if IDF_MISS_RIGHT$ in (0) then goto T84_5;
 else goto T84_6;

T84_5: 
  response = -0.0014258638;
 goto D84;

T84_6: 
  response = 0.0005703088;
 goto D84;

N84_7: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T84_7;
 else goto N84_8;

T84_7: 
  response = -0.0016356253;
 goto D84;

N84_8: 
  if POS_L_P_5$ in (0) then goto N84_9;
 else goto T84_10;

N84_9: 
  if POS_L_P_NO$ in (0) then goto T84_8;
 else goto T84_9;

T84_8: 
  response = -0.0002221924;
 goto D84;

T84_9: 
  response = 0.0018382729;
 goto D84;

T84_10: 
  response = 0.0031714566;
 goto D84;

D84:

tnscore = tnscore + response;

  /* Tree 86 of 150 */
N85_1: 
  if POS_N_Q_0_P_0$ in (0) then goto N85_2;
 else goto T85_10;

N85_2: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N85_3;
 else goto T85_9;

N85_3: 
  if TP_FRAC < -0.0000348511 then goto T85_1;
 else goto N85_4;

T85_1: 
  response = 0.0032685752;
 goto D85;

N85_4: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N85_5;
 else goto T85_8;

N85_5: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N85_6;
 else goto T85_7;

N85_6: 
  if POS_R_P_5_E_0$ in (1) then goto N85_7;
 else goto N85_9;

N85_7: 
  if QBERT_SCORE$ in (0) then goto N85_8;
 else goto T85_4;

N85_8: 
  if IDF_FRAC < 0.6742424965 then goto T85_2;
 else goto T85_3;

T85_2: 
  response = -0.0011180752;
 goto D85;

T85_3: 
  response = -0.0052418380;
 goto D85;

T85_4: 
  response = 0.0010748989;
 goto D85;

N85_9: 
  if POS_L_P_1_S_1$ in (0) then goto T85_5;
 else goto T85_6;

T85_5: 
  response = -0.0001990679;
 goto D85;

T85_6: 
  response = 0.0046893092;
 goto D85;

T85_7: 
  response = 0.0013159401;
 goto D85;

T85_8: 
  response = 0.0007252189;
 goto D85;

T85_9: 
  response = 0.0017781939;
 goto D85;

T85_10: 
  response = 0.0020635314;
 goto D85;

D85:

tnscore = tnscore + response;

  /* Tree 87 of 150 */
N86_1: 
  if POS_R_P_0_E_5$ in (0) then goto N86_2;
 else goto T86_10;

N86_2: 
  if PARTIAL_BRAND$ in (0) then goto N86_3;
 else goto N86_8;

N86_3: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T86_1;
 else goto N86_4;

T86_1: 
  response = -0.0011867828;
 goto D86;

N86_4: 
  if BRAND_NAME$ in (0) then goto T86_2;
 else goto N86_5;

T86_2: 
  response = -0.0004208641;
 goto D86;

N86_5: 
  if POS_L_P_1_S_1$ in (0) then goto N86_6;
 else goto T86_6;

N86_6: 
  if POS_R_P_1_E_0$ in (1) then goto T86_3;
 else goto N86_7;

T86_3: 
  response = -0.0030700604;
 goto D86;

N86_7: 
  if POS_L_P_3_S_0$ in (1) then goto T86_4;
 else goto T86_5;

T86_4: 
  response = -0.0009609512;
 goto D86;

T86_5: 
  response = 0.0003530550;
 goto D86;

T86_6: 
  response = 0.0066838492;
 goto D86;

N86_8: 
  if IDF_MISS_LEFT_WEIGHT < 0.3514705002 then goto N86_9;
 else goto T86_9;

N86_9: 
  if POS_R_P_NO$ in (0) then goto T86_7;
 else goto T86_8;

T86_7: 
  response = 0.0004365931;
 goto D86;

T86_8: 
  response = 0.0030362977;
 goto D86;

T86_9: 
  response = -0.0004491454;
 goto D86;

T86_10: 
  response = 0.0009666920;
 goto D86;

D86:

tnscore = tnscore + response;

  /* Tree 88 of 150 */
N87_1: 
  if TP_FRAC < -0.0000343383 then goto T87_1;
 else goto N87_2;

T87_1: 
  response = 0.0033399062;
 goto D87;

N87_2: 
  if PARTIAL_BRAND$ in (0) then goto N87_3;
 else goto N87_7;

N87_3: 
  if BRAND_NAME$ in (0) then goto T87_2;
 else goto N87_4;

T87_2: 
  response = -0.0003910171;
 goto D87;

N87_4: 
  if POS_L_P_1_S_1$ in (0) then goto N87_5;
 else goto T87_6;

N87_5: 
  if POS_N_Q_0_P_0$ in (0) then goto N87_6;
 else goto T87_5;

N87_6: 
  if POS_R_P_4_E_0$ in (1) then goto T87_3;
 else goto T87_4;

T87_3: 
  response = -0.0043362683;
 goto D87;

T87_4: 
  response = 0.0001779973;
 goto D87;

T87_5: 
  response = 0.0024972572;
 goto D87;

T87_6: 
  response = 0.0058429004;
 goto D87;

N87_7: 
  if POS_N_Q_1_P_1$ in (1) then goto T87_7;
 else goto N87_8;

T87_7: 
  response = -0.0017297592;
 goto D87;

N87_8: 
  if POS_R_P_NO$ in (0) then goto T87_8;
 else goto N87_9;

T87_8: 
  response = 0.0003843515;
 goto D87;

N87_9: 
  if IDF_MISS_LEFT_WEIGHT < 0.3514705002 then goto T87_9;
 else goto T87_10;

T87_9: 
  response = 0.0036822301;
 goto D87;

T87_10: 
  response = 0.0010210344;
 goto D87;

D87:

tnscore = tnscore + response;

  /* Tree 89 of 150 */
N88_1: 
  if POS_L_P_1_S_1$ in (0) then goto N88_2;
 else goto T88_10;

N88_2: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T88_1;
 else goto N88_3;

T88_1: 
  response = -0.0022085505;
 goto D88;

N88_3: 
  if PARTIAL_BRAND$ in (0) then goto N88_4;
 else goto T88_9;

N88_4: 
  if POS_R_P_0_E_5$ in (0) then goto N88_5;
 else goto T88_8;

N88_5: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T88_2;
 else goto N88_6;

T88_2: 
  response = -0.0012780728;
 goto D88;

N88_6: 
  if POS_R_P_5_E_5$ in (0) then goto N88_7;
 else goto T88_7;

N88_7: 
  if POS_R_P_1_E_0$ in (1) then goto T88_3;
 else goto N88_8;

T88_3: 
  response = -0.0029860505;
 goto D88;

N88_8: 
  if BRAND_NAME$ in (0) then goto T88_4;
 else goto N88_9;

T88_4: 
  response = -0.0003693967;
 goto D88;

N88_9: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T88_5;
 else goto T88_6;

T88_5: 
  response = -0.0008221900;
 goto D88;

T88_6: 
  response = 0.0003759932;
 goto D88;

T88_7: 
  response = 0.0016963834;
 goto D88;

T88_8: 
  response = 0.0010214235;
 goto D88;

T88_9: 
  response = 0.0009476939;
 goto D88;

T88_10: 
  response = 0.0044503547;
 goto D88;

D88:

tnscore = tnscore + response;

  /* Tree 90 of 150 */
N89_1: 
  if POS_L_P_NO$ in (0) then goto N89_2;
 else goto N89_7;

N89_2: 
  if IDF_MISS_LEFT$ in (0) then goto T89_1;
 else goto N89_3;

T89_1: 
  response = -0.0006361619;
 goto D89;

N89_3: 
  if IDF_MISS_LEFT_WEIGHT < 0.3717104793 then goto N89_4;
 else goto N89_6;

N89_4: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T89_2;
 else goto N89_5;

T89_2: 
  response = -0.0010992630;
 goto D89;

N89_5: 
  if TP_FRAC < 0.5652065277 then goto T89_3;
 else goto T89_4;

T89_3: 
  response = 0.0004972605;
 goto D89;

T89_4: 
  response = 0.0020801828;
 goto D89;

N89_6: 
  if IDF_MISS_LEFT_WEIGHT < 0.8995100260 then goto T89_5;
 else goto T89_6;

T89_5: 
  response = -0.0003987385;
 goto D89;

T89_6: 
  response = 0.0050241535;
 goto D89;

N89_7: 
  if POS_R_P_NO$ in (0) then goto N89_8;
 else goto T89_10;

N89_8: 
  if POS_R_P_4_E_0$ in (1) then goto T89_7;
 else goto N89_9;

T89_7: 
  response = -0.0041063446;
 goto D89;

N89_9: 
  if POS_R_P_1_E_0$ in (1) then goto T89_8;
 else goto T89_9;

T89_8: 
  response = -0.0032291590;
 goto D89;

T89_9: 
  response = 0.0004603418;
 goto D89;

T89_10: 
  response = 0.0043538597;
 goto D89;

D89:

tnscore = tnscore + response;

  /* Tree 91 of 150 */
N90_1: 
  if LEN_Q_6_LEN_P_4$ in (0) then goto N90_2;
 else goto T90_10;

N90_2: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N90_3;
 else goto T90_9;

N90_3: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N90_4;
 else goto T90_8;

N90_4: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N90_5;
 else goto N90_9;

N90_5: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N90_6;
 else goto T90_5;

N90_6: 
  if POS_R_P_0_E_5$ in (0) then goto N90_7;
 else goto T90_4;

N90_7: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto T90_1;
 else goto N90_8;

T90_1: 
  response = -0.0004462228;
 goto D90;

N90_8: 
  if TP_FRAC < 0.9676054716 then goto T90_2;
 else goto T90_3;

T90_2: 
  response = 0.0010486933;
 goto D90;

T90_3: 
  response = -0.0003949362;
 goto D90;

T90_4: 
  response = 0.0007462609;
 goto D90;

T90_5: 
  response = 0.0019094961;
 goto D90;

N90_9: 
  if POS_R_P_5_E_5$ in (0) then goto T90_6;
 else goto T90_7;

T90_6: 
  response = 0.0004719726;
 goto D90;

T90_7: 
  response = 0.0045709387;
 goto D90;

T90_8: 
  response = 0.0060885709;
 goto D90;

T90_9: 
  response = 0.0015587496;
 goto D90;

T90_10: 
  response = 0.0054521446;
 goto D90;

D90:

tnscore = tnscore + response;

  /* Tree 92 of 150 */
N91_1: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T91_1;
 else goto N91_2;

T91_1: 
  response = -0.0010117976;
 goto D91;

N91_2: 
  if PARTIAL_BRAND$ in (0) then goto N91_3;
 else goto T91_10;

N91_3: 
  if POS_L_P_NO$ in (0) then goto N91_4;
 else goto N91_6;

N91_4: 
  if IDF_MISS_LEFT$ in (0) then goto T91_2;
 else goto N91_5;

T91_2: 
  response = -0.0006470335;
 goto D91;

N91_5: 
  if IDF_MISS_LEFT_WEIGHT < 0.4142160118 then goto T91_3;
 else goto T91_4;

T91_3: 
  response = 0.0008527953;
 goto D91;

T91_4: 
  response = -0.0002690021;
 goto D91;

N91_6: 
  if POS_R_P_NO$ in (0) then goto N91_7;
 else goto T91_9;

N91_7: 
  if IDF_MISS_RIGHT$ in (0) then goto T91_5;
 else goto N91_8;

T91_5: 
  response = -0.0002238549;
 goto D91;

N91_8: 
  if IDF_MISS_RIGHT_WEIGHT < 0.5250630379 then goto N91_9;
 else goto T91_8;

N91_9: 
  if IDF_MISS_RIGHT_WEIGHT < 0.1225000024 then goto T91_6;
 else goto T91_7;

T91_6: 
  response = 0.0037565565;
 goto D91;

T91_7: 
  response = 0.0008577205;
 goto D91;

T91_8: 
  response = -0.0007943409;
 goto D91;

T91_9: 
  response = 0.0040737711;
 goto D91;

T91_10: 
  response = 0.0009874527;
 goto D91;

D91:

tnscore = tnscore + response;

  /* Tree 93 of 150 */
N92_1: 
  if POS_R_P_3_E_5$ in (0) then goto N92_2;
 else goto T92_10;

N92_2: 
  if POS_R_P_1_E_0$ in (1) then goto T92_1;
 else goto N92_3;

T92_1: 
  response = -0.0027377963;
 goto D92;

N92_3: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T92_2;
 else goto N92_4;

T92_2: 
  response = -0.0020970392;
 goto D92;

N92_4: 
  if IDF_MISS_RIGHT$ in (0) then goto N92_5;
 else goto N92_7;

N92_5: 
  if TP_PARTIAL$ in (0) then goto T92_3;
 else goto N92_6;

T92_3: 
  response = -0.0002558686;
 goto D92;

N92_6: 
  if IDF_MISS_LEFT_WEIGHT < 0.2970589995 then goto T92_4;
 else goto T92_5;

T92_4: 
  response = 0.0017931430;
 goto D92;

T92_5: 
  response = -0.0001301133;
 goto D92;

N92_7: 
  if IDF_MISS_RIGHT_WEIGHT < 0.0741758496 then goto T92_6;
 else goto N92_8;

T92_6: 
  response = 0.0030815573;
 goto D92;

N92_8: 
  if IDF_MISS_RIGHT_WEIGHT < 0.4422219992 then goto N92_9;
 else goto T92_9;

N92_9: 
  if POS_R_P_0_E_0$ in (1) then goto T92_7;
 else goto T92_8;

T92_7: 
  response = 0.0001594377;
 goto D92;

T92_8: 
  response = 0.0014542535;
 goto D92;

T92_9: 
  response = -0.0002210134;
 goto D92;

T92_10: 
  response = 0.0024116754;
 goto D92;

D92:

tnscore = tnscore + response;

  /* Tree 94 of 150 */
N93_1: 
  if IDF_MISS_LEFT_WEIGHT < 0.8722825050 then goto N93_2;
 else goto T93_10;

N93_2: 
  if IDF_MISS_RIGHT$ in (0) then goto N93_3;
 else goto N93_6;

N93_3: 
  if POS_R_P_0_E_0$ in (1) then goto T93_1;
 else goto N93_4;

T93_1: 
  response = -0.0008087365;
 goto D93;

N93_4: 
  if IDF_MISS_LEFT_WEIGHT < 0.4641025066 then goto N93_5;
 else goto T93_4;

N93_5: 
  if TP_PARTIAL$ in (0) then goto T93_2;
 else goto T93_3;

T93_2: 
  response = -0.0000293992;
 goto D93;

T93_3: 
  response = 0.0010564548;
 goto D93;

T93_4: 
  response = -0.0006585492;
 goto D93;

N93_6: 
  if IDF_MISS_RIGHT_WEIGHT < 0.1081870049 then goto T93_5;
 else goto N93_7;

T93_5: 
  response = 0.0026685956;
 goto D93;

N93_7: 
  if IDF_MISS_RIGHT_WEIGHT < 0.4599354863 then goto N93_8;
 else goto T93_9;

N93_8: 
  if TP_FRAC < 0.9337195158 then goto T93_6;
 else goto N93_9;

T93_6: 
  response = 0.0000649457;
 goto D93;

N93_9: 
  if POS_R_P_0_E_5$ in (0) then goto T93_7;
 else goto T93_8;

T93_7: 
  response = 0.0008791886;
 goto D93;

T93_8: 
  response = 0.0036554039;
 goto D93;

T93_9: 
  response = -0.0002238045;
 goto D93;

T93_10: 
  response = 0.0049981083;
 goto D93;

D93:

tnscore = tnscore + response;

  /* Tree 95 of 150 */
N94_1: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N94_2;
 else goto T94_10;

N94_2: 
  if LEN_Q_6_LEN_P_4$ in (0) then goto N94_3;
 else goto T94_9;

N94_3: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N94_4;
 else goto N94_8;

N94_4: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N94_5;
 else goto T94_5;

N94_5: 
  if TP_FRAC < -0.0000349969 then goto T94_1;
 else goto N94_6;

T94_1: 
  response = 0.0025843172;
 goto D94;

N94_6: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N94_7;
 else goto T94_4;

N94_7: 
  if LEN_Q_4_LEN_P_4$ in (0) then goto T94_2;
 else goto T94_3;

T94_2: 
  response = -0.0003428890;
 goto D94;

T94_3: 
  response = 0.0033127891;
 goto D94;

T94_4: 
  response = 0.0017788176;
 goto D94;

T94_5: 
  response = 0.0013426732;
 goto D94;

N94_8: 
  if IDF_FRAC < 0.3858560026 then goto T94_6;
 else goto N94_9;

T94_6: 
  response = 0.0038466209;
 goto D94;

N94_9: 
  if TP_PARTIAL$ in (0) then goto T94_7;
 else goto T94_8;

T94_7: 
  response = 0.0000473372;
 goto D94;

T94_8: 
  response = 0.0015901373;
 goto D94;

T94_9: 
  response = 0.0047089020;
 goto D94;

T94_10: 
  response = 0.0016608557;
 goto D94;

D94:

tnscore = tnscore + response;

  /* Tree 96 of 150 */
N95_1: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N95_2;
 else goto T95_10;

N95_2: 
  if POS_N_Q_1_P_1$ in (1) then goto N95_3;
 else goto N95_6;

N95_3: 
  if POS_L_P_5_S_0$ in (1) then goto T95_1;
 else goto N95_4;

T95_1: 
  response = -0.0038931267;
 goto D95;

N95_4: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N95_5;
 else goto T95_4;

N95_5: 
  if POS_R_P_NO$ in (0) then goto T95_2;
 else goto T95_3;

T95_2: 
  response = -0.0015573408;
 goto D95;

T95_3: 
  response = 0.0002366101;
 goto D95;

T95_4: 
  response = 0.0017262303;
 goto D95;

N95_6: 
  if PARTIAL_BRAND$ in (0) then goto N95_7;
 else goto N95_8;

N95_7: 
  if POS_L_P_3$ in (1) then goto T95_5;
 else goto T95_6;

T95_5: 
  response = -0.0009463197;
 goto D95;

T95_6: 
  response = 0.0001211577;
 goto D95;

N95_8: 
  if IDF_MISS_LEFT_WEIGHT < 0.4749370217 then goto N95_9;
 else goto T95_9;

N95_9: 
  if POS_R_P_NO$ in (0) then goto T95_7;
 else goto T95_8;

T95_7: 
  response = 0.0006591733;
 goto D95;

T95_8: 
  response = 0.0024162138;
 goto D95;

T95_9: 
  response = -0.0010618223;
 goto D95;

T95_10: 
  response = 0.0019711730;
 goto D95;

D95:

tnscore = tnscore + response;

  /* Tree 97 of 150 */
N96_1: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N96_2;
 else goto T96_10;

N96_2: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N96_3;
 else goto T96_9;

N96_3: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N96_4;
 else goto T96_8;

N96_4: 
  if TP_FRAC < -0.0000347941 then goto T96_1;
 else goto N96_5;

T96_1: 
  response = 0.0026591692;
 goto D96;

N96_5: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N96_6;
 else goto T96_7;

N96_6: 
  if POS_N_Q_1_P_1$ in (1) then goto T96_2;
 else goto N96_7;

T96_2: 
  response = -0.0010300313;
 goto D96;

N96_7: 
  if IDF_FRAC < 0.8915979862 then goto N96_8;
 else goto T96_6;

N96_8: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto T96_3;
 else goto N96_9;

T96_3: 
  response = -0.0003826907;
 goto D96;

N96_9: 
  if IDF_MISS_RIGHT$ in (0) then goto T96_4;
 else goto T96_5;

T96_4: 
  response = -0.0001992911;
 goto D96;

T96_5: 
  response = 0.0013651424;
 goto D96;

T96_6: 
  response = 0.0008592292;
 goto D96;

T96_7: 
  response = 0.0016957747;
 goto D96;

T96_8: 
  response = 0.0014794121;
 goto D96;

T96_9: 
  response = 0.0008089680;
 goto D96;

T96_10: 
  response = 0.0017499055;
 goto D96;

D96:

tnscore = tnscore + response;

  /* Tree 98 of 150 */
N97_1: 
  if POS_L_P_4$ in (1) then goto T97_1;
 else goto N97_2;

T97_1: 
  response = -0.0021886617;
 goto D97;

N97_2: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N97_3;
 else goto T97_10;

N97_3: 
  if POS_R_P_5_E_5$ in (0) then goto N97_4;
 else goto T97_9;

N97_4: 
  if POS_R_P_3_E_5$ in (0) then goto N97_5;
 else goto T97_8;

N97_5: 
  if LEN_Q_4_LEN_P_4$ in (0) then goto N97_6;
 else goto T97_7;

N97_6: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto N97_7;
 else goto N97_9;

N97_7: 
  if POS_N_Q_1_P_1$ in (1) then goto N97_8;
 else goto T97_4;

N97_8: 
  if IDF_FRAC < 0.9782609940 then goto T97_2;
 else goto T97_3;

T97_2: 
  response = 0.0005557447;
 goto D97;

T97_3: 
  response = -0.0013727566;
 goto D97;

T97_4: 
  response = -0.0000279805;
 goto D97;

N97_9: 
  if IDF_FRAC < 0.5092594624 then goto T97_5;
 else goto T97_6;

T97_5: 
  response = 0.0103128902;
 goto D97;

T97_6: 
  response = 0.0007257324;
 goto D97;

T97_7: 
  response = 0.0036695165;
 goto D97;

T97_8: 
  response = 0.0023533689;
 goto D97;

T97_9: 
  response = 0.0013027487;
 goto D97;

T97_10: 
  response = 0.0017297541;
 goto D97;

D97:

tnscore = tnscore + response;

  /* Tree 99 of 150 */
N98_1: 
  if POS_R_P_1_E_0$ in (1) then goto T98_1;
 else goto N98_2;

T98_1: 
  response = -0.0028638531;
 goto D98;

N98_2: 
  if POS_L_P_4$ in (1) then goto T98_2;
 else goto N98_3;

T98_2: 
  response = -0.0018380846;
 goto D98;

N98_3: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T98_3;
 else goto N98_4;

T98_3: 
  response = -0.0005071910;
 goto D98;

N98_4: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T98_4;
 else goto N98_5;

T98_4: 
  response = -0.0007572573;
 goto D98;

N98_5: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T98_5;
 else goto N98_6;

T98_5: 
  response = -0.0020058794;
 goto D98;

N98_6: 
  if LEN_Q_4_LEN_P_2$ in (1) then goto T98_6;
 else goto N98_7;

T98_6: 
  response = -0.0003576713;
 goto D98;

N98_7: 
  if POS_L_P_3_S_0$ in (1) then goto T98_7;
 else goto N98_8;

T98_7: 
  response = -0.0007838567;
 goto D98;

N98_8: 
  if POS_L_P_5_S_5$ in (0) then goto N98_9;
 else goto T98_10;

N98_9: 
  if POS_N_Q_0_P_0$ in (0) then goto T98_8;
 else goto T98_9;

T98_8: 
  response = 0.0004817217;
 goto D98;

T98_9: 
  response = 0.0025140074;
 goto D98;

T98_10: 
  response = 0.0024722605;
 goto D98;

D98:

tnscore = tnscore + response;

  /* Tree 100 of 150 */
N99_1: 
  if POS_L_P_4$ in (1) then goto T99_1;
 else goto N99_2;

T99_1: 
  response = -0.0019542145;
 goto D99;

N99_2: 
  if POS_R_P_4_E_0$ in (1) then goto T99_2;
 else goto N99_3;

T99_2: 
  response = -0.0030852982;
 goto D99;

N99_3: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N99_4;
 else goto T99_10;

N99_4: 
  if QBERT_SCORE$ in (0) then goto N99_5;
 else goto N99_6;

N99_5: 
  if POS_R_P_5_E_0$ in (1) then goto T99_3;
 else goto T99_4;

T99_3: 
  response = -0.0020785231;
 goto D99;

T99_4: 
  response = 0.0000310645;
 goto D99;

N99_6: 
  if POS_R_P_0_E_0$ in (1) then goto T99_5;
 else goto N99_7;

T99_5: 
  response = -0.0005996229;
 goto D99;

N99_7: 
  if IDF_FRAC < 0.6792855263 then goto N99_8;
 else goto T99_9;

N99_8: 
  if POS_N_Q_2_P_1$ in (0) then goto N99_9;
 else goto T99_8;

N99_9: 
  if IDF_FRAC < 0.2933095098 then goto T99_6;
 else goto T99_7;

T99_6: 
  response = 0.0014213780;
 goto D99;

T99_7: 
  response = -0.0014295872;
 goto D99;

T99_8: 
  response = 0.0017720473;
 goto D99;

T99_9: 
  response = 0.0016097300;
 goto D99;

T99_10: 
  response = 0.0015143369;
 goto D99;

D99:

tnscore = tnscore + response;

  /* Tree 101 of 150 */
N100_1: 
  if POS_L_P_3_S_0$ in (1) then goto T100_1;
 else goto N100_2;

T100_1: 
  response = -0.0007731906;
 goto D100;

N100_2: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T100_2;
 else goto N100_3;

T100_2: 
  response = -0.0009111668;
 goto D100;

N100_3: 
  if POS_N_Q_0_P_0$ in (0) then goto N100_4;
 else goto N100_8;

N100_4: 
  if POS_L_P_4$ in (1) then goto T100_3;
 else goto N100_5;

T100_3: 
  response = -0.0017264622;
 goto D100;

N100_5: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto N100_6;
 else goto N100_7;

N100_6: 
  if IDF_FRAC < 0.9258239865 then goto T100_4;
 else goto T100_5;

T100_4: 
  response = -0.0001404857;
 goto D100;

T100_5: 
  response = -0.0034387586;
 goto D100;

N100_7: 
  if LEN_Q_4_LEN_P_2$ in (1) then goto T100_6;
 else goto T100_7;

T100_6: 
  response = -0.0002980502;
 goto D100;

T100_7: 
  response = 0.0004260430;
 goto D100;

N100_8: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T100_8;
 else goto N100_9;

T100_8: 
  response = -0.0015046173;
 goto D100;

N100_9: 
  if POS_L_P_NO$ in (0) then goto T100_9;
 else goto T100_10;

T100_9: 
  response = 0.0006708180;
 goto D100;

T100_10: 
  response = 0.0054222990;
 goto D100;

D100:

tnscore = tnscore + response;

  /* Tree 102 of 150 */
N101_1: 
  if POS_R_P_0_E_5$ in (0) then goto N101_2;
 else goto T101_10;

N101_2: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T101_1;
 else goto N101_3;

T101_1: 
  response = -0.0009567589;
 goto D101;

N101_3: 
  if POS_R_P_5_E_5$ in (0) then goto N101_4;
 else goto T101_9;

N101_4: 
  if POS_N_Q_2_P_1$ in (0) then goto N101_5;
 else goto N101_9;

N101_5: 
  if POS_R_P_1_E_0$ in (1) then goto T101_2;
 else goto N101_6;

T101_2: 
  response = -0.0031083109;
 goto D101;

N101_6: 
  if TP_FRAC < 0.2343584895 then goto T101_3;
 else goto N101_7;

T101_3: 
  response = -0.0006671117;
 goto D101;

N101_7: 
  if PARTIAL_BRAND$ in (0) then goto N101_8;
 else goto T101_6;

N101_8: 
  if POS_L_P_NO$ in (0) then goto T101_4;
 else goto T101_5;

T101_4: 
  response = -0.0002729776;
 goto D101;

T101_5: 
  response = 0.0003316087;
 goto D101;

T101_6: 
  response = 0.0010416177;
 goto D101;

N101_9: 
  if IDF_FRAC < 0.5810199976 then goto T101_7;
 else goto T101_8;

T101_7: 
  response = 0.0010870876;
 goto D101;

T101_8: 
  response = -0.0001149468;
 goto D101;

T101_9: 
  response = 0.0014339013;
 goto D101;

T101_10: 
  response = 0.0008741477;
 goto D101;

D101:

tnscore = tnscore + response;

  /* Tree 103 of 150 */
N102_1: 
  if POS_R_P_0_E_5$ in (0) then goto N102_2;
 else goto T102_10;

N102_2: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto N102_3;
 else goto N102_4;

N102_3: 
  if IDF_FRAC < 0.9782609940 then goto T102_1;
 else goto T102_2;

T102_1: 
  response = -0.0004425990;
 goto D102;

T102_2: 
  response = -0.0029114149;
 goto D102;

N102_4: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto N102_5;
 else goto N102_6;

N102_5: 
  if IDF_FRAC < 0.7303029895 then goto T102_3;
 else goto T102_4;

T102_3: 
  response = -0.0003671867;
 goto D102;

T102_4: 
  response = -0.0033203156;
 goto D102;

N102_6: 
  if POS_N_Q_0_P_0$ in (0) then goto N102_7;
 else goto T102_9;

N102_7: 
  if POS_L_P_5_S_5$ in (0) then goto N102_8;
 else goto T102_8;

N102_8: 
  if POS_R_P_4_E_0$ in (1) then goto T102_5;
 else goto N102_9;

T102_5: 
  response = -0.0031629494;
 goto D102;

N102_9: 
  if BRAND_NAME$ in (0) then goto T102_6;
 else goto T102_7;

T102_6: 
  response = -0.0002185775;
 goto D102;

T102_7: 
  response = 0.0003280478;
 goto D102;

T102_8: 
  response = 0.0019788143;
 goto D102;

T102_9: 
  response = 0.0025411632;
 goto D102;

T102_10: 
  response = 0.0009488488;
 goto D102;

D102:

tnscore = tnscore + response;

  /* Tree 104 of 150 */
N103_1: 
  if POS_R_P_4_E_0$ in (1) then goto T103_1;
 else goto N103_2;

T103_1: 
  response = -0.0029424084;
 goto D103;

N103_2: 
  if IDF_MISS_LEFT_WEIGHT < 0.8441294432 then goto N103_3;
 else goto T103_10;

N103_3: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N103_4;
 else goto T103_9;

N103_4: 
  if QBERT_SCORE$ in (0) then goto N103_5;
 else goto N103_9;

N103_5: 
  if IDF_FRAC < 0.6464459896 then goto N103_6;
 else goto N103_8;

N103_6: 
  if TP_FRAC < 0.9362075329 then goto N103_7;
 else goto T103_4;

N103_7: 
  if TP_PARTIAL$ in (0) then goto T103_2;
 else goto T103_3;

T103_2: 
  response = -0.0005288614;
 goto D103;

T103_3: 
  response = 0.0003490962;
 goto D103;

T103_4: 
  response = 0.0007564592;
 goto D103;

N103_8: 
  if POS_R_P_5_E_0$ in (1) then goto T103_5;
 else goto T103_6;

T103_5: 
  response = -0.0031432559;
 goto D103;

T103_6: 
  response = -0.0003000364;
 goto D103;

N103_9: 
  if POS_R_P_0_E_0$ in (1) then goto T103_7;
 else goto T103_8;

T103_7: 
  response = -0.0006097149;
 goto D103;

T103_8: 
  response = 0.0009199325;
 goto D103;

T103_9: 
  response = 0.0051740276;
 goto D103;

T103_10: 
  response = 0.0044909830;
 goto D103;

D103:

tnscore = tnscore + response;

  /* Tree 105 of 150 */
N104_1: 
  if POS_R_P_3_E_5$ in (0) then goto N104_2;
 else goto T104_10;

N104_2: 
  if POS_R_P_0_E_5$ in (0) then goto N104_3;
 else goto N104_9;

N104_3: 
  if POS_L_P_5_S_5$ in (0) then goto N104_4;
 else goto N104_8;

N104_4: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto N104_5;
 else goto N104_6;

N104_5: 
  if IDF_FRAC < 0.1185896471 then goto T104_1;
 else goto T104_2;

T104_1: 
  response = 0.0008930056;
 goto D104;

T104_2: 
  response = -0.0015605847;
 goto D104;

N104_6: 
  if POS_R_P_5_E_5$ in (0) then goto N104_7;
 else goto T104_5;

N104_7: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto T104_3;
 else goto T104_4;

T104_3: 
  response = -0.0001473936;
 goto D104;

T104_4: 
  response = 0.0015632153;
 goto D104;

T104_5: 
  response = 0.0013518814;
 goto D104;

N104_8: 
  if QBERT_SCORE$ in (0) then goto T104_6;
 else goto T104_7;

T104_6: 
  response = 0.0002805392;
 goto D104;

T104_7: 
  response = 0.0040515180;
 goto D104;

N104_9: 
  if IDF_FRAC < 0.4577379823 then goto T104_8;
 else goto T104_9;

T104_8: 
  response = -0.0005539539;
 goto D104;

T104_9: 
  response = 0.0014986679;
 goto D104;

T104_10: 
  response = 0.0022500705;
 goto D104;

D104:

tnscore = tnscore + response;

  /* Tree 106 of 150 */
N105_1: 
  if IDF_MISS_LEFT_WEIGHT < 0.8995100260 then goto N105_2;
 else goto T105_10;

N105_2: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto N105_3;
 else goto N105_4;

N105_3: 
  if IDF_FRAC < 0.6809090376 then goto T105_1;
 else goto T105_2;

T105_1: 
  response = -0.0005235413;
 goto D105;

T105_2: 
  response = -0.0053856765;
 goto D105;

N105_4: 
  if IDF_MISS_RIGHT$ in (0) then goto N105_5;
 else goto N105_8;

N105_5: 
  if POS_L_P_5_S_5$ in (0) then goto N105_6;
 else goto T105_6;

N105_6: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto N105_7;
 else goto T105_5;

N105_7: 
  if POS_L_P_0_S_5$ in (0) then goto T105_3;
 else goto T105_4;

T105_3: 
  response = -0.0002661542;
 goto D105;

T105_4: 
  response = 0.0011880447;
 goto D105;

T105_5: 
  response = 0.0016273963;
 goto D105;

T105_6: 
  response = 0.0012485166;
 goto D105;

N105_8: 
  if IDF_MISS_RIGHT_WEIGHT < 0.4686275125 then goto N105_9;
 else goto T105_9;

N105_9: 
  if POS_R_P_0_E_5$ in (0) then goto T105_7;
 else goto T105_8;

T105_7: 
  response = 0.0006541335;
 goto D105;

T105_8: 
  response = 0.0022396170;
 goto D105;

T105_9: 
  response = -0.0003896233;
 goto D105;

T105_10: 
  response = 0.0046958316;
 goto D105;

D105:

tnscore = tnscore + response;

  /* Tree 107 of 150 */
N106_1: 
  if LEN_Q_4_LEN_P_4$ in (0) then goto N106_2;
 else goto T106_10;

N106_2: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T106_1;
 else goto N106_3;

T106_1: 
  response = -0.0019231992;
 goto D106;

N106_3: 
  if POS_N_Q_0_P_0$ in (0) then goto N106_4;
 else goto T106_9;

N106_4: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N106_5;
 else goto T106_8;

N106_5: 
  if IDF_MISS_RIGHT$ in (0) then goto N106_6;
 else goto N106_8;

N106_6: 
  if POS_R_P_0_E_0$ in (1) then goto T106_2;
 else goto N106_7;

T106_2: 
  response = -0.0008591153;
 goto D106;

N106_7: 
  if POS_N_Q_2_P_1$ in (0) then goto T106_3;
 else goto T106_4;

T106_3: 
  response = -0.0001944246;
 goto D106;

T106_4: 
  response = 0.0005016899;
 goto D106;

N106_8: 
  if IDF_MISS_RIGHT_WEIGHT < 0.4791305065 then goto N106_9;
 else goto T106_7;

N106_9: 
  if TP_FRAC < 0.9981369972 then goto T106_5;
 else goto T106_6;

T106_5: 
  response = 0.0001764009;
 goto D106;

T106_6: 
  response = 0.0011615243;
 goto D106;

T106_7: 
  response = -0.0004461706;
 goto D106;

T106_8: 
  response = 0.0047002714;
 goto D106;

T106_9: 
  response = 0.0013076373;
 goto D106;

T106_10: 
  response = 0.0038670359;
 goto D106;

D106:

tnscore = tnscore + response;

  /* Tree 108 of 150 */
N107_1: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N107_2;
 else goto T107_10;

N107_2: 
  if POS_R_P_3_E_5$ in (0) then goto N107_3;
 else goto T107_9;

N107_3: 
  if PARTIAL_BRAND$ in (0) then goto N107_4;
 else goto N107_8;

N107_4: 
  if POS_L_P_1_S_1$ in (0) then goto N107_5;
 else goto T107_5;

N107_5: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto N107_6;
 else goto T107_4;

N107_6: 
  if TP_FRAC < 0.0011527800 then goto T107_1;
 else goto N107_7;

T107_1: 
  response = 0.0047041588;
 goto D107;

N107_7: 
  if POS_R_P_0_E_5$ in (0) then goto T107_2;
 else goto T107_3;

T107_2: 
  response = -0.0015236917;
 goto D107;

T107_3: 
  response = 0.0008747889;
 goto D107;

T107_4: 
  response = -0.0000933077;
 goto D107;

T107_5: 
  response = 0.0034490443;
 goto D107;

N107_8: 
  if IDF_MISS_LEFT_WEIGHT < 0.3431369960 then goto N107_9;
 else goto T107_8;

N107_9: 
  if POS_L_P_3_S_3$ in (0) then goto T107_6;
 else goto T107_7;

T107_6: 
  response = 0.0008844722;
 goto D107;

T107_7: 
  response = 0.0075873095;
 goto D107;

T107_8: 
  response = -0.0005665113;
 goto D107;

T107_9: 
  response = 0.0020896003;
 goto D107;

T107_10: 
  response = 0.0013773123;
 goto D107;

D107:

tnscore = tnscore + response;

  /* Tree 109 of 150 */
N108_1: 
  if TP_FRAC < -0.0000340721 then goto T108_1;
 else goto N108_2;

T108_1: 
  response = 0.0027051425;
 goto D108;

N108_2: 
  if TP_FRAC < 0.1887409985 then goto T108_2;
 else goto N108_3;

T108_2: 
  response = -0.0007030844;
 goto D108;

N108_3: 
  if IDF_MISS_LEFT$ in (0) then goto N108_4;
 else goto N108_8;

N108_4: 
  if POS_L_P_NO$ in (0) then goto T108_3;
 else goto N108_5;

T108_3: 
  response = -0.0005484698;
 goto D108;

N108_5: 
  if POS_R_P_NO$ in (0) then goto N108_6;
 else goto N108_7;

N108_6: 
  if POS_R_P_4_E_0$ in (1) then goto T108_4;
 else goto T108_5;

T108_4: 
  response = -0.0040172237;
 goto D108;

T108_5: 
  response = 0.0000532488;
 goto D108;

N108_7: 
  if IDF_FRAC < 0.5000000000 then goto T108_6;
 else goto T108_7;

T108_6: 
  response = 0.0230940795;
 goto D108;

T108_7: 
  response = 0.0026522031;
 goto D108;

N108_8: 
  if IDF_MISS_LEFT_WEIGHT < 0.4387499988 then goto N108_9;
 else goto T108_10;

N108_9: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T108_8;
 else goto T108_9;

T108_8: 
  response = -0.0009543258;
 goto D108;

T108_9: 
  response = 0.0013758175;
 goto D108;

T108_10: 
  response = -0.0001557192;
 goto D108;

D108:

tnscore = tnscore + response;

  /* Tree 110 of 150 */
N109_1: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T109_1;
 else goto N109_2;

T109_1: 
  response = -0.0019007927;
 goto D109;

N109_2: 
  if PARTIAL_BRAND$ in (0) then goto N109_3;
 else goto N109_8;

N109_3: 
  if TP_FRAC < -0.0000395822 then goto T109_2;
 else goto N109_4;

T109_2: 
  response = 0.0034222150;
 goto D109;

N109_4: 
  if IDF_MISS_RIGHT$ in (0) then goto N109_5;
 else goto N109_7;

N109_5: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto T109_3;
 else goto N109_6;

T109_3: 
  response = -0.0002430559;
 goto D109;

N109_6: 
  if POS_L_P_3$ in (1) then goto T109_4;
 else goto T109_5;

T109_4: 
  response = -0.0023685549;
 goto D109;

T109_5: 
  response = 0.0028845359;
 goto D109;

N109_7: 
  if IDF_MISS_RIGHT_WEIGHT < 0.0690476447 then goto T109_6;
 else goto T109_7;

T109_6: 
  response = 0.0027327465;
 goto D109;

T109_7: 
  response = 0.0001526986;
 goto D109;

N109_8: 
  if TP_FRAC < 0.3311434984 then goto N109_9;
 else goto T109_10;

N109_9: 
  if IDF_FRAC < 0.7290209532 then goto T109_8;
 else goto T109_9;

T109_8: 
  response = 0.0006384208;
 goto D109;

T109_9: 
  response = -0.0027031924;
 goto D109;

T109_10: 
  response = 0.0011624962;
 goto D109;

D109:

tnscore = tnscore + response;

  /* Tree 111 of 150 */
N110_1: 
  if POS_R_P_3_E_5$ in (0) then goto N110_2;
 else goto T110_10;

N110_2: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N110_3;
 else goto T110_9;

N110_3: 
  if IDF_MISS_LEFT_WEIGHT < 0.7113095522 then goto N110_4;
 else goto T110_8;

N110_4: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N110_5;
 else goto T110_7;

N110_5: 
  if IDF_MISS_LEFT_WEIGHT < 0.4641025066 then goto N110_6;
 else goto T110_6;

N110_6: 
  if IDF_MISS_LEFT$ in (0) then goto T110_1;
 else goto N110_7;

T110_1: 
  response = -0.0001566753;
 goto D110;

N110_7: 
  if TP_FRAC < 0.2362335026 then goto T110_2;
 else goto N110_8;

T110_2: 
  response = -0.0007204896;
 goto D110;

N110_8: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T110_3;
 else goto N110_9;

T110_3: 
  response = -0.0011132188;
 goto D110;

N110_9: 
  if IDF_MISS_LEFT_WEIGHT < 0.2970589995 then goto T110_4;
 else goto T110_5;

T110_4: 
  response = 0.0019492408;
 goto D110;

T110_5: 
  response = 0.0004748664;
 goto D110;

T110_6: 
  response = -0.0006810519;
 goto D110;

T110_7: 
  response = 0.0046894293;
 goto D110;

T110_8: 
  response = 0.0017781642;
 goto D110;

T110_9: 
  response = 0.0013742341;
 goto D110;

T110_10: 
  response = 0.0023207441;
 goto D110;

D110:

tnscore = tnscore + response;

  /* Tree 112 of 150 */
N111_1: 
  if IDF_MISS_LEFT_WEIGHT < 0.7113095522 then goto N111_2;
 else goto T111_10;

N111_2: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N111_3;
 else goto T111_9;

N111_3: 
  if IDF_MISS_LEFT_WEIGHT < 0.4900000095 then goto N111_4;
 else goto T111_8;

N111_4: 
  if IDF_MISS_LEFT$ in (0) then goto N111_5;
 else goto N111_8;

N111_5: 
  if POS_L_P_NO$ in (0) then goto T111_1;
 else goto N111_6;

T111_1: 
  response = -0.0005101287;
 goto D111;

N111_6: 
  if POS_R_P_NO$ in (0) then goto T111_2;
 else goto N111_7;

T111_2: 
  response = 0.0000235198;
 goto D111;

N111_7: 
  if IDF_FRAC < 0.5000000000 then goto T111_3;
 else goto T111_4;

T111_3: 
  response = 0.0217477214;
 goto D111;

T111_4: 
  response = 0.0024136548;
 goto D111;

N111_8: 
  if TP_FRAC < 0.2260425091 then goto T111_5;
 else goto N111_9;

T111_5: 
  response = -0.0006653952;
 goto D111;

N111_9: 
  if IDF_FRAC < 0.9021999836 then goto T111_6;
 else goto T111_7;

T111_6: 
  response = 0.0004479735;
 goto D111;

T111_7: 
  response = 0.0021029592;
 goto D111;

T111_8: 
  response = -0.0006647115;
 goto D111;

T111_9: 
  response = 0.0012364519;
 goto D111;

T111_10: 
  response = 0.0020619235;
 goto D111;

D111:

tnscore = tnscore + response;

  /* Tree 113 of 150 */
N112_1: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N112_2;
 else goto N112_8;

N112_2: 
  if POS_L_P_1$ in (0) then goto N112_3;
 else goto N112_7;

N112_3: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N112_4;
 else goto T112_5;

N112_4: 
  if TP_FRAC < -0.0000351185 then goto T112_1;
 else goto N112_5;

T112_1: 
  response = 0.0024052742;
 goto D112;

N112_5: 
  if POS_N_Q_1_P_1$ in (1) then goto N112_6;
 else goto T112_4;

N112_6: 
  if QBERT_SCORE$ in (0) then goto T112_2;
 else goto T112_3;

T112_2: 
  response = -0.0013740591;
 goto D112;

T112_3: 
  response = 0.0007098562;
 goto D112;

T112_4: 
  response = -0.0000193023;
 goto D112;

T112_5: 
  response = 0.0011714334;
 goto D112;

N112_7: 
  if IDF_FRAC < 0.8651515245 then goto T112_6;
 else goto T112_7;

T112_6: 
  response = 0.0004299978;
 goto D112;

T112_7: 
  response = 0.0056638663;
 goto D112;

N112_8: 
  if POS_N_Q_3_P_3$ in (1) then goto T112_8;
 else goto N112_9;

T112_8: 
  response = -0.0012697620;
 goto D112;

N112_9: 
  if POS_N_Q_4_P_3$ in (1) then goto T112_9;
 else goto T112_10;

T112_9: 
  response = -0.0004035187;
 goto D112;

T112_10: 
  response = 0.0012319098;
 goto D112;

D112:

tnscore = tnscore + response;

  /* Tree 114 of 150 */
N113_1: 
  if POS_L_P_4$ in (1) then goto T113_1;
 else goto N113_2;

T113_1: 
  response = -0.0018620809;
 goto D113;

N113_2: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N113_3;
 else goto T113_10;

N113_3: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto N113_4;
 else goto N113_5;

N113_4: 
  if IDF_FRAC < 0.7399355173 then goto T113_2;
 else goto T113_3;

T113_2: 
  response = -0.0004330288;
 goto D113;

T113_3: 
  response = -0.0052996391;
 goto D113;

N113_5: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T113_4;
 else goto N113_6;

T113_4: 
  response = -0.0016653652;
 goto D113;

N113_6: 
  if TP_FRAC < -0.0000346579 then goto T113_5;
 else goto N113_7;

T113_5: 
  response = 0.0028011516;
 goto D113;

N113_7: 
  if TP_FRAC < 0.0782455951 then goto T113_6;
 else goto N113_8;

T113_6: 
  response = -0.0010042363;
 goto D113;

N113_8: 
  if POS_L_P_3_S_0$ in (1) then goto T113_7;
 else goto N113_9;

T113_7: 
  response = -0.0005824823;
 goto D113;

N113_9: 
  if POS_L_P_1_S_1$ in (0) then goto T113_8;
 else goto T113_9;

T113_8: 
  response = 0.0002324341;
 goto D113;

T113_9: 
  response = 0.0041382452;
 goto D113;

T113_10: 
  response = 0.0014208231;
 goto D113;

D113:

tnscore = tnscore + response;

  /* Tree 115 of 150 */
N114_1: 
  if LEN_Q_4_LEN_P_4$ in (0) then goto N114_2;
 else goto T114_10;

N114_2: 
  if POS_R_P_4_E_0$ in (1) then goto T114_1;
 else goto N114_3;

T114_1: 
  response = -0.0029356154;
 goto D114;

N114_3: 
  if QBERT_SCORE$ in (0) then goto N114_4;
 else goto N114_8;

N114_4: 
  if IDF_FRAC < 0.6575189829 then goto N114_5;
 else goto N114_6;

N114_5: 
  if TP_FRAC < 0.9474430084 then goto T114_2;
 else goto T114_3;

T114_2: 
  response = -0.0000858649;
 goto D114;

T114_3: 
  response = 0.0005871085;
 goto D114;

N114_6: 
  if POS_R_P_5_E_0$ in (1) then goto T114_4;
 else goto N114_7;

T114_4: 
  response = -0.0027446986;
 goto D114;

N114_7: 
  if POS_L_P_5_S_0$ in (1) then goto T114_5;
 else goto T114_6;

T114_5: 
  response = -0.0019920036;
 goto D114;

T114_6: 
  response = -0.0002321713;
 goto D114;

N114_8: 
  if POS_R_P_0_E_0$ in (1) then goto N114_9;
 else goto T114_9;

N114_9: 
  if IDF_MISS_RIGHT$ in (0) then goto T114_7;
 else goto T114_8;

T114_7: 
  response = -0.0014295422;
 goto D114;

T114_8: 
  response = 0.0001803536;
 goto D114;

T114_9: 
  response = 0.0007199229;
 goto D114;

T114_10: 
  response = 0.0036448773;
 goto D114;

D114:

tnscore = tnscore + response;

  /* Tree 116 of 150 */
N115_1: 
  if POS_L_P_0_S_0$ in (1) then goto T115_1;
 else goto N115_2;

T115_1: 
  response = -0.0004451756;
 goto D115;

N115_2: 
  if POS_N_Q_2_P_1$ in (0) then goto N115_3;
 else goto N115_8;

N115_3: 
  if POS_L_P_4$ in (1) then goto T115_2;
 else goto N115_4;

T115_2: 
  response = -0.0018068829;
 goto D115;

N115_4: 
  if POS_N_Q_2_P_0$ in (1) then goto T115_3;
 else goto N115_5;

T115_3: 
  response = -0.0012526968;
 goto D115;

N115_5: 
  if POS_L_P_3_S_0$ in (1) then goto T115_4;
 else goto N115_6;

T115_4: 
  response = -0.0005938534;
 goto D115;

N115_6: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N115_7;
 else goto T115_7;

N115_7: 
  if POS_R_P_NO$ in (0) then goto T115_5;
 else goto T115_6;

T115_5: 
  response = -0.0000265394;
 goto D115;

T115_6: 
  response = 0.0006057350;
 goto D115;

T115_7: 
  response = 0.0016723469;
 goto D115;

N115_8: 
  if POS_R_P_0_E_0$ in (1) then goto T115_8;
 else goto N115_9;

T115_8: 
  response = -0.0002289471;
 goto D115;

N115_9: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto T115_9;
 else goto T115_10;

T115_9: 
  response = -0.0002553938;
 goto D115;

T115_10: 
  response = 0.0014674378;
 goto D115;

D115:

tnscore = tnscore + response;

  /* Tree 117 of 150 */
N116_1: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N116_2;
 else goto T116_10;

N116_2: 
  if POS_L_P_1_S_1$ in (0) then goto N116_3;
 else goto T116_9;

N116_3: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N116_4;
 else goto T116_8;

N116_4: 
  if IDF_MISS_LEFT_WEIGHT < 0.8995100260 then goto N116_5;
 else goto T116_7;

N116_5: 
  if QBERT_SCORE$ in (0) then goto N116_6;
 else goto N116_7;

N116_6: 
  if IDF_FRAC < 0.7261365056 then goto T116_1;
 else goto T116_2;

T116_1: 
  response = -0.0000107414;
 goto D116;

T116_2: 
  response = -0.0005208372;
 goto D116;

N116_7: 
  if TP_INCLUDE$ in (1) then goto N116_8;
 else goto N116_9;

N116_8: 
  if IDF_FRAC < 0.7734605074 then goto T116_3;
 else goto T116_4;

T116_3: 
  response = -0.0007367356;
 goto D116;

T116_4: 
  response = 0.0006054470;
 goto D116;

N116_9: 
  if IDF_MISS_RIGHT_WEIGHT < 0.1751919985 then goto T116_5;
 else goto T116_6;

T116_5: 
  response = 0.0018657244;
 goto D116;

T116_6: 
  response = 0.0000314998;
 goto D116;

T116_7: 
  response = 0.0039504236;
 goto D116;

T116_8: 
  response = 0.0046746544;
 goto D116;

T116_9: 
  response = 0.0037240997;
 goto D116;

T116_10: 
  response = 0.0011858969;
 goto D116;

D116:

tnscore = tnscore + response;

  /* Tree 118 of 150 */
N117_1: 
  if POS_R_P_0_E_0$ in (1) then goto N117_2;
 else goto N117_4;

N117_2: 
  if IDF_MISS_RIGHT$ in (0) then goto T117_1;
 else goto N117_3;

T117_1: 
  response = -0.0008697689;
 goto D117;

N117_3: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto T117_2;
 else goto T117_3;

T117_2: 
  response = -0.0003358209;
 goto D117;

T117_3: 
  response = 0.0009250617;
 goto D117;

N117_4: 
  if QBERT_SCORE$ in (0) then goto N117_5;
 else goto N117_7;

N117_5: 
  if IDF_FRAC < 0.6950479746 then goto N117_6;
 else goto T117_6;

N117_6: 
  if TP_FRAC < 0.2916499972 then goto T117_4;
 else goto T117_5;

T117_4: 
  response = -0.0003732790;
 goto D117;

T117_5: 
  response = 0.0004879075;
 goto D117;

T117_6: 
  response = -0.0004006034;
 goto D117;

N117_7: 
  if IDF_FRAC < 0.6789079905 then goto N117_8;
 else goto T117_10;

N117_8: 
  if IDF_FRAC < 0.0789474994 then goto T117_7;
 else goto N117_9;

T117_7: 
  response = 0.0012876685;
 goto D117;

N117_9: 
  if POS_N_Q_2_P_1$ in (0) then goto T117_8;
 else goto T117_9;

T117_8: 
  response = -0.0017966012;
 goto D117;

T117_9: 
  response = 0.0008278727;
 goto D117;

T117_10: 
  response = 0.0010405485;
 goto D117;

D117:

tnscore = tnscore + response;

  /* Tree 119 of 150 */
N118_1: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N118_2;
 else goto N118_7;

N118_2: 
  if POS_N_Q_1_P_1$ in (1) then goto N118_3;
 else goto N118_5;

N118_3: 
  if IDF_MISS_RIGHT_WEIGHT < 0.4330354929 then goto N118_4;
 else goto T118_3;

N118_4: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto T118_1;
 else goto T118_2;

T118_1: 
  response = -0.0006231871;
 goto D118;

T118_2: 
  response = 0.0017548504;
 goto D118;

T118_3: 
  response = -0.0034150898;
 goto D118;

N118_5: 
  if POS_L_P_3_S_0$ in (1) then goto T118_4;
 else goto N118_6;

T118_4: 
  response = -0.0009547534;
 goto D118;

N118_6: 
  if LEN_Q_4_LEN_P_4$ in (0) then goto T118_5;
 else goto T118_6;

T118_5: 
  response = 0.0000484351;
 goto D118;

T118_6: 
  response = 0.0034846890;
 goto D118;

N118_7: 
  if TP_PARTIAL$ in (0) then goto N118_8;
 else goto N118_9;

N118_8: 
  if POS_N_Q_1_P_1$ in (0) then goto T118_7;
 else goto T118_8;

T118_7: 
  response = -0.0000014858;
 goto D118;

T118_8: 
  response = 0.0026157149;
 goto D118;

N118_9: 
  if TP_FRAC < 0.5848945379 then goto T118_9;
 else goto T118_10;

T118_9: 
  response = 0.0002909617;
 goto D118;

T118_10: 
  response = 0.0028245635;
 goto D118;

D118:

tnscore = tnscore + response;

  /* Tree 120 of 150 */
N119_1: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N119_2;
 else goto T119_10;

N119_2: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N119_3;
 else goto N119_9;

N119_3: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N119_4;
 else goto T119_7;

N119_4: 
  if LEN_Q_4_LEN_P_4$ in (0) then goto N119_5;
 else goto T119_6;

N119_5: 
  if POS_N_Q_1_P_1$ in (1) then goto N119_6;
 else goto T119_5;

N119_6: 
  if IDF_FRAC < 0.9782609940 then goto T119_1;
 else goto N119_7;

T119_1: 
  response = 0.0007581599;
 goto D119;

N119_7: 
  if QBERT_SCORE$ in (0) then goto T119_2;
 else goto N119_8;

T119_2: 
  response = -0.0017830345;
 goto D119;

N119_8: 
  if IDF_MISS_RIGHT_WEIGHT < 0.3660284877 then goto T119_3;
 else goto T119_4;

T119_3: 
  response = 0.0010031026;
 goto D119;

T119_4: 
  response = -0.0046452937;
 goto D119;

T119_5: 
  response = -0.0000405507;
 goto D119;

T119_6: 
  response = 0.0028910907;
 goto D119;

T119_7: 
  response = 0.0042388619;
 goto D119;

N119_9: 
  if IDF_FRAC < 0.3693954945 then goto T119_8;
 else goto T119_9;

T119_8: 
  response = 0.0033636050;
 goto D119;

T119_9: 
  response = 0.0003069893;
 goto D119;

T119_10: 
  response = 0.0012215063;
 goto D119;

D119:

tnscore = tnscore + response;

  /* Tree 121 of 150 */
N120_1: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto N120_2;
 else goto N120_3;

N120_2: 
  if IDF_FRAC < 0.6609194875 then goto T120_1;
 else goto T120_2;

T120_1: 
  response = -0.0002118485;
 goto D120;

T120_2: 
  response = -0.0020223323;
 goto D120;

N120_3: 
  if POS_R_P_1_E_0$ in (1) then goto T120_3;
 else goto N120_4;

T120_3: 
  response = -0.0023848965;
 goto D120;

N120_4: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T120_4;
 else goto N120_5;

T120_4: 
  response = -0.0006511747;
 goto D120;

N120_5: 
  if POS_L_P_4$ in (1) then goto T120_5;
 else goto N120_6;

T120_5: 
  response = -0.0017206349;
 goto D120;

N120_6: 
  if POS_L_P_3_S_0$ in (1) then goto T120_6;
 else goto N120_7;

T120_6: 
  response = -0.0005949034;
 goto D120;

N120_7: 
  if POS_N_Q_0_P_0$ in (0) then goto N120_8;
 else goto N120_9;

N120_8: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T120_7;
 else goto T120_8;

T120_7: 
  response = -0.0016209263;
 goto D120;

T120_8: 
  response = 0.0002632946;
 goto D120;

N120_9: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T120_9;
 else goto T120_10;

T120_9: 
  response = -0.0015329172;
 goto D120;

T120_10: 
  response = 0.0029921798;
 goto D120;

D120:

tnscore = tnscore + response;

  /* Tree 122 of 150 */
N121_1: 
  if POS_R_P_5_E_5$ in (0) then goto N121_2;
 else goto T121_10;

N121_2: 
  if POS_L_P_0_S_5$ in (0) then goto N121_3;
 else goto N121_9;

N121_3: 
  if POS_L_P_NO$ in (0) then goto N121_4;
 else goto N121_8;

N121_4: 
  if IDF_MISS_LEFT$ in (0) then goto N121_5;
 else goto N121_6;

N121_5: 
  if TP_FRAC < 0.9357755184 then goto T121_1;
 else goto T121_2;

T121_1: 
  response = -0.0000258042;
 goto D121;

T121_2: 
  response = -0.0010104429;
 goto D121;

N121_6: 
  if IDF_MISS_LEFT_WEIGHT < 0.3060199916 then goto N121_7;
 else goto T121_5;

N121_7: 
  if POS_R_P_NO$ in (0) then goto T121_3;
 else goto T121_4;

T121_3: 
  response = -0.0004409103;
 goto D121;

T121_4: 
  response = 0.0012294050;
 goto D121;

T121_5: 
  response = -0.0002678029;
 goto D121;

N121_8: 
  if POS_R_P_NO$ in (0) then goto T121_6;
 else goto T121_7;

T121_6: 
  response = 0.0000147442;
 goto D121;

T121_7: 
  response = 0.0030140106;
 goto D121;

N121_9: 
  if IDF_FRAC < 0.2462120056 then goto T121_8;
 else goto T121_9;

T121_8: 
  response = -0.0008709233;
 goto D121;

T121_9: 
  response = 0.0022318458;
 goto D121;

T121_10: 
  response = 0.0009546858;
 goto D121;

D121:

tnscore = tnscore + response;

  /* Tree 123 of 150 */
N122_1: 
  if IDF_MISS_LEFT_WEIGHT < 0.7029410005 then goto N122_2;
 else goto T122_10;

N122_2: 
  if POS_R_P_4_E_5$ in (1) then goto T122_1;
 else goto N122_3;

T122_1: 
  response = -0.0034108782;
 goto D122;

N122_3: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N122_4;
 else goto T122_9;

N122_4: 
  if IDF_MISS_RIGHT$ in (0) then goto N122_5;
 else goto N122_8;

N122_5: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto N122_6;
 else goto T122_5;

N122_6: 
  if TP_PARTIAL$ in (0) then goto T122_2;
 else goto N122_7;

T122_2: 
  response = -0.0003154324;
 goto D122;

N122_7: 
  if TP_FRAC < 0.9059530497 then goto T122_3;
 else goto T122_4;

T122_3: 
  response = 0.0000124760;
 goto D122;

T122_4: 
  response = 0.0031004470;
 goto D122;

T122_5: 
  response = 0.0015116664;
 goto D122;

N122_8: 
  if IDF_MISS_RIGHT_WEIGHT < 0.5099999905 then goto N122_9;
 else goto T122_8;

N122_9: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto T122_6;
 else goto T122_7;

T122_6: 
  response = 0.0002038794;
 goto D122;

T122_7: 
  response = 0.0013296550;
 goto D122;

T122_8: 
  response = -0.0004724604;
 goto D122;

T122_9: 
  response = 0.0014079095;
 goto D122;

T122_10: 
  response = 0.0017411656;
 goto D122;

D122:

tnscore = tnscore + response;

  /* Tree 124 of 150 */
N123_1: 
  if IDF_MISS_RIGHT$ in (0) then goto N123_2;
 else goto N123_5;

N123_2: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N123_3;
 else goto T123_4;

N123_3: 
  if IDF_MISS_LEFT_WEIGHT < 0.9347825050 then goto N123_4;
 else goto T123_3;

N123_4: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto T123_1;
 else goto T123_2;

T123_1: 
  response = -0.0002343786;
 goto D123;

T123_2: 
  response = 0.0011372616;
 goto D123;

T123_3: 
  response = 0.0037528179;
 goto D123;

T123_4: 
  response = 0.0013285822;
 goto D123;

N123_5: 
  if IDF_MISS_RIGHT_WEIGHT < 0.0690476447 then goto T123_5;
 else goto N123_6;

T123_5: 
  response = 0.0026848007;
 goto D123;

N123_6: 
  if IDF_MISS_RIGHT_WEIGHT < 0.4599354863 then goto N123_7;
 else goto T123_10;

N123_7: 
  if TP_FRAC < 0.9354469776 then goto N123_8;
 else goto N123_9;

N123_8: 
  if TP_FRAC < 0.6129574776 then goto T123_6;
 else goto T123_7;

T123_6: 
  response = 0.0004831699;
 goto D123;

T123_7: 
  response = -0.0008616821;
 goto D123;

N123_9: 
  if POS_R_P_0_E_5$ in (0) then goto T123_8;
 else goto T123_9;

T123_8: 
  response = 0.0004930405;
 goto D123;

T123_9: 
  response = 0.0025437628;
 goto D123;

T123_10: 
  response = -0.0002167458;
 goto D123;

D123:

tnscore = tnscore + response;

  /* Tree 125 of 150 */
N124_1: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N124_2;
 else goto N124_9;

N124_2: 
  if LEN_Q_6_LEN_P_4$ in (0) then goto N124_3;
 else goto T124_8;

N124_3: 
  if POS_R_P_0_E_5$ in (0) then goto N124_4;
 else goto T124_7;

N124_4: 
  if IDF_FRAC < 0.6079194546 then goto N124_5;
 else goto N124_6;

N124_5: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto T124_1;
 else goto T124_2;

T124_1: 
  response = -0.0001121213;
 goto D124;

T124_2: 
  response = 0.0007820161;
 goto D124;

N124_6: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto T124_3;
 else goto N124_7;

T124_3: 
  response = -0.0049721682;
 goto D124;

N124_7: 
  if POS_L_P_1$ in (0) then goto N124_8;
 else goto T124_6;

N124_8: 
  if POS_L_P_0_S_5$ in (0) then goto T124_4;
 else goto T124_5;

T124_4: 
  response = -0.0004631936;
 goto D124;

T124_5: 
  response = 0.0022890585;
 goto D124;

T124_6: 
  response = 0.0023764661;
 goto D124;

T124_7: 
  response = 0.0005394957;
 goto D124;

T124_8: 
  response = 0.0036864394;
 goto D124;

N124_9: 
  if IDF_FRAC < 0.3550420105 then goto T124_9;
 else goto T124_10;

T124_9: 
  response = 0.0031555951;
 goto D124;

T124_10: 
  response = 0.0003497905;
 goto D124;

D124:

tnscore = tnscore + response;

  /* Tree 126 of 150 */
N125_1: 
  if POS_R_P_3_E_5$ in (0) then goto N125_2;
 else goto T125_10;

N125_2: 
  if TP_PARTIAL$ in (0) then goto N125_3;
 else goto N125_8;

N125_3: 
  if IDF_MISS_RIGHT$ in (0) then goto N125_4;
 else goto N125_6;

N125_4: 
  if LEN_Q_3_LEN_P_2$ in (1) then goto N125_5;
 else goto T125_3;

N125_5: 
  if TP_FRAC < 0.2706155181 then goto T125_1;
 else goto T125_2;

T125_1: 
  response = 0.0015541515;
 goto D125;

T125_2: 
  response = -0.0009254466;
 goto D125;

T125_3: 
  response = -0.0001135599;
 goto D125;

N125_6: 
  if IDF_MISS_RIGHT_WEIGHT < 0.5313724875 then goto N125_7;
 else goto T125_6;

N125_7: 
  if IDF_MISS_RIGHT_WEIGHT < 0.0645833462 then goto T125_4;
 else goto T125_5;

T125_4: 
  response = 0.0036112908;
 goto D125;

T125_5: 
  response = 0.0004461526;
 goto D125;

T125_6: 
  response = -0.0009039405;
 goto D125;

N125_8: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto N125_9;
 else goto T125_9;

N125_9: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto T125_7;
 else goto T125_8;

T125_7: 
  response = -0.0001745309;
 goto D125;

T125_8: 
  response = 0.0008731069;
 goto D125;

T125_9: 
  response = 0.0009451955;
 goto D125;

T125_10: 
  response = 0.0018380471;
 goto D125;

D125:

tnscore = tnscore + response;

  /* Tree 127 of 150 */
N126_1: 
  if LEN_Q_4_LEN_P_3$ in (0) then goto N126_2;
 else goto N126_9;

N126_2: 
  if POS_R_P_3_E_5$ in (0) then goto N126_3;
 else goto T126_8;

N126_3: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N126_4;
 else goto T126_7;

N126_4: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N126_5;
 else goto T126_6;

N126_5: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto N126_6;
 else goto N126_7;

N126_6: 
  if TP_FRAC < 0.9978829622 then goto T126_1;
 else goto T126_2;

T126_1: 
  response = -0.0004422613;
 goto D126;

T126_2: 
  response = 0.0000747031;
 goto D126;

N126_7: 
  if TP_FRAC < 0.9240189791 then goto N126_8;
 else goto T126_5;

N126_8: 
  if QBERT_SCORE$ in (0) then goto T126_3;
 else goto T126_4;

T126_3: 
  response = 0.0004292353;
 goto D126;

T126_4: 
  response = 0.0021162442;
 goto D126;

T126_5: 
  response = -0.0003463464;
 goto D126;

T126_6: 
  response = 0.0008391502;
 goto D126;

T126_7: 
  response = 0.0008975431;
 goto D126;

T126_8: 
  response = 0.0020807356;
 goto D126;

N126_9: 
  if IDF_FRAC < 0.0833334997 then goto T126_9;
 else goto T126_10;

T126_9: 
  response = 0.0034553906;
 goto D126;

T126_10: 
  response = 0.0004029386;
 goto D126;

D126:

tnscore = tnscore + response;

  /* Tree 128 of 150 */
N127_1: 
  if POS_R_P_5_E_5$ in (0) then goto N127_2;
 else goto T127_10;

N127_2: 
  if POS_N_Q_2_P_1$ in (0) then goto N127_3;
 else goto N127_8;

N127_3: 
  if POS_R_P_2_E_0$ in (1) then goto T127_1;
 else goto N127_4;

T127_1: 
  response = -0.0024326924;
 goto D127;

N127_4: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T127_2;
 else goto N127_5;

T127_2: 
  response = -0.0010774075;
 goto D127;

N127_5: 
  if IDF_MISS_LEFT_WEIGHT < 0.4422219992 then goto N127_6;
 else goto T127_6;

N127_6: 
  if IDF_MISS_LEFT$ in (0) then goto N127_7;
 else goto T127_5;

N127_7: 
  if POS_L_P_NO$ in (0) then goto T127_3;
 else goto T127_4;

T127_3: 
  response = -0.0006075107;
 goto D127;

T127_4: 
  response = 0.0000659593;
 goto D127;

T127_5: 
  response = 0.0005703004;
 goto D127;

T127_6: 
  response = -0.0005596959;
 goto D127;

N127_8: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto N127_9;
 else goto T127_9;

N127_9: 
  if POS_R_P_0_E_0$ in (1) then goto T127_7;
 else goto T127_8;

T127_7: 
  response = -0.0007772138;
 goto D127;

T127_8: 
  response = 0.0003108019;
 goto D127;

T127_9: 
  response = 0.0009128447;
 goto D127;

T127_10: 
  response = 0.0008452326;
 goto D127;

D127:

tnscore = tnscore + response;

  /* Tree 129 of 150 */
N128_1: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N128_2;
 else goto T128_10;

N128_2: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N128_3;
 else goto T128_9;

N128_3: 
  if POS_L_P_1_S_1$ in (0) then goto N128_4;
 else goto T128_8;

N128_4: 
  if LEN_Q_6_LEN_P_4$ in (0) then goto N128_5;
 else goto T128_7;

N128_5: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N128_6;
 else goto T128_6;

N128_6: 
  if LEN_Q_6_LEN_P_3$ in (0) then goto N128_7;
 else goto T128_5;

N128_7: 
  if POS_L_P_3_S_0$ in (1) then goto T128_1;
 else goto N128_8;

T128_1: 
  response = -0.0007299399;
 goto D128;

N128_8: 
  if POS_R_P_0_E_0$ in (1) then goto T128_2;
 else goto N128_9;

T128_2: 
  response = -0.0003967958;
 goto D128;

N128_9: 
  if POS_N_Q_2_P_1$ in (0) then goto T128_3;
 else goto T128_4;

T128_3: 
  response = -0.0001555073;
 goto D128;

T128_4: 
  response = 0.0004766423;
 goto D128;

T128_5: 
  response = 0.0030006938;
 goto D128;

T128_6: 
  response = 0.0008437593;
 goto D128;

T128_7: 
  response = 0.0032019923;
 goto D128;

T128_8: 
  response = 0.0032187282;
 goto D128;

T128_9: 
  response = 0.0009261824;
 goto D128;

T128_10: 
  response = 0.0053274115;
 goto D128;

D128:

tnscore = tnscore + response;

  /* Tree 130 of 150 */
N129_1: 
  if LEN_Q_6_LEN_P_4$ in (0) then goto N129_2;
 else goto T129_10;

N129_2: 
  if POS_L_P_0_S_5$ in (0) then goto N129_3;
 else goto N129_9;

N129_3: 
  if POS_R_P_3_E_0$ in (1) then goto T129_1;
 else goto N129_4;

T129_1: 
  response = -0.0016137326;
 goto D129;

N129_4: 
  if IDF_MISS_RIGHT$ in (0) then goto N129_5;
 else goto N129_6;

N129_5: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto T129_2;
 else goto T129_3;

T129_2: 
  response = -0.0001911217;
 goto D129;

T129_3: 
  response = 0.0011732374;
 goto D129;

N129_6: 
  if POS_R_P_1_E_0$ in (1) then goto T129_4;
 else goto N129_7;

T129_4: 
  response = -0.0040363492;
 goto D129;

N129_7: 
  if IDF_MISS_RIGHT_WEIGHT < 0.3827835023 then goto N129_8;
 else goto T129_7;

N129_8: 
  if POS_R_P_0_E_0$ in (1) then goto T129_5;
 else goto T129_6;

T129_5: 
  response = 0.0000270406;
 goto D129;

T129_6: 
  response = 0.0014377460;
 goto D129;

T129_7: 
  response = -0.0000755858;
 goto D129;

N129_9: 
  if IDF_FRAC < 0.2456894964 then goto T129_8;
 else goto T129_9;

T129_8: 
  response = -0.0009984565;
 goto D129;

T129_9: 
  response = 0.0022042814;
 goto D129;

T129_10: 
  response = 0.0037586099;
 goto D129;

D129:

tnscore = tnscore + response;

  /* Tree 131 of 150 */
N130_1: 
  if POS_N_Q_2_P_1$ in (0) then goto N130_2;
 else goto N130_7;

N130_2: 
  if LEN_Q_4_LEN_P_4$ in (0) then goto N130_3;
 else goto T130_6;

N130_3: 
  if POS_R_P_5_E_5$ in (0) then goto N130_4;
 else goto T130_5;

N130_4: 
  if TP_PARTIAL$ in (0) then goto N130_5;
 else goto T130_4;

N130_5: 
  if POS_R_P_5_E_0$ in (0) then goto T130_1;
 else goto N130_6;

T130_1: 
  response = -0.0003355045;
 goto D130;

N130_6: 
  if QBERT_SCORE$ in (0) then goto T130_2;
 else goto T130_3;

T130_2: 
  response = -0.0009391946;
 goto D130;

T130_3: 
  response = 0.0043147431;
 goto D130;

T130_4: 
  response = 0.0001435822;
 goto D130;

T130_5: 
  response = 0.0008797011;
 goto D130;

T130_6: 
  response = 0.0029009666;
 goto D130;

N130_7: 
  if IDF_FRAC < 0.0916666538 then goto T130_7;
 else goto N130_8;

T130_7: 
  response = 0.0047364622;
 goto D130;

N130_8: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto N130_9;
 else goto T130_10;

N130_9: 
  if TP_FRAC < 0.9255989790 then goto T130_8;
 else goto T130_9;

T130_8: 
  response = -0.0004082005;
 goto D130;

T130_9: 
  response = 0.0005423577;
 goto D130;

T130_10: 
  response = 0.0008562860;
 goto D130;

D130:

tnscore = tnscore + response;

  /* Tree 132 of 150 */
N131_1: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N131_2;
 else goto T131_10;

N131_2: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T131_1;
 else goto N131_3;

T131_1: 
  response = -0.0015932913;
 goto D131;

N131_3: 
  if TP_FRAC < -0.0000340669 then goto T131_2;
 else goto N131_4;

T131_2: 
  response = 0.0018967104;
 goto D131;

N131_4: 
  if POS_R_P_1_E_0$ in (1) then goto T131_3;
 else goto N131_5;

T131_3: 
  response = -0.0020148594;
 goto D131;

N131_5: 
  if TP_FRAC < 0.0832026452 then goto T131_4;
 else goto N131_6;

T131_4: 
  response = -0.0007340648;
 goto D131;

N131_6: 
  if POS_L_P_3_S_0$ in (1) then goto T131_5;
 else goto N131_7;

T131_5: 
  response = -0.0005368448;
 goto D131;

N131_7: 
  if POS_L_P_0_S_0$ in (1) then goto T131_6;
 else goto N131_8;

T131_6: 
  response = -0.0003121969;
 goto D131;

N131_8: 
  if IDF_MISS_LEFT$ in (0) then goto T131_7;
 else goto N131_9;

T131_7: 
  response = 0.0000622990;
 goto D131;

N131_9: 
  if IDF_MISS_LEFT_WEIGHT < 0.3405795097 then goto T131_8;
 else goto T131_9;

T131_8: 
  response = 0.0019255517;
 goto D131;

T131_9: 
  response = 0.0001647612;
 goto D131;

T131_10: 
  response = 0.0043422489;
 goto D131;

D131:

tnscore = tnscore + response;

  /* Tree 133 of 150 */
N132_1: 
  if IDF_MISS_RIGHT$ in (0) then goto N132_2;
 else goto N132_6;

N132_2: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto N132_3;
 else goto N132_5;

N132_3: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N132_4;
 else goto T132_3;

N132_4: 
  if TP_PARTIAL$ in (0) then goto T132_1;
 else goto T132_2;

T132_1: 
  response = -0.0003166173;
 goto D132;

T132_2: 
  response = 0.0002188039;
 goto D132;

T132_3: 
  response = 0.0014762721;
 goto D132;

N132_5: 
  if IDF_FRAC < 0.4472219944 then goto T132_4;
 else goto T132_5;

T132_4: 
  response = 0.0103071628;
 goto D132;

T132_5: 
  response = 0.0008891549;
 goto D132;

N132_6: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto N132_7;
 else goto N132_9;

N132_7: 
  if TP_FRAC < 0.9978635311 then goto N132_8;
 else goto T132_8;

N132_8: 
  if IDF_MISS_LEFT_WEIGHT < 0.2052630037 then goto T132_6;
 else goto T132_7;

T132_6: 
  response = -0.0004997152;
 goto D132;

T132_7: 
  response = 0.0006646491;
 goto D132;

T132_8: 
  response = 0.0006747095;
 goto D132;

N132_9: 
  if POS_N_Q_2_P_2$ in (1) then goto T132_9;
 else goto T132_10;

T132_9: 
  response = -0.0028910833;
 goto D132;

T132_10: 
  response = 0.0012455012;
 goto D132;

D132:

tnscore = tnscore + response;

  /* Tree 134 of 150 */
N133_1: 
  if POS_R_P_2_E_0$ in (1) then goto T133_1;
 else goto N133_2;

T133_1: 
  response = -0.0019689152;
 goto D133;

N133_2: 
  if POS_L_P_4$ in (1) then goto T133_2;
 else goto N133_3;

T133_2: 
  response = -0.0014202865;
 goto D133;

N133_3: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N133_4;
 else goto T133_10;

N133_4: 
  if POS_R_P_0_E_0$ in (1) then goto N133_5;
 else goto N133_7;

N133_5: 
  if IDF_MISS_RIGHT$ in (0) then goto T133_3;
 else goto N133_6;

T133_3: 
  response = -0.0007298835;
 goto D133;

N133_6: 
  if IDF_MISS_RIGHT_WEIGHT < 0.0645833462 then goto T133_4;
 else goto T133_5;

T133_4: 
  response = 0.0028696689;
 goto D133;

T133_5: 
  response = 0.0000277956;
 goto D133;

N133_7: 
  if QBERT_SCORE$ in (0) then goto N133_8;
 else goto T133_9;

N133_8: 
  if TP_FRAC < 0.3945115209 then goto T133_6;
 else goto N133_9;

T133_6: 
  response = -0.0003422397;
 goto D133;

N133_9: 
  if IDF_FRAC < 0.6588139534 then goto T133_7;
 else goto T133_8;

T133_7: 
  response = 0.0006020674;
 goto D133;

T133_8: 
  response = -0.0000868039;
 goto D133;

T133_9: 
  response = 0.0007318797;
 goto D133;

T133_10: 
  response = 0.0011700726;
 goto D133;

D133:

tnscore = tnscore + response;

  /* Tree 135 of 150 */
N134_1: 
  if POS_R_P_4_E_5$ in (1) then goto T134_1;
 else goto N134_2;

T134_1: 
  response = -0.0031600023;
 goto D134;

N134_2: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N134_3;
 else goto T134_10;

N134_3: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N134_4;
 else goto T134_9;

N134_4: 
  if LEN_Q_6_LEN_P_4$ in (0) then goto N134_5;
 else goto T134_8;

N134_5: 
  if TP_FRAC < -0.0000340721 then goto T134_2;
 else goto N134_6;

T134_2: 
  response = 0.0015851388;
 goto D134;

N134_6: 
  if TP_FRAC < 0.2167780101 then goto N134_7;
 else goto N134_8;

N134_7: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto T134_3;
 else goto T134_4;

T134_3: 
  response = -0.0007571009;
 goto D134;

T134_4: 
  response = 0.0008018850;
 goto D134;

N134_8: 
  if IDF_FRAC < 0.0312500000 then goto T134_5;
 else goto N134_9;

T134_5: 
  response = 0.0006529348;
 goto D134;

N134_9: 
  if POS_L_P_0_S_5$ in (0) then goto T134_6;
 else goto T134_7;

T134_6: 
  response = -0.0001042333;
 goto D134;

T134_7: 
  response = 0.0014495322;
 goto D134;

T134_8: 
  response = 0.0030789836;
 goto D134;

T134_9: 
  response = 0.0009155610;
 goto D134;

T134_10: 
  response = 0.0008977049;
 goto D134;

D134:

tnscore = tnscore + response;

  /* Tree 136 of 150 */
N135_1: 
  if POS_L_P_5_S_0$ in (1) then goto N135_2;
 else goto N135_3;

N135_2: 
  if IDF_FRAC < 0.8535715342 then goto T135_1;
 else goto T135_2;

T135_1: 
  response = -0.0001271326;
 goto D135;

T135_2: 
  response = -0.0023563607;
 goto D135;

N135_3: 
  if POS_L_P_4_S_0$ in (1) then goto T135_3;
 else goto N135_4;

T135_3: 
  response = -0.0019590718;
 goto D135;

N135_4: 
  if POS_L_P_0_S_0$ in (1) then goto T135_4;
 else goto N135_5;

T135_4: 
  response = -0.0002829818;
 goto D135;

N135_5: 
  if IDF_MISS_LEFT$ in (0) then goto N135_6;
 else goto N135_9;

N135_6: 
  if POS_L_P_3$ in (1) then goto T135_5;
 else goto N135_7;

T135_5: 
  response = -0.0008539426;
 goto D135;

N135_7: 
  if POS_R_P_4_E_0$ in (1) then goto T135_6;
 else goto N135_8;

T135_6: 
  response = -0.0029975364;
 goto D135;

N135_8: 
  if POS_R_P_4_E_5$ in (1) then goto T135_7;
 else goto T135_8;

T135_7: 
  response = -0.0038546509;
 goto D135;

T135_8: 
  response = 0.0001582328;
 goto D135;

N135_9: 
  if TP_FRAC < 0.8913664818 then goto T135_9;
 else goto T135_10;

T135_9: 
  response = 0.0002829532;
 goto D135;

T135_10: 
  response = 0.0014551926;
 goto D135;

D135:

tnscore = tnscore + response;

  /* Tree 137 of 150 */
N136_1: 
  if POS_R_P_1_E_0$ in (1) then goto T136_1;
 else goto N136_2;

T136_1: 
  response = -0.0020959443;
 goto D136;

N136_2: 
  if POS_L_P_0_S_3$ in (1) then goto T136_2;
 else goto N136_3;

T136_2: 
  response = -0.0020917008;
 goto D136;

N136_3: 
  if POS_R_P_5_E_5$ in (0) then goto N136_4;
 else goto N136_9;

N136_4: 
  if POS_N_Q_2_P_1$ in (0) then goto N136_5;
 else goto N136_7;

N136_5: 
  if POS_R_P_3_E_0$ in (1) then goto T136_3;
 else goto N136_6;

T136_3: 
  response = -0.0018628961;
 goto D136;

N136_6: 
  if POS_R_P_2_E_0$ in (1) then goto T136_4;
 else goto T136_5;

T136_4: 
  response = -0.0020034080;
 goto D136;

T136_5: 
  response = -0.0000351959;
 goto D136;

N136_7: 
  if IDF_FRAC < 0.6575189829 then goto N136_8;
 else goto T136_8;

N136_8: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto T136_6;
 else goto T136_7;

T136_6: 
  response = -0.0001464193;
 goto D136;

T136_7: 
  response = 0.0008156523;
 goto D136;

T136_8: 
  response = -0.0003617992;
 goto D136;

N136_9: 
  if POS_N_Q_2_P_2$ in (0) then goto T136_9;
 else goto T136_10;

T136_9: 
  response = 0.0004104572;
 goto D136;

T136_10: 
  response = 0.0042066601;
 goto D136;

D136:

tnscore = tnscore + response;

  /* Tree 138 of 150 */
N137_1: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N137_2;
 else goto T137_10;

N137_2: 
  if TP_FRAC < -0.0000340721 then goto T137_1;
 else goto N137_3;

T137_1: 
  response = 0.0018385160;
 goto D137;

N137_3: 
  if IDF_MISS_RIGHT$ in (0) then goto N137_4;
 else goto N137_8;

N137_4: 
  if TP_PARTIAL$ in (0) then goto T137_2;
 else goto N137_5;

T137_2: 
  response = -0.0002690082;
 goto D137;

N137_5: 
  if TP_FRAC < 0.9070230126 then goto N137_6;
 else goto T137_6;

N137_6: 
  if IDF_MISS_LEFT_WEIGHT < 0.3100959957 then goto N137_7;
 else goto T137_5;

N137_7: 
  if LEN_Q_3_LEN_P_2$ in (0) then goto T137_3;
 else goto T137_4;

T137_3: 
  response = 0.0000519262;
 goto D137;

T137_4: 
  response = 0.0023606511;
 goto D137;

T137_5: 
  response = -0.0005375085;
 goto D137;

T137_6: 
  response = 0.0031802400;
 goto D137;

N137_8: 
  if IDF_MISS_RIGHT_WEIGHT < 0.0645833462 then goto N137_9;
 else goto T137_9;

N137_9: 
  if TP_FRAC < 0.6141794920 then goto T137_7;
 else goto T137_8;

T137_7: 
  response = -0.0005169794;
 goto D137;

T137_8: 
  response = 0.0037303633;
 goto D137;

T137_9: 
  response = 0.0000578207;
 goto D137;

T137_10: 
  response = 0.0014977088;
 goto D137;

D137:

tnscore = tnscore + response;

  /* Tree 139 of 150 */
N138_1: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T138_1;
 else goto N138_2;

T138_1: 
  response = -0.0014435877;
 goto D138;

N138_2: 
  if POS_L_P_0_S_5$ in (0) then goto N138_3;
 else goto N138_9;

N138_3: 
  if POS_R_P_3_E_5$ in (0) then goto N138_4;
 else goto T138_8;

N138_4: 
  if POS_R_P_0_E_5$ in (0) then goto N138_5;
 else goto T138_7;

N138_5: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto N138_6;
 else goto N138_7;

N138_6: 
  if IDF_FRAC < 0.1791445017 then goto T138_2;
 else goto T138_3;

T138_2: 
  response = 0.0008217803;
 goto D138;

T138_3: 
  response = -0.0011856894;
 goto D138;

N138_7: 
  if POS_R_P_5_E_5$ in (0) then goto T138_4;
 else goto N138_8;

T138_4: 
  response = -0.0000274138;
 goto D138;

N138_8: 
  if QBERT_SCORE$ in (0) then goto T138_5;
 else goto T138_6;

T138_5: 
  response = 0.0001017016;
 goto D138;

T138_6: 
  response = 0.0027390718;
 goto D138;

T138_7: 
  response = 0.0005265924;
 goto D138;

T138_8: 
  response = 0.0017337381;
 goto D138;

N138_9: 
  if IDF_FRAC < 0.1907484978 then goto T138_9;
 else goto T138_10;

T138_9: 
  response = -0.0009974254;
 goto D138;

T138_10: 
  response = 0.0022531782;
 goto D138;

D138:

tnscore = tnscore + response;

  /* Tree 140 of 150 */
N139_1: 
  if POS_R_P_4_E_0$ in (1) then goto T139_1;
 else goto N139_2;

T139_1: 
  response = -0.0022873833;
 goto D139;

N139_2: 
  if POS_R_P_0_E_0$ in (1) then goto T139_2;
 else goto N139_3;

T139_2: 
  response = -0.0002048795;
 goto D139;

N139_3: 
  if POS_N_Q_2_P_1$ in (0) then goto N139_4;
 else goto T139_10;

N139_4: 
  if IDF_MISS_RIGHT_WEIGHT < 0.4564389884 then goto N139_5;
 else goto T139_9;

N139_5: 
  if POS_L_P_NO$ in (0) then goto N139_6;
 else goto N139_9;

N139_6: 
  if IDF_MISS_LEFT$ in (0) then goto T139_3;
 else goto N139_7;

T139_3: 
  response = -0.0004854246;
 goto D139;

N139_7: 
  if IDF_MISS_LEFT_WEIGHT < 0.4316769838 then goto N139_8;
 else goto T139_6;

N139_8: 
  if TP_FRAC < 0.5638619661 then goto T139_4;
 else goto T139_5;

T139_4: 
  response = -0.0001160598;
 goto D139;

T139_5: 
  response = 0.0014153585;
 goto D139;

T139_6: 
  response = -0.0004179157;
 goto D139;

N139_9: 
  if POS_R_P_NO$ in (0) then goto T139_7;
 else goto T139_8;

T139_7: 
  response = 0.0002599684;
 goto D139;

T139_8: 
  response = 0.0026586962;
 goto D139;

T139_9: 
  response = -0.0011171504;
 goto D139;

T139_10: 
  response = 0.0006051655;
 goto D139;

D139:

tnscore = tnscore + response;

  /* Tree 141 of 150 */
N140_1: 
  if IDF_MISS_RIGHT$ in (0) then goto N140_2;
 else goto N140_7;

N140_2: 
  if LEN_Q_5_LEN_P_4$ in (0) then goto N140_3;
 else goto T140_6;

N140_3: 
  if LEN_Q_2_LEN_P_2$ in (0) then goto N140_4;
 else goto N140_6;

N140_4: 
  if POS_L_P_0_S_5$ in (0) then goto T140_1;
 else goto N140_5;

T140_1: 
  response = -0.0002471422;
 goto D140;

N140_5: 
  if IDF_FRAC < 0.2462120056 then goto T140_2;
 else goto T140_3;

T140_2: 
  response = -0.0011380093;
 goto D140;

T140_3: 
  response = 0.0020447196;
 goto D140;

N140_6: 
  if POS_L_P_3$ in (1) then goto T140_4;
 else goto T140_5;

T140_4: 
  response = -0.0015813704;
 goto D140;

T140_5: 
  response = 0.0024233144;
 goto D140;

T140_6: 
  response = 0.0011789126;
 goto D140;

N140_7: 
  if IDF_MISS_RIGHT_WEIGHT < 0.0741758496 then goto T140_7;
 else goto N140_8;

T140_7: 
  response = 0.0018818097;
 goto D140;

N140_8: 
  if IDF_FRAC < 0.7438880205 then goto T140_8;
 else goto N140_9;

T140_8: 
  response = 0.0003566285;
 goto D140;

N140_9: 
  if QBERT_SCORE$ in (0) then goto T140_9;
 else goto T140_10;

T140_9: 
  response = -0.0008970600;
 goto D140;

T140_10: 
  response = 0.0004096696;
 goto D140;

D140:

tnscore = tnscore + response;

  /* Tree 142 of 150 */
N141_1: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N141_2;
 else goto T141_10;

N141_2: 
  if POS_R_P_6_E_0$ in (0) then goto N141_3;
 else goto T141_9;

N141_3: 
  if POS_L_P_1_S_1$ in (0) then goto N141_4;
 else goto T141_8;

N141_4: 
  if TP_FRAC < -0.0000340733 then goto T141_1;
 else goto N141_5;

T141_1: 
  response = 0.0016061265;
 goto D141;

N141_5: 
  if LEN_Q_2_LEN_P_1$ in (1) then goto N141_6;
 else goto N141_7;

N141_6: 
  if PARTIAL_BRAND$ in (0) then goto T141_2;
 else goto T141_3;

T141_2: 
  response = -0.0007697188;
 goto D141;

T141_3: 
  response = 0.0025157977;
 goto D141;

N141_7: 
  if POS_N_Q_0_P_0$ in (0) then goto N141_8;
 else goto T141_7;

N141_8: 
  if IDF_FRAC < 0.3220050037 then goto T141_4;
 else goto N141_9;

T141_4: 
  response = -0.0003258926;
 goto D141;

N141_9: 
  if POS_L_P_0_S_5$ in (0) then goto T141_5;
 else goto T141_6;

T141_5: 
  response = 0.0000568238;
 goto D141;

T141_6: 
  response = 0.0013932563;
 goto D141;

T141_7: 
  response = 0.0014750231;
 goto D141;

T141_8: 
  response = 0.0029744989;
 goto D141;

T141_9: 
  response = 0.0018096534;
 goto D141;

T141_10: 
  response = 0.0046411570;
 goto D141;

D141:

tnscore = tnscore + response;

  /* Tree 143 of 150 */
N142_1: 
  if LEN_Q_3_LEN_P_3$ in (0) then goto N142_2;
 else goto T142_10;

N142_2: 
  if POS_L_P_5_S_0$ in (1) then goto N142_3;
 else goto N142_4;

N142_3: 
  if IDF_FRAC < 0.8708335161 then goto T142_1;
 else goto T142_2;

T142_1: 
  response = 0.0000876098;
 goto D142;

T142_2: 
  response = -0.0023684165;
 goto D142;

N142_4: 
  if POS_L_P_5$ in (0) then goto N142_5;
 else goto N142_8;

N142_5: 
  if POS_R_P_1_E_0$ in (1) then goto T142_3;
 else goto N142_6;

T142_3: 
  response = -0.0018402795;
 goto D142;

N142_6: 
  if IDF_MISS_RIGHT$ in (0) then goto T142_4;
 else goto N142_7;

T142_4: 
  response = -0.0000919901;
 goto D142;

N142_7: 
  if IDF_MISS_RIGHT_WEIGHT < 0.1791445017 then goto T142_5;
 else goto T142_6;

T142_5: 
  response = 0.0010375390;
 goto D142;

T142_6: 
  response = 0.0000747668;
 goto D142;

N142_8: 
  if IDF_FRAC < 0.0483870991 then goto T142_7;
 else goto N142_9;

T142_7: 
  response = -0.0009851611;
 goto D142;

N142_9: 
  if TP_FRAC < 0.3308699727 then goto T142_8;
 else goto T142_9;

T142_8: 
  response = 0.0029007717;
 goto D142;

T142_9: 
  response = 0.0008663359;
 goto D142;

T142_10: 
  response = 0.0014736637;
 goto D142;

D142:

tnscore = tnscore + response;

  /* Tree 144 of 150 */
N143_1: 
  if LEN_Q_6_LEN_P_5$ in (0) then goto N143_2;
 else goto T143_10;

N143_2: 
  if IDF_MISS_RIGHT_WEIGHT < 0.5250630379 then goto N143_3;
 else goto N143_9;

N143_3: 
  if IDF_MISS_RIGHT$ in (0) then goto N143_4;
 else goto N143_6;

N143_4: 
  if IDF_FRAC < 0.6079194546 then goto T143_1;
 else goto N143_5;

T143_1: 
  response = 0.0001308096;
 goto D143;

N143_5: 
  if POS_R_P_NO$ in (0) then goto T143_2;
 else goto T143_3;

T143_2: 
  response = -0.0007421283;
 goto D143;

T143_3: 
  response = -0.0000041111;
 goto D143;

N143_6: 
  if TP_FRAC < 0.9902834892 then goto N143_7;
 else goto N143_8;

N143_7: 
  if TP_FRAC < 0.8427945375 then goto T143_4;
 else goto T143_5;

T143_4: 
  response = 0.0002460145;
 goto D143;

T143_5: 
  response = -0.0012799546;
 goto D143;

N143_8: 
  if POS_R_P_0_E_5$ in (0) then goto T143_6;
 else goto T143_7;

T143_6: 
  response = 0.0005385357;
 goto D143;

T143_7: 
  response = 0.0028737200;
 goto D143;

N143_9: 
  if IDF_FRAC < 0.9833334684 then goto T143_8;
 else goto T143_9;

T143_8: 
  response = -0.0002900329;
 goto D143;

T143_9: 
  response = -0.0027808188;
 goto D143;

T143_10: 
  response = 0.0043490170;
 goto D143;

D143:

tnscore = tnscore + response;

  /* Tree 145 of 150 */
N144_1: 
  if LEN_Q_3_LEN_P_1$ in (1) then goto N144_2;
 else goto N144_3;

N144_2: 
  if IDF_FRAC < 0.6830145121 then goto T144_1;
 else goto T144_2;

T144_1: 
  response = -0.0002232839;
 goto D144;

T144_2: 
  response = -0.0017120213;
 goto D144;

N144_3: 
  if POS_L_P_5_S_5$ in (0) then goto N144_4;
 else goto N144_9;

N144_4: 
  if POS_N_Q_0_P_0$ in (0) then goto N144_5;
 else goto T144_8;

N144_5: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N144_6;
 else goto T144_7;

N144_6: 
  if POS_N_Q_2_P_0$ in (1) then goto T144_3;
 else goto N144_7;

T144_3: 
  response = -0.0014139802;
 goto D144;

N144_7: 
  if IDF_FRAC < 0.0960061476 then goto N144_8;
 else goto T144_6;

N144_8: 
  if TP_PARTIAL$ in (0) then goto T144_4;
 else goto T144_5;

T144_4: 
  response = 0.0001725655;
 goto D144;

T144_5: 
  response = 0.0019734684;
 goto D144;

T144_6: 
  response = -0.0000267049;
 goto D144;

T144_7: 
  response = 0.0008791907;
 goto D144;

T144_8: 
  response = 0.0013900307;
 goto D144;

N144_9: 
  if QBERT_SCORE$ in (0) then goto T144_9;
 else goto T144_10;

T144_9: 
  response = 0.0004214750;
 goto D144;

T144_10: 
  response = 0.0038105660;
 goto D144;

D144:

tnscore = tnscore + response;

  /* Tree 146 of 150 */
N145_1: 
  if POS_L_P_0_S_0$ in (1) then goto N145_2;
 else goto N145_4;

N145_2: 
  if QBERT_SCORE$ in (1) then goto N145_3;
 else goto T145_3;

N145_3: 
  if IDF_FRAC < 0.6858555079 then goto T145_1;
 else goto T145_2;

T145_1: 
  response = -0.0038735602;
 goto D145;

T145_2: 
  response = 0.0002439054;
 goto D145;

T145_3: 
  response = -0.0001937650;
 goto D145;

N145_4: 
  if POS_R_P_2_E_0$ in (1) then goto T145_4;
 else goto N145_5;

T145_4: 
  response = -0.0016536397;
 goto D145;

N145_5: 
  if QBERT_SCORE$ in (0) then goto T145_5;
 else goto N145_6;

T145_5: 
  response = -0.0000202395;
 goto D145;

N145_6: 
  if IDF_FRAC < 0.8923745155 then goto N145_7;
 else goto N145_8;

N145_7: 
  if TP_FRAC < 0.5015305281 then goto T145_6;
 else goto T145_7;

T145_6: 
  response = 0.0016038661;
 goto D145;

T145_7: 
  response = -0.0002812761;
 goto D145;

N145_8: 
  if POS_R_P_5_E_0$ in (0) then goto N145_9;
 else goto T145_10;

N145_9: 
  if POS_R_P_5_E_5$ in (0) then goto T145_8;
 else goto T145_9;

T145_8: 
  response = 0.0004045699;
 goto D145;

T145_9: 
  response = 0.0035739771;
 goto D145;

T145_10: 
  response = 0.0040108388;
 goto D145;

D145:

tnscore = tnscore + response;

  /* Tree 147 of 150 */
N146_1: 
  if LEN_Q_6_LEN_P_4$ in (0) then goto N146_2;
 else goto T146_10;

N146_2: 
  if IDF_MISS_LEFT_WEIGHT < 0.9583334923 then goto N146_3;
 else goto T146_9;

N146_3: 
  if BRAND_NAME$ in (0) then goto N146_4;
 else goto N146_8;

N146_4: 
  if IDF_FRAC < 0.7911825180 then goto T146_1;
 else goto N146_5;

T146_1: 
  response = -0.0000186681;
 goto D146;

N146_5: 
  if IDF_MISS_LEFT_WEIGHT < 0.5400644541 then goto N146_6;
 else goto T146_5;

N146_6: 
  if IDF_MISS_LEFT$ in (0) then goto T146_2;
 else goto N146_7;

T146_2: 
  response = -0.0012762169;
 goto D146;

N146_7: 
  if POS_N_Q_1_P_1$ in (1) then goto T146_3;
 else goto T146_4;

T146_3: 
  response = -0.0018296710;
 goto D146;

T146_4: 
  response = 0.0014645688;
 goto D146;

T146_5: 
  response = -0.0035438602;
 goto D146;

N146_8: 
  if POS_L_P_3_S_0$ in (1) then goto T146_6;
 else goto N146_9;

T146_6: 
  response = -0.0006078601;
 goto D146;

N146_9: 
  if IDF_MISS_LEFT$ in (0) then goto T146_7;
 else goto T146_8;

T146_7: 
  response = 0.0000637390;
 goto D146;

T146_8: 
  response = 0.0006448440;
 goto D146;

T146_9: 
  response = 0.0036106525;
 goto D146;

T146_10: 
  response = 0.0037069317;
 goto D146;

D146:

tnscore = tnscore + response;

  /* Tree 148 of 150 */
N147_1: 
  if LEN_Q_6_LEN_P_4$ in (0) then goto N147_2;
 else goto T147_10;

N147_2: 
  if LEN_Q_4_LEN_P_4$ in (0) then goto N147_3;
 else goto T147_9;

N147_3: 
  if IDF_FRAC < 0.6493244767 then goto N147_4;
 else goto N147_6;

N147_4: 
  if POS_N_Q_2_P_1$ in (0) then goto T147_1;
 else goto N147_5;

T147_1: 
  response = -0.0000476721;
 goto D147;

N147_5: 
  if IDF_FRAC < 0.0476190485 then goto T147_2;
 else goto T147_3;

T147_2: 
  response = 0.0042930594;
 goto D147;

T147_3: 
  response = 0.0002861671;
 goto D147;

N147_6: 
  if POS_R_P_NO$ in (0) then goto N147_7;
 else goto N147_9;

N147_7: 
  if POS_R_P_0_E_5$ in (0) then goto N147_8;
 else goto T147_6;

N147_8: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto T147_4;
 else goto T147_5;

T147_4: 
  response = -0.0007725098;
 goto D147;

T147_5: 
  response = 0.0013183416;
 goto D147;

T147_6: 
  response = 0.0006344368;
 goto D147;

N147_9: 
  if QBERT_SCORE$ in (0) then goto T147_7;
 else goto T147_8;

T147_7: 
  response = -0.0001266432;
 goto D147;

T147_8: 
  response = 0.0010055495;
 goto D147;

T147_9: 
  response = 0.0026100415;
 goto D147;

T147_10: 
  response = 0.0032255545;
 goto D147;

D147:

tnscore = tnscore + response;

  /* Tree 149 of 150 */
N148_1: 
  if LEN_Q_5_LEN_P_3$ in (0) then goto N148_2;
 else goto N148_9;

N148_2: 
  if POS_L_P_5_S_0$ in (1) then goto N148_3;
 else goto N148_4;

N148_3: 
  if IDF_FRAC < 0.9591665268 then goto T148_1;
 else goto T148_2;

T148_1: 
  response = -0.0001270328;
 goto D148;

T148_2: 
  response = -0.0018973790;
 goto D148;

N148_4: 
  if LEN_Q_4_LEN_P_4$ in (0) then goto N148_5;
 else goto T148_8;

N148_5: 
  if IDF_MISS_LEFT_WEIGHT < 0.6449580193 then goto N148_6;
 else goto T148_7;

N148_6: 
  if POS_R_P_3_E_0$ in (1) then goto T148_3;
 else goto N148_7;

T148_3: 
  response = -0.0014623220;
 goto D148;

N148_7: 
  if LEN_Q_5_LEN_P_1$ in (1) then goto T148_4;
 else goto N148_8;

T148_4: 
  response = -0.0013264271;
 goto D148;

N148_8: 
  if IDF_MISS_RIGHT$ in (0) then goto T148_5;
 else goto T148_6;

T148_5: 
  response = -0.0000767843;
 goto D148;

T148_6: 
  response = 0.0002132296;
 goto D148;

T148_7: 
  response = 0.0008363330;
 goto D148;

T148_8: 
  response = 0.0023915341;
 goto D148;

N148_9: 
  if IDF_FRAC < 0.8615900278 then goto T148_9;
 else goto T148_10;

T148_9: 
  response = 0.0003590209;
 goto D148;

T148_10: 
  response = 0.0026426742;
 goto D148;

D148:

tnscore = tnscore + response;

  /* Tree 150 of 150 */
N149_1: 
  if LEN_Q_4_LEN_P_1$ in (1) then goto N149_2;
 else goto N149_3;

N149_2: 
  if IDF_FRAC < 0.7445650101 then goto T149_1;
 else goto T149_2;

T149_1: 
  response = -0.0002959674;
 goto D149;

T149_2: 
  response = -0.0043397278;
 goto D149;

N149_3: 
  if IDF_FRAC < 0.0270270500 then goto N149_4;
 else goto N149_7;

N149_4: 
  if TP_FRAC < 0.7417514920 then goto N149_5;
 else goto T149_6;

N149_5: 
  if TP_PARTIAL$ in (0) then goto N149_6;
 else goto T149_5;

N149_6: 
  if TP_FRAC < -0.0000334913 then goto T149_3;
 else goto T149_4;

T149_3: 
  response = 0.0016688660;
 goto D149;

T149_4: 
  response = -0.0012019867;
 goto D149;

T149_5: 
  response = 0.0012755321;
 goto D149;

T149_6: 
  response = 0.0013395126;
 goto D149;

N149_7: 
  if POS_L_P_0_S_5$ in (0) then goto N149_8;
 else goto T149_10;

N149_8: 
  if POS_L_P_1_S_1$ in (0) then goto N149_9;
 else goto T149_9;

N149_9: 
  if POS_L_P_5_S_5$ in (0) then goto T149_7;
 else goto T149_8;

T149_7: 
  response = -0.0000801216;
 goto D149;

T149_8: 
  response = 0.0008577764;
 goto D149;

T149_9: 
  response = 0.0041957557;
 goto D149;

T149_10: 
  response = 0.0015868215;
 goto D149;

D149:

tnscore = tnscore + response;

return;
/******************************
 * CALL EACH TREENET EXPLICITLY
 ******************************/

void grove(void)
{
  int terminal_node_number;


  return;
}

			___FINISHED___

