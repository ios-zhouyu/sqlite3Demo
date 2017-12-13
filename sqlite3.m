
     SQLITE_EXTERN const char sqlite3_version[];
     const char *sqlite3_libversion(void);
    
    SQLITE_AVAILABLE(macos(10.7), ios(4.0))
     const char *sqlite3_sourceid(void);
    
     int sqlite3_libversion_number(void);

#ifndef SQLITE_OMIT_COMPILEOPTION_DIAGS
    SQLITE_AVAILABLE(macos(10.7), ios(5.0))
     int sqlite3_compileoption_used(const char *zOptName);
    
    SQLITE_AVAILABLE(macos(10.7), ios(5.0))
     const char *sqlite3_compileoption_get(int N);
#endif
    
     int sqlite3_threadsafe(void);

    typedef struct sqlite3 sqlite3;
    

#ifdef SQLITE_INT64_TYPE
    typedef SQLITE_INT64_TYPE sqlite_int64;
# ifdef SQLITE_UINT64_TYPE
    typedef SQLITE_UINT64_TYPE sqlite_uint64;
# else
    typedef unsigned SQLITE_INT64_TYPE sqlite_uint64;
# endif
#elif defined(_MSC_VER) || defined(__BORLANDC__)
    typedef __int64 sqlite_int64;
    typedef unsigned __int64 sqlite_uint64;
#else
    typedef long long int sqlite_int64;
    typedef unsigned long long int sqlite_uint64;
#endif
    typedef sqlite_int64 sqlite3_int64;
    typedef sqlite_uint64 sqlite3_uint64;

//关闭数据库
     int sqlite3_close(sqlite3*);
     int sqlite3_close_v2(sqlite3*);//ios(8.2)

    typedef int (*sqlite3_callback)(void*,int,char**, char**);

