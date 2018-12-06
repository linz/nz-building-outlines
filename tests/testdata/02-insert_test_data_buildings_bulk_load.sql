
INSERT INTO buildings_bulk_load.supplied_datasets(supplied_dataset_id, description, supplier_id)
VALUES (DEFAULT, 'Test Data', 1),
       (DEFAULT, 'Test Data Two', 1);

INSERT INTO buildings_common.capture_source(capture_source_id, capture_source_group_id, external_source_id) VALUES (1001, 1, '1');

-- SUPPLIED DATASET ONE
INSERT INTO buildings.buildings(building_id, begin_lifespan, end_lifespan)
VALUES (10001, '2017-01-01 09:00:00', NULL),
       (10002, '2017-01-01 09:00:00', NULL),
       (10003, '2017-01-01 09:00:00', NULL),
       (10004, '2017-01-01 09:00:00', NULL),
       (10005, '2017-01-01 09:00:00', NULL),
       (10006, '2017-01-01 09:00:00', NULL),
       (10007, '2017-01-01 09:00:00', NULL),
       (10008, '2017-01-01 09:00:00', NULL),
       (10009, '2017-01-01 09:00:00', NULL),
       (10010, '2017-01-01 09:00:00', NULL),
       (10011, '2017-01-01 09:00:00', NULL),
       (10012, '2017-01-01 09:00:00', NULL),
       (10013, '2017-01-01 09:00:00', NULL),
       (10014, '2017-01-01 09:00:00', NULL),
       (10015, '2017-01-01 09:00:00', NULL),
       (10016, '2017-01-01 09:00:00', NULL),
       (10017, '2017-01-01 09:00:00', NULL),
       (10018, '2017-01-01 09:00:00', NULL),
       (10019, '2017-01-01 09:00:00', NULL),
       (10020, '2017-01-01 09:00:00', NULL),
       (10021, '2017-01-01 09:00:00', NULL),
       (10022, '2017-01-01 09:00:00', NULL),
       (10023, '2017-01-01 09:00:00', NULL),
       (10024, '2017-01-01 09:00:00', NULL),
       (10025, '2017-01-01 09:00:00', NULL),
       (10026, '2017-01-01 09:00:00', NULL),
       (10027, '2017-01-01 09:00:00', NULL),
       (10028, '2017-01-01 09:00:00', NULL),
       (10029, '2017-01-01 09:00:00', NULL),
       (10030, '2017-01-01 09:00:00', NULL),
       (10031, '2017-01-01 09:00:00', NULL),
       (10032, '2017-01-01 09:00:00', NULL),
       (10033, '2017-01-01 09:00:00', NULL);

