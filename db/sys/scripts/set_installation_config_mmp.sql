create context config_ctx using dbms_session;

begin
   dbms_session.set_context ('config_ctx', 'tablespace', 'MMP2');
   dbms_session.set_context ('config_ctx', 'copy_tablespace', 'USERS');
   dbms_session.set_context ('config_ctx', 'user_name', 'mmp2');
   dbms_session.set_context ('config_ctx', 'password', 'Mmp2');
end;
/

@@./create_tablespace_mmp.sql

@@./create_user_mmp.sql

begin
   dbms_session.set_context ('config_ctx', 'tablespace', 'MMP_SUPER_DATA');
   dbms_session.set_context ('config_ctx', 'copy_tablespace', 'USERS');
   dbms_session.set_context ('config_ctx', 'user_name', 'mmp_super');
   dbms_session.set_context ('config_ctx', 'password', 'Mmp_super');
end;
/

@@./create_tablespace_mmp.sql

@@./create_user_mmp.sql