////执行创建语句并接受
     int sqlite3_exec( sqlite3*, const char *sql, int (*callback)(void*,int,char**,char**), void *, char **errmsg );

    typedef struct sqlite3_file sqlite3_file;
    struct sqlite3_file {
        const struct sqlite3_io_methods *pMethods;  /* Methods for an open file */
    };
    
    typedef struct sqlite3_io_methods sqlite3_io_methods;
    struct sqlite3_io_methods {
        int iVersion;
        int (*xClose)(sqlite3_file*);
        int (*xRead)(sqlite3_file*, void*, int iAmt, sqlite3_int64 iOfst);
        int (*xWrite)(sqlite3_file*, const void*, int iAmt, sqlite3_int64 iOfst);
        int (*xTruncate)(sqlite3_file*, sqlite3_int64 size);
        int (*xSync)(sqlite3_file*, int flags);
        int (*xFileSize)(sqlite3_file*, sqlite3_int64 *pSize);
        int (*xLock)(sqlite3_file*, int);
        int (*xUnlock)(sqlite3_file*, int);
        int (*xCheckReservedLock)(sqlite3_file*, int *pResOut);
        int (*xFileControl)(sqlite3_file*, int op, void *pArg);
        int (*xSectorSize)(sqlite3_file*);
        int (*xDeviceCharacteristics)(sqlite3_file*);
        /* Methods above are valid for version 1 */
        int (*xShmMap)(sqlite3_file*, int iPg, int pgsz, int, void volatile**);
        int (*xShmLock)(sqlite3_file*, int offset, int n, int flags);
        void (*xShmBarrier)(sqlite3_file*);
        int (*xShmUnmap)(sqlite3_file*, int deleteFlag);
        /* Methods above are valid for version 2 */
        int (*xFetch)(sqlite3_file*, sqlite3_int64 iOfst, int iAmt, void **pp);
        int (*xUnfetch)(sqlite3_file*, sqlite3_int64 iOfst, void *p);
        /* Methods above are valid for version 3 */
        /* Additional methods may be added in future releases */
    };

    typedef struct sqlite3_mutex sqlite3_mutex;

    typedef struct sqlite3_api_routines sqlite3_api_routines;
    
    typedef struct sqlite3_vfs sqlite3_vfs;
    typedef void (*sqlite3_syscall_ptr)(void);
    struct sqlite3_vfs {
        int iVersion;            /* Structure version number (currently 3) */
        int szOsFile;            /* Size of subclassed sqlite3_file */
        int mxPathname;          /* Maximum file pathname length */
        sqlite3_vfs *pNext;      /* Next registered VFS */
        const char *zName;       /* Name of this virtual file system */
        void *pAppData;          /* Pointer to application-specific data */
        int (*xOpen)(sqlite3_vfs*, const char *zName, sqlite3_file*,
                     int flags, int *pOutFlags);
        int (*xDelete)(sqlite3_vfs*, const char *zName, int syncDir);
        int (*xAccess)(sqlite3_vfs*, const char *zName, int flags, int *pResOut);
        int (*xFullPathname)(sqlite3_vfs*, const char *zName, int nOut, char *zOut);
        void *(*xDlOpen)(sqlite3_vfs*, const char *zFilename);
        void (*xDlError)(sqlite3_vfs*, int nByte, char *zErrMsg);
        void (*(*xDlSym)(sqlite3_vfs*,void*, const char *zSymbol))(void);
        void (*xDlClose)(sqlite3_vfs*, void*);
        int (*xRandomness)(sqlite3_vfs*, int nByte, char *zOut);
        int (*xSleep)(sqlite3_vfs*, int microseconds);
        int (*xCurrentTime)(sqlite3_vfs*, double*);
        int (*xGetLastError)(sqlite3_vfs*, int, char *);
        int (*xCurrentTimeInt64)(sqlite3_vfs*, sqlite3_int64*);

        int (*xSetSystemCall)(sqlite3_vfs*, const char *zName, sqlite3_syscall_ptr);
        sqlite3_syscall_ptr (*xGetSystemCall)(sqlite3_vfs*, const char *zName);
        const char *(*xNextSystemCall)(sqlite3_vfs*, const char *zName);
    };
    
     int sqlite3_initialize(void);
     int sqlite3_shutdown(void);
     int sqlite3_os_init(void);
     int sqlite3_os_end(void);
    
     int sqlite3_config(int, ...);
    
     int sqlite3_db_config(sqlite3*, int op, ...);
    
    typedef struct sqlite3_mem_methods sqlite3_mem_methods;
    struct sqlite3_mem_methods {
        void *(*xMalloc)(int);         /* Memory allocation function */
        void (*xFree)(void*);          /* Free a prior allocation */
        void *(*xRealloc)(void*,int);  /* Resize an allocation */
        int (*xSize)(void*);           /* Return the size of an allocation */
        int (*xRoundup)(int);          /* Round up request size to allocation size */
        int (*xInit)(void*);           /* Initialize the memory allocator */
        void (*xShutdown)(void*);      /* Deinitialize the memory allocator */
        void *pAppData;                /* Argument to xInit() and xShutdown() */
    };

     int sqlite3_extended_result_codes(sqlite3*, int onoff);
    
     sqlite3_int64 sqlite3_last_insert_rowid(sqlite3*);

     void sqlite3_set_last_insert_rowid(sqlite3*,sqlite3_int64);
    
     int sqlite3_changes(sqlite3*);

     int sqlite3_total_changes(sqlite3*);
    
     void sqlite3_interrupt(sqlite3*);
    
     int sqlite3_complete(const char *sql);
     int sqlite3_complete16(const void *sql);
    
     int sqlite3_busy_handler(sqlite3*,int(*)(void*,int),void*);
         int sqlite3_busy_timeout(sqlite3*, int ms);
    
     int sqlite3_get_table(
                                     sqlite3 *db,          /* An open database */
                                     const char *zSql,     /* SQL to be evaluated */
                                     char ***pazResult,    /* Results of the query */
                                     int *pnRow,           /* Number of result rows written here */
                                     int *pnColumn,        /* Number of result columns written here */
                                     char **pzErrmsg       /* Error msg written here */
    );
     void sqlite3_free_table(char **result);
    
     char *sqlite3_mprintf(const char*,...);
     char *sqlite3_vmprintf(const char*, va_list);
     char *sqlite3_snprintf(int,char*,const char*, ...);
    
    SQLITE_AVAILABLE(macos(10.7), ios(5.0))
     char *sqlite3_vsnprintf(int,char*,const char*, va_list);
    
     void *sqlite3_malloc(int);
    
    SQLITE_AVAILABLE(macos(10.11), ios(9.0))
     void *sqlite3_malloc64(sqlite3_uint64);
    
     void *sqlite3_realloc(void*, int);
    
    SQLITE_AVAILABLE(macos(10.11), ios(9.0))
     void *sqlite3_realloc64(void*, sqlite3_uint64);
    
     void sqlite3_free(void*);
    
    SQLITE_AVAILABLE(macos(10.11), ios(9.0))
     sqlite3_uint64 sqlite3_msize(void*);

     sqlite3_int64 sqlite3_memory_used(void);
     sqlite3_int64 sqlite3_memory_highwater(int resetFlag);

     void sqlite3_randomness(int N, void *P);
    
     int sqlite3_set_authorizer(
                                          sqlite3*,
                                          int (*xAuth)(void*,int,const char*,const char*,const char*,const char*),
                                          void *pUserData
                                          );


    SQLITE_DEPRECATED_WITH_REPLACEMENT("sqlite3_trace_v2", macos(10.7, 10.12), ios(5.0, 10.0), watchos(2.0, 3.0), tvos(9.0, 10.0))
     SQLITE_DEPRECATED void *sqlite3_trace(
                                                     sqlite3*,
                                                     void(*xTrace)(void*,const char*),
                                                     void*
                                                     );
    
    SQLITE_DEPRECATED_WITH_REPLACEMENT("sqlite3_trace_v2", macos(10.6, 10.12), ios(3.0, 10.0), watchos(2.0, 3.0), tvos(9.0, 10.0))
     SQLITE_DEPRECATED void *sqlite3_profile(
                                                       sqlite3*,
                                                       void(*xProfile)(void*,const char*,sqlite3_uint64),
                                                       void*
                                                       );
    
    SQLITE_AVAILABLE(macos(10.12), ios(10.0), watchos(3.0), tvos(10.0))
     int sqlite3_trace_v2(
                                    sqlite3*,
                                    unsigned uMask,
                                    int(*xCallback)(unsigned,void*,void*,void*),
                                    void *pCtx
                                    );
    
     void sqlite3_progress_handler(sqlite3*, int, int(*)(void*), void*);

    // 根据指定的数据库文件存储路径打开数据库
     int sqlite3_open(
                                const char *filename,   /* Database filename (UTF-8) */
                                sqlite3 **ppDb          /* OUT: SQLite db handle */
    );
     int sqlite3_open16(
                                  const void *filename,   /* Database filename (UTF-16) */
                                  sqlite3 **ppDb          /* OUT: SQLite db handle */
    );
     int sqlite3_open_v2(
                                   const char *filename,   /* Database filename (UTF-8) */
                                   sqlite3 **ppDb,         /* OUT: SQLite db handle */
                                   int flags,              /* Flags */
                                   const char *zVfs        /* Name of VFS module to use */
    );
    
    SQLITE_AVAILABLE(macos(10.8), ios(5.0))
     const char *sqlite3_uri_parameter(const char *zFilename, const char *zParam);
    
    SQLITE_AVAILABLE(macos(10.8), ios(6.0))
     int sqlite3_uri_boolean(const char *zFile, const char *zParam, int bDefault);
    
    SQLITE_AVAILABLE(macos(10.8), ios(6.0))
     sqlite3_int64 sqlite3_uri_int64(const char*, const char*, sqlite3_int64);
    
     int sqlite3_errcode(sqlite3 *db);
     int sqlite3_extended_errcode(sqlite3 *db);
//错误信息
     const char *sqlite3_errmsg(sqlite3*);
     const void *sqlite3_errmsg16(sqlite3*);
    
    SQLITE_AVAILABLE(macos(10.10), ios(8.2))
     const char *sqlite3_errstr(int);
    //sql语句对象
    typedef struct sqlite3_stmt sqlite3_stmt;
    
     int sqlite3_limit(sqlite3*, int id, int newVal);

//执行sql处理命令
     /**
      当sqlite3_prepare_v2返回状态码SQLITE_OK时开始遍历结果。

      @param db 数据库连接
      @param zSql sql语句
      @param statement 长度传入-1表示地道第一个null终止符为止
      @param nByte 返回一个语句对象
      @param ppStmt 返回一个指向该sql语句的第一个字节的指针
      */
     int sqlite3_prepare( sqlite3 *db, const char *zSql, int nByte, sqlite3_stmt **ppStmt, const char **pzTail );
     int sqlite3_prepare_v2( sqlite3 *db, const char *zSql, int nByte, sqlite3_stmt **ppStmt, const char **pzTail );
     int sqlite3_prepare16( sqlite3 *db, const void *zSql, int nByte, sqlite3_stmt **ppStmt, const void **pzTail );
     int sqlite3_prepare16_v2( sqlite3 *db, const void *zSql, int nByte,  sqlite3_stmt **ppStmt, const void **pzTail );
    
     const char *sqlite3_sql(sqlite3_stmt *pStmt);
    
    SQLITE_AVAILABLE(macos(10.12), ios(10.0), watchos(3.0), tvos(10.0))
     char *sqlite3_expanded_sql(sqlite3_stmt *pStmt);
    
    SQLITE_AVAILABLE(macos(10.7), ios(5.0))
     int sqlite3_stmt_readonly(sqlite3_stmt *pStmt);

    SQLITE_AVAILABLE(macos(10.8), ios(6.0))
     int sqlite3_stmt_busy(sqlite3_stmt*);
    
    typedef struct sqlite3_value sqlite3_value;

    typedef struct sqlite3_context sqlite3_context;

