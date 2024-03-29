 %let pgm=utl-sas-normalize-transpose-pivot-long-remove-missing-values-columns-and-missing-rows;

 sas normalize transpose pivot long remove missing values columns and missing rows

 github
 https://tinyurl.com/56efh3u8
 https://github.com/rogerjdeangelis/utl-sas-normalize-transpose-pivot-long-remove-missing-values-columns-and-missing-rows

 macros
 https://tinyurl.com/y9nfugth
 https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories

   Two Solutions (normailization is often more useful)

         1. utl_gather2
         2, utl_untranspose

 /*               _     _
  _ __  _ __ ___ | |__ | | ___ _ __ ___
 | `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
 | |_) | | | (_) | |_) | |  __/ | | | | |
 | .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
 |_|
 */

 /**************************************************************************************************************************/
 /*                                      |                                 |                                               */
 /*              INPUT                   |                                 |                                               */
 /*                                      |  PROCESS                        |  OUTPUT(NO MISSING VALUES)                    */
 /*  Note you cannot use proc transpose  |                                 |                                               */
 /*  because there is no row key,        |                                 |    Obs    VAR    VAL                          */
 /*                                      |  GATHER2(MANY OPTIONS)          |                                               */
 /*  WORK.HAVE total obs=9               |                                 |      1    C1     01                           */
 /*                                      |  %utl_gather2(                  |      2    C1     02                           */
 /*   Obs C1 C2 C3 C4  C5 C6 C7          |    sd1.have                     |      3    C1     03                           */
 /*                                      |   ,var                          |      4    C1     05                           */
 /*    1  01 15  . 31  31  . 20          |   ,val                          |      5    C1     06                           */
 /*    2  02  .  .  .   .  . 21          |   ,dbout=want_g                 |      6    C1     08                           */
 /*    3  03  .  . 33  33  . 22          |      (where=(not missing(val))) |      7    C1     09                           */
 /*    4   .  .  .  .   .  .  .          |   ,ValFormat=$3.                |      8    C2     10                           */
 /*    5  05 19  . 35  35  . 24          |    );                           |      9    C2     15                           */
 /*    6  06 10  .  .   .  . 25          |                                 |     10    C2     19                           */
 /*    7   .  .  .  .   .  .  .          |  UNTRANSPOSE (MORE OPTIONS)     |     11    C4     31                           */
 /*    8  08  .  .  .   .  . 27          |                                 |     12    C4     33                           */
 /*    9  09  .  . 39  39  .  .          |  %untranspose(data=             |     13    C4     35                           */
 /*                                      |     sd1.have                    |     14    C4     39                           */
 /*                                      |    ,out=want_u,var=c1-c7        |     15    C5     31                           */
 /*                                      |    );                           |     16    C5     33                           */
 /*                                      |                                 |     17    C5     35                           */
 /*                                      |                                 |     18    C5     39                           */
 /*                                      |                                 |     19    C7     20                           */
 /*                                      |                                 |     20    C7     21                           */
 /*                                      |                                 |     21    C7     22                           */
 /*                                      |                                 |     22    C7     24                           */
 /*                                      |                                 |     23    C7     25                           */
 /*                                      |                                 |     24    C7     27                           */
 /*                                      |                                 |                                               */
 /**************************************************************************************************************************/

 /*                   _
 (_)_ __  _ __  _   _| |_
 | | `_ \| `_ \| | | | __|
 | | | | | |_) | |_| | |_
 |_|_| |_| .__/ \__,_|\__|
         |_|
 */

 options validvarname=upcase;
 libname sd1 "d:/sd1";
 data sd1.have;
 input  (c1-c7) ($);
 cards4;
 01 15 . 31  31 . 20
 02  . .  .   . . 21
 03  . . 33  33 . 22
  .  . .  .   . .  .
 05 19 . 35  35 . 24
 06 10 .  .   . . 25
  .  . .  .   . .  .
 08  . .  .   . . 27
 09  . . 39  39 .  .
 ;;;;
 run;quit;


 /**************************************************************************************************************************/
 /*                                                                                                                        */
 /*  SD1.HAVE total obs=9                                                                                                  */
 /*                                                                                                                        */
 /*  Obs    C1    C2    C3    C4    C5    C6    C7                                                                         */
 /*                                                                                                                        */
 /*   1     01    15          31    31          20                                                                         */
 /*   2     02                                  21                                                                         */
 /*   3     03                33    33          22                                                                         */
 /*   4                                                                                                                    */
 /*   5     05    19          35    35          24                                                                         */
 /*   6     06    10                            25                                                                         */
 /*   7                                                                                                                    */
 /*   8     08                                  27                                                                         */
 /*   9     09                39    39                                                                                     */
 /*                                                                                                                        */
 /**************************************************************************************************************************/

 /*         _   _                 _   _              ____
 / |  _   _| |_| |     __ _  __ _| |_| |__   ___ _ _|___ \
 | | | | | | __| |    / _` |/ _` | __| `_ \ / _ \ `__|__) |
 | | | |_| | |_| |   | (_| | (_| | |_| | | |  __/ |  / __/
 |_|  \__,_|\__|_|____\__, |\__,_|\__|_| |_|\___|_| |_____|
                |_____|___/
 */

 %utl_gather2(
   sd1.have
  ,var
  ,val
  ,dbout=sd1.want
     (where=(not missing(val)))
  ,ValFormat=$3.
   );

 /**************************************************************************************************************************/
 /*                                                                                                                        */
 /* Obs    VAR    VAL                                                                                                      */
 /*                                                                                                                        */
 /*   1    C1     01                                                                                                       */
 /*   2    C2     15                                                                                                       */
 /*   3    C4     31                                                                                                       */
 /*   4    C5     31                                                                                                       */
 /*   5    C7     20                                                                                                       */
 /*   6    C1     02                                                                                                       */
 /*   7    C7     21                                                                                                       */
 /*   8    C1     03                                                                                                       */
 /*   9    C4     33                                                                                                       */
 /*  10    C5     33                                                                                                       */
 /*  11    C7     22                                                                                                       */
 /*  12    C1     05                                                                                                       */
 /*  13    C2     19                                                                                                       */
 /*  14    C4     35                                                                                                       */
 /*  15    C5     35                                                                                                       */
 /*  16    C7     24                                                                                                       */
 /*  17    C1     06                                                                                                       */
 /*  18    C2     10                                                                                                       */
 /*  19    C7     25                                                                                                       */
 /*  20    C1     08                                                                                                       */
 /*  21    C7     27                                                                                                       */
 /*  22    C1     09                                                                                                       */
 /*  23    C4     39                                                                                                       */
 /*  24    C5     39                                                                                                       */
 /*                                                                                                                        */
 /**************************************************************************************************************************/

 /*___          _   _                _
 |___ \   _   _| |_| |   _   _ _ __ | |_ _ __ __ _ _ __  ___ _ __   ___  ___  ___
   __) | | | | | __| |  | | | | `_ \| __| `__/ _` | `_ \/ __| `_ \ / _ \/ __|/ _ \
  / __/  | |_| | |_| |  | |_| | | | | |_| | | (_| | | | \__ \ |_) | (_) \__ \  __/
 |_____|  \__,_|\__|_|___\__,_|_| |_|\__|_|  \__,_|_| |_|___/ .__/ \___/|___/\___|
                    |_____|                                 |_|
 */

 %untranspose(data=
    sd1.have
   ,out=want_u,var=c1-c7
   );

 /**************************************************************************************************************************/
 /*                                                                                                                        */
 /* Obs    _NAME_    _VALUE_                                                                                               */
 /*                                                                                                                        */
 /*   1      C1        01                                                                                                  */
 /*   2      C2        15                                                                                                  */
 /*   3      C4        31                                                                                                  */
 /*   4      C5        31                                                                                                  */
 /*   5      C7        20                                                                                                  */
 /*   6      C1        02                                                                                                  */
 /*   7      C7        21                                                                                                  */
 /*   8      C1        03                                                                                                  */
 /*   9      C4        33                                                                                                  */
 /*  10      C5        33                                                                                                  */
 /*  11      C7        22                                                                                                  */
 /*  12      C1        05                                                                                                  */
 /*  13      C2        19                                                                                                  */
 /*  14      C4        35                                                                                                  */
 /*  15      C5        35                                                                                                  */
 /*  16      C7        24                                                                                                  */
 /*  17      C1        06                                                                                                  */
 /*  18      C2        10                                                                                                  */
 /*  19      C7        25                                                                                                  */
 /*  20      C1        08                                                                                                  */
 /*  21      C7        27                                                                                                  */
 /*  22      C1        09                                                                                                  */
 /*  23      C4        39                                                                                                  */
 /*  24      C5        39                                                                                                  */
 /*                                                                                                                        */
 /**************************************************************************************************************************/

 /*              _
   ___ _ __   __| |
  / _ \ `_ \ / _` |
 |  __/ | | | (_| |
  \___|_| |_|\__,_|

 */
