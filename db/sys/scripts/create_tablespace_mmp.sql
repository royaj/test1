declare
   --Creates a new tablespace and put the file in the same location as a existing tablespace
   lc_new_tablespace_name  constant dba_data_files.tablespace_name%type := upper(sys_context('config_ctx','tablespace'));
   lc_copy_tablespace_name constant dba_data_files.tablespace_name%type := upper(sys_context('config_ctx','copy_tablespace'));
   lc_new_file_name        constant dba_data_files.file_name%type       := lower(lc_new_tablespace_name)||'_data.dbf';
   l_file_name dba_data_files.file_name%type                            := null;
   l_new_full_file_name dba_data_files.file_name%type                   := null;
   cursor c_data_file(cp_tablespace_name in dba_data_files.tablespace_name%type)
   is
       select file_name
         from dba_data_files
        where tablespace_name=cp_tablespace_name
     order by file_id;
begin
   if lc_new_tablespace_name is null or lc_copy_tablespace_name is null
   then
      raise_application_error(-20501, 'You must specify context variable <<new_tablespace>> and <<copy_tablespace>> in <<config_ctx>> using dbms_session.set_context');
   end if;
   --Check if tablespace already exists
   open c_data_file(lc_new_tablespace_name);
   fetch c_data_file
      into l_file_name;
   close c_data_file;
   if l_file_name is null then
      --find file location
      open c_data_file(lc_copy_tablespace_name);
      fetch c_data_file
         into l_file_name;
      close c_data_file;
      if l_file_name is null then
         raise_application_error(-20502, 'Did not find tablespace '||lc_copy_tablespace_name||
         ' to reuse file location for the new file for tablespace '||lc_new_tablespace_name);
      else
         l_new_full_file_name := replace (l_file_name, regexp_substr(l_file_name, '[^\/]+$'), lc_new_file_name);
         execute immediate 'create tablespace '||lc_new_tablespace_name||' datafile '''||l_new_full_file_name||
         ''' size 10M autoextend on online';
         dbms_output.put_line('Tablespace '||lc_new_tablespace_name||' created.');
      end if;
   else
      dbms_output.put_line('Tablespace '||lc_new_tablespace_name||' already exists.');
   end if;
end;
/