//MARK: 可见需要更改的条件sql中用?来代替，然后用sqlite3_bind_text函数来绑定参数。根据类型不同绑定的函数也不同
//sqlite3_bind_text(statement, 1, "beijing", -1,SQLITE_TRANSIENT); //绑定参数
     int sqlite3_bind_blob(sqlite3_stmt*, int, const void*, int n, void(*)(void*));
     int sqlite3_bind_blob64(sqlite3_stmt*, int, const void*, sqlite3_uint64, void(*)(void*));
     int sqlite3_bind_double(sqlite3_stmt*, int, double);
     int sqlite3_bind_int(sqlite3_stmt*, int, int);
     int sqlite3_bind_int64(sqlite3_stmt*, int, sqlite3_int64);
     int sqlite3_bind_null(sqlite3_stmt*, int);
     int sqlite3_bind_text(sqlite3_stmt*,int,const char*,int,void(*)(void*));
     int sqlite3_bind_text16(sqlite3_stmt*, int, const void*, int, void(*)(void*));
     int sqlite3_bind_text64(sqlite3_stmt*, int, const char*, sqlite3_uint64, void(*)(void*), unsigned char encoding);
     int sqlite3_bind_value(sqlite3_stmt*, int, const sqlite3_value*);
     int sqlite3_bind_zeroblob(sqlite3_stmt*, int, int n);
    
    SQLITE_AVAILABLE(macos(10.12), ios(10.0), watchos(3.0), tvos(10.0))
     int sqlite3_bind_zeroblob64(sqlite3_stmt*, int, sqlite3_uint64);

     int sqlite3_bind_parameter_count(sqlite3_stmt*);

     const char *sqlite3_bind_parameter_name(sqlite3_stmt*, int);

     int sqlite3_bind_parameter_index(sqlite3_stmt*, const char *zName);

     int sqlite3_clear_bindings(sqlite3_stmt*);

     int sqlite3_column_count(sqlite3_stmt *pStmt);

     const char *sqlite3_column_name(sqlite3_stmt*, int N);
     const void *sqlite3_column_name16(sqlite3_stmt*, int N);
    
     const char *sqlite3_column_database_name(sqlite3_stmt*,int);
     const void *sqlite3_column_database_name16(sqlite3_stmt*,int);
     const char *sqlite3_column_table_name(sqlite3_stmt*,int);
     const void *sqlite3_column_table_name16(sqlite3_stmt*,int);
     const char *sqlite3_column_origin_name(sqlite3_stmt*,int);
     const void *sqlite3_column_origin_name16(sqlite3_stmt*,int);
    
     const char *sqlite3_column_decltype(sqlite3_stmt*,int);
     const void *sqlite3_column_decltype16(sqlite3_stmt*,int);
    //是否准备结束
     int sqlite3_step(sqlite3_stmt*);
    //data的数目
     int sqlite3_data_count(sqlite3_stmt *pStmt);

//MARK: 遍历的过程中要取到结果通过一下的函数获取遍历结果
//第一个参数为sql语句对象，第二个为获取哪一列的信息。
     const void *sqlite3_column_blob(sqlite3_stmt*, int iCol);
     int sqlite3_column_bytes(sqlite3_stmt*, int iCol);
     int sqlite3_column_bytes16(sqlite3_stmt*, int iCol);
     double sqlite3_column_double(sqlite3_stmt*, int iCol);
     int sqlite3_column_int(sqlite3_stmt*, int iCol);
     sqlite3_int64 sqlite3_column_int64(sqlite3_stmt*, int iCol);
     const unsigned char *sqlite3_column_text(sqlite3_stmt*, int iCol);
     const void *sqlite3_column_text16(sqlite3_stmt*, int iCol);
     int sqlite3_column_type(sqlite3_stmt*, int iCol);
     sqlite3_value *sqlite3_column_value(sqlite3_stmt*, int iCol);

//释放stmt指针
     int sqlite3_finalize(sqlite3_stmt *pStmt);
//重置stmt指针
     int sqlite3_reset(sqlite3_stmt *pStmt);
    
     int sqlite3_create_function(
                                           sqlite3 *db,
                                           const char *zFunctionName,
                                           int nArg,
                                           int eTextRep,
                                           void *pApp,
                                           void (*xFunc)(sqlite3_context*,int,sqlite3_value**),
                                           void (*xStep)(sqlite3_context*,int,sqlite3_value**),
                                           void (*xFinal)(sqlite3_context*)
                                           );
     int sqlite3_create_function16(
                                             sqlite3 *db,
                                             const void *zFunctionName,
                                             int nArg,
                                             int eTextRep,
                                             void *pApp,
                                             void (*xFunc)(sqlite3_context*,int,sqlite3_value**),
                                             void (*xStep)(sqlite3_context*,int,sqlite3_value**),
                                             void (*xFinal)(sqlite3_context*)
                                             );
    
    SQLITE_AVAILABLE(macos(10.7), ios(5.0))
     int sqlite3_create_function_v2(
                                              sqlite3 *db,
                                              const char *zFunctionName,
                                              int nArg,
                                              int eTextRep,
                                              void *pApp,
                                              void (*xFunc)(sqlite3_context*,int,sqlite3_value**),
                                              void (*xStep)(sqlite3_context*,int,sqlite3_value**),
                                              void (*xFinal)(sqlite3_context*),
                                              void(*xDestroy)(void*)
                                              );

    SQLITE_DEPRECATED_NO_REPLACEMENT("Not supported", macos(10.6, 10.6), ios(3.0, 3.0), watchos(2.0, 2.0), tvos(9.0, 9.0))
     SQLITE_DEPRECATED int sqlite3_aggregate_count(sqlite3_context*);
    
    SQLITE_DEPRECATED_NO_REPLACEMENT("Not supported", macos(10.6, 10.6), ios(3.0, 3.0), watchos(2.0, 2.0), tvos(9.0, 9.0))
     SQLITE_DEPRECATED int sqlite3_expired(sqlite3_stmt*);
    
    SQLITE_DEPRECATED_NO_REPLACEMENT("Not supported", macos(10.6, 10.6), ios(3.0, 3.0), watchos(2.0, 2.0), tvos(9.0, 9.0))
     SQLITE_DEPRECATED int sqlite3_transfer_bindings(sqlite3_stmt*, sqlite3_stmt*);
    
    SQLITE_DEPRECATED_NO_REPLACEMENT("Not supported", macos(10.6, 10.6), ios(3.0, 3.0), watchos(2.0, 2.0), tvos(9.0, 9.0))
     SQLITE_DEPRECATED int sqlite3_global_recover(void);
    
    SQLITE_DEPRECATED_NO_REPLACEMENT("Not supported", macos(10.6, 10.6), ios(3.0, 3.0), watchos(2.0, 2.0), tvos(9.0, 9.0))
     SQLITE_DEPRECATED void sqlite3_thread_cleanup(void);
    
    SQLITE_DEPRECATED_NO_REPLACEMENT("Not supported", macos(10.6, 10.6), ios(3.0, 3.0), watchos(2.0, 2.0), tvos(9.0, 9.0))
     SQLITE_DEPRECATED int sqlite3_memory_alarm(void(*)(void*,sqlite3_int64,int),
                                                          void*,sqlite3_int64);
