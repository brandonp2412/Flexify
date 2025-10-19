// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';
import 'package:drift/internal/migrations.dart';
import 'schema_v1.dart' as v1;
import 'schema_v2.dart' as v2;
import 'schema_v3.dart' as v3;
import 'schema_v4.dart' as v4;
import 'schema_v5.dart' as v5;
import 'schema_v6.dart' as v6;
import 'schema_v7.dart' as v7;
import 'schema_v8.dart' as v8;
import 'schema_v10.dart' as v10;
import 'schema_v11.dart' as v11;
import 'schema_v12.dart' as v12;
import 'schema_v13.dart' as v13;
import 'schema_v14.dart' as v14;
import 'schema_v15.dart' as v15;
import 'schema_v16.dart' as v16;
import 'schema_v17.dart' as v17;
import 'schema_v18.dart' as v18;
import 'schema_v19.dart' as v19;
import 'schema_v20.dart' as v20;
import 'schema_v21.dart' as v21;
import 'schema_v22.dart' as v22;
import 'schema_v23.dart' as v23;
import 'schema_v24.dart' as v24;
import 'schema_v25.dart' as v25;
import 'schema_v26.dart' as v26;
import 'schema_v27.dart' as v27;
import 'schema_v28.dart' as v28;
import 'schema_v29.dart' as v29;
import 'schema_v30.dart' as v30;
import 'schema_v31.dart' as v31;
import 'schema_v32.dart' as v32;
import 'schema_v33.dart' as v33;
import 'schema_v34.dart' as v34;
import 'schema_v35.dart' as v35;
import 'schema_v36.dart' as v36;
import 'schema_v37.dart' as v37;
import 'schema_v38.dart' as v38;
import 'schema_v39.dart' as v39;
import 'schema_v40.dart' as v40;
import 'schema_v41.dart' as v41;
import 'schema_v42.dart' as v42;
import 'schema_v43.dart' as v43;
import 'schema_v44.dart' as v44;

class GeneratedHelper implements SchemaInstantiationHelper {
  @override
  GeneratedDatabase databaseForVersion(QueryExecutor db, int version) {
    switch (version) {
      case 1:
        return v1.DatabaseAtV1(db);
      case 2:
        return v2.DatabaseAtV2(db);
      case 3:
        return v3.DatabaseAtV3(db);
      case 4:
        return v4.DatabaseAtV4(db);
      case 5:
        return v5.DatabaseAtV5(db);
      case 6:
        return v6.DatabaseAtV6(db);
      case 7:
        return v7.DatabaseAtV7(db);
      case 8:
        return v8.DatabaseAtV8(db);
      case 10:
        return v10.DatabaseAtV10(db);
      case 11:
        return v11.DatabaseAtV11(db);
      case 12:
        return v12.DatabaseAtV12(db);
      case 13:
        return v13.DatabaseAtV13(db);
      case 14:
        return v14.DatabaseAtV14(db);
      case 15:
        return v15.DatabaseAtV15(db);
      case 16:
        return v16.DatabaseAtV16(db);
      case 17:
        return v17.DatabaseAtV17(db);
      case 18:
        return v18.DatabaseAtV18(db);
      case 19:
        return v19.DatabaseAtV19(db);
      case 20:
        return v20.DatabaseAtV20(db);
      case 21:
        return v21.DatabaseAtV21(db);
      case 22:
        return v22.DatabaseAtV22(db);
      case 23:
        return v23.DatabaseAtV23(db);
      case 24:
        return v24.DatabaseAtV24(db);
      case 25:
        return v25.DatabaseAtV25(db);
      case 26:
        return v26.DatabaseAtV26(db);
      case 27:
        return v27.DatabaseAtV27(db);
      case 28:
        return v28.DatabaseAtV28(db);
      case 29:
        return v29.DatabaseAtV29(db);
      case 30:
        return v30.DatabaseAtV30(db);
      case 31:
        return v31.DatabaseAtV31(db);
      case 32:
        return v32.DatabaseAtV32(db);
      case 33:
        return v33.DatabaseAtV33(db);
      case 34:
        return v34.DatabaseAtV34(db);
      case 35:
        return v35.DatabaseAtV35(db);
      case 36:
        return v36.DatabaseAtV36(db);
      case 37:
        return v37.DatabaseAtV37(db);
      case 38:
        return v38.DatabaseAtV38(db);
      case 39:
        return v39.DatabaseAtV39(db);
      case 40:
        return v40.DatabaseAtV40(db);
      case 41:
        return v41.DatabaseAtV41(db);
      case 42:
        return v42.DatabaseAtV42(db);
      case 43:
        return v43.DatabaseAtV43(db);
      case 44:
        return v44.DatabaseAtV44(db);
      default:
        throw MissingSchemaException(version, versions);
    }
  }

  static const versions = const [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
    34,
    35,
    36,
    37,
    38,
    39,
    40,
    41,
    42,
    43,
    44
  ];
}