INSERT INTO buildings.building_outlines (building_outline_id, building_id, capture_method_id, capture_source_id, lifecycle_stage_id, suburb_locality_id, town_city_id, territorial_authority_id, begin_lifespan, end_lifespan, shape)
VALUES (1001, 10001, 5, 1001, 1, 102, 1001, 10001, '2017-01-01 09:00:00', NULL, '01030000209108000001000000050000002F9EEE1D40A83C4111B98E242131554135FAC7385AA83C416C3970282131554135FAC7385AA83C413B8099EB1B315541309EEE1D40A83C41877FD6E31B3155412F9EEE1D40A83C4111B98E2421315541'),
       (1002, 10002, 5, 1001, 1, 102, 1001, 10001, '2017-01-01 09:00:00', NULL, '01030000209108000001000000070000001A70C8616AA83C412ABBD73B21315541CBED31F185A83C41D13AF6372131554132EFB70086A83C41CBCEE9501F315541E6EF7A0886A83C41E02EC1EF1D315541E6EF7A0886A83C41B33FC7E51B3155417C6AB0236AA83C410DC0A8E91B3155411A70C8616AA83C412ABBD73B21315541'),
       (1003, 10003, 5, 1001, 1, 101, 1001, 10001, '2017-01-01 09:00:00', NULL, '010300002091080000010000000E0000007FE51DB69BA83C41336B438B203155417FE51DB69BA83C412DF8DA1A2131554162026916B3A83C410DB98E242131554115032C1EB3A83C417B63E2352031554149A9AB3CAFA83C417B63E23520315541B0AA314CAFA83C41E12EE2511F315541E205383DB3A83C41C9CEE9501F31554159886258B3A83C411AA6BB8E1D3155419C5812C0ABA83C415CC6A4911D3155419C5812C0ABA83C41FC0143C31E315541A9E76EDEA6A83C4129C233C51E3155414F678DDAA6A83C4173269D921D31554118E497A69BA83C4173269D921D3155417FE51DB69BA83C41336B438B20315541'),
       (1004, 10004, 5, 1001, 1, 101, 1001, 10001, '2017-01-01 09:00:00', NULL, '01030000209108000001000000050000005DC36E06CCA83C419A9BB14021315541E5C6C1B5D1A83C41999BB14021315541FEC80ACDD1A83C4187E4447D1D315541D1459921CCA83C415924547B1D3155415DC36E06CCA83C419A9BB14021315541'),
       (1005, 10005, 5, 1001, 1, 101, 1001, 10001, '2017-01-01 09:00:00', NULL, '010300002091080000010000000B00000056A6B8592EA93C414D01044424315541ABB8964545A93C41F380224024315541ACB8964545A93C41C96261F222315541AF0310733DA93C4123E342F622315541AF0310733DA93C41483089C320315541A70F0B0849A93C41EEAFA7BF20315541400E85F848A93C418E8D54431F315541E407A2A13DA93C41E70D36471F315541E407A2A13DA93C4125C2F1001C31554156A6B8592EA93C4117414DF51B31554156A6B8592EA93C414D01044424315541'),
       (1006, 10006, 5, 1001, 1, 102, 1001, 10001, '2017-01-01 09:00:00', NULL, '01030000209108000001000000090000006C7CBADC0CA83C4121486FCB21315541CD4560A120A83C41BA46E9BB21315541FE42548220A83C410146A22B1C3155413A7FC6FB0CA83C410FC746371C315541D37D40EC0CA83C418071DC0C1E315541ADAF5D241AA83C41CB7019051E315541ADAF5D241AA83C412420041120315541D37D40EC0CA83C4180A0E514203155416C7CBADC0CA83C4121486FCB21315541'),
       (1007, 10007, 5, 1001, 1, 102, 1001, 10001, '2017-01-01 09:00:00', NULL, '010300002091080000010000000500000030D8209A95A83C419573A19B183155412D1AC384A3A83C419373A19B18315541471C0C9CA3A83C41C3A6B8491531554130D8209A95A83C411F279A4D1531554130D8209A95A83C419573A19B18315541'),
       (1008, 10008, 5, 1001, 1, 103, 1001, 10001, '2017-01-01 09:00:00', NULL, '01030000209108000001000000050000006BE8B56EACA83C412D721B8C1831554117247D13BAA83C4179715884183155413326C62ABAA83C41FEE74D57153155416AE8B56EACA83C418428205D153155416BE8B56EACA83C412D721B8C18315541'),
       (1009, 10009, 5, 1001, 1, 102, 1001, 10001, '2017-01-01 09:00:00', NULL, '0103000020910800000100000005000000307A0E8A91A83C4140EE208C0A315541307A0E8A91A83C4108700C28103155412178CD839CA83C4161F0ED2B10315541567C5FB29CA83C4141EE208C0A315541307A0E8A91A83C4140EE208C0A315541'),
       (1010, 10010, 5, 1001, 1, 102, 1001, 10001, '2017-01-01 09:00:00', NULL, '0103000020910800000100000005000000977B949991A83C418128DE981231554159CA0443C1A83C41CD271B911231554127CD1062C1A83C415976E76D10315541307A0E8A91A83C41B1F6C87110315541977B949991A83C418128DE9812315541'),
       (1011, 10011, 5, 1001, 1, 103, 1001, 10001, '2017-01-01 09:00:00', NULL, '01030000209108000001000000050000006FDA81E4B6A83C41556F4920103155415ED1A290C1A83C41FBEE671C1031554161D840DEC1A83C410370889F0A315541D6DB07F4B6A83C415CF069A30A3155416FDA81E4B6A83C41556F492010315541'),
       (1012, 10012, 5, 1001, 1, 102, 1001, 10001, '2017-01-01 09:00:00', NULL, '01030000209108000001000000050000005475C1649CA83C41201B5DF406315541BC907EA4A8A83C416D1A9AEC06315541589696E2A8A83C41A998F01404315541A074FE5C9CA83C412FD9C21A043155415475C1649CA83C41201B5DF406315541'),
       (1013, 10013, 5, 1001, 1, 103, 1001, 10001, '2017-01-01 09:00:00', NULL, '010300002091080000010000000500000001E09111ACA83C416B1A9AEC0631554127E2E239B7A83C4199DA8AEE063155415DE67468B7A83C41D558E11604315541B5E05419ACA83C414F180F110431554101E09111ACA83C416B1A9AEC06315541'),
       (1014, 10014, 5, 1001, 1, 102, 1001, 10001, '2017-01-01 09:00:00', NULL, '01030000209108000001000000050000004F6E23179CA83C41B2485C6403315541229204B4A8A83C4166491F6C0331554189938AC3A8A83C41CB4A63B7003155416A706C2E9CA83C41164AA0AF003155414F6E23179CA83C41B2485C6403315541'),
       (1015, 10015, 5, 1001, 1, 103, 1001, 10001, '2017-01-01 09:00:00', NULL, '0103000020910800000100000005000000CFE29D30ACA83C41A08AB479033155419BF84232B8A83C41CD4AA57B033155411CFC1159B8A83C413689ECA500315541E9E4E647ACA83C410AC9FBA300315541CFE29D30ACA83C41A08AB47903315541'),
       (1016, 10016, 5, 1001, 1, 102, 1001, 10001, '2017-01-01 09:00:00', NULL, '01030000209108000001000000050000002FEDF2718BA83C417EB010D0FC30554115D6D78295A83C4124302FCCFC30554131D8209A95A83C413E9E0042F930554115EBA95A8BA83C41311D5C36F93055412FEDF2718BA83C417EB010D0FC305541'),
       (1017, 10017, 5, 1001, 1, 102, 1001, 10001, '2017-01-01 09:00:00', NULL, '0103000020910800000100000005000000E436F6B199A83C41CAAF4DC8FC305541D1FE0D56A2A83C41712F6CC4FC3055412105E99BA2A83C41C5DED247F9305541653AC5D899A83C41971EE245F9305541E436F6B199A83C41CAAF4DC8FC305541'),
       (1018, 10018, 5, 1001, 1, 103, 1001, 10001, '2017-01-01 09:00:00', NULL, '0103000020910800000100000005000000FF817F01A8A83C41446F7BC2FC3055411361BAA5B1A83C4163AEC7B8FC305541FC650FDCB1A83C411E5FB44BF930554166830511A8A83C41F19EC349F9305541FF817F01A8A83C41446F7BC2FC305541'),
       (1019, 10019, 5, 1001, 1, 103, 1001, 10001, '2017-01-01 09:00:00', NULL, '01030000209108000001000000050000001ED4A69EB6A83C4164AEC7B8FC3055418E9F8D69BFA83C4163AEC7B8FC3055417BAB80EDBFA83C414B1FA54DF930554170DA81E4B6A83C411E5FB44BF93055411ED4A69EB6A83C4164AEC7B8FC305541'),
       (1020, 10020, 5, 1001, 1, 103, 1001, 10001, '2017-01-01 09:00:00', NULL, '010300002091080000010000000500000068158681C4A83C41DD6DF5B2FC30554146F02EF7CDA83C4137EED6B6FC30554165F9155CCEA83C414B1FA54DF9305541E91855A8C4A83C414B1FA54DF930554168158681C4A83C41DD6DF5B2FC305541'),
       (1021, 10021, 5, 1001, 1, 102, 1001, 10001, '2017-01-01 09:00:00', NULL, '0103000020910800000100000006000000BEBC5B497EA83C41D6A394F7F330554124BEE1587EA83C4141DBC15CF63055410F0C77C78CA83C41E75AE058F6305541DA07E5988CA83C41E532F115EF30554121B7430B7EA83C41D8B14C0AEF305541BEBC5B497EA83C41D6A394F7F3305541'),
       (1022, 10022, 5, 1001, 1, 102, 1001, 10001, '2017-01-01 09:00:00', NULL, '01030000209108000001000000050000001E28EFFD8DA83C418EDAFE54F630554146C3FE36B1A83C41D892055FF630554159303D24B1A83C4154F67632F33055415025E3DE8DA83C419791C62DF33055411E28EFFD8DA83C418EDAFE54F6305541'),
       (1023, 10023, 5, 1001, 1, 103, 1001, 10001, '2017-01-01 09:00:00', NULL, '0103000020910800000100000005000000DB6ABBE6B2A83C41643F8D44F63055417FB0E545D6A83C41F5DB8464F63055414CB3F164D6A83C417AB7E8D0F4305541F99BCED0B2A83C41E0C042ACF4305541DB6ABBE6B2A83C41643F8D44F6305541'),
       (1024, 10024, 5, 1001, 1, 102, 1001, 10001, '2017-01-01 09:00:00', NULL, '0103000020910800000100000005000000B62669EE8DA83C41E18965D8F23055417AD0BF4495A83C41880984D4F230554144CC2D1695A83C41D8824302ED3055418122D7BF8DA83C41D7824302ED305541B62669EE8DA83C41E18965D8F2305541'),
       (1025, 10025, 5, 1001, 1, 103, 1001, 10001, '2017-01-01 09:00:00', NULL, '010300002091080000010000000500000081FB5E73CEA83C41692FA677F43055417EB0E545D6A83C4110AFC473F43055411AB6FD83D6A83C413639CC5BEF30554182FB5E73CEA83C413639CC5BEF30554181FB5E73CEA83C41692FA677F4305541'),
       (1026, 10026, 5, 1001, 1, 103, 1001, 10001, '2017-01-01 09:00:00', NULL, '0103000020910800000100000008000000536B3295C1A83C41A492144AF43055413376221BCDA83C41FAEBFF46F43055419FD53CD0CCA83C416B6C6792F130554179D3EBA7C1A83C41C4EC4896F1305541AC28168FC1A83C41131EB12FF3305541F9D4E1FAB2A83C41FB063C30F3305541E175A8FCB2A83C4129F4A242F4305541536B3295C1A83C41A492144AF4305541'),
       (1027, 10027, 5, 1001, 1, 101, 1001, 10001, '2017-01-01 09:00:00', NULL, '0103000020910800000100000007000000E81F573A9EA83C416A5F58182B3155414B1160A8A8A83C41971F491A2B31554197109DA0A8A83C41D08849E22C3155411ABBB6FEAFA83C41FD483AE42C31554150BF482DB0A83C41CE9D9F42283155419C201A429EA83C41A1DDAE4028315541E81F573A9EA83C416A5F58182B315541'),
       (1028, 10028, 5, 1001, 1, 101, 1001, 10001, '2017-01-01 09:00:00', NULL, '0103000020910800000100000005000000E01AFAF292A83C415870661F34315541CB33BB35B5A83C41F16EE00F34315541CF3A5983B5A83C41CB73B1BD2E3155414215E2B492A83C411773EEB52E315541E01AFAF292A83C415870661F34315541'),
       (1029, 10029, 5, 1001, 1, 101, 1001, 10001, '2017-01-01 09:00:00', NULL, '01030000209108000001000000050000009753A5568AA83C41E5F7710A45315541A3EB4D27BDA83C4182FD8948453155412010EABABEA83C419EE046F938315541D25ED5D28AA83C41EBDF83F1383155419753A5568AA83C41E5F7710A45315541'),
       (1030, 10030, 5, 1001, 1, 101, 1001, 10001, '2017-01-01 09:00:00', NULL, '010300002091080000010000000C0000007B4A2B50CCA83C4149685AF554315541B5555BCCCCA83C41A354061C5431554199DD118CBCA83C416D5074ED533155415FD2E10FBCA83C412D8E7C98563155416D64ED108BA83C41C185583B56315541F396C53F8DA83C4128E093134F315541A9E7CB1AD3A83C418ADA7BD54E315541F50E74CDD4A83C41A86483BD493155412358E25969A83C413C5C5F6049315541E94CB2DD68A83C415DDB46EE59315541413FFBD3CBA83C41FAE05E2C5A3155417B4A2B50CCA83C4149685AF554315541'),
       (1031, 10031, 5, 1001, 1, 101, 1001, 10001, '2017-01-01 09:00:00', NULL, '01030000209108000001000000050000004618243924A83C4196D4B8C26F315541D08E8BC127A93C41D0DFE83E7031554145A5EBB928A93C41AEB0D72563315541802354B524A83C4173A5A7A9623155414618243924A83C4196D4B8C26F315541'),
       (1032, 10032, 5, 1001, 1, 101, 1001, 10001, '2017-01-01 09:00:00', NULL, '0103000020910800000100000005000000020B4A9AF6A83C41B6522B9354315541994B20BBF8A83C4128E9F8A24231554158D2F189B5A93C411960CEF042315541A37FC604B4A93C415CA995D053315541020B4A9AF6A83C41B6522B9354315541'),
       (1033, 10033, 5, 1001, 1, 101, 1001, 10001, '2017-01-01 09:00:00', NULL, '0103000020910800000100000005000000B9522B1575A93C417396CD1D4131554158D2F189B5A93C41A7AF2D5841315541F012C8AAB7A93C415E5B1CEA313155416EA5569A76A93C41F4285C7531315541B9522B1575A93C417396CD1D41315541');