#endif
    
     const void *sqlite3_value_blob(sqlite3_value*);
     int sqlite3_value_bytes(sqlite3_value*);
     int sqlite3_value_bytes16(sqlite3_value*);
     double sqlite3_value_double(sqlite3_value*);
     int sqlite3_value_int(sqlite3_value*);
     sqlite3_int64 sqlite3_value_int64(sqlite3_value*);
     const unsigned char *sqlite3_value_text(sqlite3_value*);
     const void *sqlite3_value_text16(sqlite3_value*);
     const void *sqlite3_value_text16le(sqlite3_value*);
     const void *sqlite3_value_text16be(sqlite3_value*);
     int sqlite3_value_type(sqlite3_value*);
     int sqlite3_value_numeric_type(sqlite3_value*);

    SQLITE_AVAILABLE(macos(10.12), ios(10.0), watchos(3.0), tvos(10.0))
     unsigned int sqlite3_value_subtype(sqlite3_value*);

    SQLITE_AVAILABLE(macos(10.12), ios(10.0), watchos(3.0), tvos(10.0))
     sqlite3_value *sqlite3_value_dup(const sqlite3_value*);
    
    SQLITE_AVAILABLE(macos(10.12), ios(10.0), watchos(3.0), tvos(10.0))
     void sqlite3_value_free(sqlite3_value*);
    
     void *sqlite3_aggregate_context(sqlite3_context*, int nBytes);

     void *sqlite3_user_data(sqlite3_context*);

     sqlite3 *sqlite3_context_db_handle(sqlite3_context*);
    
     void *sqlite3_get_auxdata(sqlite3_context*, int N);
     void sqlite3_set_auxdata(sqlite3_context*, int N, void*, void (*)(void*));
    
    
    typedef void (*sqlite3_destructor_type)(void*);
