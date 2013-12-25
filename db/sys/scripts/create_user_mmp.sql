declare
   --Creates a new user with default tablespace and basic grants
   lc_user_name  constant user_users.username%type := upper(sys_context('config_ctx','user_name'));
   lc_password constant varchar2(30)  := upper(sys_context('config_ctx','password'));
   lc_tablespace_name  constant dba_data_files.tablespace_name%type := upper(sys_context('config_ctx','tablespace'));
begin
   if lc_user_name is null or lc_password is null or lc_tablespace_name is null
   then
      raise_application_error(-20501, 'You must specify context variable <<user_name>> and <<password>> and <<tablespace>> in <<config_ctx>> using dbms_session.set_context');
   end if;
   execute immediate 'create user '||lc_user_name||' identified by "'||lc_password||'" default tablespace '||lc_tablespace_name;
   dbms_output.put_line('User '||lc_user_name||' created.');
   execute immediate 'grant create session to '||lc_user_name;
end;
/