INSERT INTO buildings_bulk_load.existing_subset_extracts
SELECT buildings.building_outline_id, 1 AS supplied_dataset_id, buildings.shape
FROM buildings.building_outlines buildings;

INSERT INTO buildings_bulk_load.supplied_outlines (supplied_outline_id, supplied_dataset_id, shape)
VALUES (201, 1, '0103000020910800000100000005000000FB0DA8AB6BA83C4167030B97213155413A8A8B2B87A83C4167030B9721315541558CD44287A83C41D248AE4A1C315541C609167D6BA83C41FF089F4C1C315541FB0DA8AB6BA83C4167030B9721315541'),
       (202, 1, '01030000209108000001000000080000001489153E9DA83C416624D80323315541AE878F2E9DA83C4127CEAAD124315541A1416B37A5A83C41DACE6DD92431554170447756A5A83C414787BBC1213155416F6303BDB1A83C41FB877EC9213155413D660FDCB1A83C41366B438B20315541628852369DA83C41AF2A7185203155411489153E9DA83C416624D80323315541'),
       (203, 1, '0103000020910800000100000005000000772E37A2D0A83C41C57C6FAF2231554142E46BBAD7A83C4110DE7BAD22315541F7D1B2B2D7A83C410DB2F0D620315541B5ACCF8ED0A83C416632D2DA20315541772E37A2D0A83C41C57C6FAF22315541'),
       (204, 1, '01030000209108000001000000050000003897AF1E28A93C415A5857A426315541C8139BAF4EA93C415A5857A4263155416519B3ED4EA93C4170844C7C1D3155413897AF1E28A93C413F87589B1D3155413897AF1E28A93C415A5857A426315541'),
       (205, 1, '0103000020910800000100000005000000901BBDFA92A83C413522A83D1931554180E266C2BCA83C418FA289411931554119E1E0B2BCA83C419A3884AD14315541901BBDFA92A83C4140B8A2A914315541901BBDFA92A83C413522A83D19315541'),
       (206, 1, '010300002091080000010000000900000071EA6ADB90A83C415149C4560A3155410EF0821991A83C41FD0A01B512315541CE608337C2A83C41718D2BD0123155413E7045E2C2A83C412ECD74810A315541234F7064B6A83C41D34C937D0A31554187495826B6A83C416550E62C10315541B70196EC9CA83C41BFD0C73010315541230ABA499DA83C41064A875E0A31554171EA6ADB90A83C415149C4560A315541'),
       (207, 1, '010300002091080000010000000500000037D65B0B9BA83C41B3806D3307315541B38F842EB9A83C414D7FE7230731554187992E9BB9A83C41ECE45278003155416CDAED399BA83C4139E48F700031554137D65B0B9BA83C41B3806D3307315541'),
       (208, 1, '01030000209108000001000000050000007C515C3F8AA83C417C19F035FD3055415B911A60CFA83C416117A71EFD305541C7993EBDCFA83C418BB688EFF8305541DF4B44018AA83C4170B43FD8F83055417C515C3F8AA83C417C19F035FD305541'),
       (209, 1, '010300002091080000010000000D0000005A224B267DA83C41687E9882F63055419B4A3361D7A83C411C7F5B8AF630554138504B9FD7A83C4116D17205EF3055414167668ECDA83C417ED2F814EF3055414167668ECDA83C418608A06AF1305541543CE7A3C0A83C412C88BE66F1305541BC3D6DB3C0A83C41342A30DFF23055418D64F52196A83C41B22661B8F230554149DFBEE795A83C41565D05C9EC305541068BD2BB8CA83C416DBDFDC9EC3055419F894CAC8CA83C41E1CCE0D6EE305541EE1927C97CA83C41E1CCE0D6EE3055415A224B267DA83C41687E9882F6305541'),
       (210, 1, '01030000209108000001000000070000009301B41E0DA83C415FB6485229315541A6C4768C15A83C415FB64852293155413EC3F07C15A83C41E26941042631554127E7D11922A83C4189E95F00263155418EE8572922A83C4154BD6217243155415DFD21F00CA83C4107BE251F243155419301B41E0DA83C415FB6485229315541'),
       (211, 1, '0103000020910800000100000005000000273225049FA83C415DDEB30C2B315541B7F1184BA7A83C415EDEB30C2B3155416BF2DB52A7A83C410ADF345028315541DB32E80B9FA83C4109DF345028315541273225049FA83C415DDEB30C2B315541'),
       (212, 1, '01030000209108000001000000050000002122A862A9A83C41379F25522831554189232E72A9A83C4123C589B92C31554174A76225AFA83C4123C589B92C3155410CA6DC15AFA83C41635F1654283155412122A862A9A83C41379F255228315541'),
       (213, 1, '01030000209108000001000000050000002334660A94A83C41B3FE41FA31315541EB4E6042A0A83C413A3F140032315541844DDA32A0A83C41E675FAD42E31554107321DF393A83C41B9B509D32E3155412334660A94A83C41B3FE41FA31315541'),
       (214, 1, '01030000209108000001000000050000003FACAF4AA4A83C41C17FE60532315541EB1437E0B3A83C41B4FE41FA313155413C1B1226B4A83C417B3771E62E315541A2A6970CA4A83C417B3771E62E3155413FACAF4AA4A83C41C17FE60532315541'),
       (215, 1, '0103000020910800000100000005000000B72B42AD93A83C41DBA99AD733315541652534ACB3A83C41D1736DD2333155411C122BC1B3A83C41D307295F32315541852E4ECC93A83C412D880A6332315541B72B42AD93A83C41DBA99AD733315541'),
       (216, 1, '01030000209108000001000000050000004F8371668CA83C418EA17E8B3E315541C73EDB8F9FA83C418FA17E8B3E315541024A0B0CA0A83C4191293D5C39315541898EA1E28CA83C41F82AC36B393155414F8371668CA83C418EA17E8B3E315541'),
       (217, 1, '01030000209108000001000000050000002122A862A9A83C412CA796C93E31554158C4A574BBA83C4193A81CD93E315541CDDA056DBCA83C41F82AC36B393155412122A862A9A83C41F92AC36B393155412122A862A9A83C412CA796C93E315541'),
       (218, 1, '0103000020910800000100000005000000888EA1E28CA83C41332D149444315541F02D93D59EA83C41B430E3BA44315541BF309FF49EA83C41B6B8A18B3F315541919CDD7D8DA83C4103B8DE833F315541888EA1E28CA83C41332D149444315541'),
       (219, 1, '01030000209108000001000000050000004A1160A8A8A83C41E93475E944315541E2AD457CBAA83C413734B2E144315541BABE8D36BBA83C419FBDF6C13F315541F024B481A9A83C41ECBC33BA3F3155414A1160A8A8A83C41E93475E944315541'),
       (220, 1, '01030000209108000001000000050000009ACC05AD8FA83C41E8D7F8584E31554186AFDBADD0A83C417515369D4E315541E9A9C36FD0A83C419BAD79204A31554175F288D28FA83C411D3817D6493155419ACC05AD8FA83C41E8D7F8584E315541'),
       (221, 1, '01030000209108000001000000050000007FE8F1597CA83C411E55CB7254315541C8F4BCDB89A83C4116D7B75F5431554189838B3D8BA83C41A04A82D6493155413334F8A47CA83C418B38E0F5493155417FE8F1597CA83C411E55CB7254315541'),
       (222, 1, '0103000020910800000100000007000000A3B112627DA83C41579FC3C854315541D13DEF7B7DA83C416E24CABC5931554158B551CFA6A83C41946081F15931554132DBD4F4A6A83C41FB5E307B573155411B5D5A5589A83C4174B1EE6157315541F7FDED8A89A83C41323CACD354315541A3B112627DA83C41579FC3C854315541'),
       (223, 1, '0103000020910800000100000007000000C48C0086A9A83C41AB7223D2593155410DEB9230C8A83C4116190DD55931554147F6C2ACC8A83C4165A0089E543155416A37926DC0A83C41FE9E828E543155418D3F5012C0A83C410B784BAC5731554150FC637BA9A83C4185BD18A557315541C48C0086A9A83C41AB7223D259315541'),
       (224, 1, '01030000209108000001000000050000001DA11A816CA83C41AF1787C5593155413FD02B9A79A83C41481601B65931554179DB5B167AA83C4134ACF3104A315541BAA632BF6CA83C41CDAA6D014A3155411DA11A816CA83C41AF1787C559315541'),
       (225, 1, '0103000020910800000100000005000000ED82ECD428A83C411000B1DF6E315541F8D5DE8A42A83C41AD05C91D6F315541A7F76EFF43A83C41501B5EFD643155419CA47C492AA83C41E819D8ED64315541ED82ECD428A83C411000B1DF6E315541'),
       (226, 1, '0103000020910800000100000005000000E4832C5D81A83C414604430E6F315541100F0F809DA83C41DF02BDFE6E315541D703DF039DA83C41C02A20A8653155410C73E4A280A83C4159299A9865315541E4832C5D81A83C414604430E6F315541'),
       (227, 1, '0103000020910800000100000005000000A7548091ABA83C414504430E6F3155416680CA94C3A83C41AD05C91D6F31554115A25A09C5A83C4189268E7965315541D04338D7AAA83C415322FC4A65315541A7548091ABA83C414504430E6F315541'),
       (228, 1, '010300002091080000010000000500000029511EC9EDA83C4115074F2D6F3155417578C67BEFA83C41C8385C436631554125B5F3EBD0A83C41262CA6B765315541D98D4B39CFA83C41770137EF6E31554129511EC9EDA83C4115074F2D6F315541'),
       (229, 1, '01030000209108000001000000050000003A64B7ABF9A83C41780137EF6E315541A7A8B2CF1DA93C41DF02BDFE6E315541CF976A151DA93C41643E7481663155411075FF65FAA83C412F3AE252663155413A64B7ABF9A83C41780137EF6E315541'),
       (230, 1, '0103000020910800000100000005000000154E28CB52A83C41AD05C91D6F3155416AC8C2336EA83C417C08D53C6F31554141D90AEE6EA83C415422FC4A65315541886488C353A83C41B61CE40C65315541154E28CB52A83C41AD05C91D6F315541'),
       (231, 1, '01030000209108000001000000050000002F9EEE1D40A83C4111B98E242131554135FAC7385AA83C416C3970282131554135FAC7385AA83C413B8099EB1B315541309EEE1D40A83C41877FD6E31B3155412F9EEE1D40A83C4111B98E2421315541'),
       (232, 1, '0103000020910800000100000005000000137AA177FBA83C4179BBEA34533155418CA82234FEA83C4121DEAE14443155418B106F574CA93C41ECC44EDA43315541E5466E844AA93C41E3EDAAA953315541137AA177FBA83C4179BBEA3453315541'),
       (233, 1, '01030000209108000001000000050000006CBF296F71A93C41DB6FCA85523155419D2603DC7AA93C411B2C2893343155410C3FF0E3B1A93C415FCEB27F3431554192106F27AFA93C411F125572523155416CBF296F71A93C41DB6FCA8552315541');