#define SQLITE_STATIC      ((sqlite3_destructor_type)0)
#define SQLITE_TRANSIENT   ((sqlite3_destructor_type)-1)
    
     void sqlite3_result_blob(sqlite3_context*, const void*, int, void(*)(void*));
     void sqlite3_result_blob64(sqlite3_context*,const void*,
                                          sqlite3_uint64,void(*)(void*));
     void sqlite3_result_double(sqlite3_context*, double);
     void sqlite3_result_error(sqlite3_context*, const char*, int);
     void sqlite3_result_error16(sqlite3_context*, const void*, int);
     void sqlite3_result_error_toobig(sqlite3_context*);
     void sqlite3_result_error_nomem(sqlite3_context*);
     void sqlite3_result_error_code(sqlite3_context*, int);
     void sqlite3_result_int(sqlite3_context*, int);
     void sqlite3_result_int64(sqlite3_context*, sqlite3_int64);
     void sqlite3_result_null(sqlite3_context*);
     void sqlite3_result_text(sqlite3_context*, const char*, int, void(*)(void*));
     void sqlite3_result_text64(sqlite3_context*, const char*,sqlite3_uint64,
                                          void(*)(void*), unsigned char encoding);
     void sqlite3_result_text16(sqlite3_context*, const void*, int, void(*)(void*));
     void sqlite3_result_text16le(sqlite3_context*, const void*, int,void(*)(void*));
     void sqlite3_result_text16be(sqlite3_context*, const void*, int,void(*)(void*));
     void sqlite3_result_value(sqlite3_context*, sqlite3_value*);
     void sqlite3_result_zeroblob(sqlite3_context*, int n);
    
    SQLITE_AVAILABLE(macos(10.12), ios(10.0), watchos(3.0), tvos(10.0))
     int sqlite3_result_zeroblob64(sqlite3_context*, sqlite3_uint64 n);

    SQLITE_AVAILABLE(macos(10.12), ios(10.0), watchos(3.0), tvos(10.0))
     void sqlite3_result_subtype(sqlite3_context*,unsigned int);
    
     int sqlite3_create_collation(
                                            sqlite3*,
                                            const char *zName,
                                            int eTextRep,
                                            void *pArg,
                                            int(*xCompare)(void*,int,const void*,int,const void*)
                                            );
     int sqlite3_create_collation_v2(
                                               sqlite3*,
                                               const char *zName,
                                               int eTextRep,
                                               void *pArg,
                                               int(*xCompare)(void*,int,const void*,int,const void*),
                                               void(*xDestroy)(void*)
                                               );
     int sqlite3_create_collation16(
                                              sqlite3*,
                                              const void *zName,
                                              int eTextRep,
                                              void *pArg,
                                              int(*xCompare)(void*,int,const void*,int,const void*)
                                              );

     int sqlite3_collation_needed(
                                            sqlite3*,
                                            void*,
                                            void(*)(void*,sqlite3*,int eTextRep,const char*)
                                            );
     int sqlite3_collation_needed16(
                                              sqlite3*,
                                              void*,
                                              void(*)(void*,sqlite3*,int eTextRep,const void*)
                                              );
    
     int sqlite3_sleep(int);
    
     SQLITE_EXTERN char *sqlite3_temp_directory;
    
    SQLITE_AVAILABLE(macos(10.9), ios(6.0))
     SQLITE_EXTERN char *sqlite3_data_directory;
    
     int sqlite3_get_autocommit(sqlite3*);
    
     sqlite3 *sqlite3_db_handle(sqlite3_stmt*);
    
    SQLITE_AVAILABLE(macos(10.8), ios(6.0))
     const char *sqlite3_db_filename(sqlite3 *db, const char *zDbName);
    
    SQLITE_AVAILABLE(macos(10.8), ios(6.0))
     int sqlite3_db_readonly(sqlite3 *db, const char *zDbName);
    
     sqlite3_stmt *sqlite3_next_stmt(sqlite3 *pDb, sqlite3_stmt *pStmt);
    
     void *sqlite3_commit_hook(sqlite3*, int(*)(void*), void*);
     void *sqlite3_rollback_hook(sqlite3*, void(*)(void *), void*);
    
     void *sqlite3_update_hook(
                                         sqlite3*,
                                         void(*)(void *,int ,char const *,char const *,sqlite3_int64),
                                         void*
                                         );
    
    SQLITE_DEPRECATED_NO_REPLACEMENT("Not supported", macos(10.6, 10.7), ios(3.0, 5.0), watchos(2.0, 2.0), tvos(9.0, 9.0))
     int sqlite3_enable_shared_cache(int);
    
    SQLITE_AVAILABLE(macos(10.8), ios(6.0))
     int sqlite3_release_memory(int);
    
     int sqlite3_db_release_memory(sqlite3*);
    
    SQLITE_AVAILABLE(macos(10.7), ios(5.0))
     sqlite3_int64 sqlite3_soft_heap_limit64(sqlite3_int64 N);
    
    SQLITE_DEPRECATED_WITH_REPLACEMENT("sqlite3_soft_heap_limit64", macos(10.6, 10.7), ios(3.0, 5.0), watchos(2.0, 2.0), tvos(9.0, 9.0))
     SQLITE_DEPRECATED void sqlite3_soft_heap_limit(int N);
    
    
     int sqlite3_table_column_metadata(
                                                 sqlite3 *db,                /* Connection handle */
                                                 const char *zDbName,        /* Database name or NULL */
                                                 const char *zTableName,     /* Table name */
                                                 const char *zColumnName,    /* Column name */
                                                 char const **pzDataType,    /* OUTPUT: Declared data type */
                                                 char const **pzCollSeq,     /* OUTPUT: Collation sequence name */
                                                 int *pNotNull,              /* OUTPUT: True if NOT NULL constraint exists */
                                                 int *pPrimaryKey,           /* OUTPUT: True if column part of PK */
                                                 int *pAutoinc               /* OUTPUT: True if column is auto-increment */
    );
    
     int sqlite3_load_extension(
                                          sqlite3 *db,          /* Load the extension into this database connection */
                                          const char *zFile,    /* Name of the shared library containing extension */
                                          const char *zProc,    /* Entry point.  Derived from zFile if 0 */
                                          char **pzErrMsg       /* Put error message here if not 0 */
    );
    
     int sqlite3_enable_load_extension(sqlite3 *db, int onoff);
    
    SQLITE_DEPRECATED_NO_REPLACEMENT("Process-global auto extensions are not supported on Apple platforms", macos(10.10, 10.10), ios(8.2, 8.2), watchos(2.0, 2.0), tvos(9.0, 9.0))
     int sqlite3_auto_extension(void(*xEntryPoint)(void));
    
     int sqlite3_cancel_auto_extension(void(*xEntryPoint)(void));
    
     void sqlite3_reset_auto_extension(void);

    typedef struct sqlite3_vtab sqlite3_vtab;
    typedef struct sqlite3_index_info sqlite3_index_info;
    typedef struct sqlite3_vtab_cursor sqlite3_vtab_cursor;
    typedef struct sqlite3_module sqlite3_module;
    
    struct sqlite3_module {
        int iVersion;
        int (*xCreate)(sqlite3*, void *pAux,
                       int argc, const char *const*argv,
                       sqlite3_vtab **ppVTab, char**);
        int (*xConnect)(sqlite3*, void *pAux,
                        int argc, const char *const*argv,
                        sqlite3_vtab **ppVTab, char**);
        int (*xBestIndex)(sqlite3_vtab *pVTab, sqlite3_index_info*);
        int (*xDisconnect)(sqlite3_vtab *pVTab);
        int (*xDestroy)(sqlite3_vtab *pVTab);
        int (*xOpen)(sqlite3_vtab *pVTab, sqlite3_vtab_cursor **ppCursor);
        int (*xClose)(sqlite3_vtab_cursor*);
        int (*xFilter)(sqlite3_vtab_cursor*, int idxNum, const char *idxStr,
                       int argc, sqlite3_value **argv);
        int (*xNext)(sqlite3_vtab_cursor*);
        int (*xEof)(sqlite3_vtab_cursor*);
        int (*xColumn)(sqlite3_vtab_cursor*, sqlite3_context*, int);
        int (*xRowid)(sqlite3_vtab_cursor*, sqlite3_int64 *pRowid);
        int (*xUpdate)(sqlite3_vtab *, int, sqlite3_value **, sqlite3_int64 *);
        int (*xBegin)(sqlite3_vtab *pVTab);
        int (*xSync)(sqlite3_vtab *pVTab);
        int (*xCommit)(sqlite3_vtab *pVTab);
        int (*xRollback)(sqlite3_vtab *pVTab);
        int (*xFindFunction)(sqlite3_vtab *pVtab, int nArg, const char *zName,
                             void (**pxFunc)(sqlite3_context*,int,sqlite3_value**),
                             void **ppArg);
        int (*xRename)(sqlite3_vtab *pVtab, const char *zNew);
        /* The methods above are in version 1 of the sqlite_module object. Those
         ** below are for version 2 and greater. */
        int (*xSavepoint)(sqlite3_vtab *pVTab, int);
        int (*xRelease)(sqlite3_vtab *pVTab, int);
        int (*xRollbackTo)(sqlite3_vtab *pVTab, int);
    };
    
    struct sqlite3_index_info {
        /* Inputs */
        int nConstraint;           /* Number of entries in aConstraint */
        struct sqlite3_index_constraint {
            int iColumn;              /* Column constrained.  -1 for ROWID */
            unsigned char op;         /* Constraint operator */
            unsigned char usable;     /* True if this constraint is usable */
            int iTermOffset;          /* Used internally - xBestIndex should ignore */
        } *aConstraint;            /* Table of WHERE clause constraints */
        int nOrderBy;              /* Number of terms in the ORDER BY clause */
        struct sqlite3_index_orderby {
            int iColumn;              /* Column number */
            unsigned char desc;       /* True for DESC.  False for ASC. */
        } *aOrderBy;               /* The ORDER BY clause */
        /* Outputs */
        struct sqlite3_index_constraint_usage {
            int argvIndex;           /* if >0, constraint is part of argv to xFilter */
            unsigned char omit;      /* Do not code a test for this constraint */
        } *aConstraintUsage;
        int idxNum;                /* Number used to identify the index */
        char *idxStr;              /* String, possibly obtained from sqlite3_malloc */
        int needToFreeIdxStr;      /* Free idxStr using sqlite3_free() if true */
        int orderByConsumed;       /* True if output is already ordered */
        double estimatedCost;           /* Estimated cost of using this index */
        /* Fields below are only available in SQLite 3.8.2 and later */
        sqlite3_int64 estimatedRows;    /* Estimated number of rows returned */
        /* Fields below are only available in SQLite 3.9.0 and later */
        int idxFlags;              /* Mask of SQLITE_INDEX_SCAN_* flags */
        /* Fields below are only available in SQLite 3.10.0 and later */
        sqlite3_uint64 colUsed;    /* Input: Mask of columns used by statement */
    };

     int sqlite3_create_module(
                                         sqlite3 *db,               /* SQLite connection to register module with */
                                         const char *zName,         /* Name of the module */
                                         const sqlite3_module *p,   /* Methods for the module */
                                         void *pClientData          /* Client data for xCreate/xConnect */
    );
     int sqlite3_create_module_v2(
                                            sqlite3 *db,               /* SQLite connection to register module with */
                                            const char *zName,         /* Name of the module */
                                            const sqlite3_module *p,   /* Methods for the module */
                                            void *pClientData,         /* Client data for xCreate/xConnect */
                                            void(*xDestroy)(void*)     /* Module destructor function */
    );
    
    struct sqlite3_vtab {
        const sqlite3_module *pModule;  /* The module for this virtual table */
        int nRef;                       /* Number of open cursors */
        char *zErrMsg;                  /* Error message from sqlite3_mprintf() */
        /* Virtual table implementations will typically add additional fields */
    };
    
    struct sqlite3_vtab_cursor {
        sqlite3_vtab *pVtab;      /* Virtual table of this cursor */
        /* Virtual table implementations will typically add additional fields */
    };
    
     int sqlite3_declare_vtab(sqlite3*, const char *zSQL);
    
     int sqlite3_overload_function(sqlite3*, const char *zFuncName, int nArg);
    

    typedef struct sqlite3_blob sqlite3_blob;
    
     int sqlite3_blob_open(
                                     sqlite3*,
                                     const char *zDb,
                                     const char *zTable,
                                     const char *zColumn,
                                     sqlite3_int64 iRow,
                                     int flags,
                                     sqlite3_blob **ppBlob
                                     );
    
    SQLITE_AVAILABLE(macos(10.7), ios(5.0))
     int sqlite3_blob_reopen(sqlite3_blob *, sqlite3_int64);
    
     int sqlite3_blob_close(sqlite3_blob *);
    
     int sqlite3_blob_bytes(sqlite3_blob *);
    
     int sqlite3_blob_read(sqlite3_blob *, void *Z, int N, int iOffset);
    
     int sqlite3_blob_write(sqlite3_blob *, const void *z, int n, int iOffset);
    
     sqlite3_vfs *sqlite3_vfs_find(const char *zVfsName);
     int sqlite3_vfs_register(sqlite3_vfs*, int makeDflt);
     int sqlite3_vfs_unregister(sqlite3_vfs*);
    
     sqlite3_mutex *sqlite3_mutex_alloc(int);
     void sqlite3_mutex_free(sqlite3_mutex*);
     void sqlite3_mutex_enter(sqlite3_mutex*);
     int sqlite3_mutex_try(sqlite3_mutex*);
     void sqlite3_mutex_leave(sqlite3_mutex*);
    
    typedef struct sqlite3_mutex_methods sqlite3_mutex_methods;
    struct sqlite3_mutex_methods {
        int (*xMutexInit)(void);
        int (*xMutexEnd)(void);
        sqlite3_mutex *(*xMutexAlloc)(int);
        void (*xMutexFree)(sqlite3_mutex *);
        void (*xMutexEnter)(sqlite3_mutex *);
        int (*xMutexTry)(sqlite3_mutex *);
        void (*xMutexLeave)(sqlite3_mutex *);
        int (*xMutexHeld)(sqlite3_mutex *);
        int (*xMutexNotheld)(sqlite3_mutex *);
    };
    
