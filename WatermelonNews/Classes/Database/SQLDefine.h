//
//  SQLDefine.h
//  Kratos
//
//  Created by Zhangziqi on 3/29/16.
//  Copyright © 2016 lyq. All rights reserved.
//

#ifndef SQLDefine_h
#define SQLDefine_h

#define SQL_CREATE_TABLE_PACKAGES @"CREATE TABLE IF NOT EXISTS packages(\
    identifier INTEGER PRIMARY KEY AUTOINCREMENT, \
    bundle_id TEXT, \
    bundle_executable TEXT)"

#define SQL_SELECT_PACKAGE_FROM_PACKAGES @"SELECT * FROM packages"
#define SQL_SELECT_PACKAGE_BY_BUNDLE_EXECUTABLE_FROM_PACKAGES @"SELECT * FROM packages WHERE bundle_executable IN (%@)"
#define SQL_INSERT_PACKAGE_TO_PACKAGES   @"INSERT INTO packages(bundle_id, bundle_executable) VALUES(?, ?)"
#define SQL_DELETE_PACKAGE_FROM_PACKAGES_BY_BUNDLE_ID @"DELETE FROM packages WHERE bundle_id = ?"
#define SQL_DELETE_ALL_FROM_PACKAGES @"TRUNCATE packages"

#endif /* SQLDefine_h */