INSERT INTO buildings_bulk_load.bulk_load_outlines (bulk_load_outline_id, supplied_dataset_id, bulk_load_status_id, capture_method_id, capture_source_id, suburb_locality_id, town_city_id, territorial_authority_id, shape)
VALUES (2001, 1, 1, 5, 1001, 102, 1001, 10001, '0103000020910800000100000005000000FB0DA8AB6BA83C4167030B97213155413A8A8B2B87A83C4167030B9721315541558CD44287A83C41D248AE4A1C315541C609167D6BA83C41FF089F4C1C315541FB0DA8AB6BA83C4167030B9721315541'),
       (2002, 1, 1, 5, 1001, 101, 1001, 10001, '01030000209108000001000000080000001489153E9DA83C416624D80323315541AE878F2E9DA83C4127CEAAD124315541A1416B37A5A83C41DACE6DD92431554170447756A5A83C414787BBC1213155416F6303BDB1A83C41FB877EC9213155413D660FDCB1A83C41366B438B20315541628852369DA83C41AF2A7185203155411489153E9DA83C416624D80323315541'),
       (2003, 1, 1, 5, 1001, 101, 1001, 10001, '0103000020910800000100000005000000772E37A2D0A83C41C57C6FAF2231554142E46BBAD7A83C4110DE7BAD22315541F7D1B2B2D7A83C410DB2F0D620315541B5ACCF8ED0A83C416632D2DA20315541772E37A2D0A83C41C57C6FAF22315541'),
       (2004, 1, 1, 5, 1001, 101, 1001, 10001, '01030000209108000001000000050000003897AF1E28A93C415A5857A426315541C8139BAF4EA93C415A5857A4263155416519B3ED4EA93C4170844C7C1D3155413897AF1E28A93C413F87589B1D3155413897AF1E28A93C415A5857A426315541'),
       (2005, 1, 1, 5, 1001, 102, 1001, 10001, '0103000020910800000100000005000000901BBDFA92A83C413522A83D1931554180E266C2BCA83C418FA289411931554119E1E0B2BCA83C419A3884AD14315541901BBDFA92A83C4140B8A2A914315541901BBDFA92A83C413522A83D19315541'),
       (2006, 1, 1, 5, 1001, 102, 1001, 10001, '010300002091080000010000000900000071EA6ADB90A83C415149C4560A3155410EF0821991A83C41FD0A01B512315541CE608337C2A83C41718D2BD0123155413E7045E2C2A83C412ECD74810A315541234F7064B6A83C41D34C937D0A31554187495826B6A83C416550E62C10315541B70196EC9CA83C41BFD0C73010315541230ABA499DA83C41064A875E0A31554171EA6ADB90A83C415149C4560A315541'),
       (2007, 1, 1, 5, 1001, 102, 1001, 10001, '010300002091080000010000000500000037D65B0B9BA83C41B3806D3307315541B38F842EB9A83C414D7FE7230731554187992E9BB9A83C41ECE45278003155416CDAED399BA83C4139E48F700031554137D65B0B9BA83C41B3806D3307315541'),
       (2008, 1, 1, 5, 1001, 103, 1001, 10001, '01030000209108000001000000050000007C515C3F8AA83C417C19F035FD3055415B911A60CFA83C416117A71EFD305541C7993EBDCFA83C418BB688EFF8305541DF4B44018AA83C4170B43FD8F83055417C515C3F8AA83C417C19F035FD305541'),
       (2009, 1, 1, 5, 1001, 102, 1001, 10001, '010300002091080000010000000D0000005A224B267DA83C41687E9882F63055419B4A3361D7A83C411C7F5B8AF630554138504B9FD7A83C4116D17205EF3055414167668ECDA83C417ED2F814EF3055414167668ECDA83C418608A06AF1305541543CE7A3C0A83C412C88BE66F1305541BC3D6DB3C0A83C41342A30DFF23055418D64F52196A83C41B22661B8F230554149DFBEE795A83C41565D05C9EC305541068BD2BB8CA83C416DBDFDC9EC3055419F894CAC8CA83C41E1CCE0D6EE305541EE1927C97CA83C41E1CCE0D6EE3055415A224B267DA83C41687E9882F6305541'),
       (2010, 1, 1, 5, 1001, 101, 1001, 10001, '01030000209108000001000000070000009301B41E0DA83C415FB6485229315541A6C4768C15A83C415FB64852293155413EC3F07C15A83C41E26941042631554127E7D11922A83C4189E95F00263155418EE8572922A83C4154BD6217243155415DFD21F00CA83C4107BE251F243155419301B41E0DA83C415FB6485229315541'),
       (2011, 1, 1, 5, 1001, 101, 1001, 10001, '0103000020910800000100000005000000273225049FA83C415DDEB30C2B315541B7F1184BA7A83C415EDEB30C2B3155416BF2DB52A7A83C410ADF345028315541DB32E80B9FA83C4109DF345028315541273225049FA83C415DDEB30C2B315541'),
       (2012, 1, 1, 5, 1001, 101, 1001, 10001, '01030000209108000001000000050000002122A862A9A83C41379F25522831554189232E72A9A83C4123C589B92C31554174A76225AFA83C4123C589B92C3155410CA6DC15AFA83C41635F1654283155412122A862A9A83C41379F255228315541'),
       (2013, 1, 1, 5, 1001, 101, 1001, 10001, '01030000209108000001000000050000002334660A94A83C41B3FE41FA31315541EB4E6042A0A83C413A3F140032315541844DDA32A0A83C41E675FAD42E31554107321DF393A83C41B9B509D32E3155412334660A94A83C41B3FE41FA31315541'),
       (2014, 1, 1, 5, 1001, 101, 1001, 10001, '01030000209108000001000000050000003FACAF4AA4A83C41C17FE60532315541EB1437E0B3A83C41B4FE41FA313155413C1B1226B4A83C417B3771E62E315541A2A6970CA4A83C417B3771E62E3155413FACAF4AA4A83C41C17FE60532315541'),
       (2015, 1, 1, 5, 1001, 101, 1001, 10001, '0103000020910800000100000005000000B72B42AD93A83C41DBA99AD733315541652534ACB3A83C41D1736DD2333155411C122BC1B3A83C41D307295F32315541852E4ECC93A83C412D880A6332315541B72B42AD93A83C41DBA99AD733315541'),
       (2016, 1, 1, 5, 1001, 101, 1001, 10001, '01030000209108000001000000050000004F8371668CA83C418EA17E8B3E315541C73EDB8F9FA83C418FA17E8B3E315541024A0B0CA0A83C4191293D5C39315541898EA1E28CA83C41F82AC36B393155414F8371668CA83C418EA17E8B3E315541'),
       (2017, 1, 1, 5, 1001, 101, 1001, 10001, '01030000209108000001000000050000002122A862A9A83C412CA796C93E31554158C4A574BBA83C4193A81CD93E315541CDDA056DBCA83C41F82AC36B393155412122A862A9A83C41F92AC36B393155412122A862A9A83C412CA796C93E315541'),
       (2018, 1, 1, 5, 1001, 101, 1001, 10001, '0103000020910800000100000005000000888EA1E28CA83C41332D149444315541F02D93D59EA83C41B430E3BA44315541BF309FF49EA83C41B6B8A18B3F315541919CDD7D8DA83C4103B8DE833F315541888EA1E28CA83C41332D149444315541'),
       (2019, 1, 1, 5, 1001, 101, 1001, 10001, '01030000209108000001000000050000004A1160A8A8A83C41E93475E944315541E2AD457CBAA83C413734B2E144315541BABE8D36BBA83C419FBDF6C13F315541F024B481A9A83C41ECBC33BA3F3155414A1160A8A8A83C41E93475E944315541'),
       (2020, 1, 1, 5, 1001, 101, 1001, 10001, '01030000209108000001000000050000009ACC05AD8FA83C41E8D7F8584E31554186AFDBADD0A83C417515369D4E315541E9A9C36FD0A83C419BAD79204A31554175F288D28FA83C411D3817D6493155419ACC05AD8FA83C41E8D7F8584E315541'),
       (2021, 1, 1, 5, 1001, 101, 1001, 10001, '01030000209108000001000000050000007FE8F1597CA83C411E55CB7254315541C8F4BCDB89A83C4116D7B75F5431554189838B3D8BA83C41A04A82D6493155413334F8A47CA83C418B38E0F5493155417FE8F1597CA83C411E55CB7254315541'),
       (2022, 1, 1, 5, 1001, 101, 1001, 10001, '0103000020910800000100000007000000A3B112627DA83C41579FC3C854315541D13DEF7B7DA83C416E24CABC5931554158B551CFA6A83C41946081F15931554132DBD4F4A6A83C41FB5E307B573155411B5D5A5589A83C4174B1EE6157315541F7FDED8A89A83C41323CACD354315541A3B112627DA83C41579FC3C854315541'),
       (2023, 1, 1, 5, 1001, 101, 1001, 10001, '0103000020910800000100000007000000C48C0086A9A83C41AB7223D2593155410DEB9230C8A83C4116190DD55931554147F6C2ACC8A83C4165A0089E543155416A37926DC0A83C41FE9E828E543155418D3F5012C0A83C410B784BAC5731554150FC637BA9A83C4185BD18A557315541C48C0086A9A83C41AB7223D259315541'),
       (2024, 1, 1, 5, 1001, 101, 1001, 10001, '01030000209108000001000000050000001DA11A816CA83C41AF1787C5593155413FD02B9A79A83C41481601B65931554179DB5B167AA83C4134ACF3104A315541BAA632BF6CA83C41CDAA6D014A3155411DA11A816CA83C41AF1787C559315541'),
       (2025, 1, 1, 5, 1001, 101, 1001, 10001, '0103000020910800000100000005000000ED82ECD428A83C411000B1DF6E315541F8D5DE8A42A83C41AD05C91D6F315541A7F76EFF43A83C41501B5EFD643155419CA47C492AA83C41E819D8ED64315541ED82ECD428A83C411000B1DF6E315541'),
       (2026, 1, 1, 5, 1001, 101, 1001, 10001, '0103000020910800000100000005000000E4832C5D81A83C414604430E6F315541100F0F809DA83C41DF02BDFE6E315541D703DF039DA83C41C02A20A8653155410C73E4A280A83C4159299A9865315541E4832C5D81A83C414604430E6F315541'),
       (2027, 1, 1, 5, 1001, 101, 1001, 10001, '0103000020910800000100000005000000A7548091ABA83C414504430E6F3155416680CA94C3A83C41AD05C91D6F31554115A25A09C5A83C4189268E7965315541D04338D7AAA83C415322FC4A65315541A7548091ABA83C414504430E6F315541'),
       (2028, 1, 1, 5, 1001, 101, 1001, 10001, '010300002091080000010000000500000029511EC9EDA83C4115074F2D6F3155417578C67BEFA83C41C8385C436631554125B5F3EBD0A83C41262CA6B765315541D98D4B39CFA83C41770137EF6E31554129511EC9EDA83C4115074F2D6F315541'),
       (2029, 1, 1, 5, 1001, 101, 1001, 10001, '01030000209108000001000000050000003A64B7ABF9A83C41780137EF6E315541A7A8B2CF1DA93C41DF02BDFE6E315541CF976A151DA93C41643E7481663155411075FF65FAA83C412F3AE252663155413A64B7ABF9A83C41780137EF6E315541'),
       (2030, 1, 1, 5, 1001, 101, 1001, 10001, '0103000020910800000100000005000000154E28CB52A83C41AD05C91D6F3155416AC8C2336EA83C417C08D53C6F31554141D90AEE6EA83C415422FC4A65315541886488C353A83C41B61CE40C65315541154E28CB52A83C41AD05C91D6F315541'),
       (2031, 1, 1, 5, 1001, 102, 1001, 10001, '01030000209108000001000000050000002F9EEE1D40A83C4111B98E242131554135FAC7385AA83C416C3970282131554135FAC7385AA83C413B8099EB1B315541309EEE1D40A83C41877FD6E31B3155412F9EEE1D40A83C4111B98E2421315541'),
       (2032, 1, 1, 5, 1001, 101, 1001, 10001, '0103000020910800000100000005000000137AA177FBA83C4179BBEA34533155418CA82234FEA83C4121DEAE14443155418B106F574CA93C41ECC44EDA43315541E5466E844AA93C41E3EDAAA953315541137AA177FBA83C4179BBEA3453315541'),
       (2033, 1, 1, 5, 1001, 101, 1001, 10001, '01030000209108000001000000050000006CBF296F71A93C41DB6FCA85523155419D2603DC7AA93C411B2C2893343155410C3FF0E3B1A93C415FCEB27F3431554192106F27AFA93C411F125572523155416CBF296F71A93C41DB6FCA8552315541');