#ifndef NDEBUG
     int sqlite3_mutex_held(sqlite3_mutex*);
     int sqlite3_mutex_notheld(sqlite3_mutex*);
#endif
    
     sqlite3_mutex *sqlite3_db_mutex(sqlite3*);
    
     int sqlite3_file_control(sqlite3*, const char *zDbName, int op, void*);
    
     int sqlite3_test_control(int op, ...);
    
     int sqlite3_status(int op, int *pCurrent, int *pHighwater, int resetFlag);
    SQLITE_AVAILABLE(macos(10.11), ios(9.0))
     int sqlite3_status64(
                                    int op,
                                    sqlite3_int64 *pCurrent,
                                    sqlite3_int64 *pHighwater,
                                    int resetFlag
                                    );
    
     int sqlite3_db_status(sqlite3*, int op, int *pCur, int *pHiwtr, int resetFlg);
     int sqlite3_stmt_status(sqlite3_stmt*, int op,int resetFlg);
    
    typedef struct sqlite3_pcache sqlite3_pcache;
    
    typedef struct sqlite3_pcache_page sqlite3_pcache_page;
    struct sqlite3_pcache_page {
        void *pBuf;        /* The content of the page */
        void *pExtra;      /* Extra information associated with the page */
    };
    
    typedef struct sqlite3_pcache_methods2 sqlite3_pcache_methods2;
    struct sqlite3_pcache_methods2 {
        int iVersion;
        void *pArg;
        int (*xInit)(void*);
        void (*xShutdown)(void*);
        sqlite3_pcache *(*xCreate)(int szPage, int szExtra, int bPurgeable);
        void (*xCachesize)(sqlite3_pcache*, int nCachesize);
        int (*xPagecount)(sqlite3_pcache*);
        sqlite3_pcache_page *(*xFetch)(sqlite3_pcache*, unsigned key, int createFlag);
        void (*xUnpin)(sqlite3_pcache*, sqlite3_pcache_page*, int discard);
        void (*xRekey)(sqlite3_pcache*, sqlite3_pcache_page*,
                       unsigned oldKey, unsigned newKey);
        void (*xTruncate)(sqlite3_pcache*, unsigned iLimit);
        void (*xDestroy)(sqlite3_pcache*);
        void (*xShrink)(sqlite3_pcache*);
    };
    
    typedef struct sqlite3_pcache_methods sqlite3_pcache_methods;
    struct sqlite3_pcache_methods {
        void *pArg;
        int (*xInit)(void*);
        void (*xShutdown)(void*);
        sqlite3_pcache *(*xCreate)(int szPage, int bPurgeable);
        void (*xCachesize)(sqlite3_pcache*, int nCachesize);
        int (*xPagecount)(sqlite3_pcache*);
        void *(*xFetch)(sqlite3_pcache*, unsigned key, int createFlag);
        void (*xUnpin)(sqlite3_pcache*, void*, int discard);
        void (*xRekey)(sqlite3_pcache*, void*, unsigned oldKey, unsigned newKey);
        void (*xTruncate)(sqlite3_pcache*, unsigned iLimit);
        void (*xDestroy)(sqlite3_pcache*);
    };
    
    
    typedef struct sqlite3_backup sqlite3_backup;
    
     sqlite3_backup *sqlite3_backup_init(
                                                   sqlite3 *pDest,                        /* Destination database handle */
                                                   const char *zDestName,                 /* Destination database name */
                                                   sqlite3 *pSource,                      /* Source database handle */
                                                   const char *zSourceName                /* Source database name */
    );
     int sqlite3_backup_step(sqlite3_backup *p, int nPage);
     int sqlite3_backup_finish(sqlite3_backup *p);
     int sqlite3_backup_remaining(sqlite3_backup *p);
     int sqlite3_backup_pagecount(sqlite3_backup *p);
    
     int sqlite3_unlock_notify(
                                         sqlite3 *pBlocked,                          /* Waiting connection */
                                         void (*xNotify)(void **apArg, int nArg),    /* Callback function to invoke */
                                         void *pNotifyArg                            /* Argument to pass to xNotify */
    );
    
    
    SQLITE_AVAILABLE(macos(10.8), ios(6.0))
     int sqlite3_stricmp(const char *, const char *);
    
    SQLITE_AVAILABLE(macos(10.7), ios(4.0))
     int sqlite3_strnicmp(const char *, const char *, int);
    
    SQLITE_AVAILABLE(macos(10.10), ios(8.2))
     int sqlite3_strglob(const char *zGlob, const char *zStr);
    
    SQLITE_AVAILABLE(macos(10.12), ios(10.0), watchos(3.0), tvos(10.0))
     int sqlite3_strlike(const char *zGlob, const char *zStr, unsigned int cEsc);
    
    SQLITE_AVAILABLE(macos(10.7), ios(5.0))
     void sqlite3_log(int iErrCode, const char *zFormat, ...);
    
    SQLITE_AVAILABLE(macos(10.7), ios(5.0))
     void *sqlite3_wal_hook(
                                      sqlite3*,
                                      int(*)(void *,sqlite3*,const char*,int),
                                      void*
                                      );
    
    SQLITE_AVAILABLE(macos(10.7), ios(5.0))
     int sqlite3_wal_autocheckpoint(sqlite3 *db, int N);
    
    SQLITE_AVAILABLE(macos(10.7), ios(5.0))
     int sqlite3_wal_checkpoint(sqlite3 *db, const char *zDb);
    
    SQLITE_AVAILABLE(macos(10.8), ios(5.0))
     int sqlite3_wal_checkpoint_v2(
                                             sqlite3 *db,                    /* Database handle */
                                             const char *zDb,                /* Name of attached database (or NULL) */
                                             int eMode,                      /* SQLITE_CHECKPOINT_* value */
                                             int *pnLog,                     /* OUT: Size of WAL log in frames */
                                             int *pnCkpt                     /* OUT: Total number of frames checkpointed */
    );
    

#define SQLITE_CHECKPOINT_PASSIVE  0  /* Do as much as possible w/o blocking */
#define SQLITE_CHECKPOINT_FULL     1  /* Wait for writers, then checkpoint */
#define SQLITE_CHECKPOINT_RESTART  2  /* Like FULL but wait for for readers */
#define SQLITE_CHECKPOINT_TRUNCATE 3  /* Like RESTART but also truncate WAL */
    

    SQLITE_AVAILABLE(macos(10.8), ios(5.0))
     int sqlite3_vtab_config(sqlite3*, int op, ...);
    
#define SQLITE_VTAB_CONSTRAINT_SUPPORT 1
    
    SQLITE_AVAILABLE(macos(10.8), ios(5.0))
     int sqlite3_vtab_on_conflict(sqlite3 *);
    
    SQLITE_AVAILABLE(macos(10.11), ios(9.0))
     int sqlite3_stmt_scanstatus(
                                           sqlite3_stmt *pStmt,      /* Prepared statement for which info desired */
                                           int idx,                  /* Index of loop to report on */
                                           int iScanStatusOp,        /* Information desired.  SQLITE_SCANSTAT_* */
                                           void *pOut                /* Result written here */
    );

    SQLITE_AVAILABLE(macos(10.11), ios(9.0))
     void sqlite3_stmt_scanstatus_reset(sqlite3_stmt*);

    SQLITE_AVAILABLE(macos(10.12), ios(10.0), watchos(3.0), tvos(10.0))
     int sqlite3_db_cacheflush(sqlite3*);

    SQLITE_AVAILABLE(macos(10.12), ios(10.0), watchos(3.0), tvos(10.0))
     int sqlite3_system_errno(sqlite3*);
    