-- SUPPLIED DATASET TWO
-- add outlines of supplied dataset 2 to check buildings_bulk_load.compare_building_outlines(1) does not include these outlines
INSERT INTO buildings_bulk_load.supplied_outlines (supplied_outline_id, supplied_dataset_id, shape)
VALUES (234, 2, '010300002091080000010000000500000021318A090EA83C413B6659B51931554121318A090EA83C419A83A4A51431554143E87BC41DA83C41412D529C14315541A941C5E91DA83C4194BCABBE1931554121318A090EA83C413B6659B519315541'),
       (235, 2, '01030000209108000001000000050000009116537F40A83C415C2EAD301831554113C8A7D981A83C415C2EAD301831554113C8A7D981A83C41D69FD76D0F3155419116537F40A83C41D69FD76D0F3155419116537F40A83C415C2EAD3018315541'),
       (236, 2, '01030000209108000001000000070000005847509D0EA83C4166FFC8A30E315541F9664A5919A83C41C155948F0E315541F9664A5919A83C4135521F3F083155419F5C0E8034A83C4135521F3F083155419F5C0E8034A83C416FD0E416053155415847509D0EA83C416FD0E416053155415847509D0EA83C4166FFC8A30E315541');

INSERT INTO buildings_bulk_load.bulk_load_outlines (bulk_load_outline_id, supplied_dataset_id, bulk_load_status_id, capture_method_id, capture_source_id, suburb_locality_id, town_city_id, territorial_authority_id, shape)
VALUES (2034, 2, 1, 5, 1001, 101, 1001, 10001, '010300002091080000010000000500000021318A090EA83C413B6659B51931554121318A090EA83C419A83A4A51431554143E87BC41DA83C41412D529C14315541A941C5E91DA83C4194BCABBE1931554121318A090EA83C413B6659B519315541'),
       (2035, 2, 1, 5, 1001, 101, 1001, 10001, '01030000209108000001000000050000009116537F40A83C415C2EAD301831554113C8A7D981A83C415C2EAD301831554113C8A7D981A83C41D69FD76D0F3155419116537F40A83C41D69FD76D0F3155419116537F40A83C415C2EAD3018315541'),
       (2036, 2, 1, 5, 1001, 101, 1001, 10001, '01030000209108000001000000070000005847509D0EA83C4166FFC8A30E315541F9664A5919A83C41C155948F0E315541F9664A5919A83C4135521F3F083155419F5C0E8034A83C4135521F3F083155419F5C0E8034A83C416FD0E416053155415847509D0EA83C416FD0E416053155415847509D0EA83C4166FFC8A30E315541');