#ifdef __cplusplus
extern "C" {
#endif
    
    typedef struct sqlite3_rtree_geometry sqlite3_rtree_geometry;
    typedef struct sqlite3_rtree_query_info sqlite3_rtree_query_info;
    
    /* The double-precision datatype used by RTree depends on the
     ** SQLITE_RTREE_INT_ONLY compile-time option.
     */
#ifdef SQLITE_RTREE_INT_ONLY
    typedef sqlite3_int64 sqlite3_rtree_dbl;
#else
    typedef double sqlite3_rtree_dbl;
#endif

    SQLITE_AVAILABLE(macos(10.7), ios(5.0))
     int sqlite3_rtree_geometry_callback(
                                                   sqlite3 *db,
                                                   const char *zGeom,
                                                   int (*xGeom)(sqlite3_rtree_geometry*, int, sqlite3_rtree_dbl*,int*),
                                                   void *pContext
                                                   );
    

    struct sqlite3_rtree_geometry {
        void *pContext;                 /* Copy of pContext passed to s_r_g_c() */
        int nParam;                     /* Size of array aParam[] */
        sqlite3_rtree_dbl *aParam;      /* Parameters passed to SQL geom function */
        void *pUser;                    /* Callback implementation user data */
        void (*xDelUser)(void *);       /* Called by SQLite to clean up pUser */
    };
    

    SQLITE_AVAILABLE(macos(10.10), ios(8.2))
     int sqlite3_rtree_query_callback(
                                                sqlite3 *db,
                                                const char *zQueryFunc,
                                                int (*xQueryFunc)(sqlite3_rtree_query_info*),
                                                void *pContext,
                                                void (*xDestructor)(void*)
                                                );
    
    

    struct sqlite3_rtree_query_info {
        void *pContext;                   /* pContext from when function registered */
        int nParam;                       /* Number of function parameters */
        sqlite3_rtree_dbl *aParam;        /* value of function parameters */
        void *pUser;                      /* callback can use this, if desired */
        void (*xDelUser)(void*);          /* function to free pUser */
        sqlite3_rtree_dbl *aCoord;        /* Coordinates of node or entry to check */
        unsigned int *anQueue;            /* Number of pending entries in the queue */
        int nCoord;                       /* Number of coordinates */
        int iLevel;                       /* Level of current node or entry */
        int mxLevel;                      /* The largest iLevel value in the tree */
        sqlite3_int64 iRowid;             /* Rowid for current entry */
        sqlite3_rtree_dbl rParentScore;   /* Score of parent node */
        int eParentWithin;                /* Visibility of parent node */
        int eWithin;                      /* OUT: Visiblity */
        sqlite3_rtree_dbl rScore;         /* OUT: Write the score here */
        /* The following fields are only available in 3.8.11 and later */
        sqlite3_value **apSqlParam;       /* Original SQL values of parameters */
    };
    
    /*
     ** Allowed values for sqlite3_rtree_query.eWithin and .eParentWithin.
     */
#define NOT_WITHIN       0   /* Object completely outside of query region */
#define PARTLY_WITHIN    1   /* Object partially overlaps query region */
#define FULLY_WITHIN     2   /* Object fully contained within query region */
    
    
#ifdef __cplusplus
}  /* end of the 'extern "C"' block */
#endif

#endif  /* ifndef _SQLITE3RTREE_H_ */


#ifndef _FTS5_H
#define _FTS5_H


#ifdef __cplusplus
extern "C" {
#endif
  
    
    typedef struct Fts5ExtensionApi Fts5ExtensionApi;
    typedef struct Fts5Context Fts5Context;
    typedef struct Fts5PhraseIter Fts5PhraseIter;
    
    typedef void (*fts5_extension_function)(
                                            const Fts5ExtensionApi *pApi,   /* API offered by current FTS version */
                                            Fts5Context *pFts,              /* First arg to pass to pApi functions */
                                            sqlite3_context *pCtx,          /* Context for returning result/error */
                                            int nVal,                       /* Number of values in apVal[] array */
                                            sqlite3_value **apVal           /* Array of trailing arguments */
                                            );
    
    struct Fts5PhraseIter {
        const unsigned char *a;
        const unsigned char *b;
    };
    
    struct Fts5ExtensionApi {
        int iVersion;                   /* Currently always set to 3 */
        
        void *(*xUserData)(Fts5Context*);
        
        int (*xColumnCount)(Fts5Context*);
        int (*xRowCount)(Fts5Context*, sqlite3_int64 *pnRow);
        int (*xColumnTotalSize)(Fts5Context*, int iCol, sqlite3_int64 *pnToken);
        
        int (*xTokenize)(Fts5Context*,
                         const char *pText, int nText, /* Text to tokenize */
                         void *pCtx,                   /* Context passed to xToken() */
                         int (*xToken)(void*, int, const char*, int, int, int)       /* Callback */
                         );
        
        int (*xPhraseCount)(Fts5Context*);
        int (*xPhraseSize)(Fts5Context*, int iPhrase);
        
        int (*xInstCount)(Fts5Context*, int *pnInst);
        int (*xInst)(Fts5Context*, int iIdx, int *piPhrase, int *piCol, int *piOff);
        
        sqlite3_int64 (*xRowid)(Fts5Context*);
        int (*xColumnText)(Fts5Context*, int iCol, const char **pz, int *pn);
        int (*xColumnSize)(Fts5Context*, int iCol, int *pnToken);
        
        int (*xQueryPhrase)(Fts5Context*, int iPhrase, void *pUserData,
                            int(*)(const Fts5ExtensionApi*,Fts5Context*,void*)
                            );
        int (*xSetAuxdata)(Fts5Context*, void *pAux, void(*xDelete)(void*));
        void *(*xGetAuxdata)(Fts5Context*, int bClear);
        
        int (*xPhraseFirst)(Fts5Context*, int iPhrase, Fts5PhraseIter*, int*, int*);
        void (*xPhraseNext)(Fts5Context*, Fts5PhraseIter*, int *piCol, int *piOff);
        
        int (*xPhraseFirstColumn)(Fts5Context*, int iPhrase, Fts5PhraseIter*, int*);
        void (*xPhraseNextColumn)(Fts5Context*, Fts5PhraseIter*, int *piCol);
    };

    
    typedef struct Fts5Tokenizer Fts5Tokenizer;
    typedef struct fts5_tokenizer fts5_tokenizer;
    struct fts5_tokenizer {
        int (*xCreate)(void*, const char **azArg, int nArg, Fts5Tokenizer **ppOut);
        void (*xDelete)(Fts5Tokenizer*);
        int (*xTokenize)(Fts5Tokenizer*,
                         void *pCtx,
                         int flags,            /* Mask of FTS5_TOKENIZE_* flags */
                         const char *pText, int nText,
                         int (*xToken)(
                                       void *pCtx,         /* Copy of 2nd argument to xTokenize() */
                                       int tflags,         /* Mask of FTS5_TOKEN_* flags */
                                       const char *pToken, /* Pointer to buffer containing token */
                                       int nToken,         /* Size of token in bytes */
                                       int iStart,         /* Byte offset of token within input text */
                                       int iEnd            /* Byte offset of end of token within input text */
                                       )
                         );
    };
    
    typedef struct fts5_api fts5_api;
    struct fts5_api {
        int iVersion;                   /* Currently always set to 2 */
        
        /* Create a new tokenizer */
        int (*xCreateTokenizer)(
                                fts5_api *pApi,
                                const char *zName,
                                void *pContext,
                                fts5_tokenizer *pTokenizer,
                                void (*xDestroy)(void*)
                                );
        
        /* Find an existing tokenizer */
        int (*xFindTokenizer)(
                              fts5_api *pApi,
                              const char *zName,
                              void **ppContext,
                              fts5_tokenizer *pTokenizer
                              );
        
        /* Create a new auxiliary function */
        int (*xCreateFunction)(
                               fts5_api *pApi,
                               const char *zName,
                               void *pContext,
                               fts5_extension_function xFunction,
                               void (*xDestroy)(void*)
                               );
    };


